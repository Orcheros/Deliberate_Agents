---
name: qa-plan
description: Read all specifications and create the comprehensive test plan
allowed-tools: Bash, Read, Glob, Grep, Write
intent: "Decompose all specifications into a comprehensive, categorized test plan"
execution-mode: 4
responsible: qa-lead
accountable: integrator
risk-level: low
inputs:
  information: ["PRD", "architecture doc", "design brief", "story breakdown"]
  artifacts: ["all specification documents", "code diff"]
  access: ["initiative branch", "codebase read access"]
  conditions: ["development complete with DEV_COMPLETE status"]
  people: []
outputs:
  updated-information: ["test coverage analysis"]
  produced-artifacts: ["test plan document"]
  system-state-change: ["initiative status set to QA_IN_PROGRESS"]
  commitments-made: ["all acceptance criteria mapped to test cases"]
  ready-output: ["test plan ready for QA execution"]
---

# Step 1: Create the Test Plan

## Objective

Read every specification artifact for the initiative and decompose them into a comprehensive, testable plan covering acceptance criteria, security, integrations, UX/UI, regression, and edge cases.

## Instructions

1. **Read the initiative state** (`.deliberate/queue/{slug}.yaml`):
   - Identify the initiative branch and current state (should be `DEV_COMPLETE`)
   - Locate paths to PRD, architecture doc, design brief, and story breakdown

2. **Read all specification artifacts**:
   - PRD — especially acceptance criteria, data models, integrations, and failure modes
   - Architecture doc — service design, API contracts, data flows, migration plan
   - Design brief — component specs, states, responsive behavior, accessibility requirements
   - Story breakdown — per-story acceptance criteria and dependencies

3. **Read the actual code changes**:
   - `git diff staging...HEAD` on the initiative branch to see what was built
   - Identify all modified/created files
   - Note which areas of the codebase were touched

4. **Create the test plan** organized by category:

   **Acceptance Criteria Tests** — One test case per AC from every story:
   - Map each AC to a specific, verifiable test
   - Include the source story ID for traceability

   **Security Tests** — Based on architecture doc + security best practices:
   - Authentication and authorization flows
   - Input validation and sanitization
   - Data exposure risks (API responses, logs, error messages)
   - OWASP top 10 relevance

   **Integration Tests** — Based on architecture doc + data flow diagrams:
   - API contract validation
   - Database state after operations
   - Background job behavior
   - External service interactions
   - Webhook handling

   **UX/UI Tests** — Based on design brief:
   - Design fidelity per component
   - All UI states (loading, empty, error, success, disabled)
   - Responsive behavior at each breakpoint
   - Accessibility (WCAG 2.1 AA)
   - Stimulus controller interactions

   **Regression Tests** — Based on code diff:
   - Existing features that share modified files
   - Shared partials, concerns, or services that were changed
   - Routes or controllers that were modified

   **Edge Case Tests** — Based on PRD failure modes + architecture doc:
   - Boundary values, empty inputs, maximum lengths
   - Concurrent operations, race conditions
   - Network failures, timeout scenarios
   - Missing or malformed data

5. **Write the test plan** to `.deliberate/qa/{slug}/test-plan.md`:

   ```markdown
   # Test Plan: {Initiative Title}

   ## Meta
   - **Initiative**: {slug}
   - **Created**: ISO timestamp
   - **Total Cases**: N

   ## Summary
   | Category | Count |
   |----------|-------|
   | Acceptance | N |
   | Security | N |
   | Integration | N |
   | UX/UI | N |
   | Regression | N |
   | Edge Case | N |

   ## Test Cases

   ### TC-001: {Title}
   - **Category**: acceptance
   - **Source**: story-id / AC number
   - **Priority**: critical|high|medium|low
   - **Assigned To**: pending
   - **Status**: pending
   - **Preconditions**: Setup needed
   - **Steps**:
     1. Step 1
     2. Step 2
   - **Expected Result**: What should happen
   ```

6. **Prioritize test cases**:
   - **Critical**: Core acceptance criteria, auth/authz, data integrity
   - **High**: Integration correctness, security vulnerabilities, accessibility blockers
   - **Medium**: Design fidelity, edge cases, regression in related areas
   - **Low**: Cosmetic issues, minor UX enhancements, suggestion-level items

## Output

- Test plan file at `.deliberate/qa/{slug}/test-plan.md`
- Update initiative status to `QA_IN_PROGRESS`

## Transition

Proceed to `/qa-assign`
