---
name: release-plan
description: Identify what's ready to ship, assess risk, and create the release plan
allowed-tools: Bash, Read, Write, Glob, Grep
---

# Step 1: Release Planning

## Objective

Identify completed work ready to ship, assess risk, and produce a release plan.

## Instructions

1. **Identify release candidates**:
   - Read `.deliberate/queue/` for initiatives with `QA_COMPLETE` or `REVIEW_READY` status
   - Check git branches for completed work not yet in staging/main
   - Read QA reports for each candidate initiative
   - Verify all acceptance criteria are met

2. **Assess release risk**:
   - For each candidate:
     - **Database migrations**: Any schema changes? Reversible? Zero-downtime safe?
     - **External dependencies**: New API integrations, third-party services?
     - **Feature flags**: Can this be dark-launched and gradually enabled?
     - **Blast radius**: How many users are affected? Core flow or edge feature?
     - **Rollback complexity**: How hard is it to undo if something breaks?

3. **Determine release scope**:
   - Group related changes that should ship together
   - Identify changes that can ship independently
   - Recommend ordering (safest first, highest risk last)
   - Flag anything that should wait for the next release

4. **Create release plan** in `.deliberate/releases/{version}/release-plan.md`:
   - **Version**: Semantic version or date-based identifier
   - **Scope**: What's included (initiative list with summaries)
   - **Risk Assessment**: Per-initiative risk level
   - **Migration Plan**: Database changes in order
   - **Feature Flag Plan**: What's behind flags, rollout strategy
   - **Rollback Plan**: Step-by-step rollback for each component
   - **Timeline**: Pre-deploy, deploy, verify, announce
   - **Team Assignments**: Who does what

5. **Create assignments** for Release Engineer, Release Comms, and Release Marketer

## Output

- Release plan document
- Risk assessment
- Team assignments in `.deliberate/releases/{version}/assignments/`

## Transition

Proceed to `/release-coordinate`.
