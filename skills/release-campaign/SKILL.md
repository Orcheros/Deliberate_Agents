---
name: release-campaign
description: Plan launch marketing approach for significant releases
allowed-tools: Read, Write, Glob, Grep
---

# Step 1: Campaign Planning

## Objective

Determine the right marketing approach for this release and create a launch plan.

## Instructions

1. **Assess release significance**:
   - **Tier 1 (Major)**: New capability, new user segment, pricing change → Full campaign
   - **Tier 2 (Notable)**: Significant improvement, frequently requested feature → Blog + email + social
   - **Tier 3 (Minor)**: Bug fixes, small improvements → Release notes only (no campaign needed)

2. **For Tier 1/2 releases, plan the campaign**:
   - **Target segments**: Who cares most about this change?
   - **Key message**: One sentence that captures the value
   - **Content pieces needed**: Blog, email, social, in-app, landing page updates
   - **Timeline**: Pre-launch tease, launch day, follow-up sequence
   - **Adoption path**: How does a user go from "aware" to "using this feature"?

3. **Align with existing strategy**:
   - Read Growth Strategist's messaging framework
   - Ensure launch messaging is consistent with overall positioning
   - Identify opportunities to reinforce broader narrative

4. **Write campaign plan** to `.deliberate/releases/{version}/campaign-plan.md`

## Output

- Campaign tier assessment
- Launch plan with content list, timeline, and target segments
- Messaging brief for each content piece

## Transition

Proceed to `/release-content`.
