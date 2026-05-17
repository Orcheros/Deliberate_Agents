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
  product-strategist|market-researcher|\
  integrations-engineer|content-writer|compliance-analyst|\
  technical-writer|devops-engineer|security-analyst|\
  sales-development-rep|account-executive-assistant|\
  customer-success|onboarding-specialist|seo-specialist|\
  content-researcher|linkedin-copywriter|content-publisher|\
  engagement-tracker|content-reporter|\
  twitter-copywriter|threads-copywriter|facebook-copywriter|\
  video-producer|reddit-writer|hackernews-writer|producthunt-writer|\
  orchestrator|qa-lead|integration-tester|ux-ui-reviewer)
    WORK_DIR="$REPO_DIR"
    ;;
  *)
    echo "ERROR: Unknown role: $ROLE"
    exit 1
    ;;
esac

# --- Sync Agent Definitions to Target Repo -----------------------------------

# Source of truth is agents/ (organized by team), deployed flat to .claude/agents/
FRAMEWORK_AGENTS="${FRAMEWORK_DIR}/agents"
TARGET_AGENTS="${WORK_DIR}/.claude/agents"
if [[ -d "$FRAMEWORK_AGENTS" ]]; then
  mkdir -p "$TARGET_AGENTS"
  find "$FRAMEWORK_AGENTS" -name "*.md" -type f -exec cp {} "$TARGET_AGENTS/" \;
fi

