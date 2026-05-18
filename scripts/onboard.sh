#!/usr/bin/env bash
#
# onboard.sh — Get familiar with a target project
#
# Launches a Claude Code session that explores the target repo's codebase,
# documentation, and initiative state, then writes a structured project brief
# to .deliberate/onboarding.md that all future agents can reference.
#
# Usage: onboard.sh <config-file> [options]
#
# Options:
#   --refresh       Re-run onboarding even if onboarding.md already exists
#   --skip-prompt   Skip the confirmation prompt (for scripted use)
#   -h, --help      Show this help

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORK_DIR="$(dirname "$SCRIPT_DIR")"

CONFIG_FILE=""
REFRESH=false
SKIP_PROMPT=false

# --- Argument Parsing ---------------------------------------------------------

while [[ $# -gt 0 ]]; do
  case "$1" in
    --refresh)      REFRESH=true; shift ;;
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

[[ -n "$CONFIG_FILE" ]] || { echo "ERROR: Config file path required. Usage: onboard.sh <config-file>"; exit 1; }
[[ -f "$CONFIG_FILE" ]] || { echo "ERROR: Config file not found: $CONFIG_FILE"; exit 1; }

# --- Parse Config -------------------------------------------------------------

parse_yaml() {
  local key="$1"
  grep -E "^\s*${key}:" "$CONFIG_FILE" | head -1 | sed 's/[^:]*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

PROJECT_NAME="$(parse_yaml 'name')"
REPO_DIR="$(parse_yaml 'repo')"
WORKTREES_DIR="$(parse_yaml 'worktrees')"
MAIN_BRANCH="$(parse_yaml 'main_branch')"
DEV_BRANCH="$(parse_yaml 'dev_branch')"
INITIATIVES_PATH="$(parse_yaml 'initiatives_path')"
DELIBERATE_DIR="${WORKTREES_DIR}/.deliberate"
ONBOARDING_FILE="${DELIBERATE_DIR}/onboarding.md"

# --- Pre-flight Checks --------------------------------------------------------

[[ -d "$REPO_DIR" ]]       || { echo "ERROR: Repo not found: $REPO_DIR"; exit 1; }
[[ -d "$DELIBERATE_DIR" ]] || { echo "ERROR: State directory not found: $DELIBERATE_DIR (run init.sh first)"; exit 1; }

if [[ -f "$ONBOARDING_FILE" ]] && [[ "$REFRESH" != true ]]; then
  echo "Onboarding brief already exists: $ONBOARDING_FILE"
  read -rp "Regenerate? [y/N] " confirm
  if [[ "$confirm" != [yY] ]]; then
    echo "Skipped. Use --refresh to force regeneration."
    exit 0
  fi
fi

# --- Prompt User --------------------------------------------------------------

if [[ "$SKIP_PROMPT" != true ]]; then
  echo ""
  echo "Deliberate_Agents — Project Onboarding"
  echo "======================================="
  echo ""
  echo "  Project:      $PROJECT_NAME"
  echo "  Repo:         $REPO_DIR"
  echo "  Initiatives:  $REPO_DIR/$INITIATIVES_PATH/"
  echo ""
  echo "This will launch a Claude Code session to explore the project and produce"
  echo "a structured brief covering:"
  echo ""
  echo "  1. Application architecture (models, controllers, routes, jobs)"
  echo "  2. Tech stack details and key dependencies"
  echo "  3. Documentation summary"
  echo "  4. Initiative catalog with status"
  echo "  5. Current branch state and recent activity"
  echo ""
  read -rp "Proceed? [Y/n] " confirm
  if [[ "$confirm" == [nN] ]]; then
    echo "Aborted."
    exit 0
  fi
fi

# --- Build Prompt Files -------------------------------------------------------

PROMPT_FILE="$(mktemp)"
SYSTEM_FILE="$(mktemp)"
cleanup() { rm -f "$PROMPT_FILE" "$SYSTEM_FILE"; }
trap cleanup EXIT

cat > "$SYSTEM_FILE" <<SYSEOF
Write your final brief to: ${ONBOARDING_FILE}
Project name: ${PROJECT_NAME}
Repo path: ${REPO_DIR}
Worktrees path: ${WORKTREES_DIR}
Main branch: ${MAIN_BRANCH}
Dev branch: ${DEV_BRANCH}
Initiatives path: ${REPO_DIR}/${INITIATIVES_PATH}/
State directory: ${DELIBERATE_DIR}
Today's date: $(date -u '+%Y-%m-%d')
SYSEOF

cat > "$PROMPT_FILE" <<'PROMPTEOF'
You are onboarding onto a new project. Your job is to thoroughly explore the codebase and documentation, then write a structured project brief.

## What to explore

1. **Application structure** — Read the top-level directory layout, then drill into:
   - Models (app/models/) — list every model, its key associations and validations
   - Controllers (app/controllers/) — list controllers and their actions
   - Routes (config/routes.rb) — summarize the route structure
   - Views (app/views/) — note layout structure and key partials
   - Jobs, mailers, channels if they exist
   - Database schema (db/schema.rb) — key tables and relationships

2. **Configuration & dependencies** — Check:
   - Gemfile for key gems and their purpose
   - config/ for environment-specific settings
   - Any API integrations, external services, or credentials references

3. **Documentation** — Read through:
   - Any README, CLAUDE.md, or .documentation/ files
   - Vision documents, architecture specs, PRDs
   - Don't read every CSV/spreadsheet — just note they exist

4. **Initiatives** — Catalog the initiatives directory:
   - List each initiative with a one-line description (read its README or main doc)
   - Note which appear active vs shipped vs retired
   - Identify the ROADMAP.md and TRACKER.md if they exist and summarize them
   - Count and categorize: how many total, how many shipped, how many active

5. **Git state & branching strategy** — Check:
   - Current branch and recent commits (last 10)
   - Active branches (list them)
   - Any uncommitted changes
   - Determine the branching strategy. The convention is gitflow with worktrees: a main/production branch, a development/integration branch (may be called dev, develop, or staging), and feature branches in isolated worktrees. Examine: which branch has the most recent commits (the integration branch), merge patterns between branches (git log --merges), where feature branches originate from and merge back into, the config's main_branch and dev_branch settings, and the worktree naming convention. Frame your findings in gitflow terms — identify which branches map to the gitflow roles (main, develop, feature, hotfix, release) even if names differ. Tell agents clearly: which branch to create worktrees from, which branch PRs target, how releases flow, and how hotfixes are handled.

## Output format

Write the brief as a markdown file using the Write tool. Use this structure:

# Project Onboarding Brief: {project name}

> Generated: {date}
> Repo: {path}

## Application Overview
{2-3 sentence summary of what this application does}

## Architecture

### Models
{table or list of models with key associations}

### Controllers
{list of controllers with their responsibility}

### Routes
{summary of route structure — namespaces, resources, custom routes}

### Background Jobs & Services
{jobs, mailers, service objects if they exist}

## Tech Stack
- **Framework**: ...
- **Database**: ...
- **Key gems**: ... (only noteworthy ones)
- **Frontend**: ...
- **External services**: ...

## Documentation Inventory
{list of documentation files/directories with one-line descriptions}

## Initiative Catalog

### Summary
- Total: N
- Shipped: N
- Active: N
- Retired: N

### Active Initiatives
{table: name | one-line description | status}

### Shipped
{table: name | one-line description}

### Retired
{brief list}

## Branching Strategy
- **Source of truth**: {which branch is most up-to-date and why}
- **Feature branches**: {where they branch from, where they merge to, naming convention}
- **Release flow**: {how changes flow from dev → staging → main, or whatever the pattern is}
- **Worktree convention**: {how worktrees map to branches}

## Git State
- **Current branch**: ...
- **Recent activity**: {summary of last 10 commits}
- **Active branches**: {list}

## Key Observations
{3-5 bullet points of things a new developer should know — patterns, gotchas, conventions}

## Rules
- Be thorough but concise — this brief should be scannable
- Don't guess — if you can't determine something, say so
- For initiatives, read the README.md or first file in each directory to get a description
- Skip binary files, images, node_modules, vendor, tmp
- The brief should be useful to both human developers and AI agents
PROMPTEOF

# --- Launch Claude Code -------------------------------------------------------

echo ""
echo "Launching onboarding agent..."
echo "Output: $ONBOARDING_FILE"
echo ""

PERM_MODE=$(grep -E '^\s*permission_mode:' "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'" || echo "unrestricted")
PERM_MODE="${PERM_MODE:-unrestricted}"
if [[ "$PERM_MODE" == "unrestricted" ]]; then
  PERM_FLAG="--dangerously-skip-permissions"
else
  PERM_FLAG="--permission-mode auto"
fi

cd "$REPO_DIR" && claude --print \
  --max-turns 120 \
  $PERM_FLAG \
  --output-format text \
  --append-system-prompt "$(cat "$SYSTEM_FILE")" \
  -p "$(cat "$PROMPT_FILE")" \
  2>&1

echo ""

# --- Verify Output ------------------------------------------------------------

if [[ -f "$ONBOARDING_FILE" ]]; then
  LINES=$(wc -l < "$ONBOARDING_FILE")
  echo ""
  echo "==========================================="
  echo "  Onboarding complete!"
  echo "==========================================="
  echo ""
  echo "Brief: $ONBOARDING_FILE ($LINES lines)"
  echo ""
  echo "This brief will be available to all agents working on $PROJECT_NAME."
  echo "To regenerate: ./scripts/onboard.sh $CONFIG_FILE --refresh"
else
  echo ""
  echo "WARNING: Onboarding file was not created."
  echo "The agent may have encountered an issue. Check the output above."
  exit 1
fi
