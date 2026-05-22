---
name: onboarding-design
description: Design improved onboarding flows, in-app guidance, and activation sequences
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:activation"
---

# Onboarding Design

## Objective

Design improved onboarding flows based on the assessment. Produce specifications that Developer and Content Writer agents can implement.

## Instructions

### 1. Design Per-ICP Onboarding Flows

For each ICP segment:
- **First 5 minutes**: What should happen immediately after account creation?
- **First session**: What's the minimum viable experience that demonstrates value?
- **First week**: What progression should the user follow?
- **Activation moment**: What specific action proves the user "gets it"?

### 2. Specify In-App Guidance

For each screen/state in the onboarding flow:
- **Empty states**: Copy + CTA for every page the user visits before having data
- **Tooltips**: First-time hints for non-obvious features (max 3 per screen)
- **Progress indicators**: How to show the user where they are in the journey
- **Contextual help**: When to show help, what to say, how to dismiss

### 3. Design Email-Product Coordination

Map the relationship between email sequences and in-app milestones:
- Day 0 email -> What should the user have done in-app?
- Day 1 email -> What happens if they haven't activated?
- Day 7 email -> What happens if they've activated but not explored?
- Trial-end email -> What's the upgrade path?

### 4. Define Activation Metrics

For each ICP:
- **Activation event**: The specific product action that defines activation
- **Target time-to-activation**: How quickly should users reach it?
- **Measurement**: How to track this in analytics (PostHog events)
- **Threshold**: What % activation rate indicates success?

### 5. A/B Test Recommendations

If multiple approaches are viable:
- What to test (copy, flow order, feature emphasis)
- How to measure (primary metric, sample size needed)
- Duration and decision criteria

## Output

Write onboarding design specifications, email coordination brief (for Content Writer), and UI specifications (for Developer). Update assignment status.
