# State Protocol — How Agents Communicate

Agents in Deliberate Agents don't talk to each other directly. Instead, they communicate through **files** — specifically, YAML and markdown files in a `.deliberate/` directory inside your project. The orchestrator watches these files and coordinates the handoffs.

Think of it like a shared whiteboard: one agent writes "I'm done with my part," the orchestrator reads it, and launches the next agent.

## The `.deliberate/` Directory

When you initialize a project with `init.sh`, this directory is created:

```
.deliberate/
├── config.yaml              Your project settings
├── priority-stack.yaml      Ranked pipeline (Integrator owns, Orchestrator reads)
│
├── intake/                  Raw idea capture from the founder
│   └── my-idea.md           Integrator evaluates against board state
│
├── queue/                   The initiative queue
│   └── my-feature.yaml      One file per initiative — tracks its progress
│
├── assignments/             Task assignments
│   └── worktree-01.yaml     One file per workspace — what's assigned there
│
├── status/                  Agent heartbeats
│   └── developer.yaml       Each agent reports what it's working on
│
├── decisions/               Things that need your input
│   └── 2026-04-30-my-feature.md    Agents pause and wait for your answer
│
├── reports/                 Integrator audit reports and board state snapshots
│   └── integrator-audit.md  Pipeline health, stalls, shipped-but-incomplete
│
└── logs/                    Session logs
    └── developer-2026-04-30.log    Full record of what each agent did
```

## How an Initiative Moves Through the Pipeline

Each initiative has a status that changes as it progresses:

```
QUEUED                     You added it to the queue
  ↓
PM_IN_PROGRESS             The Product Manager is writing the PRD
  ↓
PRD_COMPLETE               PRD is done, waiting for Project Manager
  ↓
PJM_IN_PROGRESS            The Project Manager is breaking it into tasks
  ↓
READY_FOR_DEV              Tasks are assigned, ready for developers
  ↓
DEV_IN_PROGRESS            Developers are working on the tasks
  ↓
DEV_COMPLETE               All tasks are finished
  ↓
REVIEW_IN_PROGRESS         The Reviewer is checking the work
  ↓
REVIEW_READY               Review is done — ready for you to look at
  ↓
COMPLETE                   You've approved and merged it
```

At any point, an initiative can move to **BLOCKED** if an agent encounters something it can't resolve on its own. It will create a decision file explaining what it needs from you.

## What's in Each File

### Initiative File (`queue/my-feature.yaml`)

Tracks one initiative from start to finish:

```yaml
initiative: "my-feature"
title: "Add user authentication"
status: "DEV_IN_PROGRESS"
created_at: "2026-04-30"

# Written by the Product Manager
prd_path: "path/to/prd.md"

# Written by the Project Manager
task_count: 5
tasks:
  - id: "task-01"
    worktree: "worktree-01"
    status: "complete"
  - id: "task-02"
    worktree: "worktree-02"
    status: "in_progress"
```

### Assignment File (`assignments/worktree-01.yaml`)

Tells a Developer agent exactly what to build:

```yaml
task:
  id: "task-01"
  title: "Add login form"
  description: "Create a login page with email and password fields..."
  acceptance_criteria:
    - "User can log in with valid email and password"
    - "Invalid credentials show an error message"
  relevant_files:
    - "app/controllers/sessions_controller.rb"
    - "app/views/sessions/new.html.erb"

status: "assigned"
worktree: "worktree-01"
initiative: "my-feature"
```

### Status File (`status/developer.yaml`)

An agent's heartbeat — what it's currently doing:

```yaml
status: "active"
role: "developer"
worktree: "worktree-01"
current_task: "task-01"
last_heartbeat: "2026-04-30T14:30:00Z"
progress: "Writing tests for login form"
```

The orchestrator checks these heartbeats. If one goes stale (the agent crashed or got stuck), it logs the issue and can alert you.

### Decision File (`decisions/2026-04-30-my-feature.md`)

When an agent needs your input, it creates one of these and pauses:

```markdown
# Decision Required: Authentication Strategy

**Initiative**: my-feature
**Agent**: Developer
**Priority**: high

## Context
I'm implementing the login system and need to decide on session management.

## Question
Should we use cookie-based sessions or JWT tokens?

## Options
1. **Cookie sessions** — Simpler, built into Rails, works well for web apps
2. **JWT tokens** — Better for API-first apps, more complex to implement

## Resolution
(You fill this in, and the agent continues)
```

## Real-Time Reporting

The orchestrator compiles a report on every poll cycle, written to `.deliberate/status/report.md`. This report aggregates:

- Initiative status across the entire queue
- Active agents and their current progress
- Pending decisions awaiting human input
- Blocked items with reasons
- Recent agent activity from today's logs

When Slack is enabled, a summary is posted every N poll cycles (configurable via `report_interval_cycles`). The report is always available locally even when Slack is disabled.

## Notification & Question Routing

When an agent creates a decision file, the orchestrator:

1. Detects the new file on the next poll cycle
2. Extracts the question, initiative, and agent context
3. Posts the question to Slack (if enabled) with full context
4. Marks the file as notified (`.notified` marker) to avoid duplicate posts
5. On subsequent polls, checks if the human has filled in the `## Resolution` section
6. When resolved, clears the marker so the agent can proceed

**Notification types:**
- `decision` — Agent needs human input. Always posted to Slack.
- `transition` — Initiative moved to a new pipeline stage.
- `alert` — Agent crash, blocker, or repeated errors.
- `report` — Periodic summary of all activity.
- `progress` — Individual agent progress updates (verbose mode).

### Slack Response Routing (Bi-Directional)

The Slack bot (`integrations/slack/bot.py`) runs in Socket Mode and completes the loop:

1. Agent creates a decision file in `.deliberate/decisions/`
2. Orchestrator calls `notify.sh --type decision` which posts via the Bot API with Block Kit formatting
3. The bot registers a thread-to-decision mapping in `.deliberate/status/slack_threads.json`
4. Human replies in the Slack thread (from phone, desktop, anywhere)
5. Bot receives the reply event, looks up the thread → decision file mapping
6. Bot writes the reply into the `## Resolution` section with timestamp and responder name
7. Bot removes the `.notified` marker and adds a :white_check_mark: reaction
8. Orchestrator detects the resolution on the next poll → agent unblocks

The human can also edit the decision file directly (via Cursor) — the orchestrator detects either path.

## The Rules

1. **One writer per file.** Each file has exactly one agent that writes to it. Other agents and the orchestrator can read it, but they don't modify it.
2. **Complete writes only.** When an agent updates a file, it writes the whole file at once. No partial updates that could leave a file in a broken state.
3. **Decisions block progress.** If there's an unresolved decision file, the affected agent waits. Agents don't guess — they ask.
4. **History is preserved.** Decision files are never deleted, only marked as resolved. You can always look back at what was decided and why.
5. **Crash recovery.** If an agent crashes, its status file shows the last known state. The orchestrator detects the stale heartbeat and can re-launch the agent from where it left off.
