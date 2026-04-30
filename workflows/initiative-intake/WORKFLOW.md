# Initiative Intake Workflow

## Purpose

Transform a raw one-pager (idea description) into a complete, actionable Product Requirements Document with architecture guidance and task breakdown.

## Agent

Product Manager Agent

## Prerequisites

- An initiative one-pager exists in the project's initiatives directory
- The initiative state file in `.deliberate/queue/` has status `QUEUED`
- The project's codebase is accessible for context

## Steps

| Step | File | Purpose |
|------|------|---------|
| 1 | `step-01-assess.md` | Evaluate the one-pager for completeness |
| 2 | `step-02-expand-prd.md` | Write the full PRD |
| 3 | `step-03-architecture.md` | Document technical architecture (if needed) |
| 4 | `step-04-ready-for-dev.md` | Finalize outputs and signal completion |

## State Transitions

```
QUEUED → PM_IN_PROGRESS → PRD_COMPLETE
                ↓
            BLOCKED (if one-pager is insufficient)
```

## Outputs

- Complete PRD following the project's template
- Architecture notes (when applicable)
- Updated initiative state file
