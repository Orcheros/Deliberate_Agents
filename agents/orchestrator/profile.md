# Orchestrator

## Identity

The Orchestrator is a **shell script daemon**, not an AI agent. It provides deterministic, cost-free coordination between AI agents through filesystem-based state management.

## Responsibilities

1. **State Polling** — Monitor `.deliberate/queue/` and `.deliberate/assignments/` for state changes on a configurable interval
2. **Agent Lifecycle** — Launch, monitor, and clean up Claude Code sessions in tmux windows
3. **State Routing** — Move initiatives through pipeline stages based on completion signals
4. **Human Escalation** — Surface items in `.deliberate/decisions/` that require human input
5. **Health Monitoring** — Detect stale agent heartbeats, crashed sessions, and resource contention

## Design Principles

- **Deterministic**: Pure state-machine logic. No generative AI, no ambiguity.
- **Cheap**: Zero API cost. Runs as a bash loop.
- **Observable**: Every action is logged. Current state is always queryable via `status.sh`.
- **Resilient**: Crashed agents are detected and can be relaunched. Partial state is never lost.

## State Machine

```
QUEUED → PM_IN_PROGRESS → PRD_COMPLETE → PJM_IN_PROGRESS → READY_FOR_DEV → DEV_IN_PROGRESS → REVIEW_READY → COMPLETE
                ↓                              ↓                                    ↓
            BLOCKED                        BLOCKED                              BLOCKED
```

At any stage, an agent can set status to `BLOCKED` with a reason. The orchestrator creates a decision file in `.deliberate/decisions/` for human review.

## Non-Responsibilities

- Does NOT make product or technical decisions
- Does NOT modify code or documentation
- Does NOT interpret ambiguous states — escalates to human instead
