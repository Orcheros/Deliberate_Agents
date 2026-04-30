#!/usr/bin/env bash
#
# teardown.sh — Remove Deliberate_Agents from a project
#
# Stops all agents, removes the .deliberate/ directory, and cleans up.
# Requires confirmation before destructive operations.
#
# Usage: teardown.sh <config-file> [--force]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORK_DIR="$(dirname "$SCRIPT_DIR")"

CONFIG_FILE="${1:?Usage: teardown.sh <config-file> [--force]}"
FORCE=false

if [[ "${2:-}" == "--force" ]]; then
  FORCE=true
fi

parse_yaml() {
  local key="$1"
  grep -E "^\s*${key}:" "$CONFIG_FILE" | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'"
}

PROJECT_NAME="$(parse_yaml 'name')"
WORKTREES_DIR="$(parse_yaml 'worktrees')"
TMUX_SESSION="$(parse_yaml 'tmux_session')"

DELIBERATE_DIR="${WORKTREES_DIR}/.deliberate"

if [[ ! -d "$DELIBERATE_DIR" ]]; then
  echo "No .deliberate/ directory found at: $DELIBERATE_DIR"
  echo "Nothing to tear down."
  exit 0
fi

echo "==========================================="
echo "  Deliberate_Agents Teardown"
echo "  Project: $PROJECT_NAME"
echo "==========================================="
echo ""
echo "This will:"
echo "  1. Stop all running agent sessions"
echo "  2. Kill the tmux session: ${TMUX_SESSION:-deliberate}"
echo "  3. Remove: $DELIBERATE_DIR"
echo ""

if ! $FORCE; then
  in_progress=0
  for f in "$DELIBERATE_DIR/queue/"*.yaml "$DELIBERATE_DIR/assignments/"*.yaml; do
    [[ -f "$f" ]] || continue
    status="$(grep -E '^\s*status:' "$f" | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'")"
    if [[ "$status" == *"IN_PROGRESS"* || "$status" == "in_progress" || "$status" == "assigned" ]]; then
      ((in_progress++))
    fi
  done

  if (( in_progress > 0 )); then
    echo "WARNING: $in_progress initiative(s)/task(s) are still in progress!"
    echo ""
  fi

  read -rp "Are you sure? [y/N] " confirm
  if [[ "$confirm" != [yY] ]]; then
    echo "Aborted."
    exit 0
  fi
fi

echo "Stopping agents..."
"${FRAMEWORK_DIR}/orchestration/stop-agents.sh" "$CONFIG_FILE" --all 2>/dev/null || true

echo "Removing $DELIBERATE_DIR..."
rm -rf "$DELIBERATE_DIR"

# Remove deployed agent definitions and skills
CLAUDE_DIR="${WORKTREES_DIR}/.claude"
if [[ -d "$CLAUDE_DIR" ]]; then
  echo "Removing deployed .claude/ directory..."
  rm -rf "${CLAUDE_DIR}/agents"
  rm -rf "${CLAUDE_DIR}/skills"
  # Only remove .claude/ itself if it's empty (may contain user config)
  rmdir "$CLAUDE_DIR" 2>/dev/null || true
fi

# Remove deployed .mcp.json
if [[ -f "${WORKTREES_DIR}/.mcp.json" ]]; then
  echo "Removing .mcp.json..."
  rm -f "${WORKTREES_DIR}/.mcp.json"
fi

echo ""
echo "Teardown complete. Deliberate_Agents has been removed from $PROJECT_NAME."
echo "The framework itself (${FRAMEWORK_DIR}) is untouched."
