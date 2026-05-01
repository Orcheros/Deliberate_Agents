#!/usr/bin/env bash
#
# launch-agent.sh — Spawn a headless Claude Code session in a tmux window
#
# Uses Claude Code's native --agent flag with agent definitions from
# .claude/agents/*.md. Dynamic context (initiative, worktree, paths)
# is passed via --append-system-prompt instead of building a giant
# concatenated system prompt.
#
# Usage: launch-agent.sh --session <name> --window <name> --role <role> [options]

set -euo pipefail

# --- Argument Parsing ---------------------------------------------------------

TMUX_SESSION=""
WINDOW_NAME=""
ROLE=""
INITIATIVE=""
WORKTREE=""
CONFIG_FILE=""
FRAMEWORK_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session)      TMUX_SESSION="$2"; shift 2 ;;
    --window)       WINDOW_NAME="$2"; shift 2 ;;
    --role)         ROLE="$2"; shift 2 ;;
    --initiative)   INITIATIVE="$2"; shift 2 ;;
    --worktree)     WORKTREE="$2"; shift 2 ;;
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
  product-manager|project-manager|reviewer|\
  integrations-engineer|content-writer|compliance-analyst|\
  technical-writer|devops-engineer|security-analyst|\
  sales-development-rep|account-executive-assistant|\
  customer-success|onboarding-specialist|seo-specialist)
    WORK_DIR="$REPO_DIR"
    ;;
  *)
    echo "ERROR: Unknown role: $ROLE"
    exit 1
    ;;
esac

# --- Build Dynamic Context ---------------------------------------------------

# Only the runtime-specific context goes here — agent identity, workflow steps,
# and skills are handled natively by the --agent flag.
CONTEXT="# Runtime Context\n"
CONTEXT+="- Project config: ${CONFIG_FILE}\n"
CONTEXT+="- Framework directory: ${FRAMEWORK_DIR}\n"
CONTEXT+="- State directory: ${DELIBERATE_DIR}\n"

case "$ROLE" in
  product-manager)
    CONTEXT+="- Initiative: ${INITIATIVE}\n"
    CONTEXT+="- Initiative state file: ${DELIBERATE_DIR}/queue/${INITIATIVE}.yaml\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Process the initiative '${INITIATIVE}' through the initiative-intake workflow.\n"
    CONTEXT+="Start by reading the initiative state file to find the one-pager path, then follow the workflow steps in order.\n"
    ;;
  project-manager)
    CONTEXT+="- Initiative: ${INITIATIVE}\n"
    CONTEXT+="- Initiative state file: ${DELIBERATE_DIR}/queue/${INITIATIVE}.yaml\n"
    CONTEXT+="- Assignments directory: ${DELIBERATE_DIR}/assignments/\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Break down the PRD for initiative '${INITIATIVE}' into tasks and create worktree assignments.\n"
    ;;
  reviewer)
    CONTEXT+="- Initiative: ${INITIATIVE}\n"
    CONTEXT+="- Initiative state file: ${DELIBERATE_DIR}/queue/${INITIATIVE}.yaml\n"
    CONTEXT+="- Assignments directory: ${DELIBERATE_DIR}/assignments/\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Review the completed work for initiative '${INITIATIVE}'. Follow the review workflow steps.\n"
    ;;
  developer)
    CONTEXT+="- Worktree: ${WORKTREE}\n"
    CONTEXT+="- Worktree path: ${WORK_DIR}\n"
    CONTEXT+="- Assignment file: ${DELIBERATE_DIR}/assignments/${WORKTREE}.yaml\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Execute the development task assigned in your assignment file. Follow the development workflow steps in order.\n"
    CONTEXT+="Start by reading your assignment file.\n"
    ;;
  integrations-engineer|content-writer|compliance-analyst|\
  technical-writer|devops-engineer|security-analyst|\
  sales-development-rep|account-executive-assistant|\
  customer-success|onboarding-specialist|seo-specialist)
    CONTEXT+="- Initiative: ${INITIATIVE}\n"
    if [[ -n "$WORKTREE" ]]; then
      CONTEXT+="- Assignment file: ${DELIBERATE_DIR}/assignments/${WORKTREE}.yaml\n"
    elif [[ -n "$INITIATIVE" ]]; then
      CONTEXT+="- Initiative state file: ${DELIBERATE_DIR}/queue/${INITIATIVE}.yaml\n"
    fi
    CONTEXT+="- Assignments directory: ${DELIBERATE_DIR}/assignments/\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Execute the task described in your assignment file. Follow your workflow skills in order.\n"
    CONTEXT+="Start by reading your assignment file.\n"
    ;;
esac

# --- Determine Max Turns ------------------------------------------------------

case "$ROLE" in
  developer)                  MAX_TURNS=100 ;;
  product-manager)            MAX_TURNS=120 ;;
  project-manager)            MAX_TURNS=80  ;;
  reviewer)                   MAX_TURNS=60  ;;
  integrations-engineer)      MAX_TURNS=80  ;;
  content-writer)             MAX_TURNS=60  ;;
  compliance-analyst)         MAX_TURNS=60  ;;
  technical-writer)           MAX_TURNS=60  ;;
  devops-engineer)            MAX_TURNS=80  ;;
  security-analyst)           MAX_TURNS=60  ;;
  sales-development-rep)      MAX_TURNS=60  ;;
  account-executive-assistant) MAX_TURNS=60  ;;
  customer-success)           MAX_TURNS=60  ;;
  onboarding-specialist)      MAX_TURNS=60  ;;
  seo-specialist)             MAX_TURNS=80  ;;
  *)                          MAX_TURNS=80  ;;
esac

# --- Launch in tmux -----------------------------------------------------------

LOG_FILE="${DELIBERATE_DIR}/logs/${WINDOW_NAME}-$(date +%Y%m%d-%H%M%S).log"

# Create a temporary file for the context prompt
CONTEXT_FILE="$(mktemp)"
echo -e "$CONTEXT" > "$CONTEXT_FILE"

tmux new-window -t "$TMUX_SESSION" -n "$WINDOW_NAME" \
  "cd '$WORK_DIR' && claude --print \
    --agent $ROLE \
    --permission-mode auto \
    --max-turns $MAX_TURNS \
    --append-system-prompt \"\$(cat '$CONTEXT_FILE')\" \
    'Begin your assigned task. Read your assignment/state file first.' \
    2>&1 | tee '$LOG_FILE'; echo 'Agent session ended. Press enter to close.'; read"

# Clean up context file after a delay (tmux needs it briefly)
(sleep 5 && rm -f "$CONTEXT_FILE") &

echo "Launched $ROLE agent in tmux window: $TMUX_SESSION:$WINDOW_NAME"
