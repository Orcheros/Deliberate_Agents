#!/usr/bin/env bash
#
# launch-agent.sh — Spawn a Claude Code agent session in a tmux pane
#
# Creates a new pane in the appropriate tmux window (grouped by pipeline stage)
# and runs Claude with the specified agent role. Uses Claude Max subscription.
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
EXECUTION_MODE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session)        TMUX_SESSION="$2"; shift 2 ;;
    --window)         AGENT_NAME="$2"; shift 2 ;;
    --name)           AGENT_NAME="$2"; shift 2 ;;
    --role)           ROLE="$2"; shift 2 ;;
    --initiative)     INITIATIVE="$2"; shift 2 ;;
    --worktree)       WORKTREE="$2"; shift 2 ;;
    --config)         CONFIG_FILE="$2"; shift 2 ;;
    --framework-dir)  FRAMEWORK_DIR="$2"; shift 2 ;;
    --execution-mode) EXECUTION_MODE="$2"; shift 2 ;;
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
PERMISSION_MODE="$(parse_yaml 'permission_mode')"
PERMISSION_MODE="${PERMISSION_MODE:-auto}"
DELIBERATE_DIR="${WORKTREES_DIR}/.deliberate"
QUEUE_DIR="${DELIBERATE_DIR}/queue"
PID_DIR="${DELIBERATE_DIR}/pids"
mkdir -p "$PID_DIR"

# Source cross-agent communication library
if [[ -f "${FRAMEWORK_DIR}/orchestration/comms.sh" ]]; then
  source "${FRAMEWORK_DIR}/orchestration/comms.sh"
fi

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
  integrator|orchestrator|qa-lead|integration-tester|ux-ui-reviewer)
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
  integrator)
    CONTEXT+="- Queue directory: ${DELIBERATE_DIR}/queue/\n"
    CONTEXT+="- Intake directory: ${DELIBERATE_DIR}/intake/\n"
    CONTEXT+="- Priority stack: ${DELIBERATE_DIR}/priority-stack.yaml\n"
    CONTEXT+="- Assignments directory: ${DELIBERATE_DIR}/assignments/\n"
    CONTEXT+="- Decisions directory: ${DELIBERATE_DIR}/decisions/\n"
    CONTEXT+="- Strategic decisions: ${DELIBERATE_DIR}/decisions/strategic/\n"
    CONTEXT+="- Status directory: ${DELIBERATE_DIR}/status/\n"
    CONTEXT+="- Reports directory: ${DELIBERATE_DIR}/reports/\n"
    CONTEXT+="- System inbox: ${DELIBERATE_DIR}/comms/_system/inbox/integrator/\n"
    CONTEXT+="- Orchestrator inbox: ${DELIBERATE_DIR}/comms/_system/inbox/orchestrator/\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="You are the integrator — the user's strategic right hand.\n"
    CONTEXT+="1. Check your system inbox for escalations from the Orchestrator\n"
    CONTEXT+="2. Run the situational assessment protocol (read queue, priority stack, board state)\n"
    CONTEXT+="3. Report status and ask what the user wants to focus on\n"
    ;;
  orchestrator)
    CONTEXT+="- Queue directory: ${DELIBERATE_DIR}/queue/\n"
    CONTEXT+="- Assignments directory: ${DELIBERATE_DIR}/assignments/\n"
    CONTEXT+="- Decisions directory: ${DELIBERATE_DIR}/decisions/\n"
    CONTEXT+="- Status directory: ${DELIBERATE_DIR}/status/\n"
    CONTEXT+="- Priority stack: ${DELIBERATE_DIR}/priority-stack.yaml\n"
    CONTEXT+="- System inbox: ${DELIBERATE_DIR}/comms/_system/inbox/orchestrator/\n"
    CONTEXT+="- Integrator inbox: ${DELIBERATE_DIR}/comms/_system/inbox/integrator/\n"
    CONTEXT+="- Dashboard output: ${DELIBERATE_DIR}/status/dashboard.md\n"
    CONTEXT+="- Orchestration logic reference: ${FRAMEWORK_DIR}/orchestration/orchestrate.sh\n"
    CONTEXT+="- Gate validation reference: ${FRAMEWORK_DIR}/orchestration/gates.sh\n"
    CONTEXT+="- Comms library reference: ${FRAMEWORK_DIR}/orchestration/comms.sh\n"
    CONTEXT+="\n## Your Task\n\n"
    CONTEXT+="You are the orchestrator. You run in interactive mode — the user can see this window and type to you.\n\n"
    CONTEXT+="**On startup:**\n"
    CONTEXT+="1. Check your system inbox for directives from the Integrator\n"
    CONTEXT+="2. Read the priority stack and all initiative queue files\n"
    CONTEXT+="3. Check PID files to see which agents are running\n"
    CONTEXT+="4. Write the initial dashboard to .deliberate/status/dashboard.md\n"
    CONTEXT+="5. Report status and wait for instructions or begin orchestrating\n\n"
    CONTEXT+="**Each cycle:** Check inbox → read queue → check agents → validate gates → launch/advance → update dashboard → send escalations if needed.\n\n"
    CONTEXT+="**When the user types to you:** Respond helpfully — give status, unblock stuck work, take direct instructions.\n"
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
  integrator)                 MAX_TURNS=200 ;;
  orchestrator)               MAX_TURNS=200 ;;
  qa-lead)                    MAX_TURNS=100 ;;
  integration-tester)         MAX_TURNS=80  ;;
  ux-ui-reviewer)             MAX_TURNS=80  ;;
  product-strategist)           MAX_TURNS=100 ;;
  market-researcher)            MAX_TURNS=80  ;;
  *)                          MAX_TURNS=80  ;;
