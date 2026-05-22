---
name: content-review
description: Self-review all drafted copy against brand constraints and quality standards
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:awareness"
---

# Step 3: Review Copy

## Objective

Review all drafted copy for quality, consistency, and constraint compliance before signaling completion.

## Instructions

1. **Check each piece against constraints**:
   - [ ] Under word limit (200 words for emails)
   - [ ] No internal jargon or methodology terms in user-facing copy
   - [ ] Subject lines: short, lowercase feel, no ALL CAPS, no clickbait
   - [ ] Personalization tokens used correctly (`{first_name}`, `{business_name}`)
   - [ ] Unsubscribe expectations clear
   - [ ] Marketing vs. transactional distinction maintained
   - [ ] Win-back sequences respect caps (e.g., 3 emails over 90 days max)

2. **Check voice consistency**:
   - Does every piece sound like it came from the same product?
   - Does the voice match existing copy in the codebase?
   - Would the target persona connect with this language?

3. **Check the emotional journey**:
   - Does the copy sequence make sense? (welcome -> educate -> activate -> retain)
   - Does each touchpoint acknowledge what just happened?
   - Is the CTA appropriate for the user's current state?

4. **Revise** anything that fails these checks

5. **Update assignment status**:
   ```yaml
   status: "complete"
   completed_at: "timestamp"
   notes: "Copy deliverables summary"
   ```

## Done

Your copy work is complete. The session can end.
