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

# --- Agent Teams Settings Verification ----------------------------------------
# Verify agent teams and split-pane mode are configured in Claude Code settings.
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
if [[ -f "$CLAUDE_SETTINGS" ]]; then
  if ! grep -q '"teammateMode"' "$CLAUDE_SETTINGS" 2>/dev/null; then
    STATUS_LINES+=("agent teams: teammateMode not set — run init.sh to configure split panes")
  fi
  if ! grep -q 'CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS' "$CLAUDE_SETTINGS" 2>/dev/null; then
    STATUS_LINES+=("agent teams: not enabled — run init.sh to enable")
  fi
  if ! command -v it2 &>/dev/null; then
    STATUS_LINES+=("it2: not found — install with 'pip3 install it2' for iTerm2 split panes")
  fi
fi

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

# --- Check Orchestrator Escalations -------------------------------------------

ESCALATIONS=""
ORCH_STATUS=""

for pair in $PROJECTS; do
  slug="${pair%%:*}"
  name="${pair#*:}"
  config_file="${FRAMEWORK_DIR}/config.${slug}.yaml"

  worktrees=$(grep -E "^[[:space:]]*worktrees:" "$config_file" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'")
  [[ -n "$worktrees" ]] || continue

  # Check for pending escalations from the Orchestrator
  inbox="${worktrees}/.deliberate/comms/_system/inbox/integrator"
  if [[ -d "$inbox" ]]; then
    msg_count=0
    for msg_file in "$inbox"/*.md; do
      [[ -f "$msg_file" ]] || continue
      ((msg_count++)) || true
    done
    if (( msg_count > 0 )); then
      ESCALATIONS+="  ${name}: ${msg_count} message(s) from Orchestrator\\n"
      for msg_file in "$inbox"/*.md; do
        [[ -f "$msg_file" ]] || continue
        urgency=$(grep -E '^\*\*Urgency\*\*:' "$msg_file" 2>/dev/null | head -1 | sed 's/.*: //')
        subject=$(grep -E '^# ' "$msg_file" 2>/dev/null | head -1 | sed 's/^# //')
        if [[ "$urgency" == "critical" ]]; then
          ESCALATIONS+="    CRITICAL: ${subject}\\n"
        elif [[ "$urgency" == "warning" ]]; then
          ESCALATIONS+="    WARNING: ${subject}\\n"
        fi
      done
    fi
  fi

  # Check if Orchestrator is running
  tmux_session=$(grep -E "^[[:space:]]*tmux_session:" "$config_file" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'")
  tmux_session="${tmux_session:-deliberate}"
  orch_running="false"
  if tmux list-windows -t "$tmux_session" 2>/dev/null | grep -qi "orchestrat"; then
    orch_running="true"
  fi
  if [[ "$orch_running" == "true" ]]; then
    ORCH_STATUS+="  ${name}: RUNNING in tmux session '${tmux_session}'\\n"
  else
    ORCH_STATUS+="  ${name}: NOT RUNNING — launch with: bash ${FRAMEWORK_DIR}/orchestration/launch-agent.sh --session ${tmux_session} --name orchestrator --role orchestrator --config ${config_file} --framework-dir ${FRAMEWORK_DIR}\\n"
  fi
done

# --- Build System Message -----------------------------------------------------

STATUS=$(printf '%s\n' "${STATUS_LINES[@]}")
TIMESTAMP=$(date '+%Y-%m-%d %H:%M %Z')

MSG="Session started at ${TIMESTAMP}.\n\n"

# --- Visionary Session Identity ---
MSG+="## Deliberate Agents — Visionary Session\n\n"
MSG+="You are the user's direct Claude Code session. The user is the **Visionary** — the founder/operator who decides what gets built. You help them interact with the Deliberate Agents system.\n\n"
MSG+="The Integrator and Orchestrator are **separate AI agents** that run in tmux panes:\n"
MSG+="- **Integrator** (top pane): Strategic executor — validates ideas, prioritizes the pipeline, tracks initiatives to completion\n"
MSG+="- **Orchestrator** (bottom pane): Tactical coordinator — launches specialist agents, manages handoffs, escalates blockers\n\n"
MSG+="Launch both with \`/deliberate\`. Once running, the user attaches to the tmux coordination window to talk to them directly.\n\n"
MSG+="**What you can do in this session**:\n"
MSG+="- Launch the coordination window: \`/deliberate\`\n"
MSG+="- Send messages to the Integrator or Orchestrator via their inboxes in .deliberate/comms/_system/inbox/\n"
MSG+="- Check status: read .deliberate/ state files and present the board state\n"
MSG+="- Run the learning pass: \`/deliberate-learn\` or \`/deliberate-relearn\`\n"
MSG+="- Open the command center: \`/orchestrate\`\n\n"

# --- Pending Escalations (shown before everything else if present) ---
if [[ -n "$ESCALATIONS" ]]; then
  MSG+="## PENDING ORCHESTRATOR ESCALATIONS\n\n"
  MSG+="${ESCALATIONS}\n"
  MSG+="Review these messages before starting new work. Read each file, act on it, then move it to comms/_system/ack/.\n\n"
fi

# --- Orchestrator Status ---
if [[ -n "$ORCH_STATUS" ]]; then
  MSG+="## Orchestrator Status\n\n"
  MSG+="${ORCH_STATUS}\n"
fi

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
  MSG+="One project available: ${name}.\n\n"
else
  MSG+="Multiple projects available. Ask the user which project they'd like to focus on:\n"
  for pair in $PROJECTS; do
    slug="${pair%%:*}"
    name="${pair#*:}"
    MSG+="  - ${name} (config.${slug}.yaml)\n"
  done
  MSG+="\n"
fi

# Briefings
if [[ -n "$BRIEFINGS" ]]; then
  MSG+="## Project Briefings\n\n${BRIEFINGS}"
fi

# System status
MSG+="Startup status:\n${STATUS}\n"

printf '%s' "$MSG" | jq -Rs '{"systemMessage": .}'
