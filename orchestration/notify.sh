#!/usr/bin/env bash
#
# notify.sh — Send notifications to configured channels (Slack, log)
#
# Supports Slack webhook integration for real-time question routing
# and progress reporting. Falls back to log-only if Slack is not configured.
#
# Usage:
#   notify.sh --config <config-file> --type <type> --message <message> [options]
#
# Types:
#   decision    — An agent needs human input (routes question to Slack)
#   progress    — Agent progress update (compiled into report)
#   transition  — Initiative state change (logged, optionally posted)
#   report      — Compiled orchestration report (posted to Slack)
#   alert       — Agent crash, blocker, or error (always posted)

set -euo pipefail

# --- Argument Parsing ---------------------------------------------------------

CONFIG_FILE=""
NOTIFY_TYPE=""
MESSAGE=""
INITIATIVE=""
AGENT_ROLE=""
DECISION_FILE=""
THREAD_TS=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --config)         CONFIG_FILE="$2"; shift 2 ;;
    --type)           NOTIFY_TYPE="$2"; shift 2 ;;
    --message)        MESSAGE="$2"; shift 2 ;;
    --initiative)     INITIATIVE="$2"; shift 2 ;;
    --agent)          AGENT_ROLE="$2"; shift 2 ;;
    --decision-file)  DECISION_FILE="$2"; shift 2 ;;
    --thread-ts)      THREAD_TS="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

[[ -n "$CONFIG_FILE" ]]  || { echo "ERROR: --config required"; exit 1; }
[[ -n "$NOTIFY_TYPE" ]]  || { echo "ERROR: --type required"; exit 1; }
[[ -n "$MESSAGE" ]]      || { echo "ERROR: --message required"; exit 1; }

# --- Configuration ------------------------------------------------------------

parse_yaml() {
  local key="$1"
  grep -E "^\s*${key}:" "$CONFIG_FILE" | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'"
}

SLACK_WEBHOOK="$(parse_yaml 'slack_webhook_url')"
SLACK_CHANNEL="$(parse_yaml 'slack_channel')"
SLACK_ENABLED="$(parse_yaml 'slack_enabled')"
PROJECT_NAME="$(parse_yaml 'name')"

SLACK_ENABLED="${SLACK_ENABLED:-false}"
SLACK_CHANNEL="${SLACK_CHANNEL:-#dev-agents}"

# --- Emoji Map ----------------------------------------------------------------

emoji_for_type() {
  case "$1" in
    decision)    echo ":question:" ;;
    progress)    echo ":gear:" ;;
    transition)  echo ":arrow_right:" ;;
    report)      echo ":clipboard:" ;;
    alert)       echo ":rotating_light:" ;;
    *)           echo ":robot_face:" ;;
  esac
}

# --- Slack Posting ------------------------------------------------------------

post_to_slack() {
  local text="$1"
  local thread="${2:-}"

  [[ "$SLACK_ENABLED" == "true" ]] || return 0
  [[ -n "$SLACK_WEBHOOK" ]] || return 0

  local payload
  if [[ -n "$thread" ]]; then
    payload=$(cat <<EOF
{
  "channel": "${SLACK_CHANNEL}",
  "text": "${text}",
  "thread_ts": "${thread}",
  "unfurl_links": false
}
EOF
)
  else
    payload=$(cat <<EOF
{
  "channel": "${SLACK_CHANNEL}",
  "text": "${text}",
  "unfurl_links": false
}
EOF
)
  fi

  curl -s -X POST "$SLACK_WEBHOOK" \
    -H "Content-Type: application/json" \
    -d "$payload" \
    --max-time 5 \
    > /dev/null 2>&1 || true
}

# --- Format Messages ---------------------------------------------------------

format_decision() {
  local emoji
  emoji="$(emoji_for_type decision)"
  local header="${emoji} *Decision Required* — ${PROJECT_NAME}"

  local body="${header}\n"
  body+="*Initiative:* ${INITIATIVE:-unknown}\n"
  body+="*Agent:* ${AGENT_ROLE:-unknown}\n"
  body+="\n${MESSAGE}\n"

  if [[ -n "$DECISION_FILE" && -f "$DECISION_FILE" ]]; then
    local question
    question="$(grep -A5 "^## Question" "$DECISION_FILE" 2>/dev/null | tail -n +2 | head -5)"
    if [[ -n "$question" ]]; then
      body+="\n> ${question}\n"
    fi
    body+="\n_Reply in this thread to answer. The orchestrator will route your response back to the agent._"
  fi

  echo -e "$body"
}

format_progress() {
  local emoji
  emoji="$(emoji_for_type progress)"
  echo "${emoji} [${AGENT_ROLE:-agent}] ${MESSAGE}"
}

format_transition() {
  local emoji
  emoji="$(emoji_for_type transition)"
  echo "${emoji} *${INITIATIVE:-}* → ${MESSAGE}"
}

format_report() {
  local emoji
  emoji="$(emoji_for_type report)"
  echo -e "${emoji} *Orchestration Report* — ${PROJECT_NAME}\n\n${MESSAGE}"
}

format_alert() {
  local emoji
  emoji="$(emoji_for_type alert)"
  echo "${emoji} *Alert* — ${PROJECT_NAME}: ${MESSAGE}"
}

# --- Main ---------------------------------------------------------------------

main() {
  local formatted

  case "$NOTIFY_TYPE" in
    decision)
      formatted="$(format_decision)"
      post_to_slack "$formatted" "$THREAD_TS"
      ;;
    progress)
      formatted="$(format_progress)"
      # Progress updates go to thread if one exists, otherwise standalone
      post_to_slack "$formatted" "$THREAD_TS"
      ;;
    transition)
      formatted="$(format_transition)"
      post_to_slack "$formatted"
      ;;
    report)
      formatted="$(format_report)"
      post_to_slack "$formatted"
      ;;
    alert)
      formatted="$(format_alert)"
      post_to_slack "$formatted"
      ;;
    *)
      echo "Unknown notification type: $NOTIFY_TYPE"
      exit 1
      ;;
  esac

  # Always log to stdout (captured by orchestrator log)
  echo "[NOTIFY:${NOTIFY_TYPE}] ${MESSAGE}"
}

main
