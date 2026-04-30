#!/usr/bin/env bash
#
# launch-agent.sh — Spawn a headless Claude Code session in a tmux window
#
# Creates a new tmux window and runs Claude Code with the appropriate
# agent profile, workflow, and project context injected.
#
# Usage: launch-agent.sh --session <name> --window <name> --role <role> [options]

set -euo pipefail

# --- Argument Parsing ---------------------------------------------------------

TMUX_SESSION=""
WINDOW_NAME=""
ROLE=""
INITIATIVE=""
WORKTREE=""
WORKFLOW=""
CONFIG_FILE=""
FRAMEWORK_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session)      TMUX_SESSION="$2"; shift 2 ;;
    --window)       WINDOW_NAME="$2"; shift 2 ;;
    --role)         ROLE="$2"; shift 2 ;;
    --initiative)   INITIATIVE="$2"; shift 2 ;;
    --worktree)     WORKTREE="$2"; shift 2 ;;
    --workflow)     WORKFLOW="$2"; shift 2 ;;
    --config)       CONFIG_FILE="$2"; shift 2 ;;
    --framework-dir) FRAMEWORK_DIR="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# Validate required args
[[ -n "$TMUX_SESSION" ]] || { echo "ERROR: --session required"; exit 1; }
[[ -n "$WINDOW_NAME" ]]  || { echo "ERROR: --window required"; exit 1; }
[[ -n "$ROLE" ]]          || { echo "ERROR: --role required"; exit 1; }
[[ -n "$CONFIG_FILE" ]]   || { echo "ERROR: --config required"; exit 1; }
[[ -n "$FRAMEWORK_DIR" ]] || { echo "ERROR: --framework-dir required"; exit 1; }

# --- Configuration ------------------------------------------------------------

parse_yaml() {
  local key="$1"
  grep -E "^\s*${key}:" "$CONFIG_FILE" | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'"
}

REPO_DIR="$(parse_yaml 'repo')"
WORKTREES_DIR="$(parse_yaml 'worktrees')"
DELIBERATE_DIR="${WORKTREES_DIR}/.deliberate"

# Determine working directory based on role
case "$ROLE" in
  developer)
    [[ -n "$WORKTREE" ]] || { echo "ERROR: --worktree required for developer role"; exit 1; }
    WORK_DIR="${WORKTREES_DIR}/${WORKTREE}"
    if [[ ! -d "$WORK_DIR" ]]; then
      echo "ERROR: Worktree directory does not exist: $WORK_DIR"
      exit 1
    fi
    ;;
  product-manager|project-manager)
    WORK_DIR="$REPO_DIR"
    ;;
  *)
    echo "ERROR: Unknown role: $ROLE"
    exit 1
    ;;
esac

# --- Build the Prompt ---------------------------------------------------------

PROFILE_FILE="${FRAMEWORK_DIR}/agents/${ROLE}/profile.md"
if [[ ! -f "$PROFILE_FILE" ]]; then
  echo "ERROR: Agent profile not found: $PROFILE_FILE"
  exit 1
fi

# Determine workflow
if [[ -z "$WORKFLOW" ]]; then
  case "$ROLE" in
    product-manager)  WORKFLOW="initiative-intake" ;;
    project-manager)  WORKFLOW="review" ;;
    developer)        WORKFLOW="development" ;;
  esac
fi

WORKFLOW_DIR="${FRAMEWORK_DIR}/workflows/${WORKFLOW}"

# Build the system prompt from profile + workflow + context
PROMPT="$(cat "$PROFILE_FILE")"
PROMPT+="\n\n---\n\n"

# Add workflow instructions
if [[ -f "${WORKFLOW_DIR}/WORKFLOW.md" ]]; then
  PROMPT+="# Current Workflow\n\n"
  PROMPT+="$(cat "${WORKFLOW_DIR}/WORKFLOW.md")"
  PROMPT+="\n\n"
fi

# Add step files as reference
if [[ -d "${WORKFLOW_DIR}/steps" ]]; then
  for step_file in "${WORKFLOW_DIR}/steps"/*.md; do
    [[ -f "$step_file" ]] || continue
    PROMPT+="---\n\n"
    PROMPT+="$(cat "$step_file")"
    PROMPT+="\n\n"
  done
fi

# Add context based on role
PROMPT+="---\n\n# Current Context\n\n"
PROMPT+="- Project config: ${CONFIG_FILE}\n"
PROMPT+="- Framework directory: ${FRAMEWORK_DIR}\n"
PROMPT+="- State directory: ${DELIBERATE_DIR}\n"

case "$ROLE" in
  product-manager)
    PROMPT+="- Initiative: ${INITIATIVE}\n"
    PROMPT+="- Initiative state file: ${DELIBERATE_DIR}/queue/${INITIATIVE}.yaml\n"
    PROMPT+="\n## Your Task\n\n"
    PROMPT+="Process the initiative '${INITIATIVE}' through the initiative-intake workflow.\n"
    PROMPT+="Start by reading the initiative state file to find the one-pager path, then follow the workflow steps in order.\n"
    ;;
  project-manager)
    PROMPT+="- Initiative: ${INITIATIVE}\n"
    PROMPT+="- Initiative state file: ${DELIBERATE_DIR}/queue/${INITIATIVE}.yaml\n"
    PROMPT+="- Assignments directory: ${DELIBERATE_DIR}/assignments/\n"
    if [[ "$WORKFLOW" == "review" ]]; then
      PROMPT+="\n## Your Task\n\n"
      PROMPT+="Review the completed work for initiative '${INITIATIVE}'. Follow the review workflow steps.\n"
    else
      PROMPT+="\n## Your Task\n\n"
      PROMPT+="Break down the PRD for initiative '${INITIATIVE}' into tasks and create worktree assignments.\n"
    fi
    ;;
  developer)
    PROMPT+="- Worktree: ${WORKTREE}\n"
    PROMPT+="- Worktree path: ${WORK_DIR}\n"
    PROMPT+="- Assignment file: ${DELIBERATE_DIR}/assignments/${WORKTREE}.yaml\n"
    PROMPT+="\n## Your Task\n\n"
    PROMPT+="Execute the development task assigned in your assignment file. Follow the development workflow steps in order.\n"
    PROMPT+="Start by reading your assignment file.\n"
    ;;
esac

# --- Launch in tmux -----------------------------------------------------------

# Create a temporary file for the prompt
PROMPT_FILE="$(mktemp)"
echo -e "$PROMPT" > "$PROMPT_FILE"

# Create the tmux window with Claude Code
tmux new-window -t "$TMUX_SESSION" -n "$WINDOW_NAME" \
  "cd '$WORK_DIR' && claude --print --system-prompt '$(cat "$PROMPT_FILE")' --allowedTools 'Bash,Read,Write,Edit,Glob,Grep' 'Begin your assigned task. Read your assignment/state file first, then follow the workflow steps.' 2>&1 | tee '${DELIBERATE_DIR}/logs/${WINDOW_NAME}-$(date +%Y%m%d-%H%M%S).log'; echo 'Agent session ended. Press enter to close.'; read"

# Clean up prompt file after a delay (tmux needs it briefly)
(sleep 5 && rm -f "$PROMPT_FILE") &

echo "Launched $ROLE agent in tmux window: $TMUX_SESSION:$WINDOW_NAME"
