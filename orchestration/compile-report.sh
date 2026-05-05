#!/usr/bin/env bash
#
# compile-report.sh — Build an orchestration report from current state
#
# Reads .deliberate/ state files and agent logs to produce a real-time
# summary of what's happening across all agents. Called by the orchestrator
# on each poll cycle.
#
# Usage: compile-report.sh <config-file> [--format slack|markdown|log]
#
# Output: Writes report to .deliberate/status/report.md and optionally
#         prints a Slack-formatted summary to stdout.

set -euo pipefail

CONFIG_FILE="${1:?Usage: compile-report.sh <config-file> [--format slack|markdown|log]}"
FORMAT="${2:---format}"
FORMAT_VALUE="${3:-markdown}"

# Handle --format flag
if [[ "$FORMAT" == "--format" ]]; then
  FORMAT="$FORMAT_VALUE"
else
  FORMAT="markdown"
fi

# --- Configuration ------------------------------------------------------------

parse_yaml() {
  local key="$1"
  grep -E "^\s*${key}:" "$CONFIG_FILE" | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'"
}

WORKTREES_DIR="$(parse_yaml 'worktrees')"
PROJECT_NAME="$(parse_yaml 'name')"
DELIBERATE_DIR="${WORKTREES_DIR}/.deliberate"
QUEUE_DIR="${DELIBERATE_DIR}/queue"
ASSIGNMENTS_DIR="${DELIBERATE_DIR}/assignments"
STATUS_DIR="${DELIBERATE_DIR}/status"
DECISIONS_DIR="${DELIBERATE_DIR}/decisions"
LOG_DIR="${DELIBERATE_DIR}/logs"
REPORT_FILE="${STATUS_DIR}/report.md"

read_yaml_field() {
  local file="$1"
  local field="$2"
  grep -E "^\s*${field}:" "$file" 2>/dev/null | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'"
}

