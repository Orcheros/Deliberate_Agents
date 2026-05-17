---
name: design-experiments
description: Design pretotype and validation experiments to test product assumptions before building — Fake Door, Concierge, Wizard of Oz, and more
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Design Experiments

## Objective

Design lightweight validation experiments to test product assumptions and reduce risk before committing to full implementation. This skill covers pretotyping and qualitative validation methods — not statistical A/B testing (see `/experiment-design` for that).

## Instructions

1. **Identify what needs validation**:
   - Read the initiative context, assumption list (from `/identify-assumptions`), or assignment file
   - List the assumptions or hypotheses that need testing
   - For each, clarify: What do we believe? Why does it matter? What happens if we are wrong?
   - Prioritize: focus on assumptions that are high-impact AND low-evidence first

2. **Select experiment type per assumption**:
   - Match each assumption to the most appropriate validation method:

   **For new products / unvalidated ideas (pretotyping — Alberto Savoia, *The Right It*):**
   - **Fake Door**: Advertise a feature that does not exist yet; measure click-through or sign-up intent. Best for: demand validation.
   - **Concierge**: Deliver the value proposition manually to a small set of users, with no automation. Best for: validating the value prop and workflow before building.
   - **Wizard of Oz**: Present an automated-looking interface, but fulfill requests manually behind the scenes. Best for: testing UX assumptions when the backend is uncertain.
   - **Pinocchio**: Build a non-functional physical or digital shell (looks real, does nothing). Best for: testing form factor, branding, or first impressions.
   - **Mechanical Turk**: Use human labor to simulate what technology would eventually do. Best for: testing feasibility of an AI/ML/automation concept.
   - **One-Night Stand**: Deliver the full experience once, manually, to a single customer. Best for: end-to-end validation of a complex workflow.
   - **Landing Page / Smoke Test**: Put up a page describing the product and collect sign-ups or pre-orders. Best for: market demand signals.
   - **Crowdfunding Validation**: Launch a campaign to test willingness to pay. Best for: pricing and demand validation for physical or premium products.

   **For existing products / feature validation:**
   - **Feature Flag Rollout**: Ship to a small percentage of users, monitor metrics. Best for: validating incremental changes with real usage data.
   - **Prototype Test**: Build a clickable prototype (Figma, HTML mock) and run moderated usability sessions. Best for: UX and workflow validation.
   - **Usability Study**: Task-based observation with 5-8 participants. Best for: identifying friction points before launch.
   - **Survey / Intercept**: In-app or email survey targeting specific user segments. Best for: preference, satisfaction, or intent data at scale.
   - **Data Analysis**: Analyze existing behavioral data to validate or refute an assumption. Best for: assumptions that existing data can already answer.

3. **Write experiment cards**:
   - For each experiment, produce a card with:
     - **Assumption being tested**: State it explicitly
     - **Hypothesis**: If [intervention], then [outcome], because [mechanism]
     - **Method**: Which experiment type and how it will be executed
     - **Target audience**: Who participates, how they are recruited
     - **Success criteria**: Quantitative threshold or qualitative signal that validates the assumption
     - **Failure criteria**: What result would invalidate the assumption
     - **Required resources**: People, tools, budget, access needed
     - **Timeline**: Duration of the experiment (days/weeks)
     - **Risk if skipped**: What happens if we skip this experiment and build anyway

4. **Sequence the experiments**:
   - Order experiments by: cost (cheapest first), speed (fastest first), and dependency (foundational assumptions before derivative ones)
   - Identify which experiments can run in parallel vs. which are sequential
   - Flag any experiments that require human execution (the agent cannot run them) with a `[HUMAN GATE]` marker

5. **Define data collection plan**:
   - For each experiment: what data will be collected, how, and by whom
   - Specify tools or instrumentation needed (analytics events, spreadsheet, interview recordings)
   - Define how results will be documented and shared

6. **Write the experiment plan**:
   - Include: assumption inventory, experiment cards, sequence/timeline, resource requirements, and data collection plan
   - Write to the initiative directory or `.deliberate/reports/{slug}/experiment-plan.md`

## Output

- An experiment plan document containing:
  - Numbered list of assumptions being tested
  - Experiment card for each assumption (hypothesis, method, success/failure criteria, resources, timeline)
  - Experiment sequence with parallel/sequential mapping
  - Resource and tooling requirements
  - `[HUMAN GATE]` markers where human execution is required

## Constraints

- This skill is for pre-build validation — not for live A/B testing of shipped features (use `/experiment-design` for that)
- Every experiment must have explicit success AND failure criteria defined before execution
- Prefer the cheapest, fastest experiment that can answer the question — do not over-engineer validation
- Do not assume experiments will succeed — design for learning, not confirmation
- Do not modify application code — this produces documentation only

## Transition

After experiments are run and data is collected (by humans), results feed into `/opportunity-solution-tree` to update the tree with validated learnings, or into `/prioritize-features` to rank the validated solution set.
