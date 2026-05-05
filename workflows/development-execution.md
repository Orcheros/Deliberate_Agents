# Development Execution

## Purpose

Execute the stories and tasks defined by the Scrum Master. The Project Manager decomposes work into assignments, developers execute in parallel worktrees, and the Reviewer validates before handoff to QA.

## Trigger

Initiative status transitions to `READY_FOR_DEV` (after human sign-off on product artifacts).

## Agent Sequence

```
READY_FOR_DEV
  ↓
Project Manager
  /pjm-decompose → /pjm-assign → /pjm-coordinate
  ↓
  ┌─────────────────────────────────────────┐
  │ Parallel execution in isolated worktrees │
  ├─────────────┬──────────────┬────────────┤
  │ Developer 1 │ Developer 2  │ Developer N│
  │ /dev-understand → /dev-implement → /dev-test → /dev-complete
  ├─────────────┴──────────────┴────────────┤
  │ Integrations Engineer (if needed)        │
  │ Database Specialist (if needed)          │
  │ DevOps Engineer (if needed)              │
  └─────────────────────────────────────────┘
  ↓
All tasks complete
  ↓
Review Protocol (see review-protocol.md)
  ↓
DEV_COMPLETE
```

## Detailed Steps

### Step 1: Project Manager — Decompose

**Skill:** `/pjm-decompose`
**Input:** PRD, arch doc, design study, backlog (stories from Scrum Master)
**What happens:**
1. Read all product artifacts
2. Identify work streams by agent type (developer, integrations-engineer, devops, database-specialist)
3. Create phase dependencies (what must complete before what)
4. Size tasks: atomic, completable in one session, ≤10 files touched
5. Document decomposition plan

### Step 2: Project Manager — Assign

**Skill:** `/pjm-assign`
**What happens:**
1. Create assignment files (`.deliberate/assignments/{worktree-id}.md`) for each task
2. Each assignment includes: description, acceptance criteria, pattern reference (existing file to mirror), read-before-starting files, anti-patterns, test strategy, boundary/scope, relevant files
3. Create developer worktrees
4. Route tasks to correct agent type

**Status:** Tasks → `assigned`

### Step 3: Developers — Execute (parallel)

Each developer runs independently in its own worktree:

**Skill sequence:** `/dev-understand` → `/dev-implement` → `/dev-test` → `/dev-complete`

1. **Understand** — Read assignment, explore relevant code, read all "Read Before Starting" files, plan approach
2. **Implement** — Write code following existing patterns. If bugs encountered, invoke `/systematic-debugging`. For UI work, reference `/tailwind-design-system`.
3. **Test** — TDD discipline (red-green-refactor). Write tests matching assignment's test strategy. Run full relevant suite.
4. **Complete** — Verification gate (fresh evidence required). Clean atomic commits. Update assignment status → `complete`.

**If blocked:** Set assignment status to `blocked` with specific blocker. PjM detects and either unblocks or escalates.

**Constraints:**
- Never push to remote
- One concern per commit
- All tests must pass before marking complete
- Follow existing patterns exactly

### Step 4: Specialist Agents (as needed)

**Integrations Engineer:** Assigned when tasks involve external service configuration (CRM, analytics, payment, email). Follows `/integrations-assess` → `/integrations-configure` → `/integrations-verify`. For Stripe work, references `/stripe-lifecycle`.

**Database Specialist:** Assigned for complex schema design, migration safety review, query performance. Follows `/db-assess` → `/db-migrate` → `/db-seed`.

**DevOps Engineer:** Assigned for CI/CD changes, infrastructure, monitoring setup. Follows `/devops-assess` → `/devops-implement`. References `/observability-design` and `/incident-command` when relevant.

### Step 5: Project Manager — Coordinate

**Skill:** `/pjm-coordinate`
**What happens:**
1. Monitor developer status files for completion
2. Unblock developers where possible (provide missing context, clarify scope)
3. Escalate blockers that require human decision
4. Track cross-task dependencies
5. When all tasks complete → trigger Review Protocol

### Step 6: Review Protocol

See [review-protocol.md](review-protocol.md) for full details.

**Status after review:** `DEV_COMPLETE` (or `BLOCKED` if review finds issues)

## Decision Gates

| Gate | Who Decides | Condition |
|------|------------|-----------|
| Task blocked? | PjM first, then human | PjM attempts to unblock; escalates if can't |
| Code review intensity | Reviewer + Human | Standard `/review` vs `/ultrareview` — see review-protocol.md |
| All tasks complete? | PjM | All assignment statuses → `complete` |

## Exit Condition

Initiative status is `DEV_COMPLETE`. All tasks completed, reviewed, and committed in worktrees. Ready for **Quality Assurance** workflow.
