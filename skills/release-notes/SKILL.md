---
name: release-notes
description: Write user-facing release notes explaining what's new and why it matters
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:awareness"
---

# Step 2: Release Notes

## Objective

Transform the technical changelog into user-facing release notes that communicate value.

## Instructions

1. **Filter for user-visible changes**:
   - Not everything in the changelog matters to users
   - Infrastructure, performance, and internal refactors are usually invisible
   - Bug fixes matter when they affected user workflows
2. **Write in user-first language**:
   - Lead with the benefit: what can users DO now?
   - Use the language the user would use (not internal terminology)
   - Include context: why did we build this? What problem does it solve?
3. **Structure the release notes**:
   - **Headline**: The most impactful change in one sentence
   - **What's New**: New features and capabilities (2-3 sentences each)
   - **Improvements**: Better versions of existing things (1-2 sentences each)
   - **Fixes**: Bug fixes that users may have noticed (brief)
4. **Visual changes**:
   - If UI changed, describe the before/after
   - Reference design brief for intended experience
5. **Write release notes** to `.deliberate/releases/{version}/release-notes.md`
   - Also prepare a shorter version for in-app notification or email

## Output

- Full release notes (for blog/docs)
- Short version (for in-app or email)
- Both are drafts pending human review

## Transition

Proceed to `/release-announce`.
