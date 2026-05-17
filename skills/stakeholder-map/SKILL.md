---
name: stakeholder-map
description: Map stakeholders on a Power x Interest grid and define communication strategies per quadrant
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Stakeholder Map

## Objective

Identify all stakeholders for an initiative, map them on a Power x Interest grid, and define a communication strategy for each quadrant. Surface champions and blockers so the team knows who to engage and how.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What initiative or project is this for?
   - What is the scope and impact area?

2. **Identify all stakeholders**:
   - Internal: engineering, design, product, leadership, support, sales, marketing, legal, finance
   - External: customers, partners, vendors, regulators
   - Don't forget indirect stakeholders — people affected by the change even if not directly involved
   - List name/role, team, and their relationship to the initiative

3. **Assess power level** (ability to influence or block the initiative):
   - High: can approve/reject, controls budget or resources, has veto authority
   - Low: affected by the outcome but cannot directly influence decisions

4. **Assess interest level** (degree of concern about the initiative's outcome):
   - High: directly impacted, actively engaged, has strong opinions
   - Low: peripherally aware, limited direct impact on their work

5. **Place each stakeholder on the grid**:
   - **Manage Closely** (high power, high interest): regular 1:1 updates, involve in key decisions, seek their input proactively
   - **Keep Satisfied** (high power, low interest): periodic high-level updates, don't overwhelm with detail, escalate only when needed
   - **Keep Informed** (low power, high interest): regular broadcast updates, invite to demos, create feedback channels
   - **Monitor** (low power, low interest): minimal communication, include in broad announcements only

6. **Define communication strategy per quadrant**:
   - Frequency: daily / weekly / bi-weekly / monthly / as-needed
   - Channel: Slack, email, meeting, document, demo
   - Detail level: executive summary / working detail / full context
   - Who owns the relationship

7. **Identify champions and blockers**:
   - Champions: stakeholders who actively support and advocate — leverage them
   - Blockers: stakeholders who resist or obstruct — understand their concerns and address them
   - For each blocker: what is their concern, and what would change their position?

## Output

Write deliverable to `.deliberate/reports/{slug}/stakeholder-map.md` including:
- Complete stakeholder list with role and relationship to initiative
- Power x Interest grid placement for each stakeholder
- Communication plan per quadrant (frequency, channel, detail level, owner)
- Champions list with how to leverage them
- Blockers list with concerns and engagement strategy

## Constraints

- Do not place everyone in "Manage Closely" — force honest differentiation
- Every stakeholder must have exactly one quadrant placement
- Communication plans must be specific (not just "keep updated")
- Blockers must have a stated concern and a proposed engagement approach

## Transition

Stakeholder map informs `/summarize-meeting` for targeted distribution and `/retro` for feedback collection.