esac

# --- Execution Mode Handling --------------------------------------------------
# Modes from DeliberateWork methodology:
#   1=Human, 2=Guided Human, 3=AI-Assisted, 4=Gated Autonomous (default),
#   5=Autonomous, 6=External

EXECUTION_MODE="${EXECUTION_MODE:-4}"

case "$EXECUTION_MODE" in
  1)
    # Human mode — don't launch agent, write instructions for human
    DECISIONS_DIR="${DELIBERATE_DIR}/decisions"
    STATUS_DIR="${DELIBERATE_DIR}/status"
    mkdir -p "$DECISIONS_DIR" "$STATUS_DIR"
    cat > "${DECISIONS_DIR}/human-task-${AGENT_NAME}.md" <<EOF
# Human Task Required

**Role**: ${ROLE}
**Initiative**: ${INITIATIVE:-n/a}
**Worktree**: ${WORKTREE:-n/a}
**Created**: $(date -u '+%Y-%m-%dT%H:%M:%SZ')
**Execution Mode**: 1 (Human)

## Instructions

This task requires human execution. An AI agent cannot perform this work.

## Resolution

_(Complete the task manually, then add your notes here and delete this file)_
EOF
    cat > "${STATUS_DIR}/${AGENT_NAME}.md" <<EOF
# Status: ${ROLE}

- **Status**: awaiting_human
- **Execution Mode**: 1 (Human)
- **Initiative**: ${INITIATIVE:-n/a}
- **Decision File**: ${DECISIONS_DIR}/human-task-${AGENT_NAME}.md
- **Created**: $(date -u '+%Y-%m-%dT%H:%M:%SZ')
EOF
    echo "Execution mode 1 (Human): wrote instructions to ${DECISIONS_DIR}/human-task-${AGENT_NAME}.md"
    exit 0
    ;;
  2)
    # Guided Human — reduce max turns significantly, agent assists
    MAX_TURNS=$(( MAX_TURNS / 4 ))
    (( MAX_TURNS < 10 )) && MAX_TURNS=10
    ;;
  3)
    # AI-Assisted — interactive mode with full tool access but short leash.
    # Uses --dangerously-skip-permissions so the agent never hangs on permission
    # prompts, but caps turns low and injects interactive guidance so the agent
    # pauses for human input at decision points. The tmux window is interactive,
    # so the user sees everything and can respond in real time.
    MAX_TURNS=25
    PERM_FLAG="--dangerously-skip-permissions"
    CONTEXT+="\n## Execution Mode: AI-Assisted (Interactive)\n\n"
    CONTEXT+="You are running in AI-Assisted mode. You have full tool access but a short turn budget.\n"
    CONTEXT+="IMPORTANT behavioral rules for this mode:\n"
    CONTEXT+="1. **Ask before acting on ambiguity.** If a requirement is unclear, stop and ask the human watching this session — do not guess.\n"
    CONTEXT+="2. **Confirm before destructive actions.** Before deleting files, dropping data, force-pushing, or making irreversible changes, state what you intend to do and wait for confirmation.\n"
    CONTEXT+="3. **Show your plan before executing.** At the start, outline your approach in 3-5 bullets and wait for a thumbs-up before writing code.\n"
    CONTEXT+="4. **Checkpoint after each major step.** After completing a logical unit of work (e.g., migration written, model created, tests added), briefly summarize what you did and ask if you should continue.\n"
    CONTEXT+="5. **Surface trade-offs, don't resolve them.** When you see multiple valid approaches, present them as options with trade-offs and let the human choose.\n"
    CONTEXT+="6. **Never burn turns on exploration spirals.** If you can't find what you need in 3 file reads, ask the human for a pointer instead of scanning the whole codebase.\n"
    CONTEXT+="\nThe human is watching this tmux window. They can type responses directly. Treat this as a pair-programming session, not an autonomous run.\n"
    ;;
  4)
    # Gated Autonomous — default, no adjustment needed
    ;;
  5)
    # Autonomous — extended turns
    MAX_TURNS=$(( MAX_TURNS * 2 ))
    ;;
  6)
    # External — don't launch agent, log that this needs external action
    DECISIONS_DIR="${DELIBERATE_DIR}/decisions"
    STATUS_DIR="${DELIBERATE_DIR}/status"
    mkdir -p "$DECISIONS_DIR" "$STATUS_DIR"
    cat > "${DECISIONS_DIR}/external-task-${AGENT_NAME}.md" <<EOF
