---
name: support-triage
description: Categorize, prioritize, and route incoming user feedback and issues
allowed-tools: Read, Write, Glob, Grep
---

# Step 1: Triage

## Objective

Process incoming user feedback, categorize each item, assess priority, and determine routing.

## Instructions

1. **Read incoming feedback** from the assignment:
   - User message/report content
   - Channel it came from (Slack, email, in-app)
   - User context (plan tier, account age, recent activity if available)

2. **Categorize each item**:
   - **Bug**: Something is broken or behaving unexpectedly
   - **Feature Request**: User wants something that doesn't exist
   - **How-To**: User needs help using an existing feature
   - **Feedback**: General sentiment (positive or negative)
   - **Account Issue**: Billing, access, account management

3. **Assess priority**:
   - **P0 (Critical)**: User can't use core product functionality, data loss, security issue
   - **P1 (High)**: Significant workflow blocked, workaround exists but painful
   - **P2 (Medium)**: Feature gap or minor bug, doesn't block core workflow
   - **P3 (Low)**: Cosmetic issue, nice-to-have, general feedback

4. **Attempt reproduction** (for bugs):
   - Read the relevant codebase to understand the expected behavior
   - Try to identify the code path that would produce the reported behavior
   - Note whether the bug is reproducible from the code or needs runtime verification

5. **Route determination**:
   - Bugs → `/support-escalate` → Engineering
   - Feature Requests → `/support-escalate` → Product
   - How-To → `/support-respond` → User (with help article)
   - Account Issues → `/support-escalate` → Human (via Slack)

6. **Write triage report** to `.deliberate/support/{date}-triage.md`

## Output

- Categorized and prioritized issue list
- Routing determination for each item
- Reproduction notes for bugs

## Transition

Proceed to `/support-respond` for items needing user communication, or `/support-escalate` for items needing internal routing.
