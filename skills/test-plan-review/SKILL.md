---
name: test-plan-review
description: Read assigned test cases, understand scope, and identify dependencies
allowed-tools: Bash, Read, Glob, Grep
---

# Step 1: Review Assigned Test Cases

## Objective

Read your test case assignments from the QA Lead, understand the scope of what you need to test, and identify any dependencies or prerequisites.

## Instructions

1. **Read your assignment file** (`.deliberate/qa/{slug}/assignments/integration-tester.md`):
   - List of test cases assigned to you
   - Priority of each case
   - Preconditions and expected results

2. **Read the initiative context**:
   - PRD sections on data models, APIs, integrations, and background jobs
   - Architecture doc sections on service design, data flows, and external dependencies
   - The actual code changes: `git diff staging...HEAD` on the initiative branch

3. **Map test cases to code**:
   - For each test case, identify the specific files/methods being tested
   - Locate existing test coverage for those areas
   - Note which test cases can share setup/fixtures

4. **Identify dependencies**:
   - Test cases that must run in order (e.g., create before read)
   - External services that need to be mocked or stubbed
   - Database state prerequisites (fixtures, seeds)
   - Background job execution requirements

5. **Plan execution order**:
   - Group related cases that share setup
   - Run critical priority first
   - Run independent cases before dependent ones

6. **Update your status**:
   ```yaml
   - **Status**: in_progress
   - **Started**: ISO timestamp
   - **Total Assigned**: N
   ```

## Blockers

If you discover:
- A test case is unclear or untestable as written -> note it, proceed with others
- Required test infrastructure is missing -> mark as `blocked`, describe what's needed
- A precondition can't be met -> mark the specific case as `blocked`

## Transition

Proceed to `/test-integration`
