---
name: dev-understand
description: Understand the assigned task before writing code
allowed-tools: Read, Glob, Grep, Bash
---

# Step 1: Understand the Task

## Objective

Thoroughly understand what needs to be built before writing any code. Reading existing code is mandatory.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Task description, use cases, and acceptance criteria
   - Before/after behavior — understand what changes
   - Boundary — what is explicitly out of scope (respect this strictly)
   - Dependencies and their completion status

2. **Read the pattern reference file FIRST**:
   - The `pattern_reference` field points to an existing file that follows the same pattern you should use
   - Read it carefully — mirror its structure, naming conventions, and approach
   - This is your single most important context signal

3. **Read the "read before starting" files in order**:
   - The `read_before_starting` list is ordered by importance
   - Read every file listed, top to bottom
   - These give you the context needed to make good implementation decisions

4. **Internalize the anti-patterns**:
   - The `anti_patterns` field lists things that look correct but are wrong for this codebase
   - These are hard-won lessons — do not ignore them
   - If you find yourself tempted to do something listed here, stop and reconsider

5. **Review the test strategy**:
   - `test_file`: where to write your tests
   - `model_after`: an existing test file to use as a template for structure and conventions
   - `fixtures`: which fixture files to use for test data
   - Read the model-after test file before writing any tests

6. **Read the referenced PRD** for broader initiative context:
   - Where does this task fit in the overall feature?
   - What tasks come before and after this one?
   - Are there cross-cutting concerns?

7. **Explore additional codebase context** (beyond what was listed):
   - Check `config/routes.rb` for relevant routes
   - Look for shared concerns, service objects, or helpers in the pattern reference area
   - Check for Stimulus controllers that may need modification

8. **Plan your approach** (mental model, not a written document):
   - What files will you create or modify?
   - What's the order of operations?
   - Does your plan stay within the boundary? If not, adjust.

9. **Update your assignment status**:
   ```yaml
   - **Status**: in_progress
   - **Started**: timestamp
   ```

## Blockers

If during understanding you discover:
- The task description is ambiguous -> mark as `blocked`, explain what's unclear
- A dependency isn't actually complete -> mark as `blocked`, reference the dependency
- The task conflicts with existing code -> mark as `blocked`, describe the conflict

## Transition

Once you fully understand the task -> proceed to `/dev-implement`
