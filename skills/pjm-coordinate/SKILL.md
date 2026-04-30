---
name: pjm-coordinate
description: Monitor cross-agent progress and handle phase transitions
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Step 3: Coordinate Execution

## Objective

Monitor task completion across all agent types, manage phase transitions, and handle blockers.

## Instructions

### 1. Monitor Assignment Status

Check all assignment files for status updates:
```bash
# Check all assignments for this initiative
for f in .deliberate/assignments/*.yaml; do
  echo "$(basename $f): $(grep 'status:' $f | head -1)"
done
```

### 2. Phase Transition Management

When all tasks in a phase are complete:
1. Verify acceptance criteria for every completed task
2. Check for integration issues across tasks (conflicting changes, gaps)
3. If all checks pass, unlock next phase tasks (change `depends_on` blockers)
4. Update initiative state with phase completion

### 3. Blocker Resolution

When a task is marked `blocked`:
1. Read the blocker reason from the assignment file
2. Assess if it's resolvable:
   - **Dependency not met**: Check if the dependency task is truly incomplete
   - **Ambiguous requirement**: Create a decision file for human input
   - **Technical issue**: Create a new task to resolve the issue, then unblock
   - **Cross-agent coordination**: Adjust task ordering or dependencies

### 4. Completion Detection

When all tasks across all phases are complete:
1. Verify every task's acceptance criteria
2. Verify cross-task integration (no conflicting changes across worktrees)
3. Run final test suite (for dev tasks)
4. Update initiative status to `DEV_COMPLETE`
5. This triggers the reviewer agent

### 5. Status Reporting

Maintain a current status in the initiative state file:
```yaml
progress:
  phase_a:
    total: 8
    complete: 5
    in_progress: 2
    blocked: 1
  phase_b:
    total: 7
    complete: 0
    in_progress: 0
    blocked: 0
  blockers:
    - task: "init-001-task-04"
      reason: "Missing HubSpot API key"
      escalated: true
```

### 6. Initiative Completion

When all tasks pass validation:
```yaml
status: "DEV_COMPLETE"
completed_at: "timestamp"
all_phases_complete: true
```

The orchestrator detects `DEV_COMPLETE` and launches the reviewer agent.

## Done

Your coordination work continues until the initiative reaches `DEV_COMPLETE` or `BLOCKED` (requiring human intervention). The session can end when all tasks are assigned and initial monitoring is complete — the orchestrator handles ongoing polling.
