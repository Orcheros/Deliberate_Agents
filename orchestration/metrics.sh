#!/usr/bin/env bash
#
# metrics.sh — Three-metric observability dashboard for Deliberate_Agents
#
# Reads flow.yaml, quality.yaml, and health.yaml from .deliberate/metrics/
# and prints a summary dashboard.
#
# Usage: ./metrics.sh /path/to/project-config.yaml [--json]

set -euo pipefail

CONFIG_FILE="${1:?Usage: metrics.sh <config-file> [--json]}"
OUTPUT_FORMAT="${2:-text}"

parse_yaml() {
  local key="$1"
  grep -E "^[[:space:]]*${key}:" "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

PROJECT_NAME="$(parse_yaml 'name')"
WORKTREES_DIR="$(parse_yaml 'worktrees')"
METRICS_DIR="${WORKTREES_DIR}/.deliberate/metrics"

if [[ ! -d "$METRICS_DIR" ]]; then
  echo "No metrics directory found at $METRICS_DIR"
  exit 0
fi

FLOW_FILE="${METRICS_DIR}/flow.yaml"
QUALITY_FILE="${METRICS_DIR}/quality.yaml"
HEALTH_FILE="${METRICS_DIR}/health.yaml"

# --- Flow Metrics ---

count_transitions() {
  [[ -f "$FLOW_FILE" ]] || { echo "0"; return; }
  grep -c "^- initiative:" "$FLOW_FILE" 2>/dev/null || echo "0"
}

count_transitions_for_stage() {
  local stage="$1"
  [[ -f "$FLOW_FILE" ]] || { echo "0"; return; }
  grep -c "to: \"${stage}\"" "$FLOW_FILE" 2>/dev/null || echo "0"
}

wip_count() {
  local queue_dir="${WORKTREES_DIR}/.deliberate/queue"
  local count=0
  if [[ -d "$queue_dir" ]]; then
    for f in "$queue_dir"/*.yaml; do
      [[ -f "$f" ]] || continue
      local status
      status="$(grep -E "^\s*status:" "$f" | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'")"
      case "$status" in
        QUEUED|COMPLETE|BLOCKED|REVIEW_READY) ;;
        *) ((count++)) || true ;;
      esac
    done
  fi
  echo "$count"
}

# --- Quality Metrics ---

count_gate_passes() {
  [[ -f "$QUALITY_FILE" ]] || { echo "0"; return; }
  grep -c 'event: "gate_pass"' "$QUALITY_FILE" 2>/dev/null || echo "0"
}

count_gate_failures() {
  [[ -f "$QUALITY_FILE" ]] || { echo "0"; return; }
  grep -c 'event: "gate_fail"' "$QUALITY_FILE" 2>/dev/null || echo "0"
}

# --- Health Metrics ---

count_agent_crashes() {
  [[ -f "$HEALTH_FILE" ]] || { echo "0"; return; }
  grep -c 'event: "agent_crash"' "$HEALTH_FILE" 2>/dev/null || echo "0"
}

count_pending_decisions() {
  local decisions_dir="${WORKTREES_DIR}/.deliberate/decisions"
  local count=0
  if [[ -d "$decisions_dir" ]]; then
    for f in "$decisions_dir"/*.md; do
      [[ -f "$f" ]] || continue
      ((count++)) || true
    done
  fi
  echo "$count"
}

# --- Output ---

TOTAL_TRANSITIONS="$(count_transitions)"
WIP="$(wip_count)"
GATE_PASSES="$(count_gate_passes)"
GATE_FAILURES="$(count_gate_failures)"
CRASHES="$(count_agent_crashes)"
PENDING_DECISIONS="$(count_pending_decisions)"

REACHED_DEV="$(count_transitions_for_stage 'DEV_IN_PROGRESS')"
REACHED_REVIEW="$(count_transitions_for_stage 'REVIEW_IN_PROGRESS')"
REACHED_COMPLETE="$(count_transitions_for_stage 'DEV_COMPLETE')"

if [[ "$OUTPUT_FORMAT" == "--json" ]]; then
  cat <<EOF
{
  "project": "${PROJECT_NAME}",
  "timestamp": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')",
  "flow": {
    "total_transitions": ${TOTAL_TRANSITIONS},
    "wip": ${WIP},
    "reached_dev": ${REACHED_DEV},
    "reached_review": ${REACHED_REVIEW},
    "reached_complete": ${REACHED_COMPLETE}
  },
  "quality": {
    "gate_passes": ${GATE_PASSES},
    "gate_failures": ${GATE_FAILURES}
  },
  "health": {
    "agent_crashes": ${CRASHES},
    "pending_decisions": ${PENDING_DECISIONS}
  }
}
EOF
else
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║  Metrics Dashboard: ${PROJECT_NAME}"
  echo "║  $(date '+%Y-%m-%d %H:%M')"
  echo "╠══════════════════════════════════════════════════════════════╣"
  echo "║"
  echo "║  FLOW"
  echo "║    Total transitions:  ${TOTAL_TRANSITIONS}"
  echo "║    Work in progress:   ${WIP}"
  echo "║    Reached dev:        ${REACHED_DEV}"
  echo "║    Reached review:     ${REACHED_REVIEW}"
  echo "║    Reached complete:   ${REACHED_COMPLETE}"
  echo "║"
  echo "║  QUALITY"
  echo "║    Gate passes:        ${GATE_PASSES}"
  echo "║    Gate failures:      ${GATE_FAILURES}"
  if (( GATE_PASSES + GATE_FAILURES > 0 )); then
    PASS_RATE=$(( GATE_PASSES * 100 / (GATE_PASSES + GATE_FAILURES) ))
    echo "║    Pass rate:          ${PASS_RATE}%"
  fi
  echo "║"
  echo "║  HEALTH"
  echo "║    Agent crashes:      ${CRASHES}"
  echo "║    Pending decisions:  ${PENDING_DECISIONS}"
  echo "║"
  echo "╚══════════════════════════════════════════════════════════════╝"
fi