read_md_field() {
  local file="$1"
  local field="$2"
  grep -E "\*\*${field}\*\*:" "$file" 2>/dev/null | head -1 | sed 's/.*\*\*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

# --- Collect State ------------------------------------------------------------

# Initiative summary
declare -A initiative_status
declare -A initiative_title

if [[ -d "$QUEUE_DIR" ]]; then
  for f in "$QUEUE_DIR"/*.yaml; do
    [[ -f "$f" ]] || continue
    slug="$(basename "$f" .yaml)"
    status="$(read_yaml_field "$f" 'status')"
    title="$(read_yaml_field "$f" 'title')"
    initiative_status["$slug"]="$status"
    initiative_title["$slug"]="${title:-$slug}"
  done
fi

# Active agents
declare -A active_agents

if [[ -d "$STATUS_DIR" ]]; then
  for f in "$STATUS_DIR"/*.md; do
    [[ -f "$f" ]] || continue
    name="$(basename "$f" .md)"
    [[ "$name" == "orchestrator" || "$name" == "report" ]] && continue
    agent_status="$(read_md_field "$f" 'Status')"
    role="$(read_md_field "$f" 'Role')"
    progress="$(read_md_field "$f" 'Progress')"
    if [[ "$agent_status" == "active" ]]; then
      active_agents["$name"]="${role}: ${progress:-working...}"
    fi
  done
fi

# Pending decisions
pending_decisions=()
if [[ -d "$DECISIONS_DIR" ]]; then
  for f in "$DECISIONS_DIR"/*.md; do
    [[ -f "$f" ]] || continue
    resolved="$(grep -c "^## Resolution" "$f" 2>/dev/null || echo 0)"
    resolution_content="$(sed -n '/^## Resolution/,/^##/p' "$f" 2>/dev/null | grep -v '^##' | tr -d '[:space:]')"
    if [[ "$resolved" -eq 0 ]] || [[ -z "$resolution_content" ]]; then
      pending_decisions+=("$(basename "$f" .md)")
    fi
  done
fi

# Blocked assignments
blocked_items=()
if [[ -d "$ASSIGNMENTS_DIR" ]]; then
  for f in "$ASSIGNMENTS_DIR"/*.md; do
    [[ -f "$f" ]] || continue
    status="$(read_md_field "$f" 'Status')"
    if [[ "$status" == "blocked" ]]; then
      blocker="$(read_md_field "$f" 'Blocker')"
      blocked_items+=("$(basename "$f" .md): ${blocker:-unknown reason}")
    fi
  done
fi

# Recent log activity (last 10 lines from each active agent log)
recent_activity=()
if [[ -d "$LOG_DIR" ]]; then
  today="$(date +%Y%m%d)"
  for f in "$LOG_DIR"/*-"${today}"*.log; do
    [[ -f "$f" ]] || continue
    agent_name="$(basename "$f" | sed "s/-${today}.*//")"
    last_line="$(tail -1 "$f" 2>/dev/null | head -c 200)"
    if [[ -n "$last_line" ]]; then
      recent_activity+=("${agent_name}: ${last_line}")
    fi
  done
fi

# --- Generate Report ---------------------------------------------------------

generate_markdown() {
  local report=""
  report+="# Orchestration Report — ${PROJECT_NAME}\n"
  report+="\n**Generated:** $(date '+%Y-%m-%d %H:%M:%S')\n\n"

  # Initiatives
  report+="## Initiative Status\n\n"
  report+="| Initiative | Status |\n"
  report+="|---|---|\n"
  for slug in "${!initiative_status[@]}"; do
    report+="| ${initiative_title[$slug]} | ${initiative_status[$slug]} |\n"
  done
  report+="\n"

  # Active agents
  report+="## Active Agents\n\n"
  if [[ ${#active_agents[@]} -eq 0 ]]; then
    report+="No agents currently active.\n\n"
  else
    for name in "${!active_agents[@]}"; do
      report+="- **${name}**: ${active_agents[$name]}\n"
    done
    report+="\n"
  fi

  # Pending decisions
  report+="## Pending Decisions\n\n"
  if [[ ${#pending_decisions[@]} -eq 0 ]]; then
    report+="No decisions pending.\n\n"
  else
    for d in "${pending_decisions[@]}"; do
      report+="- ${d}\n"
    done
    report+="\n"
  fi

  # Blocked items
  report+="## Blocked\n\n"
  if [[ ${#blocked_items[@]} -eq 0 ]]; then
    report+="Nothing blocked.\n\n"
  else
    for b in "${blocked_items[@]}"; do
      report+="- ${b}\n"
    done
    report+="\n"
  fi

  # Recent activity
  report+="## Recent Activity\n\n"
  if [[ ${#recent_activity[@]} -eq 0 ]]; then
    report+="No recent activity.\n\n"
  else
    for a in "${recent_activity[@]}"; do
      report+="- ${a}\n"
    done
    report+="\n"
  fi

  echo -e "$report"
}

generate_slack() {
  local summary=""
  local active_count="${#active_agents[@]}"
  local pending_count="${#pending_decisions[@]}"
  local blocked_count="${#blocked_items[@]}"
  local initiative_count="${#initiative_status[@]}"

  summary+=":clipboard: *${PROJECT_NAME} — Status*\n"
  summary+=":package: ${initiative_count} initiatives"

  # Count by status
  local in_progress=0
  local queued=0
  local complete=0
  for slug in "${!initiative_status[@]}"; do
    case "${initiative_status[$slug]}" in
      *IN_PROGRESS*) ((in_progress++)) ;;
      QUEUED)        ((queued++)) ;;
      COMPLETE)      ((complete++)) ;;
    esac
  done
  summary+=" (${queued} queued, ${in_progress} in progress, ${complete} complete)\n"
  summary+=":robot_face: ${active_count} agents active\n"

  if [[ $pending_count -gt 0 ]]; then
    summary+=":question: *${pending_count} decisions waiting on you*\n"
    for d in "${pending_decisions[@]}"; do
      summary+="  • ${d}\n"
    done
  fi

  if [[ $blocked_count -gt 0 ]]; then
    summary+=":rotating_light: *${blocked_count} items blocked*\n"
    for b in "${blocked_items[@]}"; do
      summary+="  • ${b}\n"
    done
  fi

  # Latest agent progress
  if [[ $active_count -gt 0 ]]; then
    summary+="\n*Agent Activity:*\n"
    for name in "${!active_agents[@]}"; do
      summary+="  :gear: ${name} — ${active_agents[$name]}\n"
    done
  fi

  echo -e "$summary"
}

# --- Main ---------------------------------------------------------------------

mkdir -p "$STATUS_DIR"

case "$FORMAT" in
  markdown)
    generate_markdown | tee "$REPORT_FILE"
    ;;
  slack)
    generate_slack
    # Also write markdown version
    generate_markdown > "$REPORT_FILE"
    ;;
  log)
    generate_markdown > "$REPORT_FILE"
    echo "[REPORT] ${#initiative_status[@]} initiatives, ${#active_agents[@]} active agents, ${#pending_decisions[@]} pending decisions, ${#blocked_items[@]} blocked"
    ;;
  *)
    echo "Unknown format: $FORMAT"
    exit 1
    ;;
esac
