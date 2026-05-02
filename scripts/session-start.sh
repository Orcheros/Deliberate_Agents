#!/usr/bin/env bash
#
# session-start.sh — Housekeeping at the start of every Claude Code session
#
# Called by the SessionStart hook. Handles sleep prevention, Slack bot,
# and time-awareness so the human doesn't have to remember anything.
#
# Outputs JSON with a systemMessage for Claude to act on.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORK_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="${FRAMEWORK_DIR}/config.henry.yaml"

STATUS_LINES=()
HOUR=$(date +%H)
IS_LATE="false"

# --- Sleep Prevention ---------------------------------------------------------

start_caffeinate() {
  if pgrep -f "caffeinate.*dimsu" > /dev/null 2>&1; then
    STATUS_LINES+=("caffeinate: already running")
  else
    caffeinate -dimsu &
    local pid=$!
    echo "$pid" > /tmp/deliberate-caffeinate.pid
    STATUS_LINES+=("caffeinate: started (PID $pid)")
  fi
}

start_caffeinate

if (( HOUR >= 22 || HOUR < 5 )); then
  IS_LATE="true"
fi

# --- Slack Bot ----------------------------------------------------------------

start_slack() {
  if [[ ! -f "$CONFIG_FILE" ]]; then
    STATUS_LINES+=("Slack bot: no config file found")
    return
  fi

  local slack_enabled
  slack_enabled=$(grep -E "^[[:space:]]*slack_enabled:" "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'")

  if [[ "${slack_enabled:-false}" != "true" ]]; then
    STATUS_LINES+=("Slack bot: disabled in config")
    return
  fi

  local tmux_session
  tmux_session=$(grep -E "^[[:space:]]*tmux_session:" "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'")
  tmux_session="${tmux_session:-deliberate}"

  # Ensure tmux session exists
  if ! tmux has-session -t "$tmux_session" 2>/dev/null; then
    tmux new-session -d -s "$tmux_session"
  fi

  # Check if already running
  if tmux list-windows -t "$tmux_session" 2>/dev/null | grep -q "slack-bot"; then
    STATUS_LINES+=("Slack bot: already running in $tmux_session:slack-bot")
    return
  fi

  local slack_start="${FRAMEWORK_DIR}/integrations/slack/start.sh"
  if [[ -x "$slack_start" ]]; then
    local result
    result=$("$slack_start" "$CONFIG_FILE" 2>&1 | tail -1)
    STATUS_LINES+=("Slack bot: $result")
  else
    STATUS_LINES+=("Slack bot: start.sh not found")
  fi
}

start_slack

# --- Build System Message -----------------------------------------------------

STATUS=$(printf '%s\n' "${STATUS_LINES[@]}")
TIMESTAMP=$(date '+%Y-%m-%d %H:%M %Z')

if [[ "$IS_LATE" == "true" ]]; then
  MSG="Session started at ${TIMESTAMP}. It's after 10 PM — before beginning work, ask the user if they plan to run overnight. If yes, run \`sudo pmset -c sleep 0 && sudo pmset -c displaysleep 0 && sudo pmset -c disksleep 0 && sudo pmset -c powernap 0 && sudo pmset -c hibernatemode 0\` to prevent sleep, then proceed. If no, caffeinate is already running and will keep things awake for this session. Either way, do NOT ask the user to run commands — handle it yourself.\n\nStartup status:\n${STATUS}"
else
  MSG="Session started at ${TIMESTAMP}. Housekeeping complete — caffeinate and Slack bot are handled. Proceed with the user's work.\n\nStartup status:\n${STATUS}"
fi

printf '%s' "$MSG" | jq -Rs '{"systemMessage": .}'
