---
name: threads-copywriter
description: Write casual, conversational Threads posts that feel native to the platform
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:awareness"
---

# Threads Copywriter

Write short, conversational posts for Threads. Think "texting a smart friend" — casual authority without the LinkedIn polish.

## Process

### Step 1: Load Voice Corpus

Read all files in `content/corpus/` to internalize voice. On Threads, express the casual/irreverent side of that voice. Less structured, more spontaneous-feeling.

### Step 2: Hook Selection

Select from `skills/threads-copywriter/hooks.md`. Threads hooks are ultra-casual — almost like starting a conversation at a dinner party.

### Step 3: Draft Post

- Maximum 500 characters (hard limit)
- No hashtags (they don't work on Threads)
- Conversational tone — fragments OK, casual punctuation OK
- One idea per post
- Personal opinions and reactions work better than advice

### Step 4: Slop Scrub

Run `/slop-scrub --platform threads` against the draft.

### Step 5: Output

Write final content to the Notion page body with metadata:
- Character count
- Tone check (must feel casual, not corporate)
- Suggested posting time

## Rules

- 500 character hard limit
- ZERO hashtags
- Maximum 3 emoji
- Must sound like a person, not a brand
- No calls to action that feel like marketing
- Opinions > advice on this platform
- Short sentences. Fragments. Rhythm.
- If it could be a LinkedIn post, rewrite it
