"""
slack_bot.py — Bi-directional Slack bot for Deliberate_Agents

Runs in Socket Mode (outbound WebSocket — no public URL needed).
Posts decision questions as threaded messages, listens for replies,
and writes responses back to decision files to unblock agents.

Usage:
    python3 orchestration/slack_bot.py <config-file>

Requires:
    pip install slack-bolt pyyaml

Environment (or config):
    SLACK_BOT_TOKEN    — Bot User OAuth Token (xoxb-...)
    SLACK_APP_TOKEN    — App-Level Token (xapp-...) for Socket Mode
"""

from __future__ import annotations

import json
import os
import re
import sys
import time
import logging
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, Optional

import yaml
from slack_bolt import App
from slack_bolt.adapter.socket_mode import SocketModeHandler

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
log = logging.getLogger("deliberate-slack")

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

def load_config(config_path: str) -> dict:
    with open(config_path) as f:
        return yaml.safe_load(f)


def resolve_paths(config: dict) -> dict:
    worktrees = config["project"]["worktrees"]
    deliberate = os.path.join(worktrees, ".deliberate")
    return {
        "decisions_dir": os.path.join(deliberate, "decisions"),
        "thread_map_file": os.path.join(deliberate, "status", "slack_threads.json"),
        "status_dir": os.path.join(deliberate, "status"),
    }


# ---------------------------------------------------------------------------
# Thread ↔ Decision Mapping
# ---------------------------------------------------------------------------

class ThreadMap:
    """Maps Slack message timestamps to decision file paths."""

    def __init__(self, map_file: str):
        self.map_file = map_file
        self._data: dict[str, dict] = {}
        self._load()

    def _load(self):
        if os.path.exists(self.map_file):
            with open(self.map_file) as f:
                self._data = json.load(f)

    def _save(self):
        os.makedirs(os.path.dirname(self.map_file), exist_ok=True)
        with open(self.map_file, "w") as f:
            json.dump(self._data, f, indent=2)

    def register(self, channel: str, thread_ts: str, decision_file: str, initiative: str = "", agent: str = ""):
        key = f"{channel}:{thread_ts}"
        self._data[key] = {
            "decision_file": decision_file,
            "initiative": initiative,
            "agent": agent,
            "posted_at": datetime.now(timezone.utc).isoformat(),
            "resolved": False,
        }
        self._save()

    def lookup(self, channel: str, thread_ts: str) -> dict | None:
        key = f"{channel}:{thread_ts}"
        return self._data.get(key)

    def mark_resolved(self, channel: str, thread_ts: str):
        key = f"{channel}:{thread_ts}"
        if key in self._data:
            self._data[key]["resolved"] = True
            self._data[key]["resolved_at"] = datetime.now(timezone.utc).isoformat()
            self._save()


# ---------------------------------------------------------------------------
# Decision File Operations
# ---------------------------------------------------------------------------

def write_resolution(decision_file: str, response_text: str, responder: str = "human") -> bool:
    """Write a response into the ## Resolution section of a decision file."""
    if not os.path.exists(decision_file):
        log.error(f"Decision file not found: {decision_file}")
        return False

    with open(decision_file) as f:
        content = f.read()

    timestamp = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")

    if "## Resolution" in content:
        # Replace empty resolution section with the response
        content = re.sub(
            r"(## Resolution\n)(\(.*?\)\n?)?",
            f"\\1\n**Resolved by {responder}** — {timestamp}\n\n{response_text}\n",
            content,
        )
    else:
        # Append resolution section
        content += f"\n## Resolution\n\n**Resolved by {responder}** — {timestamp}\n\n{response_text}\n"

    with open(decision_file, "w") as f:
        f.write(content)

    # Remove the .notified marker so orchestrator sees the resolution
    notified_marker = decision_file + ".notified"
    if os.path.exists(notified_marker):
        os.remove(notified_marker)

    log.info(f"Resolution written to {decision_file}")
    return True


