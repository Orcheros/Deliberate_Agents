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

4. **If issues detected**:
   - Assess severity: P0 (rollback immediately) vs. P1 (hotfix possible) vs. P2 (monitor)
   - For rollback: follow the documented rollback procedure from the release plan
   - Document what failed and why
   - Notify Release Manager immediately

5. **Write verification report** to `.deliberate/releases/{version}/verification.md`

## Output

- Post-deploy verification report
- Health metrics comparison (before/after)
- Rollback execution (if triggered)
- All-clear or incident report

## Transition

Report results to Release Manager. Release Engineer work complete.
