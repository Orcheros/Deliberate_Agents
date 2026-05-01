#!/usr/bin/env bash
#
# start.sh — Launch the Slack bot in a tmux window
#
# The bot runs in Socket Mode (outbound WebSocket) and listens for
# threaded replies to decision notifications. When a human replies,
# the bot writes the response into the decision file and unblocks
# the waiting agent.
#
# Usage: start-slack-bot.sh <config-file> [--foreground]
#
# Normally launched by orchestrate.sh in a tmux window. Use --foreground
# for debugging.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${1:?Usage: integrations/slack/start.sh <config-file> [--foreground]}"
FOREGROUND="${2:-}"

# --- Configuration ------------------------------------------------------------

parse_yaml() {
  local key="$1"
  grep -E "^\s*${key}:" "$CONFIG_FILE" | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'"
}

SLACK_ENABLED="$(parse_yaml 'slack_enabled')"
if [[ "${SLACK_ENABLED:-false}" != "true" ]]; then
  echo "Slack is not enabled in config. Set notifications.slack_enabled: true"
  exit 0
fi

WORKTREES_DIR="$(parse_yaml 'worktrees')"
DELIBERATE_DIR="${WORKTREES_DIR}/.deliberate"
LOG_DIR="${DELIBERATE_DIR}/logs"
TMUX_SESSION="$(parse_yaml 'tmux_session')"
TMUX_SESSION="${TMUX_SESSION:-deliberate}"

VENV_DIR="${SCRIPT_DIR}/.venv"

# --- Virtual Environment ------------------------------------------------------

ensure_venv() {
  if [[ ! -d "$VENV_DIR" ]]; then
    echo "Creating Python virtual environment..."
    python3 -m venv "$VENV_DIR"
    "${VENV_DIR}/bin/pip" install --quiet --upgrade pip
    "${VENV_DIR}/bin/pip" install --quiet -r "${SCRIPT_DIR}/requirements.txt"
    echo "Dependencies installed."
  fi
}

# --- Load Tokens --------------------------------------------------------------

# Tokens can come from environment or config file
export SLACK_BOT_TOKEN="${SLACK_BOT_TOKEN:-$(parse_yaml 'slack_bot_token')}"
export SLACK_APP_TOKEN="${SLACK_APP_TOKEN:-$(parse_yaml 'slack_app_token')}"

if [[ -z "$SLACK_BOT_TOKEN" ]]; then
  echo "ERROR: SLACK_BOT_TOKEN not set (check env or config notifications.slack_bot_token)"
  exit 1
fi

if [[ -z "$SLACK_APP_TOKEN" ]]; then
  echo "ERROR: SLACK_APP_TOKEN not set (check env or config notifications.slack_app_token)"
  exit 1
fi

# --- Launch -------------------------------------------------------------------

ensure_venv

mkdir -p "$LOG_DIR"
BOT_LOG="${LOG_DIR}/slack-bot-$(date +%Y%m%d).log"

if [[ "$FOREGROUND" == "--foreground" ]]; then
  echo "Starting Slack bot in foreground..."
  exec "${VENV_DIR}/bin/python3" "${SCRIPT_DIR}/bot.py" "$CONFIG_FILE"
else
  WINDOW_NAME="slack-bot"

  # Check if already running
  if tmux list-windows -t "$TMUX_SESSION" 2>/dev/null | grep -q "$WINDOW_NAME"; then
    echo "Slack bot is already running in tmux window: $TMUX_SESSION:$WINDOW_NAME"
    exit 0
  fi

  tmux new-window -t "$TMUX_SESSION" -n "$WINDOW_NAME" \
    "cd '${SCRIPT_DIR}' && \
     export SLACK_BOT_TOKEN='${SLACK_BOT_TOKEN}' && \
     export SLACK_APP_TOKEN='${SLACK_APP_TOKEN}' && \
     '${VENV_DIR}/bin/python3' '${SCRIPT_DIR}/bot.py' '${CONFIG_FILE}' \
     2>&1 | tee -a '${BOT_LOG}'; \
     echo 'Slack bot exited. Press enter to close.'; read"

  echo "Slack bot launched in tmux window: $TMUX_SESSION:$WINDOW_NAME"
fi
