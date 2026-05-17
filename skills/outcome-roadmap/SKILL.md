---
name: outcome-roadmap
description: Transform a feature list into an outcome-focused roadmap using Now/Next/Later prioritization
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Outcome Roadmap

## Objective

Transform a feature or initiative list into an outcome-focused roadmap. Shift from "what we're building" to "what customer outcome we're enabling." Prioritize using the Now/Next/Later framework. Based on Josh Seiden's outcome-based roadmap methodology.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Where is the feature/initiative list?
   - What is the product's North Star Metric or primary goal?

2. **Read the feature/initiative list**:
   - Gather all proposed features, initiatives, or backlog items
   - Include any existing prioritization or stakeholder requests

3. **Map each feature to a customer outcome**:
   - For each item, ask: "What will the customer be able to do or achieve that they can't today?"
   - Write the outcome as a behavior change or capability gain
   - If a feature doesn't map to a clear outcome, flag it for review
   - Bad: "Add search bar" — Good: "Users can find relevant content in under 5 seconds"

4. **Group by outcome theme**:
   - Cluster related outcomes into themes (e.g., "Faster onboarding", "Self-serve analytics")
   - Each theme should represent a meaningful shift in customer capability
   - Limit to 3-5 themes to maintain focus

5. **Prioritize using Now/Next/Later**:
   - **Now** (current quarter): actively working on, committed, resourced
   - **Next** (next quarter): validated and scoped, waiting for capacity
   - **Later** (future): important but not yet scoped or validated
   - Do not assign dates or time estimates — the framework is about sequence, not schedule

6. **Write outcome statements for each item**:
   - Outcome statement: what changes for the customer
   - Success metrics: how we'll know the outcome was achieved
   - Key deliverables: the work required (without dates or estimates)

7. **Produce the roadmap document**:
   - Organized by theme, then by Now/Next/Later within each theme
   - Each item has: outcome, metrics, deliverables
   - Include a visual summary (text-based table or list)

## Output

Write deliverable to `.deliberate/reports/{slug}/outcome-roadmap.md` including:
- Product goal / North Star Metric
- Outcome themes (3-5)
- Roadmap items organized by theme and Now/Next/Later
- Per item: outcome statement, success metrics, key deliverables
- Items that didn't map to outcomes (flagged for review)

## Constraints

- No dates or time estimates — use Now/Next/Later only
- Every item must have an outcome statement, not just a feature description
- Emphasize outcomes over outputs throughout
- Limit to 3-5 themes — if there are more, consolidate or defer

## Transition

Outcome roadmap feeds into `/brainstorm-okrs` for OKR alignment and `/wwas` for backlog decomposition.
