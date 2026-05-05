---
name: qa-assign
description: Assign test cases to QA teammates based on their specialty
allowed-tools: Read, Write
---

# Step 2: Assign Test Cases

## Objective

Route each test case in the test plan to the appropriate QA teammate based on their specialty. Create per-teammate assignment files.

## Instructions

1. **Read the test plan** (`.deliberate/qa/{slug}/test-plan.md`)

2. **Route test cases by specialty**:

   | Category | Primary Assignee | Notes |
   |----------|-----------------|-------|
   | Acceptance (code behavior) | Integration Tester | Verifiable via test execution |
   | Acceptance (UI behavior) | UX/UI Reviewer | Verifiable via view/component inspection |
   | Security | Security Analyst | All security-related cases |
   | Integration | Integration Tester | API, data flow, jobs, webhooks |
   | UX/UI | UX/UI Reviewer | Design fidelity, accessibility, states |
   | Regression (code) | Integration Tester | Backend regressions |
   | Regression (UI) | UX/UI Reviewer | Frontend regressions |
   | Edge Case (data/logic) | Integration Tester | Backend edge cases |
   | Edge Case (UI) | UX/UI Reviewer | Frontend edge cases |

   Some acceptance criteria span both backend and frontend — assign to the teammate who can most directly verify it. If both need to check, create a case for each.

3. **Write per-teammate assignment files**:

   `.deliberate/qa/{slug}/assignments/security-analyst.md`:
   ```markdown
   # QA Assignment: Security Analyst

   ## Meta
   - **Assignee**: security-analyst
   - **Initiative**: {slug}
   - **Assigned**: ISO timestamp
   - **Total Cases**: N

   ## Test Cases

   ### TC-XXX: {Title}
   - **Priority**: critical|high|medium|low
   - **Preconditions**: ...
   - **Steps**:
     1. ...
   - **Expected Result**: ...
   ```

   `.deliberate/qa/{slug}/assignments/integration-tester.md`:
   ```markdown
   # QA Assignment: Integration Tester
   (same structure)
   ```

   `.deliberate/qa/{slug}/assignments/ux-ui-reviewer.md`:
   ```markdown
   # QA Assignment: UX/UI Reviewer
   (same structure)
   ```

4. **Update the test plan** with assignments:
   - Set `assigned_to` on each test case to the teammate name

5. **Handle self-assigned cases**:
   - Cross-cutting test cases that span multiple specialties: assign to yourself
   - Verification of teammate results: keep for `/qa-coordinate`

## Output

- Assignment files in `.deliberate/qa/{slug}/assignments/`
- Updated test plan with assignments
- Summary count per teammate

## Transition

Proceed to `/qa-coordinate` (after teammates have been launched by the orchestrator)
