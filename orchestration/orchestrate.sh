#!/usr/bin/env bash
#
# orchestrate.sh — Main orchestrator loop for Deliberate_Agents
#
# Polls the .deliberate/ state directory and launches/manages agents
# based on state transitions. Runs as a persistent process in tmux.
#
# Usage: ./orchestrate.sh /path/to/project-config.yaml

set -euo pipefail

# --- Configuration -----------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORK_DIR="$(dirname "$SCRIPT_DIR")"

CONFIG_FILE="${1:?Usage: orchestrate.sh <config-file>}"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "ERROR: Config file not found: $CONFIG_FILE"
  exit 1
fi

# Resolve to absolute path so tmux subprocesses don't break on cwd changes
CONFIG_FILE="$(cd "$(dirname "$CONFIG_FILE")" && pwd)/$(basename "$CONFIG_FILE")"

# Parse YAML config (simple key extraction — no yq dependency)
parse_yaml() {
  local key="$1"
  grep -E "^[[:space:]]*${key}:" "$CONFIG_FILE" | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

PROJECT_NAME="$(parse_yaml 'name')"
WORKTREES_DIR="$(parse_yaml 'worktrees')"
POLL_INTERVAL="$(parse_yaml 'poll_interval_seconds')"
TMUX_SESSION="$(parse_yaml 'tmux_session')"
MAX_DEVELOPERS="$(parse_yaml 'max_concurrent_developers')"
AUTONOMY="$(parse_yaml 'autonomy')"

POLL_INTERVAL="${POLL_INTERVAL:-30}"
MAX_DEVELOPERS="${MAX_DEVELOPERS:-3}"
AUTONOMY="${AUTONOMY:-full}"
TMUX_SESSION="${TMUX_SESSION:-deliberate}"
SLACK_ENABLED="$(parse_yaml 'slack_enabled')"
SLACK_ENABLED="${SLACK_ENABLED:-false}"
REPORT_INTERVAL="$(parse_yaml 'report_interval_cycles')"
REPORT_INTERVAL="${REPORT_INTERVAL:-10}"

DELIBERATE_DIR="${WORKTREES_DIR}/.deliberate"

# Source gate validation and cross-agent communication libraries
source "${SCRIPT_DIR}/gates.sh"
source "${SCRIPT_DIR}/comms.sh"

# Ensure system comms directories exist (for projects initialized before this feature)
mkdir -p "${DELIBERATE_DIR}/comms/_system/inbox/integrator" \
         "${DELIBERATE_DIR}/comms/_system/inbox/orchestrator" \
         "${DELIBERATE_DIR}/comms/_system/ack" \
         "${DELIBERATE_DIR}/decisions/strategic" 2>/dev/null || true
LOG_DIR="${DELIBERATE_DIR}/logs"
QUEUE_DIR="${DELIBERATE_DIR}/queue"
ASSIGNMENTS_DIR="${DELIBERATE_DIR}/assignments"
STATUS_DIR="${DELIBERATE_DIR}/status"
DECISIONS_DIR="${DELIBERATE_DIR}/decisions"

# --- Logging ------------------------------------------------------------------

mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/orchestrator-$(date +%Y%m%d).log"

log() {
  local level="$1"
  shift
  local msg="$*"
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "[$timestamp] [$level] $msg" | tee -a "$LOG_FILE"
}

log_info()  { log "INFO"  "$@"; }
log_warn()  { log "WARN"  "$@"; }
log_error() { log "ERROR" "$@"; }
log_debug() { log "DEBUG" "$@"; }

# --- State Helpers ------------------------------------------------------------

# Read a field from a YAML file (simple grep-based, no yq needed)
read_yaml_field() {
  local file="$1"
  local field="$2"
  grep -E "^[[:space:]]*${field}:" "$file" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

# Read a field from a markdown status/assignment file (- **Field**: value)
read_md_field() {
  local file="$1"
  local field="$2"
  grep -E "\*\*${field}\*\*:" "$file" 2>/dev/null | head -1 | sed 's/.*\*\*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

# Write/update a field in a YAML file
write_yaml_field() {
  local file="$1"
  local field="$2"
  local value="$3"
  if grep -qE "^\s*${field}:" "$file" 2>/dev/null; then
    sed -i '' "s|^\(\s*${field}:\).*|\1 \"${value}\"|" "$file"
  else
    echo "${field}: \"${value}\"" >> "$file"
  fi
}

# Write/update a field in a markdown status/assignment file
write_md_field() {
  local file="$1"
  local field="$2"
  local value="$3"
  if grep -qE "\*\*${field}\*\*:" "$file" 2>/dev/null; then
    sed -i '' "s|\(\*\*${field}\*\*:\).*|\1 ${value}|" "$file"
  else
    echo "- **${field}**: ${value}" >> "$file"
  fi
}

# Count running developer agents
count_active_developers() {
  local count=0
  if [[ -d "$ASSIGNMENTS_DIR" ]]; then
    for f in "$ASSIGNMENTS_DIR"/*.md; do
      [[ -f "$f" ]] || continue
      local status
      status="$(read_md_field "$f" 'Status')"
      if [[ "$status" == "in_progress" ]]; then
        ((count++)) || true
      fi
    done
  fi
  echo "$count"
}

# Check if an agent process is still running (by PID file)
PID_DIR="${DELIBERATE_DIR}/pids"
mkdir -p "$PID_DIR" 2>/dev/null || true

agent_is_running() {
  local agent_name="$1"
  local pid_file="${PID_DIR}/${agent_name}.pid"
  if [[ -f "$pid_file" ]]; then
    local pid
    pid="$(cat "$pid_file")"
    if kill -0 "$pid" 2>/dev/null; then
      return 0
    else
      rm -f "$pid_file"
      return 1
    fi
  fi
  return 1
}

sanitize_tmux_name() {
  local name="$1"
  name="${name//[^a-zA-Z0-9_-]/-}"
  echo "$name"
}

agent_window_exists() {
  local name="$1"
  agent_is_running "$name" && return 0
  tmux list-windows -t "$TMUX_SESSION" -F '#{window_name}' 2>/dev/null | grep -qx "$name"
}

# --- Agent Launcher (generic) -------------------------------------------------

launch_agent() {
  local role="$1"
  local initiative_slug="$2"
  local new_status="$3"
  local initiative_file="${QUEUE_DIR}/${initiative_slug}.yaml"
  local window_name="$(sanitize_tmux_name "${role}-${initiative_slug}")"

  if agent_window_exists "$window_name"; then
    log_debug "${role} agent already running for $initiative_slug"
    return
  fi

  local title
  title="$(read_yaml_field "$initiative_file" 'title')"
  title="${title:-$initiative_slug}"

  log_info "Launching ${role} agent for: ${title}"

  write_yaml_field "$initiative_file" "status" "$new_status"

  "${SCRIPT_DIR}/launch-agent.sh" \
    --session "$TMUX_SESSION" \
    --window "$window_name" \
    --window-name "$window_name" \
    --role "$role" \
    --initiative "$initiative_slug" \
    --config "$CONFIG_FILE" \
    --framework-dir "$FRAMEWORK_DIR"
}

launch_dev_agent() {
  local worktree_name="$1"
  local assignment_file="${ASSIGNMENTS_DIR}/${worktree_name}.md"
  local window_name="$(sanitize_tmux_name "dev-${worktree_name}")"

  if agent_window_exists "$window_name"; then
    log_debug "Dev agent already running for $worktree_name"
    return
  fi

  local active
  active="$(count_active_developers)"
  if (( active >= MAX_DEVELOPERS )); then
    log_info "Max concurrent developers ($MAX_DEVELOPERS) reached, deferring $worktree_name"
    return
  fi

  log_info "Launching Developer agent for worktree: $worktree_name"

  "${SCRIPT_DIR}/launch-agent.sh" \
    --session "$TMUX_SESSION" \
    --window "$window_name" \
    --window-name "$window_name" \
    --role "developer" \
    --worktree "$worktree_name" \
    --config "$CONFIG_FILE" \
    --framework-dir "$FRAMEWORK_DIR"
}

launch_specialist_agent() {
  local agent_type="$1"
  local worktree_name="$2"
  local assignment_file="${ASSIGNMENTS_DIR}/${worktree_name}.md"
  local window_name="$(sanitize_tmux_name "${agent_type}-${worktree_name}")"

  if agent_window_exists "$window_name"; then
    log_debug "${agent_type} agent already running for $worktree_name"
    return
  fi

  local initiative
  initiative="$(read_md_field "$assignment_file" 'Initiative')"

  log_info "Launching ${agent_type} agent for assignment: $worktree_name"

  "${SCRIPT_DIR}/launch-agent.sh" \
    --session "$TMUX_SESSION" \
    --window "$window_name" \
    --window-name "$window_name" \
    --role "$agent_type" \
    --initiative "${initiative:-}" \
    --worktree "$worktree_name" \
    --config "$CONFIG_FILE" \
    --framework-dir "$FRAMEWORK_DIR"
}

# --- Check if any initiative agent is currently running -----------------------

any_initiative_agent_running() {
  # Check for any product-pipeline agent PID file with a live process
  # Optional arg: --exclude-parallel to ignore doc-only agents (designer, scrum-master)
  local exclude_parallel=false
  [[ "${1:-}" == "--exclude-parallel" ]] && exclude_parallel=true

  for pid_file in "$PID_DIR"/*.pid; do
    [[ -f "$pid_file" ]] || continue
    local name
    name="$(basename "$pid_file" .pid)"
    case "$name" in
      product-strategist-*|product-manager-*|architect-*|product-designer-*|scrum-master-*|project-manager-*)
        if $exclude_parallel; then
          case "$name" in product-designer-*|scrum-master-*) continue ;; esac
        fi
        local pid
        pid="$(cat "$pid_file")"
        if kill -0 "$pid" 2>/dev/null; then
          return 0
        else
          rm -f "$pid_file"
        fi
        ;;
    esac
  done
  return 1
}

count_running_designers() {
  local count=0
  for pid_file in "$PID_DIR"/product-designer-*.pid; do
    [[ -f "$pid_file" ]] || continue
    local pid
    pid="$(cat "$pid_file")"
    kill -0 "$pid" 2>/dev/null && { ((count++)) || true; } || rm -f "$pid_file"
  done
  echo "$count"
}

get_active_initiative() {
  # Return the slug of the initiative currently being processed
  for initiative_file in "$QUEUE_DIR"/*.yaml; do
    [[ -f "$initiative_file" ]] || continue
    local status
    status="$(read_yaml_field "$initiative_file" 'status')"
    case "$status" in
      PM_IN_PROGRESS|ARCH_IN_PROGRESS|DESIGN_IN_PROGRESS|SCRUM_IN_PROGRESS|PJM_IN_PROGRESS)
        basename "$initiative_file" .yaml
        return
        ;;
    esac
  done
}

# --- Detect agent completion (window gone = agent finished) -------------------

agent_crashed() {
  local agent_name="$1"
  local pid_file="${PID_DIR}/${agent_name}.pid"
  # If PID file was removed by agent_is_running (process dead), check the log
  # for a recent launch — if the agent ran less than 2 minutes, it crashed
  local log_entry
  log_entry="$(grep "Launching.*${agent_name}" "$LOG_FILE" 2>/dev/null | tail -1)"
  if [[ -z "$log_entry" ]]; then
    return 1
  fi
  local launch_time
  launch_time="$(echo "$log_entry" | grep -oE '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}')"
  if [[ -z "$launch_time" ]]; then
    return 1
  fi
  local launch_epoch now_epoch
  launch_epoch="$(date -j -f '%Y-%m-%d %H:%M:%S' "$launch_time" '+%s' 2>/dev/null)" || return 1
  now_epoch="$(date '+%s')"
  local elapsed=$(( now_epoch - launch_epoch ))
  if (( elapsed < 120 )); then
    return 0
  fi
  return 1
}

check_agent_completion() {
  local initiative_slug="$1"
  local initiative_file="${QUEUE_DIR}/${initiative_slug}.yaml"
  local status
  status="$(read_yaml_field "$initiative_file" 'status')"
  local title
  title="$(read_yaml_field "$initiative_file" 'title')"
  title="${title:-$initiative_slug}"

  # Map status to agent name prefix, next status, and handoff roles
  local agent_name=""
  local next_status=""
  local notify_msg=""
  local from_role=""
  local to_role=""
  case "$status" in
    VALIDATION_IN_PROGRESS)
      agent_name="product-strategist-${initiative_slug}"
      next_status="VALIDATED"
      from_role="product-strategist"
      to_role="product-manager"
      notify_msg="Validation complete for ${title} — ready for product definition"
      ;;
    PM_IN_PROGRESS)
      agent_name="product-manager-${initiative_slug}"
      next_status="PRD_COMPLETE"
      from_role="product-manager"
      to_role="architect"
      notify_msg="PRD complete for ${title} — launching architect"
      ;;
    ARCH_IN_PROGRESS)
      agent_name="architect-${initiative_slug}"
      next_status="ARCH_COMPLETE"
      from_role="architect"
      to_role="product-designer"
      notify_msg="Architecture doc complete for ${title} — launching designer"
      ;;
    DESIGN_IN_PROGRESS)
      agent_name="product-designer-${initiative_slug}"
      next_status="DESIGN_COMPLETE"
      from_role="product-designer"
      to_role="scrum-master"
      notify_msg="Design brief complete for ${title} — launching scrum master"
      ;;
    SCRUM_IN_PROGRESS)
      agent_name="scrum-master-${initiative_slug}"
      next_status="SPECIFIED"
      from_role="scrum-master"
      to_role="project-manager"
      notify_msg="${title} is fully specified — ready for handoff"
      ;;
    PJM_IN_PROGRESS)
      agent_name="project-manager-${initiative_slug}"
      next_status="READY_FOR_DEV"
      from_role="project-manager"
      to_role="developer"
      notify_msg="${title} has tasks assigned — ready for development"
      ;;
    *) return ;;
  esac

  if agent_is_running "$agent_name"; then
    return
  fi

  # Agent is not running — read completion signal to determine outcome
  local signal_file=""
  signal_file="$(read_completion_signal "$initiative_slug" "$from_role" "$agent_name" 2>/dev/null)" || true
  local signal_status=""
  if [[ -n "$signal_file" ]]; then
    signal_status="$(read_signal_field "$signal_file" "Status")"
  fi

  if [[ -n "$signal_file" && -n "$signal_status" ]]; then
    # Closed-loop: agent wrote a completion signal
    local signal_summary=""
    signal_summary="$(read_signal_section "$signal_file" "Summary" 2>/dev/null | head -5 | tr '\n' ' ')" || true
    local handoff_notes=""
    handoff_notes="$(read_signal_section "$signal_file" "Handoff Notes" 2>/dev/null | head -5 | tr '\n' ' ')" || true
    local notes="Signal: ${signal_status}. ${signal_summary}"
    [[ -n "$handoff_notes" ]] && notes+=" Handoff: ${handoff_notes}"

    case "$signal_status" in
      success)
        log_info "Agent $agent_name completed successfully for ${title}"
        record_flow_metric "$initiative_slug" "$status" "$next_status"
        record_handoff "$initiative_slug" "$status" "$next_status" "$from_role" "$to_role" "$notes"
        write_yaml_field "$initiative_file" "status" "$next_status"
        notify "transition" "$notify_msg" --initiative "$initiative_slug"
        ;;
      partial)
        log_warn "Agent $agent_name partially completed for ${title}"
        record_flow_metric "$initiative_slug" "$status" "$next_status"
        record_handoff "$initiative_slug" "$status" "$next_status" "$from_role" "$to_role" "$notes"
        write_yaml_field "$initiative_file" "status" "$next_status"
        send_system_message "orchestrator" "integrator" "escalation" \
          "Partial completion: ${agent_name}" \
          "Agent ${agent_name} partially completed for '${title}'. Advanced to ${next_status} but review may be needed. ${signal_summary}" \
          "warning"
        notify "transition" "$notify_msg" --initiative "$initiative_slug"
        ;;
      blocked)
        local open_items=""
        open_items="$(read_signal_section "$signal_file" "Open Items" 2>/dev/null | head -3 | tr '\n' ' ')" || true
        log_warn "Agent $agent_name blocked for ${title}: ${open_items}"
        write_yaml_field "$initiative_file" "status" "BLOCKED"
        write_yaml_field "$initiative_file" "blocker" "${open_items:-Agent reported blocked — check completion signal}"
        record_health_metric "agent_blocked" "$agent_name"
        send_to_founder "orchestrator" "agent-blocked" \
          "${from_role} blocked on ${title}" \
          "$initiative_slug" "high" \
          "Agent reported blocked.\n${open_items}\nSignal: ${signal_file}"
        notify "alert" "Agent blocked for ${title}" --initiative "$initiative_slug"
        ;;
      failed)
        log_error "Agent $agent_name failed for ${title}"
        write_yaml_field "$initiative_file" "status" "BLOCKED"
        write_yaml_field "$initiative_file" "blocker" "Agent ${agent_name} failed — check completion signal"
        record_health_metric "agent_failure" "$agent_name"
        send_to_founder "orchestrator" "agent-failed" \
          "${from_role} failed on ${title}" \
          "$initiative_slug" "critical" \
          "Agent reported failure.\n${signal_summary}\nSignal: ${signal_file}"
        notify "alert" "Agent failed for ${title} — needs investigation" --initiative "$initiative_slug"
        ;;
    esac
  elif agent_crashed "$agent_name"; then
    log_error "Agent $agent_name crashed for ${title} (ran < 2 minutes, no completion signal)"
    write_yaml_field "$initiative_file" "status" "BLOCKED"
    write_yaml_field "$initiative_file" "blocker" "Agent ${agent_name} crashed — check logs"
    record_health_metric "agent_crash" "$agent_name"
    send_system_message "orchestrator" "integrator" "escalation" \
      "Agent crash: ${agent_name}" \
      "Agent ${agent_name} crashed for initiative '${title}' (ran < 2 minutes, no completion signal). Status set to BLOCKED. Check logs." \
      "critical"
    notify "alert" "Agent crashed for ${title} — needs investigation" --initiative "$initiative_slug"
  else
    log_warn "Agent $agent_name exited without completion signal for ${title}"
    write_yaml_field "$initiative_file" "status" "BLOCKED"
    write_yaml_field "$initiative_file" "blocker" "Agent ${agent_name} completed without writing a completion signal — may need re-dispatch"
    record_health_metric "missing_signal" "$agent_name"
    send_system_message "orchestrator" "integrator" "escalation" \
      "Missing completion signal: ${agent_name}" \
      "Agent ${agent_name} exited for '${title}' without writing a completion signal. Cannot confirm work was done. Status set to BLOCKED." \
      "warning"
    notify "alert" "Missing completion signal for ${title}" --initiative "$initiative_slug"
  fi
}

# --- Poll Functions -----------------------------------------------------------

process_queue() {
  [[ -d "$QUEUE_DIR" ]] || return 0

  # Check all in-progress initiatives for agent completion
  for initiative_file in "$QUEUE_DIR"/*.yaml; do
    [[ -f "$initiative_file" ]] || continue
    local check_status
    check_status="$(read_yaml_field "$initiative_file" 'status')"
    case "$check_status" in
      PM_IN_PROGRESS|ARCH_IN_PROGRESS|DESIGN_IN_PROGRESS|SCRUM_IN_PROGRESS|PJM_IN_PROGRESS)
        check_agent_completion "$(basename "$initiative_file" .yaml)"
        ;;
    esac
  done

  # If a serial agent (PM, architect, PJM) is running, don't launch another serial agent.
  # Designers and scrum-masters can run in parallel (doc-only, separate branches).
  local serial_blocked=false
  any_initiative_agent_running --exclude-parallel && serial_blocked=true

  local running_designers
  running_designers="$(count_running_designers)"
  local max_parallel_designers=3

  for initiative_file in "$QUEUE_DIR"/*.yaml; do
    [[ -f "$initiative_file" ]] || continue

    local slug
    slug="$(basename "$initiative_file" .yaml)"
    local status
    status="$(read_yaml_field "$initiative_file" 'status')"
    local title
    title="$(read_yaml_field "$initiative_file" 'title')"
    title="${title:-$slug}"

    case "$status" in

      # --- Product Pipeline (serial, one initiative at a time) ---

      QUEUED)
        $serial_blocked && continue
        local requires_validation
        requires_validation="$(read_yaml_field "$initiative_file" 'requires_validation')"
        if [[ "$requires_validation" == "true" ]]; then
          if ! run_gate validate_ready_for_validation "$slug" "medium"; then
            continue
          fi
          log_info "Starting validation phase for: ${title}"
          record_flow_metric "$slug" "QUEUED" "VALIDATION_IN_PROGRESS"
          record_handoff "$slug" "QUEUED" "VALIDATION_IN_PROGRESS" "integrator" "product-strategist"
          notify "transition" "Starting validation for ${title}" --initiative "$slug"
          launch_agent "product-strategist" "$slug" "VALIDATION_IN_PROGRESS"
        else
          if ! run_gate validate_ready_for_prd "$slug" "medium"; then
            continue
          fi
          log_info "Starting product pipeline for: ${title}"
          record_flow_metric "$slug" "QUEUED" "PM_IN_PROGRESS"
          record_handoff "$slug" "QUEUED" "PM_IN_PROGRESS" "integrator" "product-manager"
          notify "transition" "Starting product definition for ${title}" --initiative "$slug"
          launch_agent "product-manager" "$slug" "PM_IN_PROGRESS"
        fi
        return  # Only one at a time
        ;;

      VALIDATED)
        $serial_blocked && continue
        if ! run_gate validate_ready_for_prd "$slug" "medium"; then
          continue
        fi
        log_info "Validation complete for ${title} — advancing to PM"
        record_flow_metric "$slug" "VALIDATED" "PM_IN_PROGRESS"
        record_handoff "$slug" "VALIDATED" "PM_IN_PROGRESS" "product-strategist" "product-manager"
        notify "transition" "Validation complete for ${title} — starting product definition" --initiative "$slug"
        launch_agent "product-manager" "$slug" "PM_IN_PROGRESS"
        return
        ;;

      PRD_COMPLETE|PM_COMPLETE)
        $serial_blocked && continue
        if ! run_gate validate_ready_for_arch "$slug" "medium"; then
          continue
        fi
        log_info "Advancing ${title} to architecture"
        record_flow_metric "$slug" "$status" "ARCH_IN_PROGRESS"
        record_handoff "$slug" "$status" "ARCH_IN_PROGRESS" "product-manager" "architect"
        launch_agent "architect" "$slug" "ARCH_IN_PROGRESS"
        return
        ;;

      ARCH_COMPLETE|ARCHITECT_COMPLETE)
        if (( running_designers >= max_parallel_designers )); then
          log_debug "Designer cap reached ($running_designers/$max_parallel_designers) — ${title} waiting"
          continue
        fi
        if ! run_gate validate_ready_for_design "$slug" "medium"; then
          continue
        fi
        log_info "Advancing ${title} to design"
        record_flow_metric "$slug" "$status" "DESIGN_IN_PROGRESS"
        record_handoff "$slug" "$status" "DESIGN_IN_PROGRESS" "architect" "product-designer"
        launch_agent "product-designer" "$slug" "DESIGN_IN_PROGRESS"
        ((running_designers++)) || true
        ;;

      DESIGN_COMPLETE|DESIGNER_COMPLETE)
        if ! run_gate validate_ready_for_stories "$slug" "medium"; then
          continue
        fi
        log_info "Advancing ${title} to scrum breakdown"
        record_flow_metric "$slug" "$status" "SCRUM_IN_PROGRESS"
        record_handoff "$slug" "$status" "SCRUM_IN_PROGRESS" "product-designer" "scrum-master"
        launch_agent "scrum-master" "$slug" "SCRUM_IN_PROGRESS"
        return
        ;;

      AWAITING_HANDOFF)
        log_debug "${title} is awaiting handoff decision"
        ;;

      SPECIFIED)
        if ! run_gate validate_ready_for_dev "$slug" "medium"; then
          continue
        fi
        log_info "${title} is specified — promoting to READY_FOR_DEV"
        write_yaml_field "$initiative_file" "status" "READY_FOR_DEV"
        write_yaml_field "$initiative_file" "phase" "engineering"
        write_yaml_field "$initiative_file" "specified_at" "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
        record_flow_metric "$slug" "SPECIFIED" "READY_FOR_DEV"
        record_handoff "$slug" "SPECIFIED" "READY_FOR_DEV" "scrum-master" "project-manager"
        notify "transition" "${title} promoted to engineering — ready for dev assignment" --initiative "$slug"
        $serial_blocked && continue
        log_info "${title} ready for dev — launching project manager to create assignments"
        launch_agent "project-manager" "$slug" "PJM_IN_PROGRESS"
        return
        ;;

      # --- Engineering Pipeline (after handoff) ---

      READY_FOR_DEV)
        $serial_blocked && continue
        log_info "${title} ready for dev — launching project manager to create assignments"
        launch_agent "project-manager" "$slug" "PJM_IN_PROGRESS"
        return
        ;;

      PJM_IN_PROGRESS)
        log_debug "${title} — project manager is creating assignments"
        ;;

      PJM_COMPLETE|SCRUM_COMPLETE)
        log_info "${title} — assignments ready, checking for developer agents to launch"
        write_yaml_field "$initiative_file" "status" "DEV_IN_PROGRESS"
        process_assignments
        ;;

      DEV_IN_PROGRESS)
        process_assignments
        ;;

      DEV_COMPLETE)
        if ! run_gate validate_ready_for_review "$slug" "high"; then
          continue
        fi
        log_info "Dev complete for ${title}"
        record_flow_metric "$slug" "DEV_COMPLETE" "REVIEW_IN_PROGRESS"
        record_handoff "$slug" "DEV_COMPLETE" "REVIEW_IN_PROGRESS" "developer" "reviewer"
        notify "transition" "Development complete for ${title} — starting code review" --initiative "$slug"
        launch_agent "reviewer" "$slug" "REVIEW_IN_PROGRESS"
        return
        ;;

      REVIEW_READY)
        log_info "${title} ready for human review"
        notify "progress" "${title} is ready for your review — branch is waiting in Cursor" --initiative "$slug"
        ;;

      QA_APPROVED)
        if ! run_gate validate_ready_for_qa "$slug" "medium"; then
          continue
        fi
        log_info "QA approved for ${title} — launching QA lead"
        record_flow_metric "$slug" "QA_APPROVED" "QA_IN_PROGRESS"
        record_handoff "$slug" "QA_APPROVED" "QA_IN_PROGRESS" "reviewer" "qa-lead"
        launch_agent "qa-lead" "$slug" "QA_IN_PROGRESS"
        return
        ;;

      BLOCKED)
        local reason
        reason="$(read_yaml_field "$initiative_file" 'blocker')"
        log_warn "${title} is BLOCKED: $reason"
        notify "alert" "${title} is blocked: ${reason}" --initiative "$slug"
        ;;

      PM_IN_PROGRESS|ARCH_IN_PROGRESS|DESIGN_IN_PROGRESS|SCRUM_IN_PROGRESS|\
      PJM_IN_PROGRESS|DEV_IN_PROGRESS|REVIEW_IN_PROGRESS|\
      SCRUM_COMPLETE|PJM_COMPLETE)
        log_debug "${title} is in progress ($status)"
        ;;

      COMPLETE)
        log_debug "${title} is complete"
        ;;

      *)
        log_warn "Unknown status '$status' for initiative $slug"
        ;;
    esac
  done
}

process_assignments() {
  [[ -d "$ASSIGNMENTS_DIR" ]] || return 0

  for assignment_file in "$ASSIGNMENTS_DIR"/*.md; do
    [[ -f "$assignment_file" ]] || continue

    local worktree
    worktree="$(basename "$assignment_file" .md)"
    local status
    status="$(read_md_field "$assignment_file" 'Status')"

    local agent_type
    agent_type="$(read_md_field "$assignment_file" 'Agent')"
    agent_type="${agent_type:-developer}"

    case "$status" in
      assigned)
        case "$agent_type" in
          developer)
            launch_dev_agent "$worktree"
            ;;
          integrations-engineer|content-writer|compliance-analyst|\
          technical-writer|devops-engineer|security-analyst|\
          product-strategist|market-researcher|\
          sales-development-rep|account-executive-assistant|\
          customer-success|onboarding-specialist|seo-specialist|\
          content-researcher|linkedin-copywriter|content-publisher|\
          engagement-tracker|content-reporter|\
          twitter-copywriter|threads-copywriter|facebook-copywriter|\
          video-producer|reddit-writer|hackernews-writer|producthunt-writer)
            launch_specialist_agent "$agent_type" "$worktree"
            ;;
          *)
            log_warn "Unknown agent_type '$agent_type' for assignment $worktree"
            ;;
        esac
        ;;
      in_progress)
        local window_prefix
        if [[ "$agent_type" == "developer" ]]; then
          window_prefix="dev"
        else
          window_prefix="$agent_type"
        fi
        check_agent_health "${window_prefix}-${worktree}" "$assignment_file"
        ;;
      complete)
        log_debug "Assignment $worktree is complete"
        check_initiative_completion "$assignment_file"
        ;;
      blocked)
        local reason
        reason="$(read_md_field "$assignment_file" 'Blocker')"
        log_warn "Assignment $worktree is BLOCKED: $reason"
        ;;
    esac
  done
}

check_agent_health() {
  local window_name="$1"
  local state_file="$2"

  if ! agent_window_exists "$window_name"; then
    local status
    status="$(read_md_field "$state_file" 'Status')"
    if [[ "$status" == "in_progress" ]]; then
      # Check for completion signal before assuming crash
      local signal_file=""
      signal_file="$(read_completion_signal "_system" "" "$window_name" 2>/dev/null)" || true

      if [[ -n "$signal_file" ]]; then
        local signal_status
        signal_status="$(read_signal_field "$signal_file" "Status")"
        case "$signal_status" in
          success|complete)
            log_info "Agent $window_name completed with signal (status: $signal_status)"
            write_md_field "$state_file" "Status" "complete"
            ;;
          blocked)
            log_warn "Agent $window_name reported blocked"
            write_md_field "$state_file" "Status" "blocked"
            local open_items=""
            open_items="$(read_signal_section "$signal_file" "Open Items" 2>/dev/null | head -3 | tr '\n' ' ')" || true
            write_md_field "$state_file" "Blocker" "${open_items:-Agent reported blocked}"
            ;;
          *)
            log_warn "Agent $window_name exited with signal status: $signal_status"
            write_md_field "$state_file" "Status" "blocked"
            write_md_field "$state_file" "Blocker" "Agent exited with status: ${signal_status}"
            ;;
        esac
      else
        log_warn "Agent window $window_name disappeared — no completion signal"
        write_md_field "$state_file" "Status" "blocked"
        write_md_field "$state_file" "Blocker" "Agent session ended without completion signal"
        record_health_metric "missing_signal" "$window_name"
        notify "alert" "Agent $window_name ended without completion signal — marked as blocked"
      fi
    fi
  fi
}

check_initiative_completion() {
  local assignment_file="$1"
  local initiative
  initiative="$(read_md_field "$assignment_file" 'Initiative')"

  [[ -n "$initiative" ]] || return 0

  local all_complete=true
  for f in "$ASSIGNMENTS_DIR"/*.md; do
    [[ -f "$f" ]] || continue
    local init
    init="$(read_md_field "$f" 'Initiative')"
    [[ "$init" == "$initiative" ]] || continue
    local status
    status="$(read_md_field "$f" 'Status')"
    if [[ "$status" != "complete" ]]; then
      all_complete=false
      break
    fi
  done

  if $all_complete; then
    local initiative_file="${QUEUE_DIR}/${initiative}.yaml"
    local current_status
    current_status="$(read_yaml_field "$initiative_file" 'status')"
    if [[ "$current_status" != "DEV_COMPLETE" && "$current_status" != "REVIEW_READY" && "$current_status" != "COMPLETE" ]]; then
      log_info "All tasks complete for initiative $initiative — marking DEV_COMPLETE"
      write_yaml_field "$initiative_file" "status" "DEV_COMPLETE"
      local title
      title="$(read_yaml_field "$initiative_file" 'title')"
      send_to_founder "orchestrator" "review-ready" \
        "${title:-$initiative} is ready for review" \
        "$initiative" "high" \
        "Development complete. All tasks finished — branch ready for human code review."
    fi
  fi
}

check_decisions() {
  [[ -d "$DECISIONS_DIR" ]] || return 0

  local pending_count=0
  for f in "$DECISIONS_DIR"/*.md; do
    [[ -f "$f" ]] || continue

    # Check if already notified (marker file)
    local notified_marker="${f}.notified"
    if [[ -f "$notified_marker" ]]; then
      # Already sent notification, check for resolution
      local resolution_content
      resolution_content="$(sed -n '/^## Resolution/,/^##/p' "$f" 2>/dev/null | grep -v '^##' | tr -d '[:space:]')"
      # Also check for .response.md file (closed-loop human response)
      local response_file="${f%.md}.response.md"
      if [[ -f "$response_file" && -z "$resolution_content" ]]; then
        local action
        action="$(grep -E '^\- \*\*Action\*\*:' "$response_file" 2>/dev/null | head -1 | sed 's/.*: //')"
        local decision_text
        decision_text="$(sed -n '/^## Decision/,/^##/p' "$response_file" 2>/dev/null | grep -v '^##')"
        # Write the response into the decision file's Resolution section
        printf "\n## Resolution\n\n**Action**: %s (via response file)\n\n%s\n" "$action" "$decision_text" >> "$f"
        resolution_content="filled"
        log_info "Decision resolved via response file: $(basename "$f" .md)"
        mv "$response_file" "${DECISIONS_DIR}/resolved-$(basename "$response_file")"
      fi
      if [[ -n "$resolution_content" ]]; then
        log_info "Decision resolved: $(basename "$f" .md)"
        rm -f "$notified_marker"
      else
        ((pending_count++)) || true
      fi
      continue
    fi

    ((pending_count++)) || true

    # Extract context for notification
    local initiative
    initiative="$(grep -E '^\*\*Initiative\*\*:' "$f" 2>/dev/null | sed 's/.*: //' || echo 'unknown')"
    local agent
    agent="$(grep -E '^\*\*Agent\*\*:' "$f" 2>/dev/null | sed 's/.*: //' || echo 'unknown')"
    local question
    question="$(sed -n '/^## Question/,/^##/p' "$f" 2>/dev/null | grep -v '^##' | head -3 | tr '\n' ' ')"

    # Send notification
    notify "decision" "${question:-Decision needed — see $f}" \
      --initiative "$initiative" \
      --agent "$agent" \
      --decision-file "$f"

    # Mark as notified
    touch "$notified_marker"
  done

  if (( pending_count > 0 )); then
    log_warn "$pending_count decision(s) pending human review in $DECISIONS_DIR"
  fi
}

# --- Notification & Reporting ------------------------------------------------

notify() {
  local type="$1"
  shift
  local message="$1"
  shift

  "${SCRIPT_DIR}/notify.sh" \
    --config "$CONFIG_FILE" \
    --type "$type" \
    --message "$message" \
    "$@" 2>/dev/null || log_debug "Notification failed (non-fatal)"
}

compile_report() {
  "${SCRIPT_DIR}/compile-report.sh" "$CONFIG_FILE" --format log 2>/dev/null || true
}

compile_and_post_report() {
  local slack_summary
  slack_summary="$("${SCRIPT_DIR}/compile-report.sh" "$CONFIG_FILE" --format slack 2>/dev/null)" || return
  if [[ -n "$slack_summary" ]]; then
    notify "report" "$slack_summary"
  fi
}

# --- Main Loop ----------------------------------------------------------------

main() {
  log_info "========================================="
  log_info "Deliberate_Agents Orchestrator starting"
  log_info "Project: $PROJECT_NAME"
  log_info "Worktrees: $WORKTREES_DIR"
  log_info "Poll interval: ${POLL_INTERVAL}s"
  log_info "Max developers: $MAX_DEVELOPERS"
  log_info "Autonomy: $AUTONOMY"
  log_info "Slack: ${SLACK_ENABLED}"
  log_info "Report interval: every ${REPORT_INTERVAL} cycles"
  log_info "========================================="

  # Ensure the tmux session exists
  if ! tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
    log_info "Creating tmux session: $TMUX_SESSION"
    tmux new-session -d -s "$TMUX_SESSION" -n "orchestrator"
  fi

  # Ensure state directories exist
  mkdir -p "$QUEUE_DIR" "$ASSIGNMENTS_DIR" "$STATUS_DIR" "$DECISIONS_DIR" "$LOG_DIR"

  # Launch Slack bot if enabled
  if [[ "$SLACK_ENABLED" == "true" ]]; then
    local slack_start="${FRAMEWORK_DIR}/integrations/slack/start.sh"
    if [[ -x "$slack_start" ]]; then
      log_info "Starting Slack bot..."
      "$slack_start" "$CONFIG_FILE" || log_warn "Slack bot launch failed (non-fatal)"
    else
      log_warn "Slack enabled but integrations/slack/start.sh not found"
    fi
  fi

  local consecutive_errors=0
  local poll_count=0
  local was_idle=false
  local was_all_blocked=false

  while true; do
    if (( consecutive_errors >= 5 )); then
      local backoff=$(( POLL_INTERVAL * 2 ))
      log_error "Too many consecutive errors, backing off to ${backoff}s"
      notify "alert" "Orchestrator backing off — ${consecutive_errors} consecutive errors"
      sleep "$backoff"
      consecutive_errors=0
    fi

    if process_queue && process_assignments; then
      consecutive_errors=0
    else
      ((consecutive_errors++)) || true
      log_error "Error during poll cycle ($consecutive_errors consecutive)"
    fi

    check_decisions

    # Compile report every cycle (lightweight — updates .deliberate/status/report.md)
    compile_report

    # Update structured dashboard
    "${FRAMEWORK_DIR}/orchestration/dashboard.sh" "$CONFIG_FILE" 2>/dev/null || true

    # Check for directives from the Integrator
    for msg_file in "${DELIBERATE_DIR}/comms/_system/inbox/orchestrator"/*.md; do
      [[ -f "$msg_file" ]] || continue
      log_info "System message from Integrator: $(basename "$msg_file")"
      # In bash loop mode, log and ack — the interactive agent mode processes fully
      mv "$msg_file" "${DELIBERATE_DIR}/comms/_system/ack/$(date -u '+%Y%m%d-%H%M%S')-ack-$(basename "$msg_file")" 2>/dev/null || true
    done

    # Post full Slack report every N cycles
    ((poll_count++)) || true
    if (( poll_count % REPORT_INTERVAL == 0 )); then
      compile_and_post_report
    fi

    # Reconcile initiative directories with STATUS.yaml state
    "${FRAMEWORK_DIR}/scripts/sync-initiatives.sh" "$CONFIG_FILE" --quiet --no-tracker 2>/dev/null || true

    # Evaluate recurring content schedules and create assignments for due items
    "${FRAMEWORK_DIR}/orchestration/check-schedules.sh" "$CONFIG_FILE" "$FRAMEWORK_DIR" 2>/dev/null || true

    # --- Idle / All-Blocked Detection ---
    local active_count
    active_count="$(count_active_developers)"
    local pending_count=0
    local blocked_count=0
    local review_count=0

    for f in "$QUEUE_DIR"/*.yaml; do
      [[ -f "$f" ]] || continue
      local st
      st="$(read_yaml_field "$f" 'status')"
      case "$st" in
        BLOCKED) ((blocked_count++)) || true ;;
        REVIEW_READY|DEV_COMPLETE) ((review_count++)) || true ;;
      esac
    done

    for f in "$DECISIONS_DIR"/*.md; do
      [[ -f "$f" ]] || continue
      local res
      res="$(sed -n '/^## Resolution/,/^##/p' "$f" 2>/dev/null | grep -v '^##' | tr -d '[:space:]')"
      [[ -z "$res" ]] && { ((pending_count++)) || true; }
    done 2>/dev/null

    # All agents idle — send a wrap-up summary (once)
    local pipeline_running=false
    any_initiative_agent_running && pipeline_running=true

    if (( active_count == 0 )) && ! $pipeline_running && ! $was_idle; then
      was_idle=true
      local summary="All agents are idle."
      (( review_count > 0 )) && summary+=" ${review_count} branch(es) ready for your review."
      (( pending_count > 0 )) && summary+=" ${pending_count} decision(s) waiting on you."
      (( blocked_count > 0 )) && summary+=" ${blocked_count} item(s) blocked."
      (( review_count == 0 && pending_count == 0 && blocked_count == 0 )) && summary+=" Nothing needs your attention — all clear."
      notify "report" "$summary"
      log_info "$summary"
    elif (( active_count > 0 )) || $pipeline_running; then
      was_idle=false
    fi

    # Everything blocked — escalate (once)
    if (( blocked_count > 0 && active_count == 0 && pending_count > 0 )) && ! $pipeline_running && ! $was_all_blocked; then
      was_all_blocked=true
      send_system_message "orchestrator" "integrator" "escalation" \
        "Work stalled: ${pending_count} decision(s) blocking progress" \
        "All work is stalled. ${blocked_count} initiative(s) blocked, ${pending_count} decision(s) need human input. Check .deliberate/decisions/ for pending items." \
        "critical"
      send_to_founder "orchestrator" "escalation" \
        "Work stalled: ${pending_count} decision(s) blocking progress" \
        "system" "critical" \
        "All work is stalled. ${blocked_count} initiative(s) blocked, ${pending_count} decision(s) need human input.\nCheck: ${DECISIONS_DIR}/"
      notify "alert" "Work is stalled — ${pending_count} decision(s) need your input before agents can continue. Check Slack threads or .deliberate/decisions/"
    elif (( blocked_count == 0 || active_count > 0 )) || $pipeline_running; then
      was_all_blocked=false
    fi

    # Write orchestrator heartbeat
    cat > "${STATUS_DIR}/orchestrator.md" <<EOF
# Status: Orchestrator

- **Status**: running
- **Last Poll**: $(date -u '+%Y-%m-%dT%H:%M:%SZ')
- **Active Developers**: ${active_count}
- **Pipeline Agent Running**: ${pipeline_running}
- **Pending Decisions**: ${pending_count}
- **Blocked**: ${blocked_count}
- **Review Ready**: ${review_count}
- **Poll Count**: ${poll_count}
- **Slack Enabled**: ${SLACK_ENABLED}
EOF

    sleep "$POLL_INTERVAL"
  done
}

# --- Entry Point --------------------------------------------------------------

trap 'log_info "Orchestrator shutting down"; kill 0 2>/dev/null; exit 0' SIGTERM SIGINT

# Prevent macOS sleep for the duration of this process
caffeinate -dimsu -w $$ &
CAFF_PID=$!
log_info "caffeinate active (PID $CAFF_PID) — Mac will stay awake"

main
