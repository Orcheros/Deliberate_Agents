---
name: release-preflight
description: Pre-deploy verification — tests, migration dry-run, staging validation
allowed-tools: Bash, Read, Write, Glob, Grep
---

# Step 1: Pre-Flight Checks

## Objective

Verify all pre-deployment conditions are met before the release can proceed.

## Instructions

1. **Read the release plan** from the Release Manager
2. **Verify test suite passes**:
   ```bash
   bin/rails test
   bin/rails test:system  # if applicable
   ```
3. **Migration dry-run**:
   - Review all pending migrations for safety
   - Run migrations on a test/staging database
   - Verify rollback works: `bin/rails db:rollback` then `bin/rails db:migrate`
   - Check for long-running migrations that could cause downtime
4. **Feature flag verification**:
   - Confirm all new features behind flags are correctly configured
   - Verify flag defaults are safe (off by default for new features)
5. **Dependency check**:
   - `bundle audit` for security vulnerabilities
   - Verify no pending dependency updates that could break
6. **Staging validation**:
   - Deploy to staging (if not already deployed)
   - Run smoke tests against staging
   - Verify key user flows work end-to-end
7. **Write pre-flight report** to `.deliberate/releases/{version}/preflight.md`

## Output

- Pre-flight checklist with pass/fail for each item
- Migration safety assessment
- Staging validation results
- Any blockers or concerns

## Transition

Report results to Release Manager. Proceed to `/release-deploy` after go/no-go approval.