def read_decision_context(decision_file: str) -> dict:
    """Extract question and options from a decision file."""
    if not os.path.exists(decision_file):
        return {}

    with open(decision_file) as f:
        content = f.read()

    context = {}

    # Extract title
    title_match = re.search(r"^# (.+)$", content, re.MULTILINE)
    if title_match:
        context["title"] = title_match.group(1)

    # Extract question
    question_match = re.search(r"## Question\n(.+?)(?=\n## |\Z)", content, re.DOTALL)
    if question_match:
        context["question"] = question_match.group(1).strip()

    # Extract options
    options_match = re.search(r"## Options\n(.+?)(?=\n## |\Z)", content, re.DOTALL)
    if options_match:
        context["options"] = options_match.group(1).strip()

    # Extract initiative
    init_match = re.search(r"\*\*Initiative\*\*:\s*(.+)", content)
    if init_match:
        context["initiative"] = init_match.group(1).strip()

    # Extract agent
    agent_match = re.search(r"\*\*Agent\*\*:\s*(.+)", content)
    if agent_match:
        context["agent"] = agent_match.group(1).strip()

    return context


# ---------------------------------------------------------------------------
# Slack Message Formatting
# ---------------------------------------------------------------------------

def format_decision_message(decision_file: str, project_name: str) -> list[dict]:
    """Build Slack Block Kit message for a decision."""
    ctx = read_decision_context(decision_file)
    blocks = []

    # Header
    title = ctx.get("title", "Decision Required")
    blocks.append({
        "type": "header",
        "text": {"type": "plain_text", "text": f":question: {title}"}
    })

    # Context bar
    initiative = ctx.get("initiative", "unknown")
    agent = ctx.get("agent", "unknown")
    blocks.append({
        "type": "context",
        "elements": [
            {"type": "mrkdwn", "text": f"*Project:* {project_name}  |  *Initiative:* {initiative}  |  *Agent:* {agent}"}
        ]
    })

    blocks.append({"type": "divider"})

    # Question
    question = ctx.get("question", "See the decision file for details.")
    blocks.append({
        "type": "section",
        "text": {"type": "mrkdwn", "text": question[:3000]}
    })

    # Options (if present)
    options = ctx.get("options", "")
    if options:
        blocks.append({
            "type": "section",
            "text": {"type": "mrkdwn", "text": options[:3000]}
        })

    blocks.append({"type": "divider"})

    # Instructions
    blocks.append({
        "type": "context",
        "elements": [
            {"type": "mrkdwn", "text": ":thread: *Reply in this thread to answer.* Your response will be written back to the decision file and unblock the agent."}
        ]
    })

    return blocks


# ---------------------------------------------------------------------------
# Bot Setup
# ---------------------------------------------------------------------------

def create_bot(config: dict, paths: dict) -> tuple[App, ThreadMap]:
    bot_token = os.environ.get("SLACK_BOT_TOKEN") or config.get("notifications", {}).get("slack_bot_token", "")
    if not bot_token:
        log.error("SLACK_BOT_TOKEN not set")
        sys.exit(1)

    app = App(token=bot_token)
    thread_map = ThreadMap(paths["thread_map_file"])

    channel = config.get("notifications", {}).get("slack_channel", "#dev-agents")
    # Strip # prefix if present
    channel = channel.lstrip("#")

    bot_user_id = None

    @app.event("app_mention")
    def handle_mention(event, say):
        say(
            text="I'm the Deliberate Agents orchestrator. I post questions here when agents need your input — just reply in the thread to unblock them.",
            thread_ts=event.get("ts"),
        )

    @app.event("message")
    def handle_message(event, client):
        nonlocal bot_user_id

        # Only care about threaded replies
        thread_ts = event.get("thread_ts")
        if not thread_ts:
            return

        # Ignore bot's own messages
        if bot_user_id is None:
            try:
                auth = client.auth_test()
                bot_user_id = auth["user_id"]
            except Exception:
                bot_user_id = ""

        if event.get("user") == bot_user_id:
            return

        # Ignore subtypes (joins, leaves, etc.)
        if event.get("subtype"):
            return

        channel_id = event.get("channel", "")
        mapping = thread_map.lookup(channel_id, thread_ts)
        if not mapping:
            return

        if mapping.get("resolved"):
            return

        response_text = event.get("text", "").strip()
        if not response_text:
            return

        # Get responder name
        responder = "human"
        try:
            user_info = client.users_info(user=event["user"])
            responder = user_info["user"]["real_name"] or user_info["user"]["name"]
        except Exception:
            pass

        decision_file = mapping["decision_file"]
        initiative = mapping.get("initiative", "")

        success = write_resolution(decision_file, response_text, responder)

        if success:
            thread_map.mark_resolved(channel_id, thread_ts)
            client.reactions_add(
                channel=channel_id,
                timestamp=event["ts"],
                name="white_check_mark",
            )
            client.chat_postMessage(
                channel=channel_id,
                thread_ts=thread_ts,
                text=f":white_check_mark: Got it — resolution written to `{os.path.basename(decision_file)}`. The agent will pick this up on the next orchestrator poll.",
            )
            log.info(f"Decision resolved via Slack: {decision_file} by {responder}")
        else:
            client.chat_postMessage(
                channel=channel_id,
                thread_ts=thread_ts,
                text=f":warning: Couldn't write to `{os.path.basename(decision_file)}` — the file may have been moved or deleted. Check `.deliberate/decisions/`.",
            )

    return app, thread_map


