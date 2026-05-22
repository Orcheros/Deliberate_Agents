---
name: reddit-writer
description: Write Reddit posts and comments that add value to subreddit communities
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:awareness"
---

# Reddit Writer

Write posts and comments for Reddit that genuinely contribute to subreddit communities. Value first, self-promotion never (or last, and rarely).

## Process

### Step 1: Load Voice Corpus

Read all files in `content/corpus/`. On Reddit, express the most authentic, unpolished version of the voice. Reddit rewards specificity, evidence, and genuine helpfulness over performance.

### Step 2: Determine Context

- **New post**: Sharing knowledge/experience/resource
- **Comment**: Responding to an existing thread
- **AMA/Discussion**: Longer engagement in a thread

### Step 3: Subreddit Analysis

Read `skills/reddit-writer/subreddit-rules.md` for target subreddit rules. Consider:
- Posting format requirements (flair, title format)
- Self-promotion rules (many ban it entirely)
- Content expectations (technical depth, evidence requirements)
- Community culture (formal vs casual)

### Step 4: Title Optimization (for posts)

Reddit titles determine everything:
- Specific > vague ("Reduced API latency 40% with connection pooling" > "How to make your API faster")
- Questions drive comments
- Avoid clickbait (community will punish it)
- Include relevant context (role, scale, timeframe)

### Step 5: Body Writing

Structure for posts:
1. **TL;DR** at top (for posts >200 words)
2. **Context** (who you are relevant to this topic, what you did)
3. **Content** (the actual value — evidence, data, steps, lessons)
4. **Discussion prompt** (genuine question, not engagement bait)

For comments:
- Add specific value (not "great point!")
- Cite evidence or personal experience
- Acknowledge what you don't know
- Disagree constructively with reasoning

### Step 6: Slop Scrub

Run `/slop-scrub --platform reddit` against the draft.

### Step 7: Output

Write to Notion page body with metadata:
- Target subreddit
- Post type (text/link/comment)
- Flair (if required)
- Self-promotion ratio check (are we within 10:1?)

## Rules

- HARD: 9:1 ratio — 9 genuine value posts for every 1 that mentions our product
- Never start with "Hey everyone!" or "So I..."
- Include TL;DR for anything over 200 words
- Evidence over opinion (data, links, experience)
- Acknowledge limitations and trade-offs
- No emoji in technical subreddits
- Format with markdown (headers, bullets, code blocks)
- Respond to replies within 24 hours
- Never delete downvoted posts — learn from them
