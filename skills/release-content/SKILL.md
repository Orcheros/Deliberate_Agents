---
name: release-content
description: Create launch marketing content — blog posts, email sequences, social media
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Step 2: Launch Content

## Objective

Create all marketing content pieces defined in the campaign plan.

## Instructions

1. **Blog post** (for Tier 1/2 releases):
   - Hook: Why this matters to the reader (not "we shipped X")
   - Problem: What was hard before
   - Solution: What's possible now (with specific examples)
   - How it works: Brief walkthrough
   - CTA: Try it now, learn more, upgrade
   - Tone: Helpful and confident, not salesy

2. **Email sequence** (for Tier 1 releases):
   - **Announcement email**: What's new and why it matters (sent on launch day)
   - **How-to email**: Walkthrough with examples (sent 2-3 days after)
   - **Success story email**: How early adopters are using it (sent 1 week after, if applicable)
   - Subject lines: Clear, specific, lowercase feel
   - Segment-specific variants if ICP segments have different use cases

3. **Social media** (for Tier 1/2 releases):
   - Twitter/X: Hook + key benefit + link (under 280 chars)
   - LinkedIn: Professional angle, longer format, industry context
   - Include image/screenshot descriptions for design team

4. **In-app messaging updates**:
   - Feature announcement banner or tooltip copy
   - Onboarding flow updates if the new feature changes the activation path
   - Empty state copy updates if relevant

5. **Write all content** to `.deliberate/releases/{version}/content/`:
   - `blog-post.md`
   - `email-announcement.md`, `email-how-to.md`, `email-success.md`
   - `social.md`
   - `in-app.md`

## Output

- All content pieces, drafted and organized
- All flagged as drafts pending human review

## Transition

Proceed to `/release-measure`.
