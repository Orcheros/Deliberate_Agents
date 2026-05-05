---
name: support-escalate
description: Route issues to product/engineering with full context and reproduction details
allowed-tools: Read, Write, Glob, Grep
---

# Step 3: Escalate

## Objective

Route bugs, feature requests, and unresolvable issues to the appropriate internal team with full context.

## Instructions

1. **For bug escalations to engineering**:
   - Write a bug report in `.deliberate/support/bugs/{date}-{slug}.md`:
     - **Summary**: One sentence
     - **Reported By**: User identifier (anonymized)
     - **Priority**: P0/P1/P2/P3 with justification
     - **Steps to Reproduce**: Exact steps from the user, plus your verification
     - **Expected Behavior**: What should happen (reference PRD or existing patterns)
     - **Actual Behavior**: What the user experienced
     - **Code Investigation**: Files/methods you identified as likely involved
     - **User Impact**: How many users affected, what's the workaround
     - **Suggested Fix**: If obvious from code reading

2. **For feature request escalations to product**:
   - Write a request summary in `.deliberate/support/feature-requests/{date}-{slug}.md`:
     - **Request**: What the user wants
     - **User Context**: Who's asking (role, plan, tenure)
     - **Frequency**: How many users have requested similar
     - **Current Workaround**: How users handle this today
     - **Product Area**: Which part of the product this relates to
     - **Suggested Priority**: Based on user impact and request frequency

3. **For pattern reports** (recurring issues):
   - Write to `.deliberate/support/patterns/{slug}.md`:
     - **Pattern**: What's happening repeatedly
     - **Frequency**: How often, trending up or stable
     - **Root Cause Assessment**: Product gap, documentation gap, or UX confusion
     - **Recommendation**: Fix the product, improve docs, or add onboarding guidance

4. **For urgent escalations**:
   - Write to `.deliberate/decisions/` for immediate human attention
   - Flag in status file with `urgent: true`

## Output

- Bug reports for engineering
- Feature request summaries for product
- Pattern reports for systemic issues
- Urgent escalations via decisions directory

## Transition

Escalation complete. Update assignment status.
