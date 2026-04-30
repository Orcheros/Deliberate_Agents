# Step 1: Validate Completed Work

## Objective

Verify that all developer agent work meets the PRD's acceptance criteria before sending to human review.

## Instructions

1. **Re-read the PRD** for this initiative
2. **For each task**:
   - Read the commits produced by the developer agent
   - Verify the code changes match the acceptance criteria
   - Confirm tests exist and pass
   - Check that no task was skipped or partially completed
3. **Cross-task validation**:
   - Do the tasks integrate correctly? (No conflicting changes)
   - Are there gaps between tasks that weren't covered?
   - Does the overall implementation match the PRD's intent?
4. **If issues are found**:
   - Minor issues: note them in the review summary for the human
   - Major issues: set initiative status to `BLOCKED`, create a new task assignment for the fix

## Output

A validation checklist in the initiative state file:
```yaml
validation:
  all_tasks_complete: true
  all_tests_pass: true
  acceptance_criteria_met: true
  issues_found: []
```

## Transition

If validation passes → proceed to `step-02-summarize.md`
If validation fails → `BLOCKED`, create corrective task assignments
