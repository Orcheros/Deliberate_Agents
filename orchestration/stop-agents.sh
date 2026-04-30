#!/usr/bin/env bash
#
# stop-agents.sh — Gracefully shut down all running agent sessions
#
# Sends SIGTERM to all agent tmux windows, waits for them to finish,
# and cleans up. Does NOT kill the orchestrator window by default.
#
# Usage: stop-agents.sh <config-file> [--all]

set -euo pipefail

CONFIG_FILE="${1:?Usage: stop-agents.sh <config-file> [--all]}"
KILL_ORCHESTRATOR=false

if [[ "${2:-}" == "--all" ]]; then
  KILL_ORCHESTRATOR=true
fi

parse_yaml() {
  local key="$1"
  grep -E "^\s*${key}:" "$CONFIG_FILE" | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'"
}

TMUX_SESSION="$(parse_yaml 'tmux_session')"
TMUX_SESSION="${TMUX_SESSION:-deliberate}"

if ! tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
  echo "No tmux session found: $TMUX_SESSION"
  exit 0
fi

echo "Stopping agents in tmux session: $TMUX_SESSION"

windows="$(tmux list-windows -t "$TMUX_SESSION" -F '#{window_name}')"

stopped=0
while IFS= read -r window; do
  [[ -n "$window" ]] || continue

  if [[ "$window" == "orchestrator" ]] && ! $KILL_ORCHESTRATOR; then
    echo "  Skipping orchestrator window (use --all to include)"
    continue
  fi

  echo "  Stopping window: $window"
  tmux send-keys -t "${TMUX_SESSION}:${window}" C-c 2>/dev/null || true
  sleep 1
  tmux kill-window -t "${TMUX_SESSION}:${window}" 2>/dev/null || true
  ((stopped++))
done <<< "$windows"

echo "Stopped $stopped agent window(s)"

if $KILL_ORCHESTRATOR; then
  echo "Killing tmux session: $TMUX_SESSION"
  tmux kill-session -t "$TMUX_SESSION" 2>/dev/null || true
fi
