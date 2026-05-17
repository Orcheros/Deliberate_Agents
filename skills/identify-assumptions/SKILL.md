---
name: identify-assumptions
description: Map, categorize, and prioritize the riskiest assumptions for both existing and new products using an Impact x Evidence matrix
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Identify Assumptions

## Objective

Surface all implicit and explicit assumptions underlying a product initiative, categorize them by type, and prioritize them by risk (high impact + low evidence = highest risk). Produce a ranked assumption list with a suggested experiment type per assumption, enabling the team to systematically de-risk before building.

## Instructions

1. **Read the initiative context**:
   - Read the one-pager, PRD, brainstorm output, or assignment file
   - Identify the proposed solution, target user, desired outcome, and key claims
   - Note any stated assumptions, but focus primarily on unstated ones — the beliefs the plan takes for granted

2. **Extract assumptions by category**:

   **For existing products, use these four categories:**

   - **Value assumptions**: Will users find this valuable? Will it solve their problem?
     - "Users want [feature]"
     - "This will reduce [pain point]"
     - "Users will switch from [current behavior] to [new behavior]"
     - "This is more important to users than [alternative priority]"

   - **Usability assumptions**: Can users figure out how to use it?
     - "Users will understand [concept/UI element]"
     - "The workflow is intuitive enough that users won't need help"
     - "Users will discover [feature] through [mechanism]"

   - **Viability assumptions**: Can the business sustain it?
     - "We can deliver this at a cost that supports our margin"
     - "This won't cannibalize [existing revenue stream]"
     - "The unit economics work at [scale]"
     - "Legal/compliance requirements are met"

   - **Feasibility assumptions**: Can we build it?
     - "The existing architecture supports [capability]"
     - "We can integrate with [external system] reliably"
     - "Performance will be acceptable at [load level]"
     - "We have the skills/tools to build [component]"

   **For new products, add these additional categories:**

   - **Go-to-Market assumptions**: Can we reach and convert users?
     - "Our target user can be reached through [channel]"
     - "The acquisition cost will be below [threshold]"
     - "Users will pay [price] for this"
     - "Word-of-mouth / virality will contribute to growth"

   - **Strategy assumptions**: Is this the right thing to build?
     - "The market is large enough to justify investment"
     - "Timing is right — the market is ready"
     - "We can differentiate from [competitors]"
     - "This aligns with our long-term strategic direction"

   - **Team assumptions**: Can this team execute?
     - "We have the domain expertise needed"
     - "We can hire [role] in time"
     - "The team can shift focus without disrupting existing commitments"

   - **Legal/Regulatory assumptions**: Are we allowed to do this?
     - "No regulatory approval is needed"
     - "Data handling complies with [regulation]"
     - "IP/patent landscape is clear"
     - "Terms of service of [dependency] allow this use"

3. **Prioritize with Impact x Evidence matrix**:
   - For each assumption, score two dimensions:
     - **Impact if wrong** (1-5): How badly does the initiative fail if this assumption is false?
       - 5 = initiative is dead
       - 4 = major pivot required
       - 3 = significant rework
       - 2 = minor adjustment
       - 1 = negligible effect
     - **Evidence strength** (1-5): How much evidence supports this assumption being true?
       - 5 = strong data, validated
       - 4 = some data, mostly confident
       - 3 = anecdotal evidence, mixed signals
       - 2 = informed guess, no direct data
       - 1 = pure speculation, no evidence
   - **Risk score** = Impact x (6 - Evidence): higher score = riskier assumption
   - Plot on a 2x2 matrix:
     - **High Impact, Low Evidence** = "Test immediately" (top priority)
     - **High Impact, High Evidence** = "Monitor" (validated but critical)
     - **Low Impact, Low Evidence** = "Note and move on"
     - **Low Impact, High Evidence** = "Safe to assume"

4. **Suggest experiment type per assumption**:
   - For each "Test immediately" assumption, recommend a validation method:
     - Value: customer interviews, fake door test, landing page, survey
     - Usability: prototype test, usability study, first-click test
     - Viability: financial modeling, competitive analysis, pricing test
     - Feasibility: technical spike, proof of concept, architecture review
     - Go-to-Market: ad campaign test, channel experiment, beta waitlist
     - Strategy: market sizing research, expert interviews, competitive teardown
     - Team: skills audit, hiring timeline analysis
     - Legal: legal review, regulatory consultation
   - Note the estimated cost/time to validate: S (days), M (1-2 weeks), L (weeks-months)

5. **Identify assumption clusters and dependencies**:
   - Look for assumptions that are connected — if one falls, others fall with it
   - Identify "load-bearing" assumptions that the entire initiative rests on
   - Note any assumptions that, if validated, would make other assumptions moot
   - Order validation sequence: test foundational assumptions before dependent ones

6. **Write the assumption map document**:
   - Include: initiative summary, complete assumption list by category, Impact x Evidence scores, 2x2 matrix, prioritized risk list, suggested experiments, dependency map, and recommended validation sequence
   - Write to the initiative directory or `.deliberate/reports/{slug}/assumption-map.md`

## Output

- An assumption map document containing:
  - All identified assumptions organized by category
  - Impact x Evidence score for each assumption
  - 2x2 risk matrix visualization
  - Ranked list of riskiest assumptions (highest risk first)
  - Suggested experiment type and cost estimate per high-risk assumption
  - Assumption dependency map
  - Recommended validation sequence

## Constraints

- Aim to surface at least 15-20 assumptions — most plans have more hidden assumptions than people realize
- Do not only list assumptions the team already knows about; actively look for blind spots
- Score honestly — high confidence should require actual evidence, not conviction
- Every "Test immediately" assumption must have a suggested experiment; do not leave the team with risk but no action
- Do not modify application code — this produces documentation only

## Transition

The ranked assumption list feeds directly into `/design-experiments` to plan validation experiments for the highest-risk assumptions. After experiments are run and data collected, results update the evidence scores and the assumption map should be revised.
