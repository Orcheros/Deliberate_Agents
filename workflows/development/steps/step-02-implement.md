# Step 2: Implement

## Objective

Write the code to fulfill the task's requirements, following existing project patterns exactly.

## Instructions

1. **Work methodically** through the implementation:
   - Start with data model changes (migrations, model validations, relationships)
   - Then build controller logic
   - Then views and partials
   - Then Stimulus controllers if needed
   - Then add/modify routes

2. **Rails conventions**:
   - Follow RESTful resource patterns
   - Use strong parameters
   - Use Rails form helpers and conventions
   - Place business logic in models or service objects (follow existing patterns)
   - Use concerns where the project already uses them
   - Follow existing callback patterns (but prefer explicit over implicit)

3. **Tailwind CSS**:
   - Use the project's existing Tailwind utility patterns
   - Reference the tailwind.config.js for custom colors, spacing, etc.
   - Match the visual style of existing pages
   - If a Claude Design mockup is referenced, implement it faithfully

4. **Stimulus JS**:
   - Follow the project's controller naming conventions
   - Use `data-controller`, `data-action`, `data-{controller}-target` properly
   - Keep controllers focused — one concern per controller
   - Use Stimulus values for configuration, targets for DOM references

5. **Do NOT**:
   - Add features beyond the task scope
   - Refactor unrelated code
   - Add comments to code you didn't write
   - Over-engineer or add unnecessary abstractions
   - Install new gems without explicit approval in the task

## Quality Checks During Implementation

- Does each change follow existing patterns?
- Are you handling the edge cases listed in the acceptance criteria?
- Have you considered authorization/access control?
- Are form inputs properly validated (model + client-side if appropriate)?

## Transition

Once implementation is complete → proceed to `step-03-test.md`
