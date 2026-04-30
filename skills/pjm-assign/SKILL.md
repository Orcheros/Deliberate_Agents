---
name: pjm-assign
description: Create task assignments with correct agent type routing
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Step 2: Create Task Assignments

## Objective

Convert the decomposition plan into actual assignment files that the orchestrator can pick up and route to the correct agent type.

## Instructions

### 1. Create Assignment Files

For each task, create `.deliberate/assignments/{worktree-or-task-id}.yaml`:

```yaml
task:
  id: "init-001-task-01"
  initiative: "initiative-slug"
  title: "Short description"
  description: "Detailed description of what to implement"
  acceptance_criteria:
    - "Criterion 1"
    - "Criterion 2"
  relevant_files:
    - "path/to/relevant/file.rb"
  depends_on: []          # Other task IDs that must complete first
  branch: "feature/initiative-slug-task-01"  # For dev tasks
  prd_section: "FR-03"    # Which PRD section this fulfills

agent_type: "developer"   # developer | integrations-engineer | content-writer |
                          # compliance-analyst | technical-writer | devops-engineer |
                          # security-analyst | reviewer
status: "assigned"
worktree: "worktree-name" # For developer tasks
initiative: "initiative-slug"
phase: "A"                # Which deployment phase
priority: 1               # Lower = higher priority within phase
```

### 2. Agent Type Routing

Ensure each task has the correct `agent_type`:

| Work Stream | Agent Type | Working Directory |
|-------------|-----------|-------------------|
| Code implementation | `developer` | Worktree |
| SaaS configuration, API wiring | `integrations-engineer` | Worktree or repo root |
| Email copy, marketing messaging | `content-writer` | Repo root |
| Privacy/legal review | `compliance-analyst` | Repo root |
| Runbooks, API docs | `technical-writer` | Repo root |
| CI/CD, monitoring, infrastructure | `devops-engineer` | Repo root |
| Security review, threat model | `security-analyst` | Repo root |
| Code review against AC | `reviewer` | Repo root |

### 3. Dependency Enforcement

- Never assign a task whose `depends_on` tasks aren't complete
- Phase A tasks have no cross-phase dependencies
- Cross-stream dependencies are explicit (e.g., content-writer waits for developer to build the email infrastructure before writing templates that reference it)

### 4. Update Initiative State

```yaml
# .deliberate/queue/{initiative}.yaml
status: "READY_FOR_DEV"
task_count: 15
tasks:
  - id: "init-001-task-01"
    agent_type: "developer"
    worktree: "worktree-1"
    status: "assigned"
    phase: "A"
  - id: "init-001-task-02"
    agent_type: "integrations-engineer"
    status: "assigned"
    phase: "A"
  # ... etc
```

### 5. Update PjM Status

```yaml
# .deliberate/status/project-manager.yaml
status: "active"
current_initiative: "initiative-slug"
tasks_assigned: 15
tasks_by_type:
  developer: 6
  integrations-engineer: 3
  content-writer: 2
  compliance-analyst: 1
  technical-writer: 1
  devops-engineer: 1
  security-analyst: 1
```

## Transition

Once all assignments are created -> proceed to `/pjm-coordinate`
