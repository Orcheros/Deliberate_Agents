# Orchestration — The Coordination Layer

This directory contains the scripts that coordinate the entire system: launching agents, managing the pipeline, tracking handoffs, and enabling communication between the Integrator and Orchestrator.

## Window & Pane Layout

The coordination system uses tmux panes (visible splits) within windows:

- **Coordination window** — Two panes, both visible and interactive:
  - **Integrator** (top pane) — Your primary Claude Code session. Decides *what* to work on and *in what order*. Established automatically on session start.
  - **Orchestrator** (bottom pane) — Decides *how* to execute. Launches agents, records handoffs, writes the dashboard, escalates blockers. Falls back to `orchestrate.sh` for unattended zero-cost operation.
- **Initiative windows** — One window per active initiative. Each agent working on that initiative appears as a pane within it — PM, Developer, Reviewer all visible at once.
- **Ops window** — Agents without a specific initiative (system-wide work).

The Integrator and Orchestrator communicate via `.deliberate/comms/_system/`. Initiative agents communicate via `.deliberate/comms/{slug}/`.

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

Used by the Orchestrator (and sometimes by you) to launch one specific agent as a pane. Agents on the same initiative share a window; the Integrator and Orchestrator share the "coordination" window. Builds role-specific context, injects per-initiative and system-level communication channels, and starts the agent with appropriate permissions.

**Usage:**

```bash
./orchestration/launch-agent.sh \
  --session deliberate --name dev-auth \
  --role developer --initiative auth \
  --config /path/to/config.yaml \
  --framework-dir ~/Development/Deliberate_Agents
```

The Orchestrator calls this automatically. You can also use it to manually launch or restart agents.

### `comms.sh` — Cross-Agent Communication Library

Sourced by `orchestrate.sh` and `launch-agent.sh`. Provides functions for structured messaging at two levels:

**Per-initiative**: `record_handoff()`, `record_decision()`, `send_agent_message()`, `write_handoff_receipt()`, `build_comms_context()`

**System-level**: `send_system_message()`, `read_system_messages()`, `ack_system_message()`, `count_unread_messages()`, `build_system_comms_context()`

Not called directly — used by the orchestration scripts.

### `dashboard.sh` — Status Dashboard Generator

Reads `.deliberate/` state files and writes a structured dashboard to `.deliberate/status/dashboard.md`. Shows active agents, pipeline summary, blockers, recent transitions, and system message counts.

**Usage:**

```bash
./orchestration/dashboard.sh /path/to/config.yaml
```

Called automatically by the Orchestrator after each cycle.

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

Stops all running agents by closing their tmux panes.

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
