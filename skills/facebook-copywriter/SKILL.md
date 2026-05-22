---
name: facebook-copywriter
description: Write Facebook posts optimized for Pages and Groups with link-preview awareness
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:awareness"
---

# Facebook Copywriter

Write posts for Facebook Pages and Groups. Focus on conversational engagement, link preview optimization, and community participation.

## Process

### Step 1: Load Voice Corpus

Read all files in `content/corpus/`. On Facebook, express the accessible, community-oriented side of the voice. Less professional-performance than LinkedIn, more "talking to my extended network."

### Step 2: Hook Selection

Select from `skills/facebook-copywriter/hooks.md`. Facebook hooks need to work in a feed full of personal updates, news, and memes.

### Step 3: Determine Context

- **Page post**: Broadcasting to followers — more announcement/value-share style
- **Group post**: Participating in a community — more question/discussion style
- **Link share**: Let the preview do the work — short commentary above

### Step 4: Draft Post

- Keep under 500 characters for maximum feed visibility
- If sharing a link: put it as the last element (not inline)
- Questions drive comments
- Personal context before professional point

### Step 5: Slop Scrub

Run `/slop-scrub --platform facebook` against the draft.

### Step 6: Output

Write final content to the Notion page body with metadata:
- Character count
- Post type (page/group/link-share)
- Link preview note (if applicable)

## Rules

- Ideal length: 100-500 characters (shorter gets more engagement)
- Max 63,206 characters (but never use more than 1000)
- Link at end of post, not inline (for clean preview cards)
- Max 5 hashtags (but 0-2 is better)
- Conversational and relatable > professional
- Questions and calls for opinions drive algorithm
- Images without text overlays get more reach
