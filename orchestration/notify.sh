#!/usr/bin/env bash
#
# notify.sh — Send notifications to configured channels (Slack, log)
#
# Decision notifications are routed through the Python Slack bot (Bot API)
# for bi-directional threading. All other types use Incoming Webhooks.
#
# Usage:
#   notify.sh --config <config-file> --type <type> --message <message> [options]
#
# Types:
#   decision    — An agent needs human input (posted via Bot API for threading)
#   progress    — Agent progress update (webhook)
#   transition  — Initiative state change (webhook)
#   report      — Compiled orchestration report (webhook)
#   alert       — Agent crash, blocker, or error (webhook)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
  grep -E "^[[:space:]]*${key}:" "$CONFIG_FILE" | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

SLACK_WEBHOOK="$(parse_yaml 'slack_webhook_url')"
SLACK_BOT_TOKEN="$(parse_yaml 'slack_bot_token')"
SLACK_CHANNEL="$(parse_yaml 'slack_channel')"
SLACK_ENABLED="$(parse_yaml 'slack_enabled')"
PROJECT_NAME="$(parse_yaml 'name')"

SLACK_ENABLED="${SLACK_ENABLED:-false}"
SLACK_CHANNEL="${SLACK_CHANNEL:-#dev-agents}"

FRAMEWORK_DIR="$(dirname "$SCRIPT_DIR")"
INTEGRATIONS_DIR="${FRAMEWORK_DIR}/integrations"
SLACK_DIR="${INTEGRATIONS_DIR}/slack"
VENV_PYTHON="${SLACK_DIR}/.venv/bin/python3"

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

# --- Slack Posting (Webhook) --------------------------------------------------

post_via_webhook() {
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

# --- Slack Posting (Bot API — for decisions) ----------------------------------

post_decision_via_bot() {
  local decision_file="$1"

  [[ "$SLACK_ENABLED" == "true" ]] || return 0

  # Use the Python bot to post the decision with Block Kit formatting
  # and register the thread mapping for reply routing
  if [[ -x "$VENV_PYTHON" ]]; then
    export SLACK_BOT_TOKEN="${SLACK_BOT_TOKEN:-}"
    "$VENV_PYTHON" "${SLACK_DIR}/bot.py" "$CONFIG_FILE" \
      --post-decision "$decision_file" 2>/dev/null || {
      echo "WARN: Bot API post failed, falling back to webhook"
      local formatted
      formatted="$(format_decision)"
      post_via_webhook "$formatted"
    }
  else
    # Venv not set up yet — fall back to webhook
    local formatted
    formatted="$(format_decision)"
    post_via_webhook "$formatted"
  fi
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
    body+="\n_Reply in this thread to answer._"
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
      if [[ -n "$DECISION_FILE" && -f "$DECISION_FILE" ]]; then
        post_decision_via_bot "$DECISION_FILE"
      else
        formatted="$(format_decision)"
        post_via_webhook "$formatted"
      fi
      ;;
    progress)
      formatted="$(format_progress)"
      post_via_webhook "$formatted" "$THREAD_TS"
      ;;
    transition)
      formatted="$(format_transition)"
      post_via_webhook "$formatted"
      ;;
    report)
      formatted="$(format_report)"
      post_via_webhook "$formatted"
      ;;
    alert)
      formatted="$(format_alert)"
      post_via_webhook "$formatted"
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