# External Action Required

**Role**: ${ROLE}
**Initiative**: ${INITIATIVE:-n/a}
**Worktree**: ${WORKTREE:-n/a}
**Created**: $(date -u '+%Y-%m-%dT%H:%M:%SZ')
**Execution Mode**: 6 (External)

## Instructions

This task requires action in an external system (third-party tool, vendor, etc.).

## Resolution

_(Complete the external action, then add your notes here and delete this file)_
EOF
    cat > "${STATUS_DIR}/${AGENT_NAME}.md" <<EOF
# Status: ${ROLE}

- **Status**: awaiting_external
- **Execution Mode**: 6 (External)
- **Initiative**: ${INITIATIVE:-n/a}
- **Decision File**: ${DECISIONS_DIR}/external-task-${AGENT_NAME}.md
- **Created**: $(date -u '+%Y-%m-%dT%H:%M:%SZ')
EOF
    echo "Execution mode 6 (External): wrote instructions to ${DECISIONS_DIR}/external-task-${AGENT_NAME}.md"
    exit 0
    ;;
esac

# --- Window Naming Strategy ----------------------------------------------------
#
# Layout model:
#   - WINDOW = a full tmux window (maps to a separate terminal/iTerm2 window)
#   - PANE   = a visible split within a window (all panes visible simultaneously)
#
# Grouping:
#   - "coordination" window — Integrator + Orchestrator panes
#   - "{initiative}" window — all agents working on that initiative as panes
#   - "ops" window — agents without an initiative (system-wide work)
#
# Each agent becomes a PANE in its group's window. Agents working on the same
# initiative share a window and can see each other. The user never needs to
# switch tmux windows to see related work.

agent_target_window() {
  local role="$1"
  local initiative="${2:-}"

  case "$role" in
    integrator|orchestrator)
      echo "coordination" ;;
    *)
      if [[ -n "$initiative" ]]; then
        echo "$initiative"
      else
        echo "ops"
      fi
      ;;
  esac
}

# --- Launch in tmux window ----------------------------------------------------

TMUX_SESSION="${TMUX_SESSION:-deliberate}"

LOG_FILE="${DELIBERATE_DIR}/logs/${AGENT_NAME}-$(date +%Y%m%d-%H%M%S).log"
PID_FILE="${PID_DIR}/${AGENT_NAME}.pid"

# --- Inject Cross-Agent Communication Context --------------------------------
if [[ -n "${INITIATIVE:-}" ]] && type build_comms_context &>/dev/null; then
  COMMS_CONTEXT="$(build_comms_context "$INITIATIVE" "$ROLE" 2>/dev/null)" || true
  if [[ -n "$COMMS_CONTEXT" ]]; then
    CONTEXT+="\n# Cross-Agent Communication\n${COMMS_CONTEXT}\n"
  fi
fi

# --- Inject System-Level Communication Context --------------------------------
if type build_system_comms_context &>/dev/null; then
  case "$ROLE" in
    integrator|orchestrator)
      SYSTEM_COMMS="$(build_system_comms_context "$ROLE" 2>/dev/null)" || true
      if [[ -n "$SYSTEM_COMMS" ]]; then
        CONTEXT+="\n# System Communications\n${SYSTEM_COMMS}\n"
      fi
      ;;
  esac
fi

# --- Inject Onboarding Brief (project knowledge for all agents) ---------------
ONBOARDING_FILE="${DELIBERATE_DIR}/onboarding.md"
if [[ -f "$ONBOARDING_FILE" ]]; then
  CONTEXT+="\n# Project Knowledge (from onboarding brief)\n"
  CONTEXT+="The following is a structured brief of the target project's codebase, architecture, and state.\n"
  CONTEXT+="Reference: ${ONBOARDING_FILE}\n\n"
  CONTEXT+="$(cat "$ONBOARDING_FILE")\n"
