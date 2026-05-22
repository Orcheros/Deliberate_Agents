# Getting Started

## Prerequisites

1. **tmux** — `brew install tmux`
2. **Claude Code CLI** — [Installation guide](https://docs.anthropic.com/en/docs/claude-code)
3. **git** — `brew install git`
4. A project with a git worktree setup
5. **Node.js** (optional) — `brew install node` (only needed for MCP servers)

Run the dependency checker:
```bash
./scripts/install-deps.sh
```

## Quick Start

### 1. Initialize for your project

```bash
./scripts/init.sh \
  --name "My Project" \
  --repo /path/to/my-project \
  --worktrees /path/to/my-project-worktrees \
  --main-branch main \
  --dev-branch staging \
  --test-cmd "bin/rails test"
```

This creates:
- `.deliberate/` in your worktrees directory with the state infrastructure
- `.claude/agents/` with agent definitions deployed to your project
- `.claude/skills/` with workflow skills deployed to your project

### 2. Open Claude Code — You're the Integrator

```bash
claude
```

The session-start hook automatically establishes you as the **Integrator** — your strategic right-hand agent. You'll see a briefing with project status, Orchestrator state, and any pending escalations.

This is your primary interface. Share ideas, ask for status, dispatch work — the Integrator captures everything to `.deliberate/`.

### 3. Launch the Orchestrator

The Orchestrator runs as an interactive Claude agent in its own tmux window. The Integrator's briefing shows the launch command:

```bash
./orchestration/launch-agent.sh \
  --session deliberate --name orchestrator \
  --role orchestrator \
  --config /path/to/my-project-worktrees/.deliberate/config.yaml \
  --framework-dir ~/Development/Deliberate_Agents
```

Now you have the **coordination window** with two panes — Integrator (top) and Orchestrator (bottom), both visible and interactive simultaneously. They communicate via `.deliberate/comms/_system/`.

> **Alternative**: For zero-AI-cost unattended operation, use the bash loop instead: `./orchestration/orchestrate.sh /path/to/config.yaml`. Both modes use the same state files — don't run both simultaneously.

### 4. Queue an initiative

Share your idea with the Integrator and it will validate, prioritize, and queue it. Or create a one-pager manually:

```bash
cat > /path/to/my-project-worktrees/.deliberate/queue/my-feature.yaml <<EOF
initiative: "my-feature"
title: "My New Feature"
one_pager_path: ".documentation/initiatives/my-feature/one-pager.md"
status: "QUEUED"
created_at: "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
EOF
```

### 5. Watch it work

Check status in three ways:

1. **Ask the Integrator** — "what's the status?" in your Claude Code session
2. **Read the dashboard** — `.deliberate/status/dashboard.md` (written by the Orchestrator)
3. **Run the script** — `./orchestration/status.sh /path/to/config.yaml`

Watch agents work in real time:
```bash
tmux attach -t deliberate
```

The Orchestrator escalates blockers and crashes directly to the Integrator — you'll see them surfaced in your next session briefing.

### 6. Review when ready

When the orchestrator reports an initiative as `REVIEW_READY`:
1. Open the review summary in `.deliberate/queue/{initiative}/review-summary.md`
2. Review the code changes in Cursor
3. Approve by changing the initiative status to `COMPLETE`

## Example: Deuterophos Setup

```bash
./scripts/init.sh \
  --name "Deuterophos" \
  --repo /Users/joeminock/Development/Deuterophos \
  --worktrees /Users/joeminock/Development/Deuterophos-worktrees \
  --main-branch main \
  --dev-branch staging \
  --initiatives ".documentation/initiatives" \
  --test-cmd "bin/rails test" \
  --system-test-cmd "bin/rails test:system"
```

## How Agents Are Launched

Each agent runs via Claude Code's native `--agent` flag:

```bash
claude --print --agent developer --permission-mode auto --max-turns 100 \
  --append-system-prompt "$RUNTIME_CONTEXT" \
  'Begin your assigned task.'
```

Agent definitions live in `.claude/agents/*.md` with YAML frontmatter specifying model, tools, permissions, and available skills. Workflow steps are lazy-loaded as skills — only consuming context when the agent invokes them.

## Checking on agents

Each agent runs in its own tmux window. You can:

- **List windows**: `tmux list-windows -t deliberate-deuterophos`
- **Attach to a window**: `tmux select-window -t deliberate-deuterophos:dev-worktree-1`
- **View logs**: `ls .deliberate/logs/`

## Stopping

Stop all agents but keep the orchestrator:
```bash
./orchestration/stop-agents.sh /path/to/.deliberate/config.yaml
```

Stop everything:
```bash
./orchestration/stop-agents.sh /path/to/.deliberate/config.yaml --all
```

## Handling decisions

When an agent encounters something it can't resolve autonomously, it creates a decision file in `.deliberate/decisions/`. The orchestrator logs a warning on each poll.

To resolve:
1. Read the decision file
2. Add your decision in the "Resolution" section
3. Remove the file (or move it to a resolved/ subdirectory)
4. The agent's initiative/task will need to be re-queued or unblocked manually

## Teardown

To remove Deliberate_Agents from a project:
```bash
./scripts/teardown.sh /path/to/.deliberate/config.yaml
```

This stops all agents, removes `.deliberate/`, deployed `.claude/agents/`, `.claude/skills/`, and `.mcp.json`.
