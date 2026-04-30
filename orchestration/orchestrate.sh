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
  grep -E "^\s*${key}:" "$CONFIG_FILE" | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'"
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
  grep -E "^\s*${field}:" "$file" 2>/dev/null | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'"
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
    --role "project-manager" \
    --initiative "$initiative_slug" \
    --workflow "review" \
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
        launch_pm_agent "$slug"
        ;;
      PRD_COMPLETE)
        log_info "Detected PRD complete for: $slug"
        launch_pjm_agent "$slug"
        ;;
      READY_FOR_DEV)
        log_info "Detected ready-for-dev: $slug — checking assignments"
        process_assignments
        ;;
      DEV_COMPLETE)
        log_info "Detected dev complete for: $slug"
        launch_review_agent "$slug"
        ;;
      REVIEW_READY)
        log_info "Initiative $slug is ready for human review"
        ;;
      BLOCKED)
        local reason
        reason="$(read_yaml_field "$initiative_file" 'blocker')"
        log_warn "Initiative $slug is BLOCKED: $reason"
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

    case "$status" in
      assigned)
        launch_dev_agent "$worktree"
        ;;
      in_progress)
        check_agent_health "dev-${worktree}" "$assignment_file"
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
    ((pending_count++))
  done

  if (( pending_count > 0 )); then
    log_warn "$pending_count decision(s) pending human review in $DECISIONS_DIR"
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
  log_info "========================================="

  # Ensure the tmux session exists
  if ! tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
    log_info "Creating tmux session: $TMUX_SESSION"
    tmux new-session -d -s "$TMUX_SESSION" -n "orchestrator"
  fi

  # Ensure state directories exist
  mkdir -p "$QUEUE_DIR" "$ASSIGNMENTS_DIR" "$STATUS_DIR" "$DECISIONS_DIR" "$LOG_DIR"

  local consecutive_errors=0

  while true; do
    if (( consecutive_errors >= 5 )); then
      local backoff=$(( POLL_INTERVAL * 2 ))
      log_error "Too many consecutive errors, backing off to ${backoff}s"
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

    # Write orchestrator heartbeat
    cat > "${STATUS_DIR}/orchestrator.yaml" <<EOF
status: "running"
last_poll: "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
active_developers: $(count_active_developers)
pending_decisions: $(ls "$DECISIONS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
EOF

    sleep "$POLL_INTERVAL"
  done
}

# --- Entry Point --------------------------------------------------------------

trap 'log_info "Orchestrator shutting down"; exit 0' SIGTERM SIGINT

main
