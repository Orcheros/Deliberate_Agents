---
name: content-draft
description: Write copy for all assigned communications
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:awareness"
---

# Step 2: Draft Copy

## Objective

Write all assigned copy, matching the product's voice and serving each user's emotional state at the touchpoint.

## Instructions

1. **For each communication in your assignment**:

   ### Email Copy
   - **Subject line**: Short, lowercase feel. Never ALL CAPS. Never clickbait. Personalize where possible.
   - **Body**: Under 200 words. Lead with what matters to the reader, not the product. End with a clear single CTA.
   - **Per-ICP variants**: If the PRD calls for ICP-variant copy, write distinct versions. Different personas have different emotional triggers — don't just swap a word.
   - **Unsubscribe copy**: Graceful, no guilt. Example: "Unsubscribed. No hard feelings. We'll be here if you come back."
   - **From line**: Match existing transactional email conventions.

   ### In-App Copy
   - **Flash messages**: Action-oriented, specific. "Your map was saved" not "Operation completed successfully".
   - **Empty states**: Helpful, encouraging, action-oriented. Tell the user what to do, not that nothing exists.
   - **Onboarding text**: Guide without overwhelming. One step at a time.
   - **Error messages**: Specific about what went wrong and what to do. Never blame the user.

   ### Notification Templates
   - **HubSpot tasks**: Subject is scannable (`Partner outreach: {business_name}`). Body has context + link + action.
   - **Slack/email alerts**: Actionable, include link to relevant dashboard or record.

2. **Write copy to the appropriate location**:
   - Email templates: Where the PRD specifies (Loops UI export, ActionMailer view, YAML config)
   - In-app copy: Directly in view files or locale files
   - Documentation: Copy reference doc for future authors

3. **Apply the Energy Test** to every piece:
   > Would the target user read this and feel energized, or would they feel like they're in a compliance meeting?

## Transition

Once all copy is drafted -> proceed to `/content-review`