# Also sync skills
FRAMEWORK_SKILLS="${FRAMEWORK_DIR}/skills"
TARGET_SKILLS="${WORK_DIR}/.claude/skills"
if [[ -d "$FRAMEWORK_SKILLS" ]]; then
  mkdir -p "$TARGET_SKILLS"
  for skill_dir in "$FRAMEWORK_SKILLS"/*/; do
    [[ -d "$skill_dir" ]] || continue
    local_name="$(basename "$skill_dir")"
    mkdir -p "$TARGET_SKILLS/$local_name"
    cp "$skill_dir"* "$TARGET_SKILLS/$local_name/" 2>/dev/null || true
  done
fi

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
    CONTEXT+="- Assignment file: ${DELIBERATE_DIR}/assignments/${WORKTREE}.md\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Execute the development task assigned in your assignment file. Follow the development workflow steps in order.\n"
    CONTEXT+="Start by reading your assignment file.\n"
    ;;
  product-strategist|market-researcher)
    CONTEXT+="- Initiative: ${INITIATIVE}\n"
    CONTEXT+="- Initiative state file: ${DELIBERATE_DIR}/queue/${INITIATIVE}.yaml\n"
    if [[ -n "$WORKTREE" ]]; then
      CONTEXT+="- Assignment file: ${DELIBERATE_DIR}/assignments/${WORKTREE}.md\n"
    fi
    CONTEXT+="- Assignments directory: ${DELIBERATE_DIR}/assignments/\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Execute the task described in your assignment file. Follow your workflow skills in order.\n"
    CONTEXT+="Start by reading your assignment file.\n"
    ;;
  content-researcher|linkedin-copywriter|content-publisher|\
  engagement-tracker|content-reporter|\
  twitter-copywriter|threads-copywriter|facebook-copywriter|\
  video-producer|reddit-writer|hackernews-writer|producthunt-writer)
    CONTEXT+="- Initiative: ${INITIATIVE}\n"
    if [[ -n "$WORKTREE" ]]; then
      CONTEXT+="- Assignment file: ${DELIBERATE_DIR}/assignments/${WORKTREE}.md\n"
    elif [[ -n "$INITIATIVE" ]]; then
      CONTEXT+="- Initiative state file: ${DELIBERATE_DIR}/queue/${INITIATIVE}.yaml\n"
    fi
    CONTEXT+="- Assignments directory: ${DELIBERATE_DIR}/assignments/\n"
    CONTEXT+="- Notion integration: ${FRAMEWORK_DIR}/integrations/notion/\n"
    CONTEXT+="- LinkedIn provider: ${FRAMEWORK_DIR}/integrations/linkedin/\n"
    CONTEXT+="- Social providers: ${FRAMEWORK_DIR}/integrations/social/\n"
    CONTEXT+="- Voice corpus: ${FRAMEWORK_DIR}/content/corpus/\n"
    CONTEXT+="- Slop blacklist: ${FRAMEWORK_DIR}/content/slop-blacklist.yaml\n"
    CONTEXT+="- Platform slop rules: ${FRAMEWORK_DIR}/content/slop-rules/\n"
    CONTEXT+="- Schedules state: ${DELIBERATE_DIR}/schedules/\n"
    CONTEXT+="- Content config: config.henry.yaml (content section)\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Execute the task described in your assignment file. Follow your workflow skills in order.\n"
    CONTEXT+="Start by reading your assignment file.\n"
    ;;
  integrations-engineer|content-writer|compliance-analyst|\
  technical-writer|devops-engineer|security-analyst|\
  sales-development-rep|account-executive-assistant|\
  customer-success|onboarding-specialist|seo-specialist)
    CONTEXT+="- Initiative: ${INITIATIVE}\n"
    if [[ -n "$WORKTREE" ]]; then
      CONTEXT+="- Assignment file: ${DELIBERATE_DIR}/assignments/${WORKTREE}.md\n"
    elif [[ -n "$INITIATIVE" ]]; then
      CONTEXT+="- Initiative state file: ${DELIBERATE_DIR}/queue/${INITIATIVE}.yaml\n"
    fi
    CONTEXT+="- Assignments directory: ${DELIBERATE_DIR}/assignments/\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Execute the task described in your assignment file. Follow your workflow skills in order.\n"
    CONTEXT+="Start by reading your assignment file.\n"
    ;;
  orchestrator)
    CONTEXT+="- Queue directory: ${DELIBERATE_DIR}/queue/\n"
    CONTEXT+="- Assignments directory: ${DELIBERATE_DIR}/assignments/\n"
    CONTEXT+="- Decisions directory: ${DELIBERATE_DIR}/decisions/\n"
    CONTEXT+="- Status directory: ${DELIBERATE_DIR}/status/\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="You are the orchestrator. Poll for initiative state changes, launch teams, manage handoffs, and route all human communication through Slack.\n"
    CONTEXT+="Start by reading all initiative queue files and current status.\n"
    ;;
  qa-lead)
    CONTEXT+="- Initiative: ${INITIATIVE}\n"
    CONTEXT+="- Initiative state file: ${DELIBERATE_DIR}/queue/${INITIATIVE}.yaml\n"
    CONTEXT+="- QA directory: ${DELIBERATE_DIR}/qa/${INITIATIVE}/\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Create and execute the QA test plan for initiative '${INITIATIVE}'.\n"
    CONTEXT+="Read all specification artifacts, create the test plan, assign to teammates, coordinate execution, and produce the QA report.\n"
    ;;
  integration-tester|ux-ui-reviewer)
    CONTEXT+="- Initiative: ${INITIATIVE}\n"
    CONTEXT+="- QA assignment file: ${DELIBERATE_DIR}/qa/${INITIATIVE}/assignments/${ROLE}.md\n"
    CONTEXT+="- QA results directory: ${DELIBERATE_DIR}/qa/${INITIATIVE}/results/\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="Execute your assigned test cases for initiative '${INITIATIVE}'.\n"
    CONTEXT+="Start by reading your assignment file, then follow your workflow skills in order.\n"
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
  content-researcher)         MAX_TURNS=60  ;;
  linkedin-copywriter)        MAX_TURNS=80  ;;
  content-publisher)          MAX_TURNS=30  ;;
  engagement-tracker)         MAX_TURNS=40  ;;
  content-reporter)           MAX_TURNS=40  ;;
  twitter-copywriter)          MAX_TURNS=80  ;;
  threads-copywriter)          MAX_TURNS=80  ;;
  facebook-copywriter)         MAX_TURNS=80  ;;
  video-producer)              MAX_TURNS=100 ;;
  reddit-writer)               MAX_TURNS=60  ;;
  hackernews-writer)           MAX_TURNS=60  ;;
  producthunt-writer)          MAX_TURNS=60  ;;
  compliance-analyst)         MAX_TURNS=60  ;;
  technical-writer)           MAX_TURNS=60  ;;
  devops-engineer)            MAX_TURNS=80  ;;
  security-analyst)           MAX_TURNS=60  ;;
  sales-development-rep)      MAX_TURNS=60  ;;
  account-executive-assistant) MAX_TURNS=60  ;;
  customer-success)           MAX_TURNS=60  ;;
  onboarding-specialist)      MAX_TURNS=60  ;;
  seo-specialist)             MAX_TURNS=80  ;;
  orchestrator)               MAX_TURNS=200 ;;
  qa-lead)                    MAX_TURNS=100 ;;
  integration-tester)         MAX_TURNS=80  ;;
  ux-ui-reviewer)             MAX_TURNS=80  ;;
  product-strategist)           MAX_TURNS=100 ;;
  market-researcher)            MAX_TURNS=80  ;;
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
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  ${ROLE}: ${INITIATIVE:-${WORKTREE:-agent}}"
echo "║  Working in: ${WORK_DIR}"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Stream progress via script(1) pty wrapper + stream-json.
# script forces unbuffered output; jq filter shows human-readable progress.
# Fallback heartbeat in case stream-json produces no parseable output.
STREAM_RAW="\$(mktemp)"
LAST_ACTIVITY=\$(date +%s)

script -q /dev/null claude \\
  --agent ${ROLE} \\
  --dangerously-skip-permissions \\
  --max-turns ${MAX_TURNS} \\
  --append-system-prompt "\$(cat '${CONTEXT_FILE}')" \\
  --output-format stream-json \\
  --verbose \\
  -p 'Begin your assigned task. Read your assignment/state file first.' 2>/dev/null | \\
while IFS= read -r line; do
  # Skip lines that aren't valid JSON
  type=\$(echo "\$line" | jq -r '.type // empty' 2>/dev/null) || continue
  [[ -z "\$type" ]] && continue
  case "\$type" in
    assistant)
      msg=\$(echo "\$line" | jq -r '.message.content[]? | select(.type=="text") | .text // empty' 2>/dev/null)
      [[ -n "\$msg" ]] && printf "\n%s\n" "\$msg"
      ;;
    result)
      cost=\$(echo "\$line" | jq -r '.total_cost_usd // "?"' 2>/dev/null)
      turns=\$(echo "\$line" | jq -r '.num_turns // "?"' 2>/dev/null)
      reason=\$(echo "\$line" | jq -r '.terminal_reason // .subtype // "done"' 2>/dev/null)
      printf "\n━━━ SESSION COMPLETE ━━━\n"
      printf "Turns: %s | Cost: \$%s | Reason: %s\n" "\$turns" "\$cost" "\$reason"
      ;;
    tool_use)
      tool=\$(echo "\$line" | jq -r '.tool_name // empty' 2>/dev/null)
      case "\$tool" in
        Read)   printf "  Reading: %s\n" "\$(echo "\$line" | jq -r '.tool_input.file_path // empty' 2>/dev/null)" ;;
        Write)  printf "  Writing: %s\n" "\$(echo "\$line" | jq -r '.tool_input.file_path // empty' 2>/dev/null)" ;;
        Edit)   printf "  Editing: %s\n" "\$(echo "\$line" | jq -r '.tool_input.file_path // empty' 2>/dev/null)" ;;
        Bash)   printf "  Running: %s\n" "\$(echo "\$line" | jq -r '.tool_input.command // empty' 2>/dev/null | head -c 100)" ;;
        Grep)   printf "  Searching: %s\n" "\$(echo "\$line" | jq -r '.tool_input.pattern // empty' 2>/dev/null)" ;;
        Glob)   printf "  Finding: %s\n" "\$(echo "\$line" | jq -r '.tool_input.pattern // empty' 2>/dev/null)" ;;
        *)      printf "  %s\n" "\$tool" ;;
      esac
      ;;
  esac
done

rm -f "\$STREAM_RAW" '${PID_FILE}'
echo ""
echo "=== Agent session complete. This tab can be closed. ==="
read -r
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
