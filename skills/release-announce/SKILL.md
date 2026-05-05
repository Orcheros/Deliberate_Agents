---
name: release-announce
description: Draft internal and external announcements for the release
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Step 3: Announcements

## Objective

Draft all announcements needed for the release — both internal team communication and external user communication.

## Instructions

1. **Internal announcement** (Slack/email to team):
   - What shipped and why it matters
   - Key changes team members should know about
   - Any behavioral changes or new configuration
   - Link to full changelog
   - Deployment timeline and monitoring plan

2. **External announcement** (email to users and/or blog post):
   - Lead with the value: what can they do now?
   - Keep it concise — link to full release notes for details
   - Include a CTA if appropriate (try the new feature, update settings, etc.)
   - Match the product's email voice and formatting

3. **In-app notification** (if applicable):
   - One-line summary of the most impactful change
   - Link to release notes
   - Dismissible, not blocking

4. **Social media draft** (if significant release):
   - Platform-appropriate format (Twitter/X, LinkedIn)
   - Hook + value + CTA
   - Optional image/screenshot description

5. **Write all drafts** to `.deliberate/releases/{version}/announcements/`:
   - `internal.md` — team Slack/email
   - `external-email.md` — user email
   - `in-app.md` — notification copy
   - `social.md` — social media posts (if applicable)

## Output

- All announcement drafts
- All flagged as drafts pending human review

## Transition

Communications complete. Report to Release Manager.
