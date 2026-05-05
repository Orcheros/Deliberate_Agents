---
name: dev-complete
description: Produce clean atomic commits and signal task completion
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Step 4: Complete

## Objective

Produce clean, atomic commits and signal task completion.

## Instructions

1. **Review your changes**:
   ```bash
   git diff
   git status
   ```
   - Are there any unintended changes?
   - Any debug output left in?
   - Any files that shouldn't be committed (`.env`, temp files)?

2. **Stage and commit**:
   - Group related changes into atomic commits
   - Use the commit message format:
     ```
     [initiative-slug] Short imperative description

     - Detail about what changed and why
     - Reference acceptance criteria met

     Co-Authored-By: Claude Code <noreply@anthropic.com>
     ```
   - Separate structural changes (migrations, routes) from behavioral changes (models, controllers) if it makes sense

3. **Final test run**:
   ```bash
   bin/rails test
   ```
   Confirm all tests still pass after committing.

4. **Update your assignment status** in `.deliberate/assignments/{worktree}.md`:

   Add a `## Completion` section at the end:
   ```markdown
   ## Completion
   - **Status**: complete
   - **Completed**: timestamp
   - **Test Result**: pass
   - **Commits**:
     - `abc1234` — Short description
   - **Notes**: Any relevant notes for the project manager
   ```

5. **Update your agent status** in `.deliberate/status/developer-{worktree}.md`:
   ```markdown
   # Status: Developer ({worktree})

   - **Status**: idle
   - **Last Completed**: task-id
   - **Completed**: timestamp
   ```

## Do NOT

- Push to remote (the orchestrator or human handles this)
- Merge branches
- Delete the worktree
- Start another task (the orchestrator assigns the next one)

## Done

Your work on this task is complete. The session can end. The orchestrator will detect the completion and notify the Project Manager agent.
