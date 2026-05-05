# Release

## Purpose

Ship completed, QA-approved initiatives to production. Coordinate the release team through planning, deployment, verification, communications, and retrospective.

## Trigger

One or more initiatives reach `QA_COMPLETE` status.

## Agent Sequence

```
QA_COMPLETE (1+ initiatives)
  ↓
Release Manager
  /release-plan
  ↓
  ┌──────────────────────────────────────────────┐
  │ Parallel pre-deploy preparation               │
  ├────────────────┬──────────────┬───────────────┤
  │ Release        │ Release      │ Release       │
  │ Engineer       │ Comms        │ Marketer      │
  │                │              │ (if major)    │
  │ /release-      │ /release-    │ /release-     │
  │  preflight     │  changelog   │  campaign     │
  │                │ /release-    │ /release-     │
  │                │  notes       │  content      │
  └────────────────┴──────────────┴───────────────┘
  ↓
Release Manager
  /release-coordinate (pre-deploy checklist)
  ↓
  ┌─── Go/No-Go? ────────────┐
  │                            │
  GO          CONDITIONAL GO        NO-GO
  ↓           ↓                     ↓
  └────┬──────┘                  BLOCKED
       ↓                         (fix and retry)
  HUMAN APPROVAL REQUIRED
  (decision file + Slack)
       ↓
  Release Engineer
    /release-deploy
       ↓
  Release Engineer
    /release-verify (30-min observation)
       ↓
  ┌─── Healthy? ──────────────┐
  │                             │
  YES                          NO
  ↓                            ↓
  Release Comms               Rollback (see rollback triggers
    /release-announce          in release-verify skill)
  ↓                            ↓
  Release Marketer            Incident Response workflow
    (publish content)
  ↓
Release Manager
  /release-retro
  ↓
COMPLETE
```

## Detailed Steps

### Step 1: Release Manager — Plan

**Skill:** `/release-plan`
1. Identify `QA_COMPLETE` initiatives
2. Assess risk per initiative: migrations, external deps, feature flags, blast radius, rollback complexity
3. Group related changes, identify independent shippables
4. Recommend ordering (safest first, highest risk last)
5. Create release plan: version, scope, risk assessment, migration plan, feature flag plan, rollback plan, timeline, team assignments

### Step 2: Pre-Deploy Preparation (parallel)

**Release Engineer** — `/release-preflight`:
- Verify tests pass on release branch
- Migration dry-run
- Test rollback procedure
- Validate staging environment

**Release Comms** — `/release-changelog` → `/release-notes`:
- Generate internal changelog from git history (conventional commit parsing)
- Write user-facing release notes (benefit-first language)
- Draft internal/external announcements

**Release Marketer** — `/release-campaign` → `/release-content` (major releases only):
- Plan launch approach (launch tier classification)
- Create marketing content (blog, email, social, in-app)
- Content ready BEFORE deploy, published AFTER verification

### Step 3: Release Manager — Coordinate

**Skill:** `/release-coordinate`
1. Run pre-deploy checklist (all items must be green)
2. Monitor team progress, unblock where possible
3. Make go/no-go recommendation:
   - All green → **GO**
   - Critical issues → **NO-GO**
   - Minor issues → **CONDITIONAL GO** (requires explicit human acknowledgment of risk)
4. Write recommendation to `.deliberate/decisions/release-{version}-go-no-go.md`

**HUMAN APPROVAL REQUIRED** before proceeding to deploy.

### Step 4: Release Engineer — Deploy

**Skill:** `/release-deploy`
1. Record pre-deploy baselines (error rates, performance, current SHA)
2. Merge release branch to main/production
3. Tag release: `git tag -a v{version}`
4. Push to trigger deployment pipeline
5. Execute migrations (monitor for lock timeouts)
6. Activate feature flags per rollout plan

### Step 5: Release Engineer — Verify

**Skill:** `/release-verify`
1. Smoke tests on production
2. 30-minute monitoring window: error rate, response time, 5xx rate, job health, DB performance
3. User impact assessment

**Automatic rollback triggers** (any one → rollback immediately):
- 5xx error rate exceeds 2x baseline for 5+ minutes
- P0 user flow broken (login, signup, payment, core feature)
- Data corruption detected
- External service integration silently failing
- Database connection pool exhaustion

**If issues detected:** Classify severity (P0-P3), execute rollback or hotfix per protocol.

### Step 6: Release Comms — Announce

**Skill:** `/release-announce`
- Send internal announcement (Slack, email)
- Publish external announcement (blog, changelog page)
- All content was pre-drafted; now published after verification confirms health

### Step 7: Release Marketer — Publish

- Publish marketing content (blog, social, email sequences)
- Only for significant releases — not every deploy

### Step 8: Release Manager — Retrospective

**Skill:** `/release-retro`
1. Document what shipped (final scope, any last-minute changes)
2. Post-release health check (error rates, performance, user issues)
3. Capture incidents (what broke, detection time, resolution time)
4. Release metrics (lead time, deploy frequency, change failure rate, MTTR, rollback rate, hotfix count)
5. Process retrospective (what went well, what to improve)
6. Update initiative statuses → `COMPLETE`

## Decision Gates

| Gate | Who Decides | Condition |
|------|------------|-----------|
| Release scope | Release Manager | Which QA_COMPLETE initiatives to include |
| Go/No-Go | Release Manager recommends, Human approves | Decision file + Slack |
| Rollback | Release Engineer (automatic triggers) or Human (judgment call) | See rollback triggers above |
| Hotfix severity | Release Manager + Human | Hotfix-Critical vs Hotfix-Standard vs Deferred |

## Principles

- Ship small, ship often (weekly at alpha stage)
- Feature flags over branches (decouple deploy from release)
- Rollback plan always documented and tested
- No Friday deploys (unless critical fix)
- Human signs off on every deploy

## Exit Condition

Initiative statuses → `COMPLETE`. Retrospective document written. Release metrics recorded for trend tracking.
