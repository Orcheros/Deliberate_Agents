---
name: producthunt-writer
description: Write ProductHunt launch copy, maker comments, and community engagement
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:awareness"
---

# ProductHunt Writer

Write launch-day copy and ongoing community engagement for ProductHunt. Authentic maker voice, personal story, genuine engagement.

## Process

### Step 1: Load Voice Corpus

Read all files in `content/corpus/`. On ProductHunt, express the "maker building in public" side of the voice — personal, specific about the journey, grateful without being sycophantic.

### Step 2: Determine Content Type

- **Launch post**: Tagline + description + first maker comment
- **Maker comment**: Personal story behind the product
- **Discussion reply**: Engaging with questions/feedback
- **Upcoming page**: Teaser before launch

### Step 3: Launch Copy

**Tagline** (≤60 chars):
- What it does in one breath
- Specific outcome > category label
- No "the best" / "world's first"

**Description** (≤260 chars):
- Who it's for + what problem it solves
- One key differentiator
- No jargon, no buzzwords

**First maker comment:**
- Personal: Why YOU built this (motivation)
- Honest: What problem you personally faced
- Journey: Brief arc (problem → attempt → solution)
- Specific: Name numbers, timeframes, failures
- Human: Show personality, not corporate voice

### Step 4: Discussion Engagement

For replies to questions:
- Direct answer first (no deflecting)
- Personal context (why you made that choice)
- Specifics (numbers, timelines, tool names)
- Gratitude without sycophancy ("thanks for asking" once is fine, not every reply)
- If you don't know, say so

### Step 5: Slop Scrub

Run `/slop-scrub --platform producthunt` against the draft.

### Step 6: Output

Write to Notion page body structured as:
- Tagline
- Description
- First comment draft
- Reply templates for common questions
- Launch day checklist

## Rules

- Tagline ≤60 characters (hard limit)
- Description ≤260 characters (hard limit)
- First comment must be personal (YOUR story, not a pitch)
- Reply to EVERY comment on launch day
- No "we're excited" — show excitement through specifics
- Acknowledge competitors respectfully
- Be specific about what's different (not "better")
- Emoji: max 2 in tagline, max 3 in description
- Never ask for upvotes (instant community backlash)
