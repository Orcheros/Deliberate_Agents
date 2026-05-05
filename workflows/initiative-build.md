# Initiative Build

## Purpose

Take a one-pager from the backlog and produce everything needed for engineering to execute: a production-depth PRD, architecture document (if technical), design study with UI artifacts (if visual), and a full story/sprint/epic decomposition.

## Trigger

Founder selects a `QUEUED` initiative for grooming.

## Agent Sequence

```
One-pager (QUEUED)
  ↓
Product Manager
  /pm-assess → /pm-research → /pm-expand-prd → /pm-cross-functional → /pm-ready-for-dev
  ↓
  ┌─── Needs architecture? ───┐
  │ YES                        │ NO
  ↓                            │
Architect                      │
  (arch doc)                   │
  ↓                            │
  ←────────────────────────────┘
  ↓
  ┌─── Needs design? ─────────┐
  │ YES                        │ NO
  ↓                            │
Product Designer               │
  (design study)               │
  ↓                            │
  ┌─ Needs Claude Design? ─┐  │
  │ YES                     │  │
  ↓                         │  │
  BLOCKED: Human takes      │  │
  study → Claude Design     │  │
  → commits artifacts       │  │
  ↓                         │  │
  Designer incorporates     │  │
  ←─────────────────────────┘  │
  ←────────────────────────────┘
  ↓
Scrum Master
  (epics → sprints → stories)
  ↓
SPECIFIED — ready for human sign-off
```

## Detailed Steps

### Step 1: Product Manager — Assessment

**Skill:** `/pm-assess`
**Input:** One-pager from backlog
**What happens:**
1. Evaluate one-pager completeness
2. Create product branch: `product/{number}-{slug}`
3. Bookend start commit
4. Assess readiness: ready → proceed, needs clarification → `BLOCKED`

**Status:** `PM_IN_PROGRESS`

### Step 2: Product Manager — Research

**Skill:** `/pm-research`
**What happens:**
1. Deep-dive codebase: models, controllers, services, jobs, tests, config, schema
2. Build pattern inventory (service objects, auth patterns, API wrappers, Tailwind, Stimulus)
3. Read related initiative docs, strategy docs, vision docs
4. Document current state and dependencies

### Step 3: Product Manager — PRD

**Skill:** `/pm-expand-prd`
**What happens:**
1. Write complete 22-section PRD (functional requirements, data model, UX, comms, rollout, failure modes, test scenarios, acceptance criteria, etc.)
2. All file paths and pattern references verified against codebase
3. Cross-functional sections identify work for every agent type

**Status:** `PRD_COMPLETE`

### Step 4: Product Manager — Cross-Functional Impact

**Skill:** `/pm-cross-functional`
**What happens:**
1. Assess impact across all business functions
2. Identify which agents need to be involved (developer, integrations engineer, content writer, compliance, docs, devops, security, sales, CS)
3. Update PRD with agent routing guidance

### Step 5: Product Manager — Architecture Decision

**Skill:** `/pm-architecture` (determines if Architect is needed)
**Decision criteria:** 3+ new models, new service layers, external integrations, auth/multi-tenancy changes
- **YES** → Trigger Architect agent
- **NO** → Skip to design decision, document why architecture doc isn't needed

### Step 5a: Architect (optional)

**Triggered by:** PM determines architecture doc is needed
**What happens:**
1. Read PRD on product branch
2. Deep-dive codebase (trace models, controllers, services, routes, jobs)
3. Write implementation-ready arch doc: real code examples, migrations, service signatures, API contracts, decision gates, testing strategy, build sequence, file manifest
4. Request cross-functional feedback (security, devops, developer)
5. Incorporate feedback and revise

**Status:** `ARCH_COMPLETE`

### Step 6: Product Manager — Design Decision

**Determined by:** PM assesses if initiative has UI changes
- **YES** → Trigger Product Designer
- **NO** → Skip to Scrum Master

### Step 6a: Product Designer (optional)

**What happens:**
1. Read PRD and arch doc
2. Audit existing views, partials, Stimulus controllers, Tailwind patterns
3. Write design study: user flows, screen inventory, component specs, copy, states/transitions, responsive behavior, accessibility (WCAG 2.1 AA), edge cases
4. Create decision file flagging human for Claude Design artifact creation

**Status:** `DESIGN_PENDING_ARTIFACTS`

### Step 6b: Human + Claude Design (optional, BLOCKS)

**What happens:**
1. Human takes design study to Claude Design
2. Claude Design produces visual artifacts (mockups, component designs)
3. Human commits artifacts back to product branch
4. Product Designer reads artifacts, incorporates into design study

**Status:** `DESIGN_COMPLETE`

### Step 7: Product Manager — Finalize

**Skill:** `/pm-ready-for-dev`
**What happens:**
1. Validate all artifacts are co-located in initiative directory
2. Review completeness, validate task sizing
3. Trigger Scrum Master

### Step 8: Scrum Master

**What happens:**
1. Read PRD, arch doc, design study
2. Identify epic boundaries (data model, service layer, UI, integrations)
3. Decompose epics into stories (≤3 Fibonacci points each) with: acceptance criteria, pattern references, test strategy, boundary/scope
4. Sequence into sprints by dependency
5. Assign agent types to stories
6. Write backlog document

**Status:** `SPECIFIED`
**Output:** Bookend completion commit on product branch

## Decision Gates

| Gate | Who Decides | Condition |
|------|------------|-----------|
| One-pager ready? | PM | Clear scope and intent vs. needs founder clarification |
| Needs architecture? | PM | Technical complexity threshold |
| Needs design? | PM | UI changes present |
| Needs Claude Design? | Designer + Human | Visual artifacts needed beyond written spec |
| Ready for dev? | Human (via Slack) | Sign-off after reviewing all artifacts |

## Exit Condition

Initiative status is `SPECIFIED`. All artifacts (PRD, arch doc if applicable, design study if applicable, backlog with stories) exist on the product branch. Human signs off to transition to `READY_FOR_DEV`, which triggers the **Development Execution** workflow.
