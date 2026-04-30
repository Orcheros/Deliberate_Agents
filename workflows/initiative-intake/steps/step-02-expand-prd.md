# Step 2: Expand One-Pager into PRD

## Objective

Write a complete Product Requirements Document that developer agents can execute against without needing further product clarification.

## Instructions

1. **Deep-dive into the codebase** to understand:
   - Existing models, controllers, and views related to this feature
   - Current UI patterns (Tailwind component conventions, Stimulus controllers)
   - Test patterns and coverage in the affected areas
   - Database schema and relationships
   - Any existing service objects, concerns, or shared logic

2. **Write the PRD** with these sections:

   ### Problem Statement
   Expand from the one-pager. Include user impact and business context.

   ### Requirements
   Numbered list of specific, testable requirements. Each must have:
   - Clear description of the behavior
   - Acceptance criteria (Given/When/Then or equivalent)
   - Edge cases to handle

   ### User Experience
   - Describe the user flow step by step
   - Reference any Claude Design mockups if provided in the one-pager
   - Note Stimulus controller needs (new controllers, actions, targets)
   - Describe Tailwind styling expectations (use existing design tokens)

   ### Data Model Changes
   - New models, columns, or relationships
   - Migration details
   - Validation rules

   ### API / Route Changes
   - New routes or modifications to existing routes
   - Controller actions needed
   - Parameter requirements

   ### Task Breakdown
   Ordered list of implementation tasks, each with:
   - Brief description
   - Estimated complexity (small / medium / large)
   - Dependencies on other tasks
   - Relevant existing files to reference

3. **Cross-reference** the PRD against the one-pager to ensure nothing was missed

## Output

Write the PRD to the project's documentation directory, following existing naming conventions. Update the initiative state file with the PRD path.

## Transition

Proceed to `step-03-architecture.md`
