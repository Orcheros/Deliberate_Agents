#!/usr/bin/env bash
#
# organize-initiatives.sh — Review and organize a project's initiatives directory
#
# Examines the existing initiatives directory structure, determines the lifecycle
# state of each initiative, and offers to reorganize them into the standard
# Deliberate_Agents directory structure:
#
#   backlog/      — One-pager only, not yet fully specified
#   specified/    — All artifacts complete, ready for development
#   in-progress/  — Worktree exists, under active development
#   shipped/      — Completed and merged
#   retired/      — Absorbed, deferred, or cancelled
#
# Usage: organize-initiatives.sh <config-file> [options]
#
# Options:
#   --dry-run       Show what would change without moving anything
#   --skip-prompt   Skip the confirmation prompt
#   -h, --help      Show this help

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORK_DIR="$(dirname "$SCRIPT_DIR")"

CONFIG_FILE=""
DRY_RUN=false
SKIP_PROMPT=false

# --- Argument Parsing ---------------------------------------------------------

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)      DRY_RUN=true; shift ;;
    --skip-prompt)  SKIP_PROMPT=true; shift ;;
    -h|--help)
      sed -n '2,/^$/p' "$0" | sed 's/^# \?//'
      exit 0
      ;;
    -*)
      echo "Unknown option: $1"; exit 1
      ;;
    *)
      if [[ -z "$CONFIG_FILE" ]]; then
        CONFIG_FILE="$1"; shift
      else
        echo "ERROR: Unexpected argument: $1"; exit 1
      fi
      ;;
  esac
done

[[ -n "$CONFIG_FILE" ]] || { echo "ERROR: Config file path required. Usage: organize-initiatives.sh <config-file>"; exit 1; }
[[ -f "$CONFIG_FILE" ]] || { echo "ERROR: Config file not found: $CONFIG_FILE"; exit 1; }

# --- Parse Config -------------------------------------------------------------

parse_yaml() {
  local key="$1"
  grep -E "^\s*${key}:" "$CONFIG_FILE" | head -1 | sed 's/[^:]*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

PROJECT_NAME="$(parse_yaml 'name')"
REPO_DIR="$(parse_yaml 'repo')"
WORKTREES_DIR="$(parse_yaml 'worktrees')"
INITIATIVES_PATH="$(parse_yaml 'initiatives_path')"
INITIATIVES_DIR="${REPO_DIR}/${INITIATIVES_PATH}"
DELIBERATE_DIR="${WORKTREES_DIR}/.deliberate"

# --- Pre-flight Checks --------------------------------------------------------

[[ -d "$REPO_DIR" ]]       || { echo "ERROR: Repo not found: $REPO_DIR"; exit 1; }
[[ -d "$DELIBERATE_DIR" ]] || { echo "ERROR: State directory not found: $DELIBERATE_DIR (run init.sh first)"; exit 1; }

# --- Ensure Standard Directories Exist ----------------------------------------

echo ""
echo "Deliberate_Agents — Initiative Organization"
echo "============================================="
echo ""
echo "  Project:      $PROJECT_NAME"
echo "  Initiatives:  $INITIATIVES_DIR"
echo ""

STANDARD_DIRS=("backlog" "specified" "in-progress" "shipped" "retired")

if [[ ! -d "$INITIATIVES_DIR" ]]; then
  echo "No initiatives directory found. Creating standard structure..."
  if [[ "$DRY_RUN" != true ]]; then
    mkdir -p "$INITIATIVES_DIR"
  fi
fi

for dir in "${STANDARD_DIRS[@]}"; do
  if [[ ! -d "${INITIATIVES_DIR}/${dir}" ]]; then
    echo "  Creating: ${dir}/"
    if [[ "$DRY_RUN" != true ]]; then
      mkdir -p "${INITIATIVES_DIR}/${dir}"
    fi
  else
    echo "  Exists:   ${dir}/"
  fi
done

# --- Check for Existing Initiatives to Organize ------------------------------

# Count initiative directories at the top level (not in standard dirs, not special files)
TOP_LEVEL_INITIATIVES=()
if [[ -d "$INITIATIVES_DIR" ]]; then
  while IFS= read -r entry; do
    basename="$(basename "$entry")"
    # Skip standard lifecycle directories, hidden files, and standalone files
    case "$basename" in
      backlog|specified|in-progress|shipped|retired) continue ;;
      .*) continue ;;
      "Initiative Templates") continue ;;
    esac
    # Only count directories
    if [[ -d "$entry" ]]; then
      TOP_LEVEL_INITIATIVES+=("$basename")
    fi
  done < <(find "$INITIATIVES_DIR" -maxdepth 1 -mindepth 1 | sort)
fi

