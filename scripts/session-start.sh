#!/usr/bin/env bash
#
# session-start.sh — Housekeeping at the start of every Claude Code session
#
# Called by the SessionStart hook. Handles:
#   1. Detect available project configs
#   2. Sleep prevention (caffeinate, overnight detection)
#   3. Slack bot launch
#   4. Project briefing (what needs attention, what's in progress)
#
# Outputs JSON with a systemMessage instructing Claude on what to do next.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORK_DIR="$(dirname "$SCRIPT_DIR")"

STATUS_LINES=()
HOUR=$(date +%H)
IS_LATE="false"

# --- Discover Projects --------------------------------------------------------

discover_projects() {
  local projects=()
  for f in "$FRAMEWORK_DIR"/config.*.yaml; do
    [[ -f "$f" ]] || continue
    local basename
    basename="$(basename "$f")"
    [[ "$basename" == "config.example.yaml" ]] && continue
    local name
    name=$(grep -E "^[[:space:]]*name:" "$f" | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'")
    local slug
    slug=$(echo "$basename" | sed 's/^config\.\(.*\)\.yaml$/\1/')
    projects+=("${slug}:${name}")
  done
  echo "${projects[*]}"
}

PROJECTS="$(discover_projects)"
PROJECT_COUNT=$(echo "$PROJECTS" | wc -w | tr -d ' ')

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

# --- Slack Bot (start for each project that has it enabled) -------------------

start_slack_for_config() {
  local config_file="$1"
  local project_name="$2"

  local slack_enabled
  slack_enabled=$(grep -E "^[[:space:]]*slack_enabled:" "$config_file" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'")

  if [[ "${slack_enabled:-false}" != "true" ]]; then
    return
  fi

  local tmux_session
  tmux_session=$(grep -E "^[[:space:]]*tmux_session:" "$config_file" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'")
  tmux_session="${tmux_session:-deliberate}"

  if ! tmux has-session -t "$tmux_session" 2>/dev/null; then
    tmux new-session -d -s "$tmux_session"
  fi

  if tmux list-windows -t "$tmux_session" 2>/dev/null | grep -q "slack-bot"; then
    STATUS_LINES+=("Slack ($project_name): already running")
    return
  fi

  local slack_start="${FRAMEWORK_DIR}/integrations/slack/start.sh"
  if [[ -x "$slack_start" ]]; then
    local result
    result=$("$slack_start" "$config_file" 2>&1 | tail -1)
    STATUS_LINES+=("Slack ($project_name): $result")
  fi
}

for pair in $PROJECTS; do
  slug="${pair%%:*}"
  name="${pair#*:}"
  start_slack_for_config "${FRAMEWORK_DIR}/config.${slug}.yaml" "$name"
done

# --- Open Agent View ----------------------------------------------------------
# If a tmux session exists with agent windows, open a visible Terminal window
# so the user can see all agent tabs without running any commands.

open_agent_view() {
  for pair in $PROJECTS; do
    slug="${pair%%:*}"
    config_file="${FRAMEWORK_DIR}/config.${slug}.yaml"
    local tmux_session
    tmux_session=$(grep -E "^[[:space:]]*tmux_session:" "$config_file" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'")
    tmux_session="${tmux_session:-deliberate}"

    if tmux has-session -t "$tmux_session" 2>/dev/null; then
      # Check if already attached somewhere
      local attached
      attached=$(tmux list-clients -t "$tmux_session" 2>/dev/null | wc -l | tr -d ' ')
      if [[ "$attached" -eq 0 ]]; then
        osascript -e "
          tell application \"Terminal\"
            activate
            do script \"tmux attach -t ${tmux_session}\"
          end tell
        " 2>/dev/null || true
        STATUS_LINES+=("Agent view: opened for ${tmux_session}")
      else
        STATUS_LINES+=("Agent view: already attached for ${tmux_session}")
      fi
    fi
  done
}

open_agent_view

# --- Briefings ----------------------------------------------------------------

BRIEFINGS=""
BRIEFING_SCRIPT="${FRAMEWORK_DIR}/orchestration/briefing.sh"

if [[ -x "$BRIEFING_SCRIPT" ]]; then
  for pair in $PROJECTS; do
    slug="${pair%%:*}"
    name="${pair#*:}"
    config_file="${FRAMEWORK_DIR}/config.${slug}.yaml"
    briefing=$("$BRIEFING_SCRIPT" "$config_file" 2>/dev/null || echo "(no state directory found for $name — this project may not have been initialized yet)")
    BRIEFINGS+="--- ${name} (config.${slug}.yaml) ---\n${briefing}\n\n"
  done
fi

# --- Build System Message -----------------------------------------------------

STATUS=$(printf '%s\n' "${STATUS_LINES[@]}")
TIMESTAMP=$(date '+%Y-%m-%d %H:%M %Z')

MSG="Session started at ${TIMESTAMP}.\n\n"

# Time awareness
if [[ "$IS_LATE" == "true" ]]; then
  MSG+="It's after 10 PM. Before beginning work, ask the user if they plan to run overnight. If yes, run \`sudo pmset -c sleep 0 && sudo pmset -c displaysleep 0 && sudo pmset -c disksleep 0 && sudo pmset -c powernap 0 && sudo pmset -c hibernatemode 0\` to keep the Mac awake all night. If no, caffeinate is already handling it for this session. Do NOT ask the user to run commands — handle it yourself.\n\n"
fi

# Project selection
if [[ "$PROJECT_COUNT" -eq 0 ]]; then
  MSG+="No project configs found. Ask the user which project they'd like to work on, then help them create a config file.\n\n"
elif [[ "$PROJECT_COUNT" -eq 1 ]]; then
  slug="${PROJECTS%%:*}"
  name="${PROJECTS#*:}"
  MSG+="One project available: ${name}. Ask the user to confirm this is the project they want to work on today, then present the briefing below and ask what they'd like to focus on.\n\n"
else
  MSG+="Multiple projects available. Ask the user which project they'd like to work on today:\n"
  for pair in $PROJECTS; do
    slug="${pair%%:*}"
    name="${pair#*:}"
    MSG+="  - ${name} (config.${slug}.yaml)\n"
  done
  MSG+="\nOnce they choose, present that project's briefing and ask what they'd like to focus on.\n\n"
fi

# Briefings
if [[ -n "$BRIEFINGS" ]]; then
  MSG+="PROJECT BRIEFINGS:\n\n${BRIEFINGS}"
fi

# System status
MSG+="Startup status:\n${STATUS}\n"

printf '%s' "$MSG" | jq -Rs '{"systemMessage": .}'
