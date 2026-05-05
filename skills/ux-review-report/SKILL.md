---
name: ux-review-report
description: Document UX/UI findings, categorize severity, and write the review report
allowed-tools: Read, Write
---

# Step 3: Report Results

## Objective

Compile all design fidelity and accessibility findings into a structured report for the QA Lead.

## Instructions

1. **Compile all findings** from Steps 1 and 2 into the results file:

   `.deliberate/qa/{slug}/results/ux-ui-reviewer.md`:
   ```markdown
   # UX/UI Review Results

   ## Meta
   - **Assignee**: ux-ui-reviewer
   - **Initiative**: {slug}
   - **Completed**: ISO timestamp

   ## Summary
   | Metric | Count |
   |--------|-------|
   | Total Cases | N |
   | Passed | N |
   | Failed | N |
   | Blocked | N |
   | Total Findings | N |

   ### Findings by Severity
   | Severity | Count |
   |----------|-------|
   | Critical | N |
   | Major | N |
   | Minor | N |
   | Suggestion | N |

   ### Findings by Category
   | Category | Count |
   |----------|-------|
   | Design Fidelity | N |
   | Responsive | N |
   | Accessibility | N |
   | State | N |
   | Interaction | N |
   | Regression | N |

   ## Test Case Results

   ### TC-XXX: {Title} — PASS
   No findings.

   ### TC-YYY: {Title} — FAIL
   - **Notes**: Single accessibility violation

   #### UX-001: Missing aria-label on icon button
   - **Severity**: major
   - **Category**: accessibility
   - **File**: `app/views/features/_toolbar.html.erb:23`
   - **Description**: Delete button uses icon only with no accessible name
   - **Expected**: aria-label='Delete item' per design brief
   - **Actual**: No aria-label present
   - **Remediation**: Add aria-label='Delete item' to the button element
   - **WCAG**: 1.1.1 - Non-text Content

   ## All Findings (Aggregated)

   | ID | Severity | Category | Title | File |
   |----|----------|----------|-------|------|
   | UX-001 | major | accessibility | Missing aria-label on icon button | `_toolbar.html.erb:23` |
   ```

2. **Categorize every finding by severity**:
   - **Critical**: User cannot complete the task, or complete accessibility barrier
   - **Major**: Significant visual deviation from design, or accessibility issue affecting assistive technology users
   - **Minor**: Cosmetic deviation, or accessibility improvement that doesn't block
   - **Suggestion**: Not a defect — an enhancement opportunity

3. **For each test case**, determine status:
   - **Pass**: Implementation matches design brief, no accessibility issues
   - **Fail**: One or more findings of minor severity or above
   - **Blocked**: Cannot evaluate (missing design spec, prerequisite not met)

4. **Include remediation guidance for every finding**:
   - Specific file and line number
   - What to change (not just "fix it" — describe the fix)
   - For accessibility: cite the WCAG criterion and level

5. **Update your status** in `.deliberate/status/ux-ui-reviewer.md`:
   ```markdown
   - **Status**: complete
   - **Completed**: ISO timestamp
   ```

## Quality Checks

Before submitting:
- Every assigned test case has a result
- Every finding has a file path, line number, and remediation
- Every accessibility finding cites a WCAG criterion
- Severity is consistent (accessibility violations are never below "major")
- No vague findings — "the styling looks off" is not acceptable; specify what's different

## Output

- Results file at `.deliberate/qa/{slug}/results/ux-ui-reviewer.md`
- Status updated to `complete`

## Transition

Your work is complete. The QA Lead will aggregate your results with other teammates.