fi

CONTEXT_FILE="$(mktemp)"
echo -e "$CONTEXT" > "$CONTEXT_FILE"

# Build permission flag from config
if [[ "$PERMISSION_MODE" == "unrestricted" ]]; then
  PERM_FLAG="--dangerously-skip-permissions"
else
  PERM_FLAG="--permission-mode auto"
fi

# Write a launcher script that the tmux pane will execute.
LAUNCHER="$(mktemp)"
TAB_TITLE="${ROLE}: ${INITIATIVE:-${WORKTREE:-agent}}"

cat > "$LAUNCHER" <<SCRIPT
#!/usr/bin/env bash
cd '${WORK_DIR}'
unset ANTHROPIC_API_KEY
echo \$\$ > '${PID_FILE}'
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  ${ROLE}: ${INITIATIVE:-${WORKTREE:-agent}}"
echo "║  Working in: ${WORK_DIR}"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# --- Display instruction set for user review ----------------------------------
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│  AGENT INSTRUCTIONS                                        │"
echo "└─────────────────────────────────────────────────────────────┘"
echo ""
cat '${CONTEXT_FILE}'
echo ""
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│  AGENT COMMAND                                              │"
echo "└─────────────────────────────────────────────────────────────┘"
echo ""
echo "  claude --agent ${ROLE} ${PERM_FLAG} --max-turns ${MAX_TURNS}"
echo "  Prompt: Begin your assigned task. Read your assignment/state file first."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf "  Press ENTER to launch agent, or Ctrl-C to abort > "
read -r
echo ""

# --- Activity watchdog ---------------------------------------------------------
# Tracks last output timestamp via file. Sends macOS notification if idle too long.
ACTIVITY_TS="\$(mktemp)"
date +%s > "\$ACTIVITY_TS"

(
  while kill -0 \$\$ 2>/dev/null; do
    sleep 60
    last=\$(cat "\$ACTIVITY_TS" 2>/dev/null || date +%s)
    now=\$(date +%s)
    idle=\$(( now - last ))
    if (( idle >= 180 )); then
      mins=\$(( idle / 60 ))
      printf "\\n  ⏳ Agent idle for %dm — may be stalled\\n" "\$mins"
      osascript -e "display notification \"${ROLE} agent idle for \${mins}m — may need attention\" with title \"Deliberate Agents\" sound name \"Ping\"" 2>/dev/null
    fi
  done
) &
WATCHDOG_PID=\$!

# --- Stream progress ----------------------------------------------------------
# BUG FIXES applied:
#   1. stderr captured (2>&1) instead of discarded — --verbose output now visible
#   2. script(1) pty wrapper retained for unbuffered streaming
#   3. All tool types handled — catch-all shows tool name + context

script -q /dev/null claude \\
  --agent ${ROLE} \\
  ${PERM_FLAG} \\
  --max-turns ${MAX_TURNS} \\
  --append-system-prompt "\$(cat '${CONTEXT_FILE}')" \\
  --output-format stream-json \\
  --verbose \\
  -p 'Begin your assigned task. Read your assignment/state file first.' 2>&1 | \\
