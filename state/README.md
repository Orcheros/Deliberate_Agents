# State Protocol

This directory documents the filesystem-based inter-agent communication protocol used by Deliberate_Agents.

## Overview

Agents communicate exclusively through YAML and markdown files in the `.deliberate/` directory within the project's worktrees root. There is no direct agent-to-agent communication — the orchestrator mediates all transitions.

## Directory Structure

When `init.sh` is run against a project, it creates:

```
{worktrees-root}/.deliberate/
├── config.yaml              # Project configuration
├── queue/                   # Initiative state files
│   └── {slug}.yaml
├── assignments/             # Developer task assignments
│   └── {worktree}.yaml
├── status/                  # Agent heartbeat/status reports
│   └── {agent-role}.yaml
├── decisions/               # Items requiring human input
│   └── {timestamp}-{slug}.md
└── logs/                    # Session logs
    └── {agent}-{timestamp}.log
```

## Initiative State File

Location: `.deliberate/queue/{initiative-slug}.yaml`

```yaml
initiative: "initiative-slug"
title: "Human-readable title"
one_pager_path: "path/to/one-pager.md"
status: "QUEUED"
created_at: "2024-01-15T10:00:00Z"

# Added by PM agent
prd_path: "path/to/prd.md"
architecture_path: "path/to/arch.md"
assessment:
  readiness: "ready"
  notes: ""
  concerns: []

# Added by PjM agent
task_count: 5
tasks:
  - id: "init-001-task-01"
    worktree: "worktree-name"
    status: "complete"
```

## State Transitions

```
QUEUED
  → PM_IN_PROGRESS        (orchestrator launches PM agent)
  → PRD_COMPLETE           (PM agent finishes)
  → PJM_IN_PROGRESS        (orchestrator launches PjM agent)
  → READY_FOR_DEV          (PjM agent creates assignments)
  → DEV_IN_PROGRESS        (orchestrator launches dev agents)
  → DEV_COMPLETE           (orchestrator detects all tasks done)
  → REVIEW_IN_PROGRESS     (orchestrator launches review)
  → REVIEW_READY           (review agent finishes)
  → COMPLETE               (human approves)

Any state → BLOCKED        (agent encounters issue needing human input)
```

## Assignment File

Location: `.deliberate/assignments/{worktree-name}.yaml`

```yaml
task:
  id: "init-001-task-01"
  initiative: "initiative-slug"
  title: "Short description"
  description: "Detailed implementation instructions"
  acceptance_criteria:
    - "Criterion 1"
    - "Criterion 2"
  relevant_files:
    - "app/models/user.rb"
    - "app/controllers/users_controller.rb"
  depends_on: []
  branch: "feature/initiative-slug-task-01"

status: "assigned"          # assigned → in_progress → complete | blocked
worktree: "worktree-name"
initiative: "initiative-slug"

# Updated by developer agent
started_at: null
completed_at: null
commits: []
test_result: null
blocker: null
notes: null
```

## Status File

Location: `.deliberate/status/{agent-role}.yaml`

```yaml
status: "active"            # active | idle | error
role: "developer"
worktree: "worktree-name"   # for developer agents
current_task: "task-id"
last_heartbeat: "2024-01-15T10:30:00Z"
current_step: "step-02-implement"
progress: "Implementing user model validations"
```

## Decision File

Location: `.deliberate/decisions/{timestamp}-{slug}.md`

```markdown
# Decision Required: {Title}

**Initiative**: {initiative-slug}
**Agent**: {role}
**Created**: {timestamp}
**Priority**: {high | medium | low}

## Context

What the agent was doing when it hit this decision point.

## Question

The specific question that needs a human answer.

## Options

1. **Option A**: Description and trade-offs
2. **Option B**: Description and trade-offs

## Resolution

(Filled in by human)

**Decision**: Option chosen
**Notes**: Any additional context
**Resolved at**: timestamp
```

## Rules

1. **Atomic writes**: Always write complete files, never partial updates
2. **No direct communication**: Agents never read each other's status files — only the orchestrator reads all state
3. **Immutable history**: Decision files are never deleted, only marked as resolved
4. **Human authority**: Any file in `decisions/` blocks progress until resolved
5. **Crash recovery**: If an agent crashes, its status file reflects the last known state. The orchestrator detects stale heartbeats and can re-launch.
