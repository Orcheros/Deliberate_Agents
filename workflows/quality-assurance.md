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
| Re-test after fix? | QA Lead | Engineering delivers fix → QA re-runs affected tests |
| GO / NO-GO / CONDITIONAL | QA Lead recommends, Human approves | Decision file + Slack |

## Exit Condition

Initiative status is `QA_COMPLETE`. QA report exists with all findings documented. Ready for the **Release** workflow.
