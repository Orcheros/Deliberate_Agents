---
name: pm-ready-for-dev
description: Finalize documentation and signal the initiative is ready for development
allowed-tools: Read, Write, Glob, Grep
intent: "Validate all documentation is complete and signal readiness for development"
execution-mode: 4
responsible: product-manager
accountable: integrator
risk-level: low
inputs:
  information: ["PRD", "architecture doc", "task breakdown"]
  artifacts: ["one-pager", "PRD", "architecture doc"]
  access: ["initiative directory"]
  conditions: ["PRD complete", "architecture doc complete or explicitly skipped"]
  people: []
outputs:
  updated-information: ["validation results"]
  produced-artifacts: []
  system-state-change: ["initiative status set to PRD_COMPLETE"]
  commitments-made: ["initiative is spec-complete"]
  ready-output: ["initiative ready for project manager pickup"]
---

# Step 4: Ready for Development

## Objective

Finalize all documentation and signal that this initiative is ready for the Project Manager to pick up.

## Instructions

1. **Validate artifact co-location**:
   - [ ] All artifacts (one-pager, PRD, architecture doc, design study) are in the **same initiative directory**
   - [ ] File names follow the project's naming convention (`{slug}-{document-type}.md`)
   - [ ] No artifacts were written to cross-cutting spec directories, shared folders, or other initiative directories
   - [ ] The initiative directory path matches what the project's initiative guide prescribes

2. **Review all outputs** for completeness:
   - [ ] PRD has numbered requirements with acceptance criteria
   - [ ] Task breakdown is ordered with dependencies noted
   - [ ] Architecture doc exists (if needed) or is explicitly noted as unnecessary
   - [ ] All file paths referenced in the PRD actually exist in the codebase
   - [ ] No TODO or placeholder sections remain in the documents

3. **Validate task sizing**:
   - Each task should be completable by a single developer agent in one session
   - No task should touch more than ~10 files
   - Tasks with `large` complexity should be considered for splitting

4. **Update the initiative state file**:
   ```yaml
   status: "PRD_COMPLETE"
   prd_path: "path/to/prd.md"
   architecture_path: "path/to/arch.md"  # or null
   task_count: 5
   estimated_complexity: "medium"  # small | medium | large
   completed_at: "2024-01-15T10:30:00Z"
   ```

5. **Update the initiative's STATUS.yaml** in the initiative documentation directory:
   ```yaml
   state: "specified"
   id: "<initiative-id>"
   title: "<initiative-title>"
   updated_at: "<ISO 8601 timestamp>"
   updated_by: "product-manager"
   reason: "PRD complete, ready for development"
   ```
   The orchestrator will detect this state change and move the initiative directory from `backlog/` to `specified/`.

6. **Update your agent status**:
   Update `.deliberate/status/product-manager.md`:
   ```markdown
   # Status: Product Manager

   - **Status**: idle
   - **Last Completed**: initiative-slug
   - **Completed**: 2024-01-15T10:30:00Z
   ```

## Output

The initiative is now in `PRD_COMPLETE` state. The orchestrator will detect this and launch the Project Manager agent to begin task assignment.

## Done

Your work on this initiative is complete. The session can end.