# Count standalone files at top level (README, ROADMAP, etc.)
TOP_LEVEL_FILES=()
if [[ -d "$INITIATIVES_DIR" ]]; then
  while IFS= read -r entry; do
    if [[ -f "$entry" ]]; then
      TOP_LEVEL_FILES+=("$(basename "$entry")")
    fi
  done < <(find "$INITIATIVES_DIR" -maxdepth 1 -mindepth 1 -type f | sort)
fi

echo ""

if [[ ${#TOP_LEVEL_INITIATIVES[@]} -eq 0 ]]; then
  echo "No initiatives found at the top level to organize."
  echo "Standard directory structure is ready."
  exit 0
fi

echo "Found ${#TOP_LEVEL_INITIATIVES[@]} initiative(s) at the top level that could be organized."
if [[ ${#TOP_LEVEL_FILES[@]} -gt 0 ]]; then
  echo "Also found ${#TOP_LEVEL_FILES[@]} top-level file(s): ${TOP_LEVEL_FILES[*]}"
  echo "(Top-level files like README.md, ROADMAP.md, TRACKER.md will stay at the root.)"
fi
echo ""

if [[ "$SKIP_PROMPT" != true ]]; then
  echo "This will launch a Claude Code session to analyze each initiative and"
  echo "recommend which lifecycle directory it belongs in."
  echo ""
  if [[ "$DRY_RUN" == true ]]; then
    echo "  Mode: DRY RUN (recommendations only, no files moved)"
  else
    echo "  Mode: INTERACTIVE (will ask before moving each batch)"
  fi
  echo ""
  read -rp "Proceed? [Y/n] " confirm
  if [[ "$confirm" == [nN] ]]; then
    echo "Aborted."
    exit 0
  fi
fi

# --- Build Prompt for Claude --------------------------------------------------

PROMPT_FILE="$(mktemp)"
SYSTEM_FILE="$(mktemp)"
cleanup() { rm -f "$PROMPT_FILE" "$SYSTEM_FILE"; }
trap cleanup EXIT

# Build list of active worktrees for context
ACTIVE_WORKTREES=""
if [[ -d "$WORKTREES_DIR" ]]; then
  ACTIVE_WORKTREES=$(find "$WORKTREES_DIR" -maxdepth 1 -mindepth 1 -type d ! -name '.*' -exec basename {} \; | sort | tr '\n' ', ')
fi

DEV_BRANCH="$(parse_yaml 'dev_branch')"
DEV_BRANCH="${DEV_BRANCH:-staging}"

# Build list of merged branches for shipped detection
MERGED_BRANCHES=""
if [[ -d "${REPO_DIR}/.git" ]]; then
  MERGED_BRANCHES=$(cd "$REPO_DIR" && git branch --merged "$DEV_BRANCH" 2>/dev/null | tr -d '* ' | tr '\n' ', ')
fi

cat > "$SYSTEM_FILE" <<SYSEOF
Project name: ${PROJECT_NAME}
Initiatives directory: ${INITIATIVES_DIR}
Worktrees directory: ${WORKTREES_DIR}
Active worktrees: ${ACTIVE_WORKTREES}
Dev branch: ${DEV_BRANCH}
Branches merged to ${DEV_BRANCH}: ${MERGED_BRANCHES}
Dry run: ${DRY_RUN}
SYSEOF

cat > "$PROMPT_FILE" <<'PROMPTEOF'
You are organizing a project's initiatives into the standard Deliberate_Agents lifecycle directories.

## Standard Directory Structure

initiatives/
  backlog/        — Has only a one-pager (or minimal docs). Not yet fully specified with PRD, architecture, or task breakdown.
  specified/      — Fully specified: has a PRD, architecture decisions, task breakdown, or other artifacts beyond a one-pager. Ready for a developer to pick up.
  in-progress/    — Has an active worktree in the worktrees directory (under active development).
  shipped/        — Completed, merged, and deployed.
  retired/        — Absorbed into another initiative, deferred indefinitely, or cancelled.

## What to do

1. Read the initiatives directory to find all initiative directories at the TOP LEVEL (not already inside backlog/, specified/, in-progress/, shipped/, or retired/).

2. For each top-level initiative directory:
   a. List its contents to understand what artifacts exist
   b. Read the one-pager or primary document (first few lines) to understand the initiative
   c. Check if it has an active worktree (compare directory name against active worktrees list)
   d. Check git merge state: if a branch matching the initiative ID (e.g., feature/0s-*, feature/3i.1-*) appears in the "Branches merged to dev_branch" list from the system prompt, the initiative is **shipped** — this signal takes priority over file-based heuristics
   e. Also run `git log --oneline --all --grep="<initiative-id>"` to check for merged commits referencing the initiative
   f. Classify it into one of the lifecycle states (priority order):
      - **shipped**: Feature branch merged to dev branch (highest priority signal)
      - **in-progress**: Has a matching worktree in the active worktrees list (but NOT merged)
      - **specified**: Has a PRD, architecture doc, task breakdown, or multiple substantive artifacts beyond a one-pager
      - **backlog**: Has only a one-pager or minimal documentation
      - **retired**: Referenced as retired/absorbed/deferred in docs

3. For initiatives already in shipped/ or retired/ directories: check if they have a STATUS.yaml. If not, create one.

4. After classifying all initiatives, output a clear summary table showing:
   - Initiative name
   - Current location (top-level)
   - Recommended destination
   - Reason (1 sentence)
   - Signal used (git-merge / worktree / artifacts / docs)

5. If NOT in dry-run mode:
   - Create a STATUS.yaml file in EVERY initiative directory (including ones already in lifecycle dirs) using this exact format:
     ```yaml
     state: "<lifecycle-state>"
     id: "<initiative-id>"
     title: "<initiative-title>"
     updated_at: "<today's date ISO 8601>"
     updated_by: "organize-initiatives"
     reason: "<why this state was assigned>"
     ```
   - Use Bash to run `mv` commands to move each top-level initiative directory into its recommended lifecycle directory
   - Move ALL classified initiatives — do not ask for confirmation on each one individually
   - After moving, output the final state of the initiatives directory

6. If in dry-run mode:
   - Just output the recommendations, don't move anything or create STATUS.yaml files

## Important rules
- Git merge state is the HIGHEST PRIORITY signal — if a feature branch is merged, the initiative is shipped regardless of artifact count
- Do NOT move the shipped/ or retired/ directories — they are already lifecycle directories
- Do NOT move top-level files (README.md, ROADMAP.md, TRACKER.md, CLAUDE.md, etc.) — they stay at the root
- Do NOT move directories named "Initiative Templates" or similar utility directories
- Super-initiatives with sub-initiative directories (like 3p with 3p.1, 3p.2, etc.) should be moved as a unit — the entire parent directory moves
- Cross-cutting spec directories (like payments-stripe/, export-foundation/) that aren't tied to a single initiative should be classified as specified/ if they have substantial docs, or backlog/ if minimal
- Be thorough — classify every single top-level initiative directory
- Every initiative directory MUST get a STATUS.yaml — this is required for the orchestrator to track lifecycle state going forward
PROMPTEOF

# --- Launch Claude Code -------------------------------------------------------

echo ""
echo "Analyzing initiatives..."
echo ""

PERM_MODE=$(grep -E '^\s*permission_mode:' "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'" || echo "unrestricted")
PERM_MODE="${PERM_MODE:-unrestricted}"
if [[ "$PERM_MODE" == "unrestricted" ]]; then
  PERM_FLAG="--dangerously-skip-permissions"
else
  PERM_FLAG="--permission-mode auto"
fi

cd "$REPO_DIR" && claude --print \
  --max-turns 60 \
  $PERM_FLAG \
  --output-format text \
  --append-system-prompt "$(cat "$SYSTEM_FILE")" \
  -p "$(cat "$PROMPT_FILE")" \
  2>&1

echo ""

# --- Regenerate TRACKER.md from STATUS.yaml files ----------------------------

if [[ "$DRY_RUN" != true ]]; then
  echo ""
  echo "Regenerating TRACKER.md..."
  "${SCRIPT_DIR}/sync-initiatives.sh" "$CONFIG_FILE" --quiet 2>/dev/null || true
fi

# --- Summary ------------------------------------------------------------------

echo ""
echo "==========================================="
echo "  Organization complete!"
echo "==========================================="
echo ""
echo "Initiative lifecycle directories:"
for dir in "${STANDARD_DIRS[@]}"; do
  if [[ -d "${INITIATIVES_DIR}/${dir}" ]]; then
    count=$(find "${INITIATIVES_DIR}/${dir}" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    echo "  ${dir}/: ${count} initiative(s)"
  fi
done
echo ""

# Count any remaining top-level initiatives
remaining=0
while IFS= read -r entry; do
  basename="$(basename "$entry")"
  case "$basename" in
    backlog|specified|in-progress|shipped|retired|.*|"Initiative Templates") continue ;;
  esac
  if [[ -d "$entry" ]]; then
    remaining=$((remaining + 1))
  fi
done < <(find "$INITIATIVES_DIR" -maxdepth 1 -mindepth 1 2>/dev/null)

if [[ $remaining -gt 0 ]]; then
  echo "  NOTE: ${remaining} initiative(s) remain at the top level."
fi
