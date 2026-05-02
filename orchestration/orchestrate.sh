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

# Count running developer agents
count_active_developers() {
  local count=0
  if [[ -d "$ASSIGNMENTS_DIR" ]]; then
    for f in "$ASSIGNMENTS_DIR"/*.yaml; do
      [[ -f "$f" ]] || continue
      local status
      status="$(read_yaml_field "$f" 'status')"
      if [[ "$status" == "in_progress" || "$status" == "assigned" ]]; then
        ((count++))
      fi
    done
  fi
  echo "$count"
}

# Check if a tmux window exists for an agent
agent_window_exists() {
  local window_name="$1"
  tmux list-windows -t "$TMUX_SESSION" 2>/dev/null | grep -q "$window_name"
}

# --- Agent Launcher (generic) -------------------------------------------------

launch_agent() {
  local role="$1"
  local initiative_slug="$2"
  local new_status="$3"
  local initiative_file="${QUEUE_DIR}/${initiative_slug}.yaml"
  local window_name="${role}-${initiative_slug}"

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
    --role "$role" \
    --initiative "$initiative_slug" \
    --config "$CONFIG_FILE" \
    --framework-dir "$FRAMEWORK_DIR"
}

launch_dev_agent() {
  local worktree_name="$1"
  local assignment_file="${ASSIGNMENTS_DIR}/${worktree_name}.yaml"
  local window_name="dev-${worktree_name}"

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
    --role "developer" \
    --worktree "$worktree_name" \
    --config "$CONFIG_FILE" \
    --framework-dir "$FRAMEWORK_DIR"
}

launch_specialist_agent() {
  local agent_type="$1"
  local worktree_name="$2"
  local assignment_file="${ASSIGNMENTS_DIR}/${worktree_name}.yaml"
  local window_name="${agent_type}-${worktree_name}"

  if agent_window_exists "$window_name"; then
    log_debug "${agent_type} agent already running for $worktree_name"
    return
  fi

  local initiative
  initiative="$(read_yaml_field "$assignment_file" 'initiative')"

  log_info "Launching ${agent_type} agent for assignment: $worktree_name"

  "${SCRIPT_DIR}/launch-agent.sh" \
    --session "$TMUX_SESSION" \
    --window "$window_name" \
    --role "$agent_type" \
    --initiative "${initiative:-}" \
    --worktree "$worktree_name" \
    --config "$CONFIG_FILE" \
    --framework-dir "$FRAMEWORK_DIR"
}

# --- Check if any initiative agent is currently running -----------------------

any_initiative_agent_running() {
  # Check for any product-pipeline agent window (pm-, architect-, designer-, scrum-)
  tmux list-windows -t "$TMUX_SESSION" 2>/dev/null | \
    grep -qE "(pm-|architect-|product-designer-|scrum-master-|project-manager-)" && return 0
  return 1
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

check_agent_completion() {
  local initiative_slug="$1"
  local initiative_file="${QUEUE_DIR}/${initiative_slug}.yaml"
  local status
  status="$(read_yaml_field "$initiative_file" 'status')"
  local title
  title="$(read_yaml_field "$initiative_file" 'title')"
  title="${title:-$initiative_slug}"

  case "$status" in
    PM_IN_PROGRESS)
      if ! agent_window_exists "pm-${initiative_slug}" && \
         ! agent_window_exists "product-manager-${initiative_slug}"; then
        log_info "PM agent finished for ${title}"
        write_yaml_field "$initiative_file" "status" "PRD_COMPLETE"
        notify "transition" "PRD complete for ${title} — launching architect" --initiative "$initiative_slug"
      fi
      ;;
    ARCH_IN_PROGRESS)
      if ! agent_window_exists "architect-${initiative_slug}"; then
        log_info "Architect agent finished for ${title}"
        write_yaml_field "$initiative_file" "status" "ARCH_COMPLETE"
        notify "transition" "Architecture doc complete for ${title} — launching designer" --initiative "$initiative_slug"
      fi
      ;;
    DESIGN_IN_PROGRESS)
      if ! agent_window_exists "product-designer-${initiative_slug}"; then
        log_info "Designer agent finished for ${title}"
        write_yaml_field "$initiative_file" "status" "DESIGN_COMPLETE"
        notify "transition" "Design brief complete for ${title} — launching scrum master" --initiative "$initiative_slug"
      fi
      ;;
    SCRUM_IN_PROGRESS)
      if ! agent_window_exists "scrum-master-${initiative_slug}"; then
        log_info "Scrum master finished for ${title}"
        write_yaml_field "$initiative_file" "status" "SPECIFIED"
        notify "progress" "${title} is fully specified — ready for handoff to Design or Engineering" --initiative "$initiative_slug"
      fi
      ;;
    PJM_IN_PROGRESS)
      if ! agent_window_exists "project-manager-${initiative_slug}"; then
        log_info "Project Manager finished for ${title}"
        write_yaml_field "$initiative_file" "status" "READY_FOR_DEV"
        notify "transition" "${title} has tasks assigned — ready for development" --initiative "$initiative_slug"
      fi
      ;;
  esac
}

# --- Poll Functions -----------------------------------------------------------

process_queue() {
  [[ -d "$QUEUE_DIR" ]] || return

  # Check if the active initiative's agent finished and advance the pipeline
  local active_slug
  active_slug="$(get_active_initiative)"
  if [[ -n "$active_slug" ]]; then
    check_agent_completion "$active_slug"
  fi

  # If an agent is still running, don't launch anything new
  if any_initiative_agent_running; then
    return
  fi

  # Find the current active initiative (may have just advanced to a new state)
  # or pick the next QUEUED one
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
        log_info "Starting product pipeline for: ${title}"
        notify "transition" "Starting product definition for ${title}" --initiative "$slug"
        launch_agent "product-manager" "$slug" "PM_IN_PROGRESS"
        return  # Only one at a time
        ;;

      PRD_COMPLETE)
        log_info "Advancing ${title} to architecture"
        launch_agent "architect" "$slug" "ARCH_IN_PROGRESS"
        return
        ;;

      ARCH_COMPLETE)
        log_info "Advancing ${title} to design"
        launch_agent "product-designer" "$slug" "DESIGN_IN_PROGRESS"
        return
        ;;

      DESIGN_COMPLETE)
        log_info "Advancing ${title} to scrum breakdown"
        launch_agent "scrum-master" "$slug" "SCRUM_IN_PROGRESS"
        return
        ;;

      SPECIFIED)
        log_info "${title} is fully specified — awaiting handoff decision"
        notify "progress" "${title} is fully specified. Handoff artifacts are ready — assign to Design (Claude Design) or Engineering when ready." --initiative "$slug"
        write_yaml_field "$initiative_file" "status" "AWAITING_HANDOFF"
        ;;

      AWAITING_HANDOFF)
        log_debug "${title} is awaiting handoff decision"
        ;;

      # --- Engineering Pipeline (after handoff) ---

      READY_FOR_DEV)
        log_info "${title} ready for dev — checking assignments"
        notify "transition" "${title} is ready for development — assigning engineers" --initiative "$slug"
        process_assignments
        ;;

      DEV_COMPLETE)
        log_info "Dev complete for ${title}"
        notify "transition" "Development complete for ${title} — starting code review" --initiative "$slug"
        launch_agent "reviewer" "$slug" "REVIEW_IN_PROGRESS"
        return
        ;;

      REVIEW_READY)
        log_info "${title} ready for human review"
        notify "progress" "${title} is ready for your review — branch is waiting in Cursor" --initiative "$slug"
        ;;

      BLOCKED)
        local reason
        reason="$(read_yaml_field "$initiative_file" 'blocker')"
        log_warn "${title} is BLOCKED: $reason"
        notify "alert" "${title} is blocked: ${reason}" --initiative "$slug"
        ;;

      PM_IN_PROGRESS|ARCH_IN_PROGRESS|DESIGN_IN_PROGRESS|SCRUM_IN_PROGRESS|\
      PJM_IN_PROGRESS|DEV_IN_PROGRESS|REVIEW_IN_PROGRESS)
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
  [[ -d "$ASSIGNMENTS_DIR" ]] || return

  for assignment_file in "$ASSIGNMENTS_DIR"/*.yaml; do
    [[ -f "$assignment_file" ]] || continue

    local worktree
    worktree="$(basename "$assignment_file" .yaml)"
    local status
    status="$(read_yaml_field "$assignment_file" 'status')"

    local agent_type
    agent_type="$(read_yaml_field "$assignment_file" 'agent_type')"
    agent_type="${agent_type:-developer}"

    case "$status" in
      assigned)
        case "$agent_type" in
          developer)
            launch_dev_agent "$worktree"
            ;;
          integrations-engineer|content-writer|compliance-analyst|\
          technical-writer|devops-engineer|security-analyst|\
          sales-development-rep|account-executive-assistant|\
          customer-success|onboarding-specialist|seo-specialist)
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
        reason="$(read_yaml_field "$assignment_file" 'blocker')"
        log_warn "Assignment $worktree is BLOCKED: $reason"
        ;;
    esac
  done
}

check_agent_health() {
  local window_name="$1"
  local state_file="$2"

  if ! agent_window_exists "$window_name"; then
    log_warn "Agent window $window_name disappeared — session may have crashed"
    local status
    status="$(read_yaml_field "$state_file" 'status')"
    if [[ "$status" == "in_progress" ]]; then
      log_warn "Marking $state_file as blocked (agent crashed)"
      write_yaml_field "$state_file" "status" "blocked"
      write_yaml_field "$state_file" "blocker" "Agent session crashed unexpectedly"
      notify "alert" "Agent $window_name crashed — session marked as blocked"
    fi
  fi
}

check_initiative_completion() {
  local assignment_file="$1"
  local initiative
  initiative="$(read_yaml_field "$assignment_file" 'initiative')"

  [[ -n "$initiative" ]] || return

  local all_complete=true
  for f in "$ASSIGNMENTS_DIR"/*.yaml; do
    [[ -f "$f" ]] || continue
    local init
    init="$(read_yaml_field "$f" 'initiative')"
    [[ "$init" == "$initiative" ]] || continue
    local status
    status="$(read_yaml_field "$f" 'status')"
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
    fi
  fi
}

check_decisions() {
  [[ -d "$DECISIONS_DIR" ]] || return

  local pending_count=0
  for f in "$DECISIONS_DIR"/*.md; do
    [[ -f "$f" ]] || continue

    # Check if already notified (marker file)
    local notified_marker="${f}.notified"
    if [[ -f "$notified_marker" ]]; then
      # Already sent notification, check for resolution
      local resolution_content
      resolution_content="$(sed -n '/^## Resolution/,/^##/p' "$f" 2>/dev/null | grep -v '^##' | tr -d '[:space:]')"
      if [[ -n "$resolution_content" ]]; then
        log_info "Decision resolved: $(basename "$f" .md)"
        rm -f "$notified_marker"
      else
        ((pending_count++))
      fi
      continue
    fi

    ((pending_count++))

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
      ((consecutive_errors++))
      log_error "Error during poll cycle ($consecutive_errors consecutive)"
    fi

    check_decisions

    # Compile report every cycle (lightweight — updates .deliberate/status/report.md)
    compile_report

    # Post full Slack report every N cycles
    ((poll_count++))
    if (( poll_count % REPORT_INTERVAL == 0 )); then
      compile_and_post_report
    fi

    # Reconcile initiative directories with STATUS.yaml state
    "${FRAMEWORK_DIR}/scripts/sync-initiatives.sh" "$CONFIG_FILE" --quiet --no-tracker 2>/dev/null || true

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
        BLOCKED) ((blocked_count++)) ;;
        REVIEW_READY|DEV_COMPLETE) ((review_count++)) ;;
      esac
    done

    for f in "$DECISIONS_DIR"/*.md; do
      [[ -f "$f" ]] || continue
      local res
      res="$(sed -n '/^## Resolution/,/^##/p' "$f" 2>/dev/null | grep -v '^##' | tr -d '[:space:]')"
      [[ -z "$res" ]] && ((pending_count++))
    done 2>/dev/null

    # All agents idle — send a wrap-up summary (once)
    if (( active_count == 0 )) && ! $was_idle; then
      was_idle=true
      local summary="All agents are idle."
      (( review_count > 0 )) && summary+=" ${review_count} branch(es) ready for your review."
      (( pending_count > 0 )) && summary+=" ${pending_count} decision(s) waiting on you."
      (( blocked_count > 0 )) && summary+=" ${blocked_count} item(s) blocked."
      (( review_count == 0 && pending_count == 0 && blocked_count == 0 )) && summary+=" Nothing needs your attention — all clear."
      notify "report" "$summary"
      log_info "$summary"
    elif (( active_count > 0 )); then
      was_idle=false
    fi

    # Everything blocked — escalate (once)
    if (( blocked_count > 0 && active_count == 0 && pending_count > 0 )) && ! $was_all_blocked; then
      was_all_blocked=true
      notify "alert" "Work is stalled — ${pending_count} decision(s) need your input before agents can continue. Check Slack threads or .deliberate/decisions/"
    elif (( blocked_count == 0 || active_count > 0 )); then
      was_all_blocked=false
    fi

    # Write orchestrator heartbeat
    cat > "${STATUS_DIR}/orchestrator.yaml" <<EOF
status: "running"
last_poll: "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
active_developers: ${active_count}
pending_decisions: ${pending_count}
blocked: ${blocked_count}
review_ready: ${review_count}
poll_count: ${poll_count}
slack_enabled: ${SLACK_ENABLED}
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
