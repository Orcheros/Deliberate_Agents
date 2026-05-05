# Incident Response

## Purpose

Handle production incidents — from detection through resolution, communication, and post-mortem. This is a cross-cutting workflow that can interrupt any other workflow.

## Trigger

- Post-deploy verification fails (from Release workflow)
- Monitoring alert fires
- User-reported production issue
- Security vulnerability discovered

## Flow

```
Incident detected
  ↓
Classify severity (P0-P3)
  ↓
  ┌─── Severity? ─────────────────────────────┐
  │                                             │
  P0 (Critical)        P1 (High)         P2-P3 (Medium/Low)
  ↓                    ↓                 ↓
  Immediate rollback   Hotfix within     Track and fix
  (automatic triggers  2 hours or        in next sprint
  in release-verify)   rollback
  ↓                    ↓                 ↓
  ├─ DevOps: rollback  ├─ Developer:     Log issue,
  │  execution         │  hotfix branch  schedule fix
  ├─ Comms: incident   ├─ QA: fast-track │
  │  notification      │  validation     Done
  └─ Human: notified   └─ Release Eng:
     immediately          deploy hotfix
  ↓                    ↓
  Post-incident        Post-incident
  review               review (if P1)
```

## Severity Classification

| Severity | Criteria | Response SLA | Communication |
|----------|----------|-------------|---------------|
| **P0** | Core flow broken, data loss risk, security breach | 15 min to rollback | Immediate Slack alert to founder |
| **P1** | Major feature broken, >10% users affected | 2 hr resolution | Slack alert within 15 min |
| **P2** | Minor feature broken, workaround exists | 24 hr resolution | Note in daily status |
| **P3** | Cosmetic, edge case, non-blocking | Next release | Track in backlog |

## Automatic Rollback Triggers (P0)

Any ONE of these → rollback immediately, no deliberation:
- 5xx error rate exceeds 2x pre-deploy baseline for 5+ minutes
- P0 user-facing flow broken (login, signup, payment, core feature)
- Data corruption or integrity violation detected
- External service integration silently failing
- Database connection pool exhaustion

## Hotfix Protocol

**Hotfix-Critical** (P0 that can't be solved by rollback alone):
1. Branch from release tag: `hotfix/{version}-{description}`
2. Assign developer — bypass normal sprint process
3. Abbreviated QA: smoke tests + affected area only
4. Deploy independently

**Hotfix-Standard** (P1):
1. Cherry-pick fix onto staging
2. Fast-track through QA
3. Bundle with next scheduled deploy

**Deferred** (P2-P3):
1. Log as issue in backlog
2. Schedule in next sprint
3. No expedited action

## Agents Involved

| Agent | Role in Incident |
|-------|-----------------|
| **DevOps Engineer** | Rollback execution, infrastructure investigation, monitoring |
| **Developer** | Root cause investigation, hotfix implementation |
| **Security Analyst** | Security incident triage, forensic evidence collection |
| **Release Engineer** | Emergency deployment, verification |
| **Release Comms** | Incident communication drafts |
| **Release Manager** | Coordination, post-incident review |

## Post-Incident Review

For P0 and P1 incidents:
1. Timeline reconstruction (when detected, when resolved, total impact window)
2. Root cause analysis (5 Whys)
3. What detection mechanism caught it (or didn't)
4. Whether rollback plan worked
5. Process improvements to prevent recurrence
6. Document in `.deliberate/releases/{version}/incidents/`

## Exit Condition

Incident resolved (rollback, hotfix, or deferred). Communication sent. Post-incident review completed for P0/P1. Process improvements documented.
