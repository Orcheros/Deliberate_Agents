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

For each task, create `.deliberate/assignments/{worktree-or-task-id}.md`:

```markdown
# Task: {Short title}

## Meta
- **ID**: init-001-task-01
- **Initiative**: initiative-slug
- **Story**: Story 1.1
- **Agent**: developer
- **Status**: assigned
- **Worktree**: worktree-name
- **Branch**: feature/initiative-slug-task-01
- **Phase**: A
- **Priority**: 1
- **PRD Section**: FR-03
- **Depends On**: (none)

## Description
Detailed description of what to implement.

## Use Cases
- As a {user type}, I {action} so that {outcome}

## Acceptance Criteria
- [ ] Given {precondition}, when {action}, then {expected result}
- [ ] Given {precondition}, when {action}, then {expected result}

## Before/After Behavior
**Before**: What the system does now — specific, observable behavior.

**After**: What the system should do after this task — specific, observable behavior.

## Pattern Reference
Implement like `app/controllers/similar_controller.rb` — mirror its structure, naming, and conventions.

## Read Before Starting
Read these files in order before writing any code:
1. `app/models/relevant_model.rb`
2. `app/controllers/relevant_controller.rb`
3. `test/controllers/relevant_controller_test.rb`

## Anti-Patterns
- Do not use `has_many :through` — we use a service object for this relationship
- {Other codebase-specific warnings}

## Test Strategy
- **Test file**: `test/controllers/feature_test.rb`
- **Model after**: `test/controllers/existing_similar_test.rb`
- **Fixtures**: `users`, `relevant_model`

## Boundary (Out of Scope)
- Do not modify the navigation partial
- Ignore mobile layout — that is Story 2.3

## Relevant Files
- `path/to/relevant/file.rb`
- `path/to/another/file.rb`
```

### Carrying Context from Stories to Assignments

The Scrum Master's backlog stories contain rich AI-developer context (pattern references, anti-patterns, test strategy, boundaries). When creating assignments, **preserve all of this context** — copy it directly from the story into the assignment markdown. Do not summarize or omit fields. The developer agent's output quality is directly proportional to the context it receives.

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

### 5. Update Initiative STATUS.yaml

Update the initiative's `STATUS.yaml` in its documentation directory:
```yaml
state: "in-progress"
id: "<initiative-id>"
title: "<initiative-title>"
updated_at: "<ISO 8601 timestamp>"
updated_by: "project-manager"
reason: "Tasks assigned, development starting"
```
The orchestrator will detect this and move the initiative directory from `specified/` to `in-progress/`.

### 6. Update PjM Status

Update `.deliberate/status/project-manager.md`:
```markdown
# Status: Project Manager

- **Status**: active
- **Current Initiative**: initiative-slug
- **Tasks Assigned**: 15

## Tasks by Type
| Agent Type | Count |
|------------|-------|
| developer | 6 |
| integrations-engineer | 3 |
| content-writer | 2 |
| compliance-analyst | 1 |
| technical-writer | 1 |
| devops-engineer | 1 |
| security-analyst | 1 |
```

## Transition

Once all assignments are created -> proceed to `/pjm-coordinate`
