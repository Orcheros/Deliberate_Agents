---
name: onboarding-assess
description: Evaluate current onboarding effectiveness and identify gaps by ICP segment
allowed-tools: Read, Glob, Grep
aaaerrr-zone: "funnel:activation"
---

# Onboarding Assessment

## Objective

Understand the current onboarding experience and identify where users get stuck, drop off, or fail to reach their activation moment.

## Instructions

1. **Map the current onboarding flow**:
   - What happens after account creation? (first screen, first email, first prompt)
   - What's the intended activation sequence? (create operation map -> explore -> export -> invite team)
   - Where are the handoff points between in-app and email?
   - What guidance exists? (tooltips, empty states, help text)

2. **Analyze activation metrics** (from analytics/PRD):
   - What's the defined "aha moment" for each ICP segment?
   - What % of trial users reach activation within the trial period?
   - Where do users drop off in the activation funnel?
   - How does activation differ by ICP segment?

3. **Assess per-ICP experience**:
   - Does the current onboarding speak to each persona's pain?
   - Does the first experience lead to the right feature for their use case?
   - Is the time-to-value appropriate for each segment?
   - Are ICP-specific email sequences differentiated enough?

4. **Identify gaps**:
   - Missing guidance at critical decision points
   - Empty states that don't help the user take the next step
   - Email sequences that don't reinforce in-app progress
   - Features that are hidden or hard to discover at the right time
   - Friction points (forms too long, steps too many, value too delayed)

5. **Benchmark against best practices**:
   - Is there a clear progress indicator?
   - Can the user get value before providing payment?
   - Does the trial experience match the paid experience?
   - Is the upgrade prompt contextual (at the moment of need)?

## Output

Write onboarding assessment with gap analysis, per-ICP findings, and prioritized improvement opportunities. Transition to `/onboarding-design`.
