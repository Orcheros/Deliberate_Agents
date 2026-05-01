# Integrations

External service connectors for Deliberate_Agents. Each integration lives in its own directory with its own dependencies and lifecycle.

## Available Integrations

### [Slack](slack/)

Bi-directional Slack integration for real-time question routing and progress reporting.

- **Bot API** (Socket Mode) — Posts decision questions with Block Kit formatting, listens for threaded replies, writes responses back to decision files to unblock agents
- **Webhooks** — Used for transitions, alerts, progress updates, and periodic reports

**Setup:**
1. Create a Slack app at [api.slack.com/apps](https://api.slack.com/apps)
2. Enable **Socket Mode** (Settings > Socket Mode > Enable)
3. Generate an **App-Level Token** with `connections:write` scope → this is your `SLACK_APP_TOKEN` (`xapp-...`)
4. Under **OAuth & Permissions**, add Bot Token Scopes: `chat:write`, `reactions:write`, `users:read`
5. Install the app to your workspace → copy the **Bot User OAuth Token** → this is your `SLACK_BOT_TOKEN` (`xoxb-...`)
6. Under **Event Subscriptions** > Subscribe to bot events: `message.channels`, `message.groups`, `app_mention`
7. Optionally create an **Incoming Webhook** for the channel (used as fallback for non-decision messages)
8. Add tokens to your project config or environment:

```yaml
notifications:
  slack_enabled: true
  slack_bot_token: "xoxb-..."      # or set SLACK_BOT_TOKEN env var
  slack_app_token: "xapp-..."      # or set SLACK_APP_TOKEN env var
  slack_webhook_url: "https://hooks.slack.com/services/..."  # optional fallback
  slack_channel: "#dev-agents"
```

**Running:**
- Automatically started by the orchestrator when `slack_enabled: true`
- Manual start: `integrations/slack/start.sh <config-file> [--foreground]`
- Creates its own Python venv on first run (`integrations/slack/.venv/`)

## Adding New Integrations

Create a directory under `integrations/` with:
- `start.sh` — Launcher script (called by orchestrator or manually)
- `requirements.txt` or equivalent dependency file
- `.gitignore` for runtime artifacts (venvs, caches)
- README or inline docs explaining setup and configuration