# ---------------------------------------------------------------------------
# Public API (called by notify.sh or orchestrate.sh)
# ---------------------------------------------------------------------------

def post_decision(config: dict, paths: dict, decision_file: str):
    """Post a decision to Slack and register the thread mapping."""
    bot_token = os.environ.get("SLACK_BOT_TOKEN") or config.get("notifications", {}).get("slack_bot_token", "")
    channel = config.get("notifications", {}).get("slack_channel", "#dev-agents").lstrip("#")
    project_name = config.get("project", {}).get("name", "Project")

    from slack_sdk import WebClient
    client = WebClient(token=bot_token)

    blocks = format_decision_message(decision_file, project_name)
    ctx = read_decision_context(decision_file)
    fallback_text = f"Decision required: {ctx.get('title', 'See thread')}"

    response = client.chat_postMessage(
        channel=channel,
        text=fallback_text,
        blocks=blocks,
    )

    if response["ok"]:
        thread_ts = response["ts"]
        channel_id = response["channel"]
        thread_map = ThreadMap(paths["thread_map_file"])
        thread_map.register(
            channel=channel_id,
            thread_ts=thread_ts,
            decision_file=decision_file,
            initiative=ctx.get("initiative", ""),
            agent=ctx.get("agent", ""),
        )
        log.info(f"Decision posted to Slack: {decision_file} → {channel_id}:{thread_ts}")

        # Mark as notified
        notified_marker = decision_file + ".notified"
        Path(notified_marker).touch()

        return thread_ts

    return None


# ---------------------------------------------------------------------------
# Entry Point
# ---------------------------------------------------------------------------

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 slack_bot.py <config-file> [--post-decision <decision-file>]")
        sys.exit(1)

    config_file = sys.argv[1]
    config = load_config(config_file)
    paths = resolve_paths(config)

    os.makedirs(paths["decisions_dir"], exist_ok=True)
    os.makedirs(paths["status_dir"], exist_ok=True)

    # CLI mode: post a single decision and exit
    if len(sys.argv) >= 4 and sys.argv[2] == "--post-decision":
        decision_file = sys.argv[3]
        ts = post_decision(config, paths, decision_file)
        if ts:
            print(ts)
        sys.exit(0 if ts else 1)

    # Daemon mode: run the Socket Mode listener
    app_token = os.environ.get("SLACK_APP_TOKEN") or config.get("notifications", {}).get("slack_app_token", "")
    if not app_token:
        log.error("SLACK_APP_TOKEN not set (required for Socket Mode)")
        sys.exit(1)

    app, thread_map = create_bot(config, paths)

    log.info("Starting Slack bot in Socket Mode...")
    log.info(f"Listening for threaded replies in #{config.get('notifications', {}).get('slack_channel', 'dev-agents')}")

    # Write bot status
    status_file = os.path.join(paths["status_dir"], "slack_bot.yaml")
    with open(status_file, "w") as f:
        yaml.dump({
            "status": "running",
            "started_at": datetime.now(timezone.utc).isoformat(),
            "channel": config.get("notifications", {}).get("slack_channel", "#dev-agents"),
        }, f)

    handler = SocketModeHandler(app, app_token)
    try:
        handler.start()
    except KeyboardInterrupt:
        log.info("Slack bot shutting down")
    finally:
        with open(status_file, "w") as f:
            yaml.dump({"status": "stopped", "stopped_at": datetime.now(timezone.utc).isoformat()}, f)


if __name__ == "__main__":
    main()
