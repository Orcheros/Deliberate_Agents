---
name: opportunity-solution-tree
description: Build an Opportunity Solution Tree from a desired outcome, mapping opportunities, solutions, and experiments into a visual tree
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Opportunity Solution Tree

## Objective

Construct an Opportunity Solution Tree (Teresa Torres, *Continuous Discovery Habits*) that connects a desired outcome to the opportunity space, candidate solutions, and validation experiments. The tree makes the reasoning from outcome to action visible and traceable.

## Instructions

1. **Define the desired outcome**:
   - Read the initiative context (one-pager, PRD, or assignment file)
   - Identify the single measurable outcome the team is pursuing
   - Frame it as a behavior change or metric movement: "Increase [metric] from [baseline] to [target]"
   - This becomes the root node of the tree

2. **Map the opportunity space**:
   - Gather inputs: user research, interview transcripts, feedback logs, support tickets, analytics
   - Extract opportunity statements — unmet needs, pain points, and desires expressed as customer problems (not solutions)
   - Format each as: "[User] struggles with / needs / wants [thing] when [context]"
   - Group related opportunities into parent-child clusters (max 3 levels deep)
   - Each opportunity must trace back to at least one piece of evidence (quote, data point, observation)

3. **Brainstorm solutions per opportunity**:
   - For each leaf-level opportunity, generate at least 3 candidate solutions
   - Solutions should vary in scope and approach — avoid converging too early
   - Include both incremental improvements and bold bets
   - Label each solution with a confidence tag: **High** (evidence-backed), **Medium** (informed guess), **Low** (speculative)

4. **Design experiments per solution**:
   - For each solution, define at least one experiment to test the riskiest assumption
   - Use lightweight validation methods: Fake Door, Concierge, Wizard of Oz, prototype test, survey, data analysis
   - Each experiment needs: hypothesis (If/Then/Because), method, success criteria, and estimated cost/effort (S/M/L)
   - Prioritize experiments that are cheap and fast over thorough and slow

5. **Assess and prune the tree**:
   - Score each opportunity branch on: evidence strength (1-5), potential impact (1-5), and feasibility (1-5)
   - Highlight the 2-3 highest-scoring branches as recommended focus areas
   - Mark low-evidence / low-impact branches as "park" — do not delete, but deprioritize
   - Flag any opportunity where evidence is thin but impact is high as "needs research"

6. **Render the visual tree (ASCII)**:
   - Produce the full tree in ASCII art format
   - Structure: Outcome at top, opportunities branching below, solutions under each opportunity, experiments at leaves
   - Use clear indentation and box-drawing characters for readability
   - Example structure:
     ```
     [Desired Outcome]
      ├── Opportunity A
      │   ├── Solution A1
      │   │   └── Experiment A1a
      │   └── Solution A2
      │       └── Experiment A2a
      ├── Opportunity B
      │   ├── Solution B1
      │   │   └── Experiment B1a
      │   ├── Solution B2
      │   │   └── Experiment B2a
      │   └── Solution B3
      │       └── Experiment B3a
      └── Opportunity C (parked — low evidence)
     ```

7. **Write the OST document**:
   - Include: outcome definition, evidence sources, full tree (ASCII), opportunity scoring table, recommended focus branches, and next steps
   - Write to the initiative directory or `.deliberate/reports/{slug}/opportunity-solution-tree.md`

## Output

- A complete Opportunity Solution Tree document containing:
  - Desired outcome definition
  - Opportunity space map with evidence references
  - Solutions per opportunity with confidence tags
  - Experiments per solution with hypotheses and success criteria
  - ASCII tree visualization
  - Scoring table and recommended focus areas

## Constraints

- Every opportunity must connect to real evidence — no invented user needs
- Solutions must remain solution-agnostic at the opportunity level (opportunities describe problems, not solutions)
- Do not collapse the tree prematurely — breadth before depth
- The tree is a living document; mark it as a snapshot with a date
- Do not modify application code — this produces documentation only

## Transition

The OST feeds into `/prioritize-features` to rank the validated solutions, or into `/design-experiments` for deeper experiment planning on the recommended branches. Validated solutions eventually flow into `/pm-intake` to become formal initiative one-pagers.
