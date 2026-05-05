---
name: release-retro
description: Post-release retrospective — what shipped, what broke, what to improve
allowed-tools: Bash, Read, Write, Glob, Grep
---

# Step 3: Release Retrospective

## Objective

Document the release outcome, capture learnings, and identify process improvements.

## Instructions

1. **Document what shipped**:
   - Final list of initiatives and changes included
   - Any last-minute scope changes and why
   - Migration outcomes

2. **Post-release health check**:
   - Error rates before/after deploy
   - Performance metrics before/after
   - User-facing issues reported in the first 24 hours
   - Feature flag rollout status

3. **Capture incidents** (if any):
   - What broke, when it was detected, how it was fixed
   - Time to detection and time to resolution
   - Was the rollback plan used? Did it work?

4. **Release metrics** — calculate and record for trend tracking:

   | Metric | Definition | Target |
   |--------|-----------|--------|
   | Lead time | Merge to staging → deploy to production | < 48 hours |
   | Deploy frequency | Releases per week | 1-2x/week at alpha stage |
   | Change failure rate | Releases requiring hotfix or rollback / total releases | < 15% |
   | Time to recovery | Issue detected → fix deployed (hotfix or rollback) | < 2 hours for P0/P1 |
   | Rollback rate | Rollbacks / total deploys | < 5% |
   | Hotfix count | Hotfixes per release | 0 is ideal, >2 signals process gap |
   | Pre-deploy block rate | Go/no-go blocks / total release attempts | Track trend (should decrease) |
   | Checklist completion time | Release plan created → all checklist items green | Track trend |

   Compare each metric to the previous 3 releases to identify trends.

5. **Process retrospective**:
   - What went well in this release process?
   - What could be improved?
   - Were there unnecessary blockers or delays?
   - Was communication timely and clear?
   - Which metrics improved or regressed vs. recent releases?

6. **Write retrospective** to `.deliberate/releases/{version}/retrospective.md`

7. **Update initiative statuses** — mark shipped initiatives as `COMPLETE`

## Output

- Retrospective document
- Updated initiative statuses
- Process improvement recommendations

## Transition

Release complete. Update assignment status.
