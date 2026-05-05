---
name: dev-implement
description: Write code to fulfill the task requirements following existing patterns
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

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

5. **Mirror the pattern reference**:
   - Your assignment's `pattern_reference` file is your north star
   - Match its structure, naming, method signatures, and conventions
   - If your implementation looks different from the pattern reference, ask yourself why — the deviation is likely wrong

6. **Respect the boundary**:
   - Your assignment's `boundary` field lists what is explicitly out of scope
   - Do NOT touch, fix, or improve anything listed there — even if it looks broken
   - If you discover something that needs attention outside your boundary, note it in your status file but do not act on it

7. **Do NOT**:
   - Add features beyond the task scope
   - Refactor unrelated code
   - Add comments to code you didn't write
   - Over-engineer or add unnecessary abstractions
   - Install new gems without explicit approval in the task
   - Do anything listed in the `anti_patterns` field of your assignment

## Quality Checks During Implementation

- Does each change mirror the pattern reference?
- Are you staying within the boundary?
- Are you handling the edge cases listed in the acceptance criteria?
- Does the before/after behavior match what's specified in your assignment?
- Have you considered authorization/access control?
- Are form inputs properly validated (model + client-side if appropriate)?

## Transition

Once implementation is complete -> proceed to `/dev-test`
