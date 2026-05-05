---
name: release-deploy
description: Execute the deployment procedure with logging and monitoring
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Step 2: Deploy

## Objective

Execute the deployment according to the release plan, with detailed logging.

## Instructions

1. **Confirm approval**: Verify the Release Manager's go/no-go decision has been approved by human
2. **Pre-deploy snapshot**:
   - Record current error rates and performance baselines
   - Note current git SHA in production
   - Confirm rollback procedure is documented and ready
3. **Execute deployment**:
   - Merge release branch to main/production branch
   - Tag the release: `git tag -a v{version} -m "Release {version}"`
   - Push to trigger deployment pipeline
   - Monitor deployment logs for errors
4. **Migration execution** (if applicable):
   - Verify migrations run in the correct order
   - Monitor for lock timeouts or long-running operations
   - Verify data backfills complete successfully
5. **Feature flag activation** (if applicable):
   - Enable flags per the rollout plan (gradual or full)
   - Verify flag state is correct
6. **Log everything** to `.deliberate/releases/{version}/deploy-log.md`

## Output

- Deployment execution log with timestamps
- Migration execution results
- Feature flag state confirmation
- Ready for post-deploy verification

## Transition

Proceed immediately to `/release-verify`.
