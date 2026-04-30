#!/usr/bin/env bash
#
# status.sh — Report current state of the Deliberate_Agents system
#
# Displays initiative status, active agents, pending decisions,
# and tmux session information.
#
# Usage: status.sh <config-file>

set -euo pipefail

CONFIG_FILE="${1:?Usage: status.sh <config-file>}"

parse_yaml() {
  local key="$1"
  grep -E "^\s*${key}:" "$CONFIG_FILE" | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'"
}

read_yaml_field() {
  local file="$1"
  local field="$2"
  grep -E "^\s*${field}:" "$file" 2>/dev/null | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'"
}

PROJECT_NAME="$(parse_yaml 'name')"
WORKTREES_DIR="$(parse_yaml 'worktrees')"
TMUX_SESSION="$(parse_yaml 'tmux_session')"
TMUX_SESSION="${TMUX_SESSION:-deliberate}"

DELIBERATE_DIR="${WORKTREES_DIR}/.deliberate"

echo "==========================================="
echo "  Deliberate_Agents Status"
echo "  Project: $PROJECT_NAME"
echo "  $(date)"
echo "==========================================="
echo ""

echo "## Orchestrator"
if [[ -f "${DELIBERATE_DIR}/status/orchestrator.yaml" ]]; then
  orch_status="$(read_yaml_field "${DELIBERATE_DIR}/status/orchestrator.yaml" 'status')"
  last_poll="$(read_yaml_field "${DELIBERATE_DIR}/status/orchestrator.yaml" 'last_poll')"
  echo "  Status: $orch_status"
  echo "  Last poll: $last_poll"
else
  echo "  Status: not running"
fi
echo ""

echo "## tmux Session: $TMUX_SESSION"
if tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
  echo "  Session is active"
  tmux list-windows -t "$TMUX_SESSION" -F '  - #{window_name}' 2>/dev/null || true
else
  echo "  Session does not exist"
fi
echo ""

echo "## Initiatives"
if [[ -d "${DELIBERATE_DIR}/queue" ]]; then
  initiative_count=0
  for f in "${DELIBERATE_DIR}/queue/"*.yaml; do
    [[ -f "$f" ]] || continue
    ((initiative_count++))
    slug="$(basename "$f" .yaml)"
    status="$(read_yaml_field "$f" 'status')"
    printf "  %-30s %s\n" "$slug" "$status"
  done
  if (( initiative_count == 0 )); then
    echo "  No initiatives in queue"
  fi
else
  echo "  Queue directory not found"
fi
echo ""

echo "## Active Assignments"
if [[ -d "${DELIBERATE_DIR}/assignments" ]]; then
  assignment_count=0
  for f in "${DELIBERATE_DIR}/assignments/"*.yaml; do
    [[ -f "$f" ]] || continue
    ((assignment_count++))
    worktree="$(basename "$f" .yaml)"
    status="$(read_yaml_field "$f" 'status')"
    task_title="$(read_yaml_field "$f" 'title')"
    printf "  %-20s %-12s %s\n" "$worktree" "$status" "$task_title"
  done
  if (( assignment_count == 0 )); then
    echo "  No active assignments"
  fi
else
  echo "  Assignments directory not found"
fi
echo ""

echo "## Pending Decisions"
if [[ -d "${DELIBERATE_DIR}/decisions" ]]; then
  decision_count=0
  for f in "${DELIBERATE_DIR}/decisions/"*.md; do
    [[ -f "$f" ]] || continue
    ((decision_count++))
    echo "  - $(basename "$f")"
  done
  if (( decision_count == 0 )); then
    echo "  No pending decisions"
  fi
else
  echo "  Decisions directory not found"
fi
echo ""

echo "## Agent Status"
if [[ -d "${DELIBERATE_DIR}/status" ]]; then
  for f in "${DELIBERATE_DIR}/status/"*.yaml; do
    [[ -f "$f" ]] || continue
    agent="$(basename "$f" .yaml)"
    [[ "$agent" == "orchestrator" ]] && continue
    status="$(read_yaml_field "$f" 'status')"
    printf "  %-25s %s\n" "$agent" "$status"
  done
else
  echo "  No agent status reports"
fi
echo ""
echo "==========================================="
