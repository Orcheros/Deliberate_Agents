#!/usr/bin/env bash
#
# launch-agent.sh — Spawn a Claude Code agent session in a Terminal.app tab
#
# Opens a new tab in the current Terminal window and runs Claude with
# the specified agent role. Uses the Claude Max subscription (not API key).
# Tracks the process via PID files so the orchestrator can detect completion.
#
# Usage: launch-agent.sh --name <name> --role <role> --config <file> --framework-dir <dir> [options]

set -euo pipefail

# --- Argument Parsing ---------------------------------------------------------

AGENT_NAME=""
ROLE=""
INITIATIVE=""
WORKTREE=""
CONFIG_FILE=""
FRAMEWORK_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session)       shift 2 ;;  # Legacy arg, ignored (was for tmux)
    --window)        AGENT_NAME="$2"; shift 2 ;;
    --name)          AGENT_NAME="$2"; shift 2 ;;
    --role)          ROLE="$2"; shift 2 ;;
    --initiative)    INITIATIVE="$2"; shift 2 ;;
    --worktree)      WORKTREE="$2"; shift 2 ;;
    --config)        CONFIG_FILE="$2"; shift 2 ;;
    --framework-dir) FRAMEWORK_DIR="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

[[ -n "$AGENT_NAME" ]] || { echo "ERROR: --name or --window required"; exit 1; }
[[ -n "$ROLE" ]]        || { echo "ERROR: --role required"; exit 1; }
[[ -n "$CONFIG_FILE" ]] || { echo "ERROR: --config required"; exit 1; }
[[ -n "$FRAMEWORK_DIR" ]] || { echo "ERROR: --framework-dir required"; exit 1; }

# --- Configuration ------------------------------------------------------------

parse_yaml() {
  local key="$1"
  grep -E "^[[:space:]]*${key}:" "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'" || true
}

REPO_DIR="$(parse_yaml 'repo')"
WORKTREES_DIR="$(parse_yaml 'worktrees')"
VERBOSE="$(parse_yaml 'verbose')"
VERBOSE="${VERBOSE:-false}"
DELIBERATE_DIR="${WORKTREES_DIR}/.deliberate"
PID_DIR="${DELIBERATE_DIR}/pids"
mkdir -p "$PID_DIR"

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
  architect|product-designer|scrum-master|\
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

CONTEXT="# Runtime Context\n"
CONTEXT+="- Project config: ${CONFIG_FILE}\n"
CONTEXT+="- Framework directory: ${FRAMEWORK_DIR}\n"
CONTEXT+="- State directory: ${DELIBERATE_DIR}\n"
CONTEXT+="- Verbose mode: ${VERBOSE}\n"

if [[ "$VERBOSE" == "true" ]]; then
  CONTEXT+="\n## Verbose Mode (ENABLED)\n\n"
  CONTEXT+="You MUST emit a short, clear progress line to stdout at the start of every major step.\n"
  CONTEXT+="Format: a plain-English sentence describing what you are doing right now.\n"
  CONTEXT+="Examples:\n"
  CONTEXT+="  Reading one-pager for 0Z12...\n"
  CONTEXT+="  Exploring data models related to diagnosis cards...\n"
  CONTEXT+="  Writing PRD section 3: Functional Requirements...\n"
  CONTEXT+="  Committing architecture doc...\n"
  CONTEXT+="  Submitting PRD for cross-functional feedback...\n"
  CONTEXT+="  Reading feedback from architect on PRD...\n"
  CONTEXT+="  Revising PRD based on feedback...\n"
  CONTEXT+="\n"
  CONTEXT+="Emit these lines using: echo \"<progress message>\"\n"
  CONTEXT+="One line per major step. Do not skip this — it is how operators monitor your work.\n"
fi

