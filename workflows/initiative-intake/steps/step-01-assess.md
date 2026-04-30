# Step 1: Assess the One-Pager

## Objective

Evaluate the incoming one-pager for completeness, clarity, and feasibility before investing effort in a full PRD.

## Instructions

1. **Read the one-pager** from the path specified in the initiative's queue file
2. **Read the project's codebase context**:
   - `CLAUDE.md` or `README.md` for project overview
   - Relevant existing features that this initiative touches
   - Current data models and schema related to the initiative
3. **Evaluate against these criteria**:
   - [ ] Problem statement is clear
   - [ ] Target user/persona is identified
   - [ ] Desired outcome is stated (what does "done" look like?)
   - [ ] Scope is reasonable for a single initiative
   - [ ] No obvious conflicts with existing functionality
4. **Determine readiness**:
   - **Ready**: All criteria met → proceed to Step 2
   - **Needs clarification**: Some criteria unclear → write specific questions to `.deliberate/decisions/`, set status to `BLOCKED`
   - **Too large**: Scope exceeds a single initiative → recommend splitting, set status to `BLOCKED`

## Output

Update the initiative state file:
```yaml
status: "PM_IN_PROGRESS"
assessment:
  readiness: "ready"  # ready | needs_clarification | too_large
  notes: "Brief assessment summary"
  concerns: []        # Any risks or questions (non-blocking)
```

## Transition

- If ready → proceed to `step-02-expand-prd.md`
- If not ready → BLOCKED, await human resolution
