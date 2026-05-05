#!/usr/bin/env bash
#
# briefing.sh — Human-friendly status briefing
#
# Generates a "here's where things stand" summary in plain language.
# Called at session start and on-demand. Designed to be read by Claude
# or posted to Slack — no jargon, no state-machine labels.
#
# Usage: briefing.sh <config-file> [--format terminal|slack]

set -euo pipefail

CONFIG_FILE="${1:?Usage: briefing.sh <config-file> [--format terminal|slack]}"
FORMAT="${2:-terminal}"
[[ "$FORMAT" == "--format" ]] && FORMAT="${3:-terminal}"

parse_yaml() {
  local key="$1"
  grep -E "^[[:space:]]*${key}:" "$CONFIG_FILE" | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

WORKTREES_DIR="$(parse_yaml 'worktrees')"
PROJECT_NAME="$(parse_yaml 'name')"
DELIBERATE_DIR="${WORKTREES_DIR}/.deliberate"
QUEUE_DIR="${DELIBERATE_DIR}/queue"
ASSIGNMENTS_DIR="${DELIBERATE_DIR}/assignments"
STATUS_DIR="${DELIBERATE_DIR}/status"
DECISIONS_DIR="${DELIBERATE_DIR}/decisions"
LOG_DIR="${DELIBERATE_DIR}/logs"

read_yaml_field() {
  local file="$1"
  local field="$2"
  grep -E "^[[:space:]]*${field}:" "$file" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

read_md_field() {
  local file="$1"
  local field="$2"
  grep -E "\*\*${field}\*\*:" "$file" 2>/dev/null | head -1 | sed 's/.*\*\*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

# --- Collect State ------------------------------------------------------------

completed=()
in_progress=()
blocked=()
needs_review=()
pending_decisions=()
queued=()

if [[ -d "$QUEUE_DIR" ]]; then
  for f in "$QUEUE_DIR"/*.yaml; do
    [[ -f "$f" ]] || continue
    slug="$(basename "$f" .yaml)"
    status="$(read_yaml_field "$f" 'status')"
    title="$(read_yaml_field "$f" 'title')"
    title="${title:-$slug}"

    case "$status" in
      COMPLETE)
        completed+=("$title")
        ;;
      QUEUED)
        queued+=("$title")
        ;;
      REVIEW_READY)
        needs_review+=("$title ($slug)")
        ;;
      BLOCKED)
        reason="$(read_yaml_field "$f" 'blocker')"
        blocked+=("$title — ${reason:-unknown reason}")
        ;;
      *IN_PROGRESS*)
        phase=""
        case "$status" in
          PM_IN_PROGRESS)  phase="product definition" ;;
          PJM_IN_PROGRESS) phase="project planning" ;;
          DEV_IN_PROGRESS) phase="development" ;;
          REVIEW_IN_PROGRESS) phase="code review" ;;
          *) phase="$status" ;;
        esac
        in_progress+=("$title ($phase)")
        ;;
      DEV_COMPLETE)
        needs_review+=("$title ($slug)")
        ;;
      PRD_COMPLETE|READY_FOR_DEV)
        in_progress+=("$title (transitioning)")
        ;;
    esac
  done
fi

# Pending decisions
if [[ -d "$DECISIONS_DIR" ]]; then
  for f in "$DECISIONS_DIR"/*.md; do
    [[ -f "$f" ]] || continue
    resolution_content="$(sed -n '/^## Resolution/,/^##/p' "$f" 2>/dev/null | grep -v '^##' | tr -d '[:space:]')"
    if [[ -z "$resolution_content" ]]; then
      question="$(sed -n '/^## Question/,/^##/p' "$f" 2>/dev/null | grep -v '^##' | head -2 | tr '\n' ' ' | sed 's/[[:space:]]*$//')"
      initiative="$(grep -E '^\*\*Initiative\*\*:' "$f" 2>/dev/null | sed 's/.*: //' || echo '')"
      if [[ -n "$initiative" ]]; then
        pending_decisions+=("${initiative}: ${question:-see decision file}")
      else
        pending_decisions+=("$(basename "$f" .md): ${question:-see decision file}")
      fi
    fi
  done
fi

# Blocked assignments
if [[ -d "$ASSIGNMENTS_DIR" ]]; then
  for f in "$ASSIGNMENTS_DIR"/*.md; do
    [[ -f "$f" ]] || continue
    status="$(read_md_field "$f" 'Status')"
    if [[ "$status" == "blocked" ]]; then
      initiative="$(read_md_field "$f" 'Initiative')"
      reason="$(read_md_field "$f" 'Blocker')"
      blocked+=("${initiative:-$(basename "$f" .md)} — ${reason:-unknown}")
    fi
  done
fi

# Active agents
active_agents=0
if [[ -d "$STATUS_DIR" ]]; then
  for f in "$STATUS_DIR"/*.md; do
    [[ -f "$f" ]] || continue
    name="$(basename "$f" .md)"
    [[ "$name" == "orchestrator" || "$name" == "report" || "$name" == "slack_bot" ]] && continue
    agent_status="$(read_md_field "$f" 'Status')"
    if [[ "$agent_status" == "active" ]]; then
      ((active_agents++))
    fi
  done
fi

# Last orchestrator heartbeat
last_poll=""
if [[ -f "${STATUS_DIR}/orchestrator.md" ]]; then
  last_poll="$(read_md_field "${STATUS_DIR}/orchestrator.md" 'Last Poll')"
fi

# --- Generate Briefing --------------------------------------------------------

generate() {
  local out=""

  # Headline
  local total=$(( ${#completed[@]} + ${#in_progress[@]} + ${#blocked[@]} + ${#needs_review[@]} + ${#queued[@]} ))

  if [[ "$FORMAT" == "slack" ]]; then
    out+=":wave: *${PROJECT_NAME} — Session Briefing*\n\n"
  else
    out+="${PROJECT_NAME} — Session Briefing\n"
    out+="$(date '+%Y-%m-%d %H:%M %Z')\n\n"
  fi

  # What needs your attention (most important, first)
  local attention_needed=false

  if [[ ${#pending_decisions[@]} -gt 0 ]]; then
    attention_needed=true
    if [[ "$FORMAT" == "slack" ]]; then
      out+=":red_circle: *${#pending_decisions[@]} decision(s) waiting on you:*\n"
    else
      out+="NEEDS YOUR ATTENTION — ${#pending_decisions[@]} decision(s) pending:\n"
    fi
    for d in "${pending_decisions[@]}"; do
      out+="  - $d\n"
    done
    out+="\n"
  fi

  if [[ ${#needs_review[@]} -gt 0 ]]; then
    attention_needed=true
    if [[ "$FORMAT" == "slack" ]]; then
      out+=":eyes: *${#needs_review[@]} branch(es) ready for your review:*\n"
    else
      out+="READY FOR REVIEW — ${#needs_review[@]} branch(es):\n"
    fi
    for r in "${needs_review[@]}"; do
      out+="  - $r\n"
    done
    out+="\n"
  fi

  if [[ ${#blocked[@]} -gt 0 ]]; then
    attention_needed=true
    if [[ "$FORMAT" == "slack" ]]; then
      out+=":no_entry: *${#blocked[@]} item(s) blocked:*\n"
    else
      out+="BLOCKED — ${#blocked[@]} item(s):\n"
    fi
    for b in "${blocked[@]}"; do
      out+="  - $b\n"
    done
    out+="\n"
  fi

  if ! $attention_needed; then
    if [[ "$FORMAT" == "slack" ]]; then
      out+=":white_check_mark: *Nothing needs your attention right now.*\n\n"
    else
      out+="Nothing needs your attention right now.\n\n"
    fi
  fi

  # What's in progress
  if [[ ${#in_progress[@]} -gt 0 ]]; then
    if [[ "$FORMAT" == "slack" ]]; then
      out+=":gear: *In progress (${#in_progress[@]}):*\n"
    else
      out+="In progress (${#in_progress[@]}):\n"
    fi
    for ip in "${in_progress[@]}"; do
      out+="  - $ip\n"
    done
    out+="\n"
  fi

  # What's queued
  if [[ ${#queued[@]} -gt 0 ]]; then
    if [[ "$FORMAT" == "slack" ]]; then
      out+=":inbox_tray: *Queued (${#queued[@]}):*\n"
    else
      out+="Queued (${#queued[@]}):\n"
    fi
    for q in "${queued[@]}"; do
      out+="  - $q\n"
    done
    out+="\n"
  fi

  # What's done
  if [[ ${#completed[@]} -gt 0 ]]; then
    if [[ "$FORMAT" == "slack" ]]; then
      out+=":white_check_mark: *Completed (${#completed[@]}):* "
    else
      out+="Completed (${#completed[@]}): "
    fi
    out+="$(IFS=', '; echo "${completed[*]}")\n\n"
  fi

  # System status
  if [[ "$FORMAT" == "slack" ]]; then
    out+="_${active_agents} agent(s) active"
    [[ -n "$last_poll" ]] && out+=" · last poll ${last_poll}"
    out+="_\n"
  else
    out+="System: ${active_agents} agent(s) active"
    [[ -n "$last_poll" ]] && out+=" · last orchestrator poll: ${last_poll}"
    out+="\n"
  fi

  echo -e "$out"
}

generate
