---
name: qa-report
description: Aggregate all QA results into a report and make a go/no-go recommendation
allowed-tools: Bash, Read, Write, Glob, Grep
---

# Step 4: QA Report and Recommendation

## Objective

Aggregate all test results from all QA teammates into a unified report. Make a clear go/no-go recommendation with evidence.

## Instructions

1. **Collect all results**:
   - Read `.deliberate/qa/{slug}/results/security-analyst.md`
   - Read `.deliberate/qa/{slug}/results/integration-tester.md`
   - Read `.deliberate/qa/{slug}/results/ux-ui-reviewer.md`
   - Include your own self-assigned case results

2. **Compile statistics**:
   ```
   Total test cases: N
   Passed: N (X%)
   Failed: N (X%)
   Blocked: N (X%)
   
   By category:
     Acceptance: N/N passed
     Security: N/N passed
     Integration: N/N passed
     UX/UI: N/N passed
     Regression: N/N passed
     Edge Cases: N/N passed
   
   By severity of failures:
     Critical: N
     Major: N
     Minor: N
   ```

3. **List all failures** grouped by severity:
   - For each failure: test case ID, title, what failed, evidence, which teammate found it
   - For security findings: include OWASP category and remediation guidance
   - For accessibility findings: include WCAG criterion

4. **Make the recommendation**:

   **GO** — All critical and high-priority cases pass. Minor/medium failures are documented.
   ```yaml
   recommendation: "go"
   confidence: "high"
   summary: "All acceptance criteria met. N minor issues documented as known issues."
   ```

   **NO-GO** — Critical failures or unmet acceptance criteria.
   ```yaml
   recommendation: "no-go"
   confidence: "high"
   summary: "N critical failures found. Key issues: [list]"
   send_back_to: "engineering"
   required_fixes:
     - "TC-XXX: Description of what needs fixing"
   ```

   **CONDITIONAL GO** — No critical failures, but some high-priority issues.
   ```yaml
   recommendation: "conditional-go"
   confidence: "medium"
   summary: "Core functionality works. N high-priority issues need human risk assessment."
   conditions:
     - "Issue X is acceptable if Y"
   requires_human_decision: true
   ```

5. **Write the QA report** to `.deliberate/qa/{slug}/qa-report.md`:

   ```markdown
   # QA Report: {Initiative Title}
   
   ## Summary
   - **Recommendation**: GO / NO-GO / CONDITIONAL GO
   - **Test Cases**: N total, N passed, N failed, N blocked
   - **Critical Issues**: N
   
   ## Results by Category
   ### Acceptance Criteria
   [table of results]
   
   ### Security
   [findings with severity and remediation]
   
   ### Integration
   [results with evidence]
   
   ### UX/UI
   [findings with severity and file references]
   
   ### Regression
   [results]
   
   ### Edge Cases
   [results]
   
   ## Failures Requiring Action
   [ordered by severity, with clear remediation steps]
   
   ## Known Issues (Acceptable)
   [minor issues documented for tracking]
   
   ## Recommendation
   [detailed justification for the go/no-go call]
   ```

6. **Update initiative status**:
   - If GO or CONDITIONAL GO: set status to `QA_COMPLETE`
   - If NO-GO: set status to `QA_FAILED` with required fixes listed
   - The orchestrator will handle routing back to engineering or to human sign-off

7. **Commit the QA report** to the initiative branch

## Output

- QA report at `.deliberate/qa/{slug}/qa-report.md`
- Updated initiative state in `.deliberate/queue/{slug}.yaml`
- Orchestrator can now route to human for final sign-off (or back to engineering)

## Transition

QA Lead work is complete. The orchestrator takes over for human sign-off routing.
