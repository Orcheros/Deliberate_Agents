# Development Workflow

## Purpose

Execute a single development task in an isolated git worktree — from understanding the requirement through implementation, testing, and clean commit.

## Agent

Developer Agent

## Prerequisites

- A task assignment exists in `.deliberate/assignments/{worktree}.yaml` with status `assigned`
- The worktree exists and is on the correct branch
- All task dependencies are marked as `complete`

## Steps

| Step | File | Purpose |
|------|------|---------|
| 1 | `step-01-understand.md` | Read the task, explore code, plan approach |
| 2 | `step-02-implement.md` | Write the code |
| 3 | `step-03-test.md` | Run tests, fix failures |
| 4 | `step-04-complete.md` | Commit and report completion |

## State Transitions

```
assigned → in_progress → complete
              ↓
           blocked
```

## Tech Stack

- Ruby on Rails (models, controllers, views, routes)
- Tailwind CSS (utility classes, design tokens)
- Stimulus JS (controllers in app/javascript/controllers/)
- Minitest or RSpec (depending on project)

## Outputs

- Code changes in the worktree
- Passing test suite
- Atomic git commits with descriptive messages
- Updated assignment status
