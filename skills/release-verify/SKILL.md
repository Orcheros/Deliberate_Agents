---
name: release-verify
description: Post-deploy verification, monitoring, and rollback if needed
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Step 3: Post-Deploy Verification

## Objective

Verify the deployment is healthy and trigger rollback if issues are detected.

## Instructions

1. **Smoke tests**:
   - Verify key user flows work in production
   - Check critical API endpoints respond correctly
   - Verify new features are accessible (or correctly hidden behind flags)

2. **Monitor metrics** (30-minute observation window):
   - Error rate: compare to pre-deploy baseline
   - Response time: check for latency increases
   - 5xx rate: any new server errors?
   - Background job health: are jobs processing normally?
   - Database performance: any slow query spikes?

3. **User impact assessment**:
   - Check for user-reported issues in support channels
   - Monitor application logs for unexpected errors
   - Verify email/notification delivery (if applicable)

4. **If issues detected — classify and act**:

   **Automatic rollback triggers** (any one of these → rollback immediately, no deliberation):
   - 5xx error rate exceeds 2x pre-deploy baseline for 5+ minutes
   - P0 user-facing flow is broken (login, signup, payment, core feature)
   - Data corruption or integrity violation detected
   - External service integration silently failing (webhooks not processing, sync broken)
   - Database connection pool exhaustion or persistent lock contention

   **Severity classification**:
   | Severity | Criteria | Response | SLA |
   |----------|----------|----------|-----|
   | P0 — Critical | Core flow broken, data loss risk, security breach | Rollback immediately | 15 min to rollback |
   | P1 — High | Major feature broken, degraded for >10% users | Hotfix within 2 hours or rollback | 2 hr resolution |
   | P2 — Medium | Minor feature broken, workaround exists | Hotfix in next deploy | 24 hr resolution |
   | P3 — Low | Cosmetic, non-blocking, edge case | Track and fix in next sprint | Next release |

   **Hotfix classification** (when rollback is not triggered):
   - **Hotfix-Critical**: Branch from the release tag, fix, deploy independently — skip normal release process
   - **Hotfix-Standard**: Cherry-pick fix onto staging, fast-track through abbreviated QA, deploy with next release
   - **Deferred**: Log as issue, schedule in next sprint — no expedited action

   **Rollback execution**:
   - Follow the documented rollback procedure from the release plan
   - Verify rollback completes successfully (re-run smoke tests)
   - If migrations were run: execute documented reverse migrations or confirm forward-only safety
   - Document what failed, when it was detected, and time-to-rollback

5. **Write verification report** to `.deliberate/releases/{version}/verification.md`

## Output

- Post-deploy verification report
- Health metrics comparison (before/after)
- Rollback execution (if triggered)
- All-clear or incident report

## Transition

Report results to Release Manager. Release Engineer work complete.