case "$ROLE" in
  product-manager)
    CONTEXT+="- Initiative: ${INITIATIVE}\n"
    CONTEXT+="- Initiative state file: ${DELIBERATE_DIR}/queue/${INITIATIVE}.yaml\n"
    CONTEXT+="- Feedback directory: ${DELIBERATE_DIR}/feedback/${INITIATIVE}/\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Process the initiative '${INITIATIVE}' through the initiative-intake workflow.\n"
    CONTEXT+="Start by reading the initiative state file to find the one-pager path, then follow the workflow steps in order.\n"
    CONTEXT+="After writing the PRD, submit it for a cross-functional feedback round before finalizing.\n"
    ;;
  architect)
    CONTEXT+="- Initiative: ${INITIATIVE}\n"
    CONTEXT+="- Initiative state file: ${DELIBERATE_DIR}/queue/${INITIATIVE}.yaml\n"
    CONTEXT+="- Feedback directory: ${DELIBERATE_DIR}/feedback/${INITIATIVE}/\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Write the architecture document for initiative '${INITIATIVE}'.\n"
    CONTEXT+="Start by reading the initiative state file and PRD, then produce the architecture doc.\n"
    CONTEXT+="After writing the architecture doc, submit it for a cross-functional feedback round before finalizing.\n"
    ;;
  product-designer)
    CONTEXT+="- Initiative: ${INITIATIVE}\n"
    CONTEXT+="- Initiative state file: ${DELIBERATE_DIR}/queue/${INITIATIVE}.yaml\n"
    CONTEXT+="- Feedback directory: ${DELIBERATE_DIR}/feedback/${INITIATIVE}/\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Write the design brief for initiative '${INITIATIVE}'.\n"
    CONTEXT+="Start by reading the initiative state file, PRD, and architecture doc, then produce the design brief.\n"
    CONTEXT+="After writing the design brief, submit it for a cross-functional feedback round before finalizing.\n"
    ;;
  scrum-master)
    CONTEXT+="- Initiative: ${INITIATIVE}\n"
    CONTEXT+="- Initiative state file: ${DELIBERATE_DIR}/queue/${INITIATIVE}.yaml\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Shard the initiative '${INITIATIVE}' into epics, sprints, and stories.\n"
    CONTEXT+="Start by reading the PRD, architecture doc, and design brief, then decompose into an actionable backlog.\n"
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
  architect)                  MAX_TURNS=100 ;;
  product-designer)           MAX_TURNS=80  ;;
  scrum-master)               MAX_TURNS=80  ;;
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

# --- Launch in Terminal.app tab -----------------------------------------------

LOG_FILE="${DELIBERATE_DIR}/logs/${AGENT_NAME}-$(date +%Y%m%d-%H%M%S).log"
PID_FILE="${PID_DIR}/${AGENT_NAME}.pid"

CONTEXT_FILE="$(mktemp)"
echo -e "$CONTEXT" > "$CONTEXT_FILE"

# Write a launcher script that the Terminal tab will execute.
# This avoids quote-escaping hell in AppleScript.
LAUNCHER="$(mktemp)"
TAB_TITLE="${ROLE}: ${INITIATIVE:-${WORKTREE:-agent}}"

cat > "$LAUNCHER" <<SCRIPT
#!/usr/bin/env bash
printf '\e]1;${TAB_TITLE}\a'
printf '\e]2;${TAB_TITLE}\a'
cd '${WORK_DIR}'
unset ANTHROPIC_API_KEY
echo \$\$ > '${PID_FILE}'
exec claude \\
  --agent ${ROLE} \\
  --dangerously-skip-permissions \\
  --max-turns ${MAX_TURNS} \\
  --append-system-prompt "\$(cat '${CONTEXT_FILE}')" \\
  --resume no \\
  'Begin your assigned task. Read your assignment/state file first.'
SCRIPT
chmod +x "$LAUNCHER"

# Open a new tab in the current terminal window.
# Detect terminal app and use the right method.
TERM_APP="${TERM_PROGRAM:-Terminal}"

case "$TERM_APP" in
  iTerm.app|iTerm2)
    osascript -e "
      tell application \"iTerm2\"
        tell current window
          create tab with default profile
          tell current session of current tab
            write text \"exec '${LAUNCHER}'\"
          end tell
        end tell
      end tell
    "
    ;;
  *)
    # Terminal.app fallback
    osascript -e "tell application \"Terminal\" to do script \"exec '${LAUNCHER}'\""
    ;;
esac

# Clean up temp files after a delay (claude needs to start first)
(sleep 15 && rm -f "$CONTEXT_FILE" "$LAUNCHER") &

echo "Launched ${ROLE} agent in Terminal tab: ${TAB_TITLE}"
