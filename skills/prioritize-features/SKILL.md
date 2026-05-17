---
name: prioritize-features
description: Analyze, categorize, and prioritize feature requests and ideas into a scored, ranked backlog with strategic rationale
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Prioritize Features

## Objective

Take a set of feature requests, ideas, or validated opportunities and produce a prioritized backlog with transparent scoring and strategic rationale. This skill merges request analysis, triage, and prioritization into a single comprehensive pass.

## Instructions

1. **Ingest the feature list**:
   - Read the input: feature requests (from support, sales, feedback), brainstorm output (from `/brainstorm-ideas`), validated opportunities (from `/opportunity-solution-tree`), or a raw backlog
   - For each item, capture:
     - **Description**: What is being requested or proposed
     - **Source**: Where it came from (customer request, internal idea, research finding, competitor gap)
     - **Requester segment**: Which user segment, ICP tier, or internal team
     - **Frequency**: How many times this has been requested or surfaced (if available)
     - **Raw quotes or evidence**: Supporting data points

2. **Categorize by theme**:
   - Group features into thematic clusters (e.g., onboarding, collaboration, reporting, performance, integrations)
   - Identify themes with the highest concentration of requests — these signal systemic needs
   - Flag any items that don't fit existing themes as potential new opportunity areas
   - Note cross-cutting items that touch multiple themes

3. **Assess strategic alignment**:
   - For each feature, evaluate alignment with:
     - **Product vision**: Does it move toward the stated north star?
     - **Current strategy**: Does it support this quarter's/half's strategic bets?
     - **Target ICP**: Does it serve the primary customer segment or a secondary one?
     - **Competitive positioning**: Does it defend an existing advantage or close a gap?
   - Tag each item: **Core** (directly aligned), **Adjacent** (indirectly supports strategy), **Tangential** (nice-to-have, not strategic), **Anti** (conflicts with strategy)

4. **Score each feature**:
   - Apply **RICE scoring** as the primary framework:
     - **Reach**: How many users/accounts will this affect per quarter? (estimate a number)
     - **Impact**: How much will it move the target metric per user? (3 = massive, 2 = high, 1 = medium, 0.5 = low, 0.25 = minimal)
     - **Confidence**: How strong is the evidence? (100% = strong data, 80% = some data, 50% = intuition, 20% = speculative)
     - **Effort**: Person-weeks to build (estimate a number)
     - **RICE Score** = (Reach x Impact x Confidence) / Effort
   - If RICE is not applicable (early-stage, no reach data), fall back to **weighted scoring**:
     - Criteria: Strategic Fit (25%), User Impact (25%), Evidence Strength (20%), Feasibility (15%), Urgency (15%)
     - Score each criterion 1-5, compute weighted total

5. **Apply strategic overrides**:
   - After scoring, review the ranked list for strategic sense:
     - Does a foundational capability need to rank higher despite low RICE? (platform investments)
     - Are there regulatory or compliance items that must be done regardless of score?
     - Are there quick wins (low effort, moderate impact) that should be pulled forward for momentum?
   - Document any manual overrides with explicit rationale — never silently reorder

6. **Produce the prioritized backlog**:
   - Rank all features by score (RICE or weighted), with overrides applied
   - For each item in the final list, include:
     - Rank and score
     - Feature description
     - Theme
     - Strategic alignment tag
     - Source and frequency data
     - RICE/weighted score breakdown
     - Override rationale (if any)
   - Group the list into tiers:
     - **Tier 1 — Do Next**: Top 3-5 items, strong evidence, high strategic alignment
     - **Tier 2 — Plan Soon**: Next 5-10 items, solid scores, may need more validation
     - **Tier 3 — Backlog**: Remaining items, parked for future consideration
     - **Tier 4 — Decline**: Items that conflict with strategy or have insufficient evidence; include rationale for declining

7. **Write the prioritization document**:
   - Include: input summary, thematic analysis, scoring methodology and results, tiered backlog, override rationale, and recommended next actions
   - Write to the initiative directory or `.deliberate/reports/{slug}/prioritized-backlog.md`

## Output

- A prioritization document containing:
  - Feature inventory with source, segment, and frequency data
  - Thematic groupings
  - Strategic alignment assessment
  - RICE or weighted scores per feature
  - Tiered prioritized backlog (Tier 1-4) with rationale
  - Override explanations
  - Recommended next actions per tier

## Constraints

- Every prioritization decision must have a documented rationale — no black-box rankings
- Do not inflate confidence scores — be honest about evidence gaps
- Strategic alignment tags must reference the actual product vision/strategy, not assumed priorities
- Declining a feature is a valid and important outcome — document why clearly
- Do not modify application code — this produces documentation only

## Transition

Tier 1 items feed into `/pm-intake` to become formal initiative one-pagers. Tier 2 items may need `/design-experiments` or `/customer-interview-guide` to gather more evidence before promotion. Tier 4 items are communicated back to requesters with rationale.
