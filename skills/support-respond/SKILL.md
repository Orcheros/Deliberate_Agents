---
name: support-respond
description: Draft support responses, help articles, and FAQ entries
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Step 2: Respond

## Objective

Draft helpful, empathetic support responses and create/update help documentation.

## Instructions

1. **For direct user responses**:
   - Acknowledge the issue and the user's experience
   - Provide clear, step-by-step resolution if available
   - If no resolution: explain what you understand, what you're doing about it, when they'll hear back
   - End with an invitation to follow up if the issue persists
   - Match the product's communication voice

2. **For help articles**:
   - Title: Action-oriented ("How to export your data", not "Data Export Feature")
   - Structure: Problem → Solution → Steps → Related articles
   - Every step includes the exact UI element to interact with
   - Include common variations and edge cases
   - Write for the user who's frustrated, not the one who's browsing

3. **For FAQ entries**:
   - Question phrased in the user's language (not internal terminology)
   - Answer: direct response first, then context
   - Link to relevant help article for details

4. **Write responses** to `.deliberate/support/responses/` (drafts for human review)

## Output

- Draft user responses
- New or updated help articles
- FAQ entries
- All flagged as drafts pending human review

## Transition

Proceed to `/support-escalate` if items need internal routing, or complete if all items are handled.
