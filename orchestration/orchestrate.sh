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

# --- Agent Launchers ----------------------------------------------------------

launch_pm_agent() {
  local initiative_slug="$1"
  local initiative_file="${QUEUE_DIR}/${initiative_slug}.yaml"
  local window_name="pm-${initiative_slug}"

  if agent_window_exists "$window_name"; then
    log_debug "PM agent already running for $initiative_slug"
    return
  fi

  log_info "Launching Product Manager agent for initiative: $initiative_slug"

  write_yaml_field "$initiative_file" "status" "PM_IN_PROGRESS"

  "${SCRIPT_DIR}/launch-agent.sh" \
    --session "$TMUX_SESSION" \
    --window "$window_name" \
    --role "product-manager" \
    --initiative "$initiative_slug" \
    --config "$CONFIG_FILE" \
    --framework-dir "$FRAMEWORK_DIR"
}

launch_pjm_agent() {
  local initiative_slug="$1"
  local initiative_file="${QUEUE_DIR}/${initiative_slug}.yaml"
  local window_name="pjm-${initiative_slug}"

  if agent_window_exists "$window_name"; then
    log_debug "PjM agent already running for $initiative_slug"
    return
  fi

  log_info "Launching Project Manager agent for initiative: $initiative_slug"

  write_yaml_field "$initiative_file" "status" "PJM_IN_PROGRESS"

  "${SCRIPT_DIR}/launch-agent.sh" \
    --session "$TMUX_SESSION" \
    --window "$window_name" \
    --role "project-manager" \
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

launch_review_agent() {
  local initiative_slug="$1"
  local window_name="review-${initiative_slug}"

  if agent_window_exists "$window_name"; then
    log_debug "Review agent already running for $initiative_slug"
    return
  fi

  log_info "Launching review agent for initiative: $initiative_slug"

  "${SCRIPT_DIR}/launch-agent.sh" \
    --session "$TMUX_SESSION" \
    --window "$window_name" \
    --role "reviewer" \
    --initiative "$initiative_slug" \
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

# --- Poll Functions -----------------------------------------------------------

process_queue() {
  [[ -d "$QUEUE_DIR" ]] || return

  for initiative_file in "$QUEUE_DIR"/*.yaml; do
    [[ -f "$initiative_file" ]] || continue

    local slug
    slug="$(basename "$initiative_file" .yaml)"
    local status
    status="$(read_yaml_field "$initiative_file" 'status')"

    case "$status" in
      QUEUED)
        log_info "Detected queued initiative: $slug"
        notify "transition" "QUEUED → PM_IN_PROGRESS" --initiative "$slug"
        launch_pm_agent "$slug"
        ;;
      PRD_COMPLETE)
        log_info "Detected PRD complete for: $slug"
        notify "transition" "PRD_COMPLETE → PJM_IN_PROGRESS" --initiative "$slug"
        launch_pjm_agent "$slug"
        ;;
      READY_FOR_DEV)
        log_info "Detected ready-for-dev: $slug — checking assignments"
        notify "transition" "READY_FOR_DEV — assigning developers" --initiative "$slug"
        process_assignments
        ;;
      DEV_COMPLETE)
        log_info "Detected dev complete for: $slug"
        notify "transition" "DEV_COMPLETE → REVIEW" --initiative "$slug"
        launch_review_agent "$slug"
        ;;
      REVIEW_READY)
        log_info "Initiative $slug is ready for human review"
        notify "transition" "REVIEW_READY — awaiting human review" --initiative "$slug"
        ;;
      BLOCKED)
        local reason
        reason="$(read_yaml_field "$initiative_file" 'blocker')"
        log_warn "Initiative $slug is BLOCKED: $reason"
        notify "alert" "Initiative BLOCKED: $reason" --initiative "$slug"
        ;;
      PM_IN_PROGRESS|PJM_IN_PROGRESS|DEV_IN_PROGRESS|REVIEW_IN_PROGRESS)
        log_debug "Initiative $slug is in progress ($status)"
        ;;
      COMPLETE)
        log_debug "Initiative $slug is complete"
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

    # Write orchestrator heartbeat
    cat > "${STATUS_DIR}/orchestrator.yaml" <<EOF
status: "running"
last_poll: "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
active_developers: $(count_active_developers)
pending_decisions: $(ls "$DECISIONS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
poll_count: ${poll_count}
slack_enabled: ${SLACK_ENABLED}
EOF

    sleep "$POLL_INTERVAL"
  done
}

# --- Entry Point --------------------------------------------------------------

trap 'log_info "Orchestrator shutting down"; exit 0' SIGTERM SIGINT

main