while IFS= read -r line; do
  # Skip lines that aren't valid JSON (verbose/stderr output — print directly)
  type=\$(echo "\$line" | jq -r '.type // empty' 2>/dev/null) || { echo "\$line"; continue; }
  if [[ -z "\$type" ]]; then
    [[ -n "\$line" ]] && echo "\$line"
    continue
  fi
  date +%s > "\$ACTIVITY_TS"
  case "\$type" in
    assistant)
      msg=\$(echo "\$line" | jq -r '.message.content[]? | select(.type=="text") | .text // empty' 2>/dev/null)
      [[ -n "\$msg" ]] && printf "\\n%s\\n" "\$msg"
      ;;
    result)
      cost=\$(echo "\$line" | jq -r '.total_cost_usd // "?"' 2>/dev/null)
      turns=\$(echo "\$line" | jq -r '.num_turns // "?"' 2>/dev/null)
      reason=\$(echo "\$line" | jq -r '.terminal_reason // .subtype // "done"' 2>/dev/null)
      printf "\\n━━━ SESSION COMPLETE ━━━\\n"
      printf "Turns: %s | Cost: \$%s | Reason: %s\\n" "\$turns" "\$cost" "\$reason"
      osascript -e "display notification \"${ROLE} complete (\${turns} turns, \\\$\${cost})\" with title \"Deliberate Agents\" sound name \"Glass\"" 2>/dev/null
      ;;
    tool_use)
      tool=\$(echo "\$line" | jq -r '.tool_name // empty' 2>/dev/null)
      case "\$tool" in
        Read)       printf "  Reading: %s\\n" "\$(echo "\$line" | jq -r '.tool_input.file_path // empty' 2>/dev/null)" ;;
        Write)      printf "  Writing: %s\\n" "\$(echo "\$line" | jq -r '.tool_input.file_path // empty' 2>/dev/null)" ;;
        Edit)       printf "  Editing: %s\\n" "\$(echo "\$line" | jq -r '.tool_input.file_path // empty' 2>/dev/null)" ;;
        Bash)       printf "  Running: %s\\n" "\$(echo "\$line" | jq -r '.tool_input.command // empty' 2>/dev/null | head -c 120)" ;;
        Grep)       printf "  Searching: %s\\n" "\$(echo "\$line" | jq -r '.tool_input.pattern // empty' 2>/dev/null)" ;;
        Glob)       printf "  Finding: %s\\n" "\$(echo "\$line" | jq -r '.tool_input.pattern // empty' 2>/dev/null)" ;;
        Agent)      printf "  Spawning agent: %s\\n" "\$(echo "\$line" | jq -r '.tool_input.description // empty' 2>/dev/null | head -c 100)" ;;
        TaskCreate) printf "  Creating task: %s\\n" "\$(echo "\$line" | jq -r '.tool_input.description // empty' 2>/dev/null | head -c 100)" ;;
        TaskUpdate) printf "  Updating task\\n" ;;
        WebSearch)  printf "  Web search: %s\\n" "\$(echo "\$line" | jq -r '.tool_input.query // empty' 2>/dev/null)" ;;
        WebFetch)   printf "  Fetching: %s\\n" "\$(echo "\$line" | jq -r '.tool_input.url // empty' 2>/dev/null | head -c 100)" ;;
        mcp__*)     printf "  MCP tool: %s\\n" "\$tool" ;;
        *)          printf "  [%s]: running...\\n" "\$tool" ;;
      esac
      ;;
  esac
done

# --- Cleanup ------------------------------------------------------------------
kill \$WATCHDOG_PID 2>/dev/null
rm -f "\$ACTIVITY_TS" '${PID_FILE}' '${CONTEXT_FILE}'
echo ""
osascript -e "display notification \"${ROLE} agent session ended\" with title \"Deliberate Agents\"" 2>/dev/null
echo "=== Agent session complete. Shell remains interactive. ==="
SCRIPT
chmod +x "$LAUNCHER"

# --- Ensure tmux session exists -----------------------------------------------
if ! tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
  tmux new-session -d -s "$TMUX_SESSION" -n "coordination"
fi

# --- Determine target window and create pane ----------------------------------
#
# Each agent becomes a PANE (split) in a shared window. Agents on the same
# initiative share one window. The coordination window holds Integrator +
# Orchestrator side by side.

TARGET_WINDOW="$(agent_target_window "$ROLE" "${INITIATIVE:-}")"

window_exists() {
  tmux list-windows -t "$TMUX_SESSION" -F '#{window_name}' 2>/dev/null | grep -qx "$1"
}

if window_exists "$TARGET_WINDOW"; then
  # Window exists — add a new pane (vertical split) to it
  tmux split-window -t "${TMUX_SESSION}:${TARGET_WINDOW}" -v
  sleep 0.3
  # Re-tile all panes evenly so they share space
  tmux select-layout -t "${TMUX_SESSION}:${TARGET_WINDOW}" tiled 2>/dev/null || true
  # The new pane is automatically selected; send the launcher to it
  tmux send-keys -t "${TMUX_SESSION}:${TARGET_WINDOW}" "'${LAUNCHER}'" Enter
else
  # Window doesn't exist — create it with this agent as the first pane
  tmux new-window -t "$TMUX_SESSION" -n "$TARGET_WINDOW"
  sleep 0.3
  tmux send-keys -t "${TMUX_SESSION}:${TARGET_WINDOW}" "'${LAUNCHER}'" Enter
fi

# Set pane title for identification (marks the active pane in the target window)
tmux select-pane -t "${TMUX_SESSION}:${TARGET_WINDOW}" -T "$TAB_TITLE"

# Launcher script handles its own cleanup after the agent runs;
# remove the launcher wrapper itself once it's been read into memory.
(sleep 5 && rm -f "$LAUNCHER") &

echo "Launched ${ROLE} agent as pane in: ${TMUX_SESSION}:${TARGET_WINDOW} [${TAB_TITLE}]"
