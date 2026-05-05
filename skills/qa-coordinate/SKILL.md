---
name: qa-coordinate
description: Monitor QA teammate progress, handle re-tests, and manage dependencies
allowed-tools: Bash, Read, Write, Glob, Grep
---

# Step 3: Coordinate QA Execution

## Objective

Monitor teammate progress, unblock where possible, handle re-test requests, and manage dependencies between test areas.

## Instructions

1. **Monitor teammate status**:
   - Read `.deliberate/status/security-analyst.md`
   - Read `.deliberate/status/integration-tester.md`
   - Read `.deliberate/status/ux-ui-reviewer.md`
   - Check for `blocked` status on any teammate

2. **Read incoming results** as they arrive:
   - `.deliberate/qa/{slug}/results/security-analyst.md`
   - `.deliberate/qa/{slug}/results/integration-tester.md`
   - `.deliberate/qa/{slug}/results/ux-ui-reviewer.md`

3. **Handle blockers**:
   - If a teammate is blocked due to unclear requirements: check the PRD/arch doc yourself and provide clarification by updating their assignment notes
   - If a teammate is blocked due to a code issue: document it as a finding and reassign remaining cases if possible
   - If a teammate is blocked due to environment/setup: escalate to orchestrator

4. **Manage cross-area dependencies**:
   - Security findings may affect integration test priorities
   - Integration test failures may invalidate UX/UI test preconditions
   - If a critical failure is found, assess whether dependent tests should be paused or continued

5. **Handle re-tests**:
   - If engineering fixes are submitted during QA, identify which test cases need re-execution
   - Update affected assignment files with re-test markers
   - Track re-test results separately

6. **Execute self-assigned cases**:
   - Run any cross-cutting test cases you kept for yourself
   - Verify that teammate results are consistent with each other
   - Check for gaps: did any test case fall through the cracks?

7. **Track completion**:
   - Maintain a running tally: total cases, passed, failed, blocked, pending
   - All teammates must complete before proceeding to report

## Completion Criteria

Move to `/qa-report` when:
- All teammates have reported results for all assigned cases
- No cases are in `pending` status
- All blockers are either resolved or documented

## Output

- Updated status tracking
- Blocker escalations (if any)
- Re-test records (if any)
- Self-assigned case results

## Transition

When all results are in -> proceed to `/qa-report`
