# Review Workflow

## Purpose

Validate completed initiative work against the PRD before presenting to the human for final approval. This is a quality gate between autonomous agent work and human review.

## Agent

Project Manager Agent (reactivated for review)

## Prerequisites

- All tasks for the initiative are marked `complete`
- All tests pass across all worktrees
- Initiative status is `DEV_COMPLETE` (set by orchestrator when all tasks finish)

## Steps

| Step | File | Purpose |
|------|------|---------|
| 1 | `steps/step-01-validate.md` | Verify all acceptance criteria are met |
| 2 | `steps/step-02-summarize.md` | Write a review summary for the human |

## State Transitions

```
DEV_COMPLETE → REVIEW_IN_PROGRESS → REVIEW_READY
                      ↓
                   BLOCKED (if issues found)
```

## Outputs

- A review summary document for the human
- Initiative status → `REVIEW_READY`
- The human reviews in Cursor and approves or requests changes
