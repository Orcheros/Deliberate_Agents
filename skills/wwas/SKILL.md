---
name: wwas
description: Decompose initiatives into backlog items using Why-What-Acceptance-Signals format
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# WWAS (Why-What-Acceptance-Signals)

## Objective

Decompose a PRD or initiative into well-structured backlog items using the WWAS format. Each item captures business context (Why), clear scope (What), testable completeness conditions (Acceptance Criteria), and outcome metrics (Signals of Success).

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What initiative or PRD needs decomposition?
   - What is the target granularity (epics, stories, tasks)?

2. **Read the PRD or initiative context**:
   - Read the full PRD, architecture doc, and any design brief
   - Understand the user outcomes, technical approach, and scope boundaries
   - Identify natural decomposition boundaries (features, workflows, components)

3. **Decompose into backlog items**:
   - Each item should be independently deliverable
   - Size items to be completable in 1-3 days of development
   - Identify dependencies between items and note the order

4. **Write each item in WWAS format**:

   **Why** (Business Context):
   - Why this matters now — what's at stake
   - Connect to the initiative's goals or user outcomes
   - Answer: "If we don't do this, what happens?"

   **What** (Description):
   - Clear description of what we're building (not how)
   - Scope boundaries — what's included and excluded
   - User-facing behavior change or system capability added

   **Acceptance Criteria** (Definition of Done):
   - Specific, testable conditions for "done"
   - Written as Given/When/Then or checklist format
   - Include edge cases and error states
   - 3-7 criteria per item

   **Signals of Success** (Outcome Metrics):
   - Metrics that indicate this was the right thing to build
   - Leading indicators measurable within days/weeks of shipping
   - Connect to the initiative's success metrics
   - Answer: "How will we know this worked?"

5. **Order and group items**:
   - Group by epic or feature area
   - Order by dependency (blocking items first)
   - Flag items on the critical path

6. **Validate completeness**:
   - Cross-reference with PRD — is anything missing?
   - Ensure every PRD requirement maps to at least one backlog item
   - Check that acceptance criteria cover the PRD's success criteria

## Output

Write deliverable to `.deliberate/reports/{slug}/backlog-wwas.md` including:
- Initiative context and link to PRD
- Backlog items in WWAS format, grouped by epic
- Dependency graph (which items block which)
- Critical path items flagged
- Coverage check against PRD requirements

## Constraints

- Every item must have all four WWAS sections — no shortcuts
- "What" describes behavior, not implementation details
- Acceptance criteria must be testable without reading the code
- Signals of Success must be measurable metrics, not subjective assessments

## Transition

WWAS backlog feeds into `/prioritization-frameworks` for prioritization and project management for sprint assignment.
