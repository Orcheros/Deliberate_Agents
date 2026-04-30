# Step 3: Architecture Review

## Objective

Determine whether this initiative requires architectural documentation beyond the PRD. If so, document the technical approach.

## Instructions

1. **Evaluate architectural impact**:
   - Does this initiative introduce new data models or significantly modify existing ones?
   - Does it require new Stimulus controllers or significant JS behavior?
   - Does it change authorization or authentication patterns?
   - Does it introduce new external service integrations?
   - Does it affect the existing Rails concern/module structure?
   - Does it require background jobs, caching, or other infrastructure?

2. **If no significant architectural impact**: Skip to Step 4. Note in the state file that no architecture doc was needed.

3. **If architectural documentation is needed**, write it covering:

   ### Technical Approach
   - Chosen pattern and rationale (why this approach over alternatives)
   - How it fits with existing Rails conventions in the project

   ### Model/Schema Design
   - ERD or relationship description
   - Index strategy
   - Migration order

   ### Controller/View Architecture
   - New controller structure
   - Stimulus controller design (targets, values, actions)
   - Partial/component organization
   - Turbo Frame/Stream usage if applicable

   ### Risks and Trade-offs
   - Performance considerations
   - Migration risks for existing data
   - Backward compatibility concerns

## Output

If created, write the architecture doc alongside the PRD. Update the initiative state file.

## Transition

Proceed to `step-04-ready-for-dev.md`
