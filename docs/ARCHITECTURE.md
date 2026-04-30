# Architecture

## System Overview

Deliberate_Agents is a multi-agent coordination framework that runs multiple Claude Code sessions as autonomous agents, coordinated through filesystem-based state management.

```
┌─────────────────────────────────────────────────────────────┐
│                        Human                                 │
│              (Reviews in Cursor, makes decisions)            │
└──────────────────────────┬───────────────────────────────────┘
                           │ decisions/, review
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                   Orchestrator (bash)                         │
│         Polls state, launches agents, routes work            │
│                  Runs in tmux window                         │
└──────┬──────────────┬──────────────┬────────────────────────┘
       │              │              │
       ▼              ▼              ▼
┌────────────┐ ┌────────────┐ ┌────────────────┐
│     PM     │ │    PjM     │ │  Developer(s)  │
│   Agent    │ │   Agent    │ │    Agents      │
│            │ │            │ │                │
│ Claude Code│ │ Claude Code│ │ Claude Code    │
│  headless  │ │  headless  │ │  headless      │
└──────┬─────┘ └──────┬─────┘ └───────┬────────┘
       │              │               │
       └──────────────┴───────────────┘
                      │
                      ▼
              ┌───────────────┐
              │  .deliberate/ │
              │  (state dir)  │
              └───────────────┘
```

## Component Roles

### Orchestrator (Shell Script)

The orchestrator is intentionally NOT an AI agent. It is a deterministic bash script that:

1. **Polls** `.deliberate/queue/` and `.deliberate/assignments/` every N seconds
2. **Detects** state transitions (new initiatives, completed tasks, blocked work)
3. **Launches** the appropriate AI agent as a new tmux window with Claude Code in headless mode
4. **Monitors** agent health via tmux window existence and heartbeat staleness
5. **Routes** completed work to the next pipeline stage

This design keeps the coordination layer cheap (zero API cost), deterministic (no LLM variance), and observable (pure state machine).

### AI Agents

Each AI agent runs as an independent Claude Code session:

- **Product Manager**: Transforms one-pagers into PRDs. Reads the codebase for context, writes structured documentation. Never touches code.
- **Project Manager**: Breaks PRDs into developer tasks. Creates worktree assignments. Validates completed work against acceptance criteria.
- **Developer(s)**: Executes tasks in isolated worktrees. Writes code, runs tests, produces commits. Multiple can run concurrently.

### State Directory

The `.deliberate/` directory is the single source of truth for all inter-agent coordination:

- `queue/` — Initiative lifecycle (QUEUED → ... → COMPLETE)
- `assignments/` — Developer task assignments (assigned → in_progress → complete)
- `status/` — Agent heartbeats and activity reports
- `decisions/` — Items requiring human input
- `logs/` — Session output logs

See `state/README.md` for the full protocol specification.

## Execution Model

### Agent Isolation

Each agent runs in its own:
- **tmux window** (separate terminal)
- **Claude Code session** (separate context/conversation)
- **Working directory** (repo root for PM/PjM, worktree for developers)

Agents never share Claude Code context. All communication is through the state files.

### Workflow Step Files

Inspired by BMAD-METHOD, each agent follows a step-file workflow that provides structured instructions. The agent profile is injected as the system prompt, and all step files are included as reference material.

This provides:
- **Consistency** — agents follow the same process every time
- **Transparency** — you can read the steps to understand what the agent will do
- **Customizability** — modify step files to change agent behavior

### Worktree-Based Development

Developer agents work in git worktrees, providing:
- **Isolation** — each task gets its own checkout, no conflicts
- **Parallelism** — multiple developers can work simultaneously
- **Clean history** — each worktree produces its own commits on its own branch

## Technology Choices

| Component | Technology | Rationale |
|-----------|-----------|-----------|
| Agent runtime | Claude Code (headless) | Best autonomous coding agent available |
| Process management | tmux | Lightweight, scriptable, observable |
| State management | Filesystem (YAML/MD) | No database needed, git-friendly, human-readable |
| Orchestration | Bash script | Deterministic, zero API cost, easy to debug |
| Human review | Cursor | Visual diffs, inline comments, familiar IDE |
| Design | Claude Design | AI-assisted UI/UX design |

## Security Considerations

- Agent sessions run with the same permissions as the user
- Agents can read/write files within their working directory
- Developer agents are constrained to their worktree by convention (enforced in profile)
- No network access beyond what Claude Code provides
- Secrets should be managed through the project's existing mechanisms (not in `.deliberate/`)
