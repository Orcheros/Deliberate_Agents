---
name: release-measure
description: Define success metrics and measurement plan for launch campaigns
allowed-tools: Read, Write, Glob, Grep
---

# Step 3: Measurement Plan

## Objective

Define how we'll measure the success of this launch and what signals to watch.

## Instructions

1. **Define success metrics**:
   - **Awareness**: Email open rates, blog views, social engagement
   - **Adoption**: % of active users who try the new feature within 7/14/30 days
   - **Activation**: % of users who complete the core action of the new feature
   - **Retention impact**: Does this feature improve overall retention?
   - **Revenue impact**: Does this drive upgrades or expansion? (if applicable)

2. **Set targets**:
   - Baseline: current metrics for comparison
   - Target: realistic goals based on user base size and feature significance
   - Stretch: optimistic scenario
   - Failure threshold: below this, we need to investigate

3. **Measurement timeline**:
   - Day 1: Launch day metrics (email sends, open rates, blog traffic)
   - Week 1: Early adoption metrics
   - Week 2-4: Sustained adoption and retention impact
   - Month 2: Long-term impact assessment

4. **Attribution plan**:
   - How will we know which marketing touchpoint drove adoption?
   - UTM parameters for links
   - Feature flag tracking for gradual rollout
   - Cohort comparison (exposed vs. not exposed to campaign)

5. **Write measurement plan** to `.deliberate/releases/{version}/measurement-plan.md`

## Output

- Success metrics with targets
- Measurement timeline
- Attribution methodology
- Data Analyst brief (what queries/reports to run and when)

## Transition

Measurement plan complete. Report to Release Manager.
