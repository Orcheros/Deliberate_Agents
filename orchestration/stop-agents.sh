#!/usr/bin/env bash
#
# stop-agents.sh — Gracefully shut down all running agent sessions
#
# Iterates tmux panes in each window, sends C-c to gracefully stop agents,
# then kills the panes. Cleans up PID files. Does NOT kill the orchestrator
# window by default.
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

WORKTREES_DIR="$(parse_yaml 'worktrees')"
PID_DIR="${WORKTREES_DIR}/.deliberate/pids"

if ! tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
  echo "No tmux session found: $TMUX_SESSION"
  # Still clean up any orphaned PID files
  if [[ -d "$PID_DIR" ]]; then
    rm -f "$PID_DIR"/*.pid 2>/dev/null || true
    echo "Cleaned up orphaned PID files"
  fi
  exit 0
fi

echo "Stopping agents in tmux session: $TMUX_SESSION"

windows="$(tmux list-windows -t "$TMUX_SESSION" -F '#{window_name}')"

stopped_panes=0
stopped_windows=0

while IFS= read -r window; do
  [[ -n "$window" ]] || continue

  if [[ "$window" == "orchestrator" ]] && ! $KILL_ORCHESTRATOR; then
    echo "  Skipping orchestrator window (use --all to include)"
    continue
  fi

  # Get all panes in this window
  panes="$(tmux list-panes -t "${TMUX_SESSION}:${window}" -F '#{pane_id}' 2>/dev/null)" || continue

  echo "  Stopping window: $window"

  # Send C-c to each pane first for graceful shutdown
  while IFS= read -r pane_id; do
    [[ -n "$pane_id" ]] || continue
    tmux send-keys -t "$pane_id" C-c 2>/dev/null || true
    ((stopped_panes++))
  done <<< "$panes"

  # Brief pause for graceful shutdown
  sleep 2

  # Kill the entire window (removes all panes)
  tmux kill-window -t "${TMUX_SESSION}:${window}" 2>/dev/null || true
  ((stopped_windows++))
done <<< "$windows"

# Clean up PID files
if [[ -d "$PID_DIR" ]]; then
  pid_count=0
  for pid_file in "$PID_DIR"/*.pid; do
    [[ -f "$pid_file" ]] || continue
    local_pid="$(cat "$pid_file" 2>/dev/null)" || continue
    # Kill the process if still running
    kill "$local_pid" 2>/dev/null || true
    rm -f "$pid_file"
    ((pid_count++)) || true
  done
  [[ $pid_count -gt 0 ]] && echo "  Cleaned up $pid_count PID file(s)"
fi

echo "Stopped $stopped_panes pane(s) across $stopped_windows window(s)"

if $KILL_ORCHESTRATOR; then
  echo "Killing tmux session: $TMUX_SESSION"
  tmux kill-session -t "$TMUX_SESSION" 2>/dev/null || true
fi
