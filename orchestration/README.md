# Orchestration — The Coordination Layer

This directory contains the bash scripts that coordinate the entire system. The orchestrator is the "manager" that watches for work, launches agents, and keeps things moving — without using any AI itself.

## Why Bash?

The orchestrator is intentionally simple. It's a bash script, not an AI agent, because:

- **Zero cost.** It doesn't call any AI APIs. Only actual agent work costs money.
- **Predictable.** It follows rules mechanically — no creativity, no surprises.
- **Observable.** You can read the script and know exactly what it will do.

## The Two Layers

The coordination system has two layers:

- **Integrator** (AI agent) — Decides *what* to work on and *in what order*. Validates new ideas against everything in flight, maintains the priority stack, and tracks initiatives to completion (shipped + marketed + supported). Runs as a persistent agent in its own tmux window.
- **Orchestrator** (bash script) — Decides *how* to execute. Reads the Integrator's priority stack, polls state files, and launches the right agent at the right time. Zero AI cost.

## The Scripts

### `orchestrate.sh` — The Main Loop

This is the heart of the execution layer. When you run it, it starts a loop that:

1. Reads the Integrator's priority stack (`.deliberate/priority-stack.yaml`)
2. Checks the initiative queue for new work
3. Detects when one stage finishes (e.g., "the PRD is done")
4. Launches the next agent in the pipeline (e.g., "start the Project Manager")
5. Monitors agent health (detects crashes)
6. Checks for pending human decisions
7. Repeats every 30 seconds

**Usage:**

```bash
./orchestration/orchestrate.sh /path/to/your-project-worktrees/.deliberate/config.yaml
```

This runs in the foreground. Use a separate terminal for other work, or run it in a tmux session.

**What it watches for:**

```
Priority stack updated?       → Re-order the work queue
New initiative queued?        → Launch the Product Manager
PRD finished?                 → Launch the Project Manager
Tasks created?                → Launch Developer agents
All tasks complete?           → Launch the Reviewer
Review finished?              → Notify you it's ready
Agent crashed?                → Log the issue, alert you
Human decision needed?        → Warn you there's a blocker
```

### `launch-agent.sh` — Start a Single Agent

Used by the orchestrator (and sometimes by you) to launch one specific agent in a tmux window.

**Usage:**

```bash
./orchestration/launch-agent.sh \
  --role developer \
  --config /path/to/config.yaml \
  --initiative my-feature \
  --worktree my-feature-worktree
```

You generally don't need to call this directly — the orchestrator handles it. But it's useful for debugging or manually restarting a specific agent.

### `status.sh` — Check What's Happening

Shows you the current state of everything: which agents are running, how far along each initiative is, and whether anything needs your attention.

**Usage:**

```bash
./orchestration/status.sh /path/to/your-project-worktrees/.deliberate/config.yaml
```

**Example output:**

```
Orchestrator: RUNNING (last poll: 15s ago)
Session: deliberate-my-project (3 windows)

Initiatives:
  user-auth    DEV_IN_PROGRESS    3/5 tasks complete
  dashboard    PRD_COMPLETE       Waiting for PjM

Active Agents:
  developer    worktree-01    Task: Add login form

Decisions: None pending
```

### `stop-agents.sh` — Shut Everything Down

Stops all running agents by closing their tmux windows.

**Usage:**

```bash
./orchestration/stop-agents.sh /path/to/your-project-worktrees/.deliberate/config.yaml
```

## How tmux Fits In

[tmux](https://github.com/tmux/tmux) is a terminal multiplexer — it lets you run multiple terminal sessions in the background. The orchestrator uses tmux to:

- Give each agent its own window (so they don't interfere with each other)
- Keep agents running even if you close your terminal
- Let you peek into any agent's session to see what it's doing

You don't need to know tmux to use Deliberate Agents. The scripts handle it. But if you're curious, `tmux attach -t deliberate-your-project` will let you watch agents work in real time.
