---
name: release-coordinate
description: Manage the release team through the checklist and make go/no-go recommendation
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Step 2: Release Coordination

## Objective

Shepherd the release through pre-deploy checks, team coordination, and go/no-go decision.

## Instructions

1. **Pre-deploy checklist**:
   - [ ] Release Engineer: pre-deploy checks complete
   - [ ] Release Engineer: migration dry-run successful
   - [ ] Release Engineer: rollback procedure tested
   - [ ] Release Comms: internal changelog drafted
   - [ ] Release Comms: external release notes drafted
   - [ ] Release Marketer: launch content prepared (if significant release)
   - [ ] All QA reports reviewed — no open critical/high issues
   - [ ] Feature flags configured correctly

2. **Monitor team progress**:
   - Read status files for each release team member
   - Unblock where possible (provide missing context, clarify scope)
   - Escalate blockers to orchestrator if unresolvable

3. **Go/no-go decision**:
   - All checklist items green → recommend GO
   - Critical issues unresolved → recommend NO-GO with explanation
   - Minor issues outstanding → recommend CONDITIONAL GO with risk acknowledgment
   - Write recommendation to `.deliberate/decisions/release-{version}-go-no-go.md`
   - This requires human approval before proceeding

4. **Post-deploy coordination** (after human approves):
   - Monitor Release Engineer's deployment execution
   - Coordinate Release Comms to send announcements
   - Coordinate Release Marketer to publish launch content
   - Track post-deploy verification results

5. **Update release status** in `.deliberate/releases/{version}/status.md`

## Output

- Updated checklist with status
- Go/no-go recommendation in decisions directory
- Post-deploy verification tracking

## Transition

Proceed to `/release-retro` after deploy is verified.
