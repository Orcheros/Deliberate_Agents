# Step 1: Understand the Task

## Objective

Thoroughly understand what needs to be built before writing any code. Reading existing code is mandatory.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.yaml`):
   - Task description and acceptance criteria
   - Relevant file paths
   - Dependencies and their completion status

2. **Read the referenced PRD** for broader initiative context:
   - Where does this task fit in the overall feature?
   - What tasks come before and after this one?
   - Are there cross-cutting concerns?

3. **Explore the existing codebase**:
   - Read every file listed in `relevant_files`
   - Understand the current data models involved (schema, validations, relationships)
   - Read existing controllers and views in the affected area
   - Check for Stimulus controllers that may need modification
   - Look at existing test coverage for the area you'll be modifying
   - Check `config/routes.rb` for relevant routes

4. **Identify patterns** already established in the project:
   - How are similar features structured?
   - What naming conventions are used?
   - Are there shared concerns, service objects, or helpers?
   - What Tailwind component patterns exist?

5. **Plan your approach** (mental model, not a written document):
   - What files will you create or modify?
   - What's the order of operations?
   - Are there any risks or unknowns?

6. **Update your assignment status**:
   ```yaml
   status: "in_progress"
   started_at: "timestamp"
   ```

## Blockers

If during understanding you discover:
- The task description is ambiguous → mark as `blocked`, explain what's unclear
- A dependency isn't actually complete → mark as `blocked`, reference the dependency
- The task conflicts with existing code → mark as `blocked`, describe the conflict

## Transition

Once you fully understand the task → proceed to `step-02-implement.md`
