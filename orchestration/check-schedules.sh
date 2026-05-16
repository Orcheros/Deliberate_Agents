#!/usr/bin/env bash
# check-schedules.sh — Evaluate schedule definitions and create assignments for due items
# Called by orchestrate.sh each poll cycle. Checks schedules/ YAML files against current time.
# Uses marker files in .deliberate/schedules/<name>.last to prevent double-execution.
set -euo pipefail

CONFIG_FILE="${1:-}"
FRAMEWORK_DIR="${2:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

[[ -z "$CONFIG_FILE" ]] && { echo "Usage: check-schedules.sh <config-file> [framework-dir]"; exit 1; }

SCHEDULES_DIR="${FRAMEWORK_DIR}/schedules"
[[ -d "$SCHEDULES_DIR" ]] || exit 0

# Read config values
REPO_DIR="$(grep 'repo:' "$CONFIG_FILE" | head -1 | sed 's/.*: *"\?\([^"]*\)"\?/\1/')"
DELIBERATE_DIR="${REPO_DIR}/.deliberate"
SCHEDULES_STATE_DIR="${DELIBERATE_DIR}/schedules"
ASSIGNMENTS_DIR="${DELIBERATE_DIR}/assignments"

# Check if content scheduling is enabled
SCHEDULES_ENABLED="$(grep 'schedules_enabled:' "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*: *//' | tr -d ' "')"
[[ "$SCHEDULES_ENABLED" == "false" ]] && exit 0

# Ensure state directories exist
mkdir -p "$SCHEDULES_STATE_DIR" "$ASSIGNMENTS_DIR"

# Get poll interval from config (default 30s, used for window matching)
POLL_INTERVAL="$(grep 'poll_interval_seconds:' "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*: *//' | tr -d ' ')"
POLL_INTERVAL="${POLL_INTERVAL:-30}"

# Window: fire if scheduled time is within this many seconds of now
# Set to 2x poll interval to avoid missing schedules
WINDOW_SECONDS=$(( POLL_INTERVAL * 2 ))

# --- Helper Functions ---

read_yaml_value() {
  local file="$1" key="$2"
  grep "^  ${key}:" "$file" 2>/dev/null | head -1 | sed 's/.*: *"\?\([^"]*\)"\?/\1/' | tr -d '"'
}

read_yaml_top() {
  local file="$1" key="$2"
  grep "^${key}:" "$file" 2>/dev/null | head -1 | sed 's/.*: *"\?\([^"]*\)"\?/\1/' | tr -d '"'
}

get_current_epoch() {
  date +%s
}

get_day_of_week() {
  # Returns lowercase day name in the given timezone
  local tz="$1"
  TZ="$tz" date +%A | tr '[:upper:]' '[:lower:]'
}

get_time_epoch_for_today() {
  # Get epoch time for a HH:MM time today in a given timezone
  local time_str="$1" tz="$2"
  local hour="${time_str%%:*}"
  local minute="${time_str##*:}"
  local today
  today="$(TZ="$tz" date +%Y-%m-%d)"
  # macOS date -j parsing
  if date -j -f "%Y-%m-%d %H:%M" "${today} ${hour}:${minute}" +%s 2>/dev/null; then
    return
  fi
  # Linux fallback
  TZ="$tz" date -d "${today} ${hour}:${minute}" +%s 2>/dev/null || echo "0"
}

already_ran_today() {
  local name="$1"
  local marker_file="${SCHEDULES_STATE_DIR}/${name}.last"
  [[ ! -f "$marker_file" ]] && return 1
  local last_run today
  last_run="$(cat "$marker_file" 2>/dev/null)"
  today="$(date +%Y-%m-%d)"
  [[ "$last_run" == "$today" ]]
}

mark_ran() {
  local name="$1"
  date +%Y-%m-%d > "${SCHEDULES_STATE_DIR}/${name}.last"
}

create_assignment() {
  local agent="$1" schedule_name="$2" description="$3"
  local assignment_file="${ASSIGNMENTS_DIR}/scheduled-${schedule_name}.md"

  # Don't create if assignment already exists and isn't complete
  if [[ -f "$assignment_file" ]]; then
    local existing_status
    existing_status="$(grep '^- Status:' "$assignment_file" 2>/dev/null | sed 's/.*: *//')"
    if [[ "$existing_status" != "complete" ]]; then
      return 0
    fi
  fi

  cat > "$assignment_file" <<EOF
# Scheduled Task: ${schedule_name}

- Agent: ${agent}
- Status: assigned
- Priority: normal
- Created: $(date -u '+%Y-%m-%dT%H:%M:%SZ')
- Source: schedule/${schedule_name}

## Description

${description}

## Instructions

Execute your primary skill workflow. This is an automated scheduled invocation.
Report results via standard status file updates and Slack notifications.
EOF
}

# --- Main Logic ---

NOW_EPOCH="$(get_current_epoch)"

for schedule_file in "$SCHEDULES_DIR"/*.yaml; do
  [[ -f "$schedule_file" ]] || continue

  name="$(read_yaml_top "$schedule_file" 'name')"
  agent="$(read_yaml_top "$schedule_file" 'agent')"
  description="$(read_yaml_top "$schedule_file" 'description')"
  frequency="$(read_yaml_value "$schedule_file" 'frequency')"
  time_str="$(read_yaml_value "$schedule_file" 'time')"
  timezone="$(read_yaml_value "$schedule_file" 'timezone')"
  day="$(read_yaml_value "$schedule_file" 'day')"

  [[ -z "$name" || -z "$agent" || -z "$time_str" ]] && continue

  timezone="${timezone:-America/New_York}"

  # Check if already ran today
  if already_ran_today "$name"; then
    continue
  fi

  # Weekly schedules: check day of week
  if [[ "$frequency" == "weekly" ]]; then
    current_day="$(get_day_of_week "$timezone")"
    if [[ "$current_day" != "$day" ]]; then
      continue
    fi
  fi

  # Check if current time is within window of scheduled time
  scheduled_epoch="$(get_time_epoch_for_today "$time_str" "$timezone")"
  [[ "$scheduled_epoch" == "0" ]] && continue

  diff=$(( NOW_EPOCH - scheduled_epoch ))
  # Allow negative diff (slightly before) and positive diff (slightly after)
  if [[ "$diff" -lt "-${WINDOW_SECONDS}" ]] || [[ "$diff" -gt "$WINDOW_SECONDS" ]]; then
    continue
  fi

  # Schedule matches — create assignment and mark as ran
  create_assignment "$agent" "$name" "$description"
  mark_ran "$name"

done
