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

4. **Process retrospective**:
   - What went well in this release process?
   - What could be improved?
   - Were there unnecessary blockers or delays?
   - Was communication timely and clear?

5. **Write retrospective** to `.deliberate/releases/{version}/retrospective.md`

6. **Update initiative statuses** — mark shipped initiatives as `COMPLETE`

## Output

- Retrospective document
- Updated initiative statuses
- Process improvement recommendations

## Transition

Release complete. Update assignment status.
