# Quality Assurance

## Purpose

Validate the completed implementation across security, integration correctness, and UX quality before the initiative can be released.

## Trigger

Initiative status transitions to `DEV_COMPLETE` (after review and human acknowledgment).

## Agent Sequence

```
DEV_COMPLETE
  ↓
QA Lead
  /qa-plan → /qa-assign
  ↓
  ┌──────────────────────────────────────────────────────┐
  │ Phase 1–8: QA Agent Test Protocol (see below)        │
  │ QA Lead executes hands-on verification before        │
  │ routing to specialist teammates                      │
  └──────────────────────────────────────────────────────┘
  ↓
  ┌──────────────────────────────────────────┐
  │ Parallel QA execution by specialty        │
  ├──────────────┬─────────────┬─────────────┤
  │ Security     │ Integration │ UX/UI       │
  │ Analyst      │ Tester      │ Reviewer    │
  │              │             │             │
  │ /security-   │ /test-plan- │ /ux-review- │
  │  assess      │  review     │  design     │
  │ /security-   │ /test-      │ /ux-review- │
  │  review      │  integration│  a11y       │
  │              │ /test-report│ /ux-review- │
  │              │             │  report     │
  └──────────────┴─────────────┴─────────────┘
  ↓
QA Lead
  /qa-coordinate → /qa-report
  ↓
  ┌─── Recommendation? ───────┐
  │                             │
  GO            CONDITIONAL GO         NO-GO
  ↓             ↓                      ↓
QA_COMPLETE    Human approves?    BLOCKED
  │             ├─ YES → QA_COMPLETE   (corrective tasks)
  │             └─ NO → BLOCKED
  ↓
  Ready for Release
```

## QA Agent Test Protocol

The QA Lead executes this 8-phase protocol before routing to specialist teammates. This is the hands-on verification procedure — tested on branches with 300+ changed files, multiple migrations, and dozens of new services/workflows.

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
   - **Ordering pollution** — test passes solo, fails in suite (shared state leaking between tests)
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

1. Start server (`bin/dev`) or verify it is already running
2. Fetch public pages and verify content renders (marketing, pricing, about, etc.)
3. For authenticated pages:
   - Verify subdomain routing works
   - Verify auth redirects behave correctly (unauthenticated users get redirected, not 500s)
4. Check new view templates exist and are referenced from their controllers
5. Verify no orphaned views (templates that exist but have no route)

### Phase 7: Domain-Specific Verification

Validate business logic, registries, coordination, and JS behavior.

1. Test registries, configuration objects, and coordination logic
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

## Detailed Steps

### Step 1: QA Lead — Plan

**Skill:** `/qa-plan`
**Input:** PRD, arch doc, design study, stories, developer commits
**What happens:**
1. Decompose into testable cases by category: acceptance criteria, security, integration, UX/UI, regression, edge cases
2. Prioritize: critical → high → medium → low
3. Write test plan with total case count

**Status:** `QA_IN_PROGRESS`

### Step 2: QA Lead — Assign

**Skill:** `/qa-assign`
**Routing:**
- **Security Analyst** → Auth flows, input validation, data exposure, OWASP top 10, dependency audit
- **Integration Tester** → API contracts, data integrity, background jobs, webhooks, data flows, concurrency
- **UX/UI Reviewer** → Design fidelity, responsive behavior, accessibility (WCAG 2.1 AA), UI states, interactions

Not every initiative needs all three. QA Lead assigns based on what the initiative touches.

### Step 3: Specialists — Execute (parallel)

**Security Analyst:**
1. `/security-assess` — Threat model the initiative, identify attack surfaces
2. `/security-review` — Review code for vulnerabilities (XSS, CSRF, injection, mass assignment, IDOR, SSRF)
3. Can invoke `/dep-audit` for dependency vulnerabilities, `/incident-respond` if a security incident is found
4. Report findings with severity (Critical/High/Medium/Low/Informational)

**Integration Tester:**
1. `/test-plan-review` — Review assigned test cases, identify dependencies
2. `/test-integration` — Execute integration tests, write new tests for gaps
3. `/test-report` — Document results with evidence (test output, DB state, API responses)

**UX/UI Reviewer:**
1. `/ux-review-design` — Compare implementation against design brief
2. `/ux-review-accessibility` — Audit WCAG 2.1 AA (contrast, keyboard nav, ARIA, focus management)
3. `/ux-review-report` — Document findings with severity (critical/major/minor/suggestion)

### Step 4: QA Lead — Coordinate

**Skill:** `/qa-coordinate`
1. Monitor teammate status files
2. Handle blockers (clarify requirements, provide context)
3. Manage cross-area dependencies (security findings affect integration priorities)
4. Handle re-tests if engineering fixes come in
5. Escalate unresolvable blockers to orchestrator

### Step 5: QA Lead — Report

**Skill:** `/qa-report`
**What happens:**
1. Aggregate all teammate results
2. Compile findings with evidence
3. Make recommendation:

| Recommendation | Criteria |
|---------------|----------|
| **GO** | All critical/high pass, no security vulnerabilities, all ACs verified |
| **CONDITIONAL GO** | All critical pass, some high failures that don't block core — requires human approval |
| **NO-GO** | Any critical fails, security vulnerability, AC not met, regression found |

**Status:** `QA_COMPLETE` (GO) or `BLOCKED` (NO-GO, with corrective task assignments sent back to engineering)

## Decision Gates

| Gate | Who Decides | Condition |
|------|------------|-----------|
| Which specialists needed? | QA Lead | Based on what the initiative touches |
| Phase 1–8 pass? | QA Lead | Must complete test protocol before specialist routing |
| Re-test after fix? | QA Lead | Engineering delivers fix → QA re-runs affected tests |
| GO / NO-GO / CONDITIONAL | QA Lead recommends, Human approves | Decision file + Slack |

## Exit Condition

Initiative status is `QA_COMPLETE`. QA report exists with all findings documented (including Phase 8 summary table). Ready for the **Release** workflow.
