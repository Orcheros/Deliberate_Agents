---
name: test-report
description: Document test results with evidence and update test case statuses
allowed-tools: Read, Write
---

# Step 3: Report Results

## Objective

Compile all test execution results into a structured report for the QA Lead. Every result must include evidence.

## Instructions

1. **Compile results** from your test execution into the results file:

   `.deliberate/qa/{slug}/results/integration-tester.md`:
   ```markdown
   # Integration Test Results

   ## Meta
   - **Assignee**: integration-tester
   - **Initiative**: {slug}
   - **Completed**: ISO timestamp

   ## Summary
   | Metric | Count |
   |--------|-------|
   | Total | N |
   | Passed | N |
   | Failed | N |
   | Blocked | N |

   ## New Tests Written
   - `test/integration/feature_name_test.rb`
   - `test/controllers/api/endpoint_test.rb`

   ## Test Case Results

   ### TC-XXX: {Title} — PASS
   - **Evidence**: `bin/rails test test/integration/feature_test.rb`
   - **Output**: X runs, X assertions, 0 failures, 0 errors

   ### TC-YYY: {Title} — FAIL
   - **Evidence**: `bin/rails test test/integration/feature_test.rb:42`
   - **Output**: Expected 200 but got 422. Validation error: ...
   - **Detail**: The endpoint rejects valid input when field X contains special characters
   - **Notes**: Likely a validation regex that's too strict
   ```

2. **For each failure**, include:
   - What was expected vs. what happened
   - The exact command and output that demonstrates the failure
   - Your assessment of severity and likely root cause
   - Whether this is a code bug, a spec ambiguity, or a test environment issue

3. **For each new test written**, include:
   - File path
   - What it tests (which test case it covers)
   - Whether it currently passes or fails

4. **Update your status** in `.deliberate/status/integration-tester.md`:
   ```markdown
   - **Status**: complete
   - **Completed**: ISO timestamp
   ```

## Quality Checks

Before submitting your report:
- Every assigned test case has a result (no gaps)
- Every failure has evidence (no unsupported claims)
- Every blocked case has a clear explanation of why
- New test files are committed to the initiative branch

## Output

- Results file at `.deliberate/qa/{slug}/results/integration-tester.md`
- New test files committed to the initiative branch
- Status updated to `complete`

## Transition

Your work is complete. The QA Lead will aggregate your results with other teammates.
