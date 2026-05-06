---
name: qa-branch
description: Execute the 8-phase QA test protocol on a branch — boot verification, test suite, runtime validation, page rendering, and final sign-off
allowed-tools: Bash, Read, Write, Glob, Grep
---

# QA Branch Protocol

## Objective

Execute hands-on verification of a feature branch across 8 phases before routing to specialist QA teammates. This is the QA Lead's direct testing procedure — validated on branches with 300+ changed files, multiple migrations, and dozens of new services/workflows.

## Prerequisites

- Branch is in `DEV_COMPLETE` state (all development work finished)
- Worktree exists for the branch (all dev work happens in worktrees)
- Dev server may already be running on the worktree — check before starting one

## Instructions

### Phase 1: Branch Audit

Understand the full scope of what changed before touching anything.

1. `git log staging..HEAD` — review all commits, understand the narrative of changes
2. `git diff staging --stat` — file change summary (count of files, insertions, deletions)
3. Identify scope explicitly:
   - New models
   - New/modified services
   - New/modified controllers
   - New jobs
   - New/modified views
   - Migrations
   - Test files

### Phase 2: Migration & Boot Verification

Confirm the app can start and the database schema is sound.

1. `bin/rails db:migrate:status` — check for pending migrations
2. Verify all migrations use `change` (reversible) or have explicit `up`/`down` methods
3. `bin/rails zeitwerk:check` — detect autoloading conflicts (constant naming, file path mismatches)
4. `bin/rails runner "puts 'Boot OK'"` — confirm the app boots without errors

**Hard stop:** If the app does not boot, do not proceed. Fix boot issues first.

### Phase 3: Full Test Suite

Run the entire suite and get to green before proceeding.

1. `bin/rails test` — run the full suite
2. If failures: diagnose root cause before fixing
   - **Ordering pollution** — test passes solo, fails in suite (shared state leaking between tests). Check for `define_method`/`remove_method` in test files — replace with scoped Minitest `stub` blocks.
   - **Missing stubs** — tests hitting real services or missing WebMock registrations
   - **Parallelization deadlocks** — database lock contention in parallel test workers
   - **Monkey-patch poisoning** — `define_method`/`remove_method` in tests that mutate classes for subsequent tests
3. Fix bugs, commit each fix atomically, re-run until 0 failures and 0 errors

### Phase 4: Model Runtime Verification

Validate new/modified models behave correctly at runtime, beyond what unit tests cover.

1. For each new model, verify via `bin/rails runner`:
   - Enums resolve correctly (e.g., `Model.statuses`)
   - Scopes return expected query structure
   - Validations reject bad data and accept good data
   - Associations are properly defined (belongs_to, has_many, etc.)
2. For modified models:
   - Verify new methods handle edge cases (nil inputs, wrong types)
   - Test display/presentation methods with both real data and nil data

### Phase 5: Service Smoke Tests

Run each new service's tests individually and verify patterns.

1. Run each test file individually: `bin/rails test test/services/foo_test.rb -v`
2. Verify services follow project patterns:
   - Single entry method (e.g., `call`, `perform`, `execute`)
   - Error handling (rescue, return values, logging)
3. Check for WebMock/stub gaps — tests that accidentally hit real APIs will hang or produce intermittent failures

### Phase 6: Page/View Rendering

Verify that views actually render and routes resolve.

1. Check if dev server is already running (`bin/dev`). Do not start a duplicate.
2. Fetch public pages and verify content renders (marketing, pricing, about, etc.)
3. For authenticated pages:
   - Verify subdomain routing works (lvh.me for local dev)
   - Verify auth redirects behave correctly (unauthenticated users get redirected, not 500s)
4. Check new view templates exist and are referenced from their controllers
5. Verify no orphaned views (templates that exist but have no route)

### Phase 7: Domain-Specific Verification

Validate business logic, registries, coordination, and JS behavior.

1. Test registries, configuration objects, and coordination logic via `bin/rails runner`
2. Verify background jobs are properly enqueued (not just defined) — check `perform_later` calls
3. Check Stimulus controllers exist for any new JS behavior referenced in views
4. Verify no inline JS in views (all JS belongs in Stimulus controllers per project convention)

### Phase 8: Final Confirmation

Clean exit — no loose ends.

1. Full test suite one more time: `bin/rails test` — must be 0 failures, 0 errors
2. `git status` — no uncommitted changes (all fixes committed atomically)
3. Produce summary report:

| Category | Status | Notes |
|----------|--------|-------|
| Boot & migrations | PASS/FAIL | |
| Test suite | PASS/FAIL | X tests, X assertions |
| Models | PASS/FAIL | |
| Services | PASS/FAIL | |
| Views/pages | PASS/FAIL | |
| Domain logic | PASS/FAIL | |
| Bugs found & fixed | count | list commit SHAs |
| Remaining manual items | count | list what needs human |

## Commit Discipline

- Every bug fix gets its own atomic commit with a clear message
- Never batch unrelated fixes into one commit
- Run the test suite after each fix to confirm it doesn't introduce new failures

## Output

- All phases passed with evidence
- Phase 8 summary table
- List of bugs found and fixed (with commit SHAs)
- List of remaining items that require manual browser testing

## Transition

When all 8 phases pass → proceed to `/qa-assign` for specialist routing (security, integration, UX/UI) or directly to `/qa-report` if specialists are not needed.
