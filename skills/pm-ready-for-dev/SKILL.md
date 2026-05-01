---
name: pm-ready-for-dev
description: Finalize documentation and signal the initiative is ready for development
allowed-tools: Read, Write, Glob, Grep
---

# Step 4: Ready for Development

## Objective

Finalize all documentation and signal that this initiative is ready for the Project Manager to pick up.

## Instructions

1. **Review all outputs** for completeness:
   - [ ] PRD has numbered requirements with acceptance criteria
   - [ ] Task breakdown is ordered with dependencies noted
   - [ ] Architecture doc exists (if needed) or is explicitly noted as unnecessary
   - [ ] All file paths referenced in the PRD actually exist in the codebase
   - [ ] No TODO or placeholder sections remain in the documents

2. **Validate task sizing**:
   - Each task should be completable by a single developer agent in one session
   - No task should touch more than ~10 files
   - Tasks with `large` complexity should be considered for splitting

3. **Update the initiative state file**:
   ```yaml
   status: "PRD_COMPLETE"
   prd_path: "path/to/prd.md"
   architecture_path: "path/to/arch.md"  # or null
   task_count: 5
   estimated_complexity: "medium"  # small | medium | large
   completed_at: "2024-01-15T10:30:00Z"
   ```

4. **Update the initiative's STATUS.yaml** in the initiative documentation directory:
   ```yaml
   state: "specified"
   id: "<initiative-id>"
   title: "<initiative-title>"
   updated_at: "<ISO 8601 timestamp>"
   updated_by: "product-manager"
   reason: "PRD complete, ready for development"
   ```
   The orchestrator will detect this state change and move the initiative directory from `backlog/` to `specified/`.

5. **Update your agent status**:
   ```yaml
   # .deliberate/status/product-manager.yaml
   status: "idle"
   last_completed: "initiative-slug"
   completed_at: "2024-01-15T10:30:00Z"
   ```

## Output

The initiative is now in `PRD_COMPLETE` state. The orchestrator will detect this and launch the Project Manager agent to begin task assignment.

## Done

Your work on this initiative is complete. The session can end.
