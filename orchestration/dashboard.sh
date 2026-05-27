#!/usr/bin/env bash
#
# dashboard.sh — Generate a structured status dashboard
#
# Reads .deliberate/ state files and writes a human-readable dashboard
# to .deliberate/status/dashboard.md. Called by orchestrate.sh or by
# the Orchestrator agent via bash.
#
# Usage: dashboard.sh <config-file>

set -euo pipefail

CONFIG_FILE="${1:?Usage: dashboard.sh <config-file>}"

parse_yaml() {
  local key="$1"
  grep -E "^[[:space:]]*${key}:" "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

PROJECT_NAME="$(parse_yaml 'name')"
WORKTREES_DIR="$(parse_yaml 'worktrees')"
DELIBERATE_DIR="${WORKTREES_DIR}/.deliberate"

[[ -d "$DELIBERATE_DIR" ]] || { echo "No .deliberate/ directory found"; exit 1; }

QUEUE_DIR="${DELIBERATE_DIR}/queue"
PID_DIR="${DELIBERATE_DIR}/pids"
STATUS_DIR="${DELIBERATE_DIR}/status"
DECISIONS_DIR="${DELIBERATE_DIR}/decisions"
LOG_DIR="${DELIBERATE_DIR}/logs"
COMMS_DIR="${DELIBERATE_DIR}/comms"
DASHBOARD_FILE="${STATUS_DIR}/dashboard.md"
TIMESTAMP="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

read_yaml_field() {
  local file="$1"
  local field="$2"
  grep -E "^[[:space:]]*${field}:" "$file" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

# --- Active Agents ------------------------------------------------------------

AGENTS_TABLE="| Role | Initiative | Elapsed | Window |\n|------|-----------|---------|--------|\n"
AGENT_COUNT=0

for pid_file in "$PID_DIR"/*.pid; do
  [[ -f "$pid_file" ]] || continue
  pid="$(cat "$pid_file")"
  if kill -0 "$pid" 2>/dev/null; then
    agent_name="$(basename "$pid_file" .pid)"
    role="${agent_name%%-*}"
    initiative="${agent_name#*-}"

    # Estimate elapsed time from log file
    log_match="$(grep "Launching.*${agent_name}" "$LOG_DIR"/orchestrator-*.log 2>/dev/null | tail -1)"
    elapsed="?"
    if [[ -n "$log_match" ]]; then
      launch_time="$(echo "$log_match" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}')"
      if [[ -n "$launch_time" ]]; then
        launch_epoch="$(date -j -f '%Y-%m-%d %H:%M:%S' "$launch_time" '+%s' 2>/dev/null)" || true
        if [[ -n "$launch_epoch" ]]; then
          now_epoch="$(date '+%s')"
          mins="$(( (now_epoch - launch_epoch) / 60 ))"
          if (( mins >= 60 )); then
            elapsed="$((mins / 60))h$((mins % 60))m"
          else
            elapsed="${mins}m"
          fi
        fi
      fi
    fi

    AGENTS_TABLE+="| ${role} | ${initiative} | ${elapsed} | ${agent_name} |\n"
    ((AGENT_COUNT++)) || true
  else
    rm -f "$pid_file"
  fi
done

if (( AGENT_COUNT == 0 )); then
  AGENTS_TABLE+="| _(none)_ | | | |\n"
fi

# --- Pipeline Summary ---------------------------------------------------------

declare -A STAGE_COUNTS
declare -A STAGE_INITIATIVES

for initiative_file in "$QUEUE_DIR"/*.yaml; do
  [[ -f "$initiative_file" ]] || continue
  slug="$(basename "$initiative_file" .yaml)"
  status="$(read_yaml_field "$initiative_file" 'status')"
  status="${status:-UNKNOWN}"

  STAGE_COUNTS["$status"]=$(( ${STAGE_COUNTS["$status"]:-0} + 1 ))
  if [[ -n "${STAGE_INITIATIVES["$status"]:-}" ]]; then
    STAGE_INITIATIVES["$status"]+=", ${slug}"
  else
    STAGE_INITIATIVES["$status"]="$slug"
  fi
done

PIPELINE_TABLE="| Stage | Count | Initiatives |\n|-------|-------|------------|\n"
for stage in QUEUED PM_IN_PROGRESS PRD_COMPLETE ARCH_IN_PROGRESS ARCH_COMPLETE \
             DESIGN_IN_PROGRESS DESIGN_COMPLETE SCRUM_IN_PROGRESS SPECIFIED \
             READY_FOR_DEV PJM_IN_PROGRESS DEV_IN_PROGRESS DEV_COMPLETE \
             REVIEW_IN_PROGRESS QA_IN_PROGRESS BLOCKED COMPLETE; do
  count="${STAGE_COUNTS["$stage"]:-0}"
  (( count > 0 )) || continue
  initiatives="${STAGE_INITIATIVES["$stage"]:-}"
  PIPELINE_TABLE+="| ${stage} | ${count} | ${initiatives} |\n"
done

# --- Needs Attention ----------------------------------------------------------

ATTENTION=""

# Blocked initiatives
for initiative_file in "$QUEUE_DIR"/*.yaml; do
  [[ -f "$initiative_file" ]] || continue
  status="$(read_yaml_field "$initiative_file" 'status')"
  if [[ "$status" == "BLOCKED" ]]; then
    slug="$(basename "$initiative_file" .yaml)"
    blocker="$(read_yaml_field "$initiative_file" 'blocker')"
    ATTENTION+="- **BLOCKED**: ${slug} — ${blocker:-unknown reason}\n"
  fi
done

# Pending decisions
pending_decisions=0
if [[ -d "$DECISIONS_DIR" ]]; then
  for dec_file in "$DECISIONS_DIR"/*.md; do
    [[ -f "$dec_file" ]] || continue
    resolution="$(sed -n '/^## Resolution/,/^##/p' "$dec_file" 2>/dev/null | grep -v '^##' | tr -d '[:space:]')"
    if [[ -z "$resolution" ]]; then
      ((pending_decisions++)) || true
    fi
  done
fi
(( pending_decisions > 0 )) && ATTENTION+="- **${pending_decisions} decision(s)** pending human review\n"

# Dead PID files (agent finished but PID file lingers — already cleaned above)

if [[ -z "$ATTENTION" ]]; then
  ATTENTION="- All clear — nothing needs immediate attention\n"
fi

# --- Recent Transitions -------------------------------------------------------

TRANSITIONS=""
today_log="${LOG_DIR}/orchestrator-$(date +%Y%m%d).log"
if [[ -f "$today_log" ]]; then
  TRANSITIONS="$(grep -E '(Launching|finished|Advancing|Starting product|Dev complete|QA approved)' "$today_log" 2>/dev/null | tail -5 | while IFS= read -r line; do
    ts="$(echo "$line" | grep -oE '\[.*?\]' | head -1)"
    msg="$(echo "$line" | sed 's/\[.*\] \[.*\] //')"
    echo "- ${ts} ${msg}"
  done)"
fi

if [[ -z "$TRANSITIONS" ]]; then
  TRANSITIONS="- No transitions recorded today"
fi

# --- System Messages ----------------------------------------------------------

integrator_count=0
orchestrator_count=0
if [[ -d "$COMMS_DIR/_system/inbox/integrator" ]]; then
  for f in "$COMMS_DIR/_system/inbox/integrator"/*.md; do
    [[ -f "$f" ]] || continue
    ((integrator_count++)) || true
  done
fi
if [[ -d "$COMMS_DIR/_system/inbox/orchestrator" ]]; then
  for f in "$COMMS_DIR/_system/inbox/orchestrator"/*.md; do
    [[ -f "$f" ]] || continue
    ((orchestrator_count++)) || true
  done
fi
founder_count=0
if [[ -d "$COMMS_DIR/_system/inbox/founder" ]]; then
  for f in "$COMMS_DIR/_system/inbox/founder"/*.md; do
    [[ -f "$f" ]] || continue
    ((founder_count++)) || true
  done
fi

# --- Write Dashboard ----------------------------------------------------------

mkdir -p "$STATUS_DIR"

cat > "$DASHBOARD_FILE" <<EOF
# Dashboard — ${PROJECT_NAME:-project}
**Updated**: ${TIMESTAMP}

## Active Agents (${AGENT_COUNT})
$(echo -e "$AGENTS_TABLE")

## Pipeline
$(echo -e "$PIPELINE_TABLE")

## Needs Attention
$(echo -e "$ATTENTION")

## Recent Transitions
${TRANSITIONS}

## System Messages
- Integrator inbox: ${integrator_count}
- Orchestrator inbox: ${orchestrator_count}
- Founder inbox: ${founder_count}
EOF

echo "Dashboard written to ${DASHBOARD_FILE}"
