---
name: hackernews-writer
description: Write HackerNews submissions and comments with zero marketing language and maximum technical depth
allowed-tools: Read, Write, Edit, Glob, Grep
---

# HackerNews Writer

Write for Hacker News with absolute zero tolerance for marketing language. Technical depth, intellectual honesty, and genuine contribution to discourse.

## Process

### Step 1: Load Voice Corpus

Read all files in `content/corpus/`. On HN, strip ALL polish. Express pure technical thinking — direct, precise, willing to be wrong.

### Step 2: Determine Submission Type

- **Show HN**: Launching or demonstrating something built
- **Ask HN**: Genuine question seeking technical community input
- **Comment**: Adding depth to an existing discussion
- **Link submission**: Sharing notable technical content

### Step 3: Title Craft

**Show HN format:**
```
Show HN: [What it does] – [one technical detail or differentiator]
```
Examples:
- "Show HN: A SQLite extension for full-text search in 500 lines of C"
- "Show HN: Real-time collaborative editor using CRDTs, no central server"

**Regular submission:**
- Factual, specific, no superlatives
- No exclamation marks
- No "amazing", "incredible", "revolutionary"
- State what it IS, not how you feel about it

### Step 4: Body Writing

**For Show HN:**
1. What it does (one paragraph, specific)
2. Technical approach (why this architecture)
3. Limitations (honest about what it doesn't do)
4. What's next (roadmap without hype)
5. Link to demo/repo

**For Comments:**
- Lead with the most important technical point
- Cite sources (papers, docs, benchmarks)
- Acknowledge counterarguments proactively
- Add context the parent comment might be missing
- Disagree with reasoning, never with tone

### Step 5: STRICT Slop Scrub

Run `/slop-scrub --platform hackernews` against the draft.

Then manually verify:
- Zero emoji? ✓
- Zero exclamation marks? ✓
- Zero marketing language? ✓
- Zero superlatives? ✓
- Would a senior engineer at a FAANG company respect this? ✓

### Step 6: Output

Write to Notion page body with metadata:
- Submission type (show_hn/ask_hn/comment/link)
- Technical depth score (self-assessed 1-5)
- Marketing language scan: PASS/FAIL (must be PASS)

## Rules

- HARD CONSTRAINT: Zero marketing language. Not reduced. ZERO.
- No emoji. Ever.
- No exclamation marks.
- No buzzwords (AI-powered, game-changing, revolutionary, disruptive)
- Acknowledge what's NOT novel about your approach
- Cite prior art and alternatives honestly
- If someone has done this before, say so and explain what's different
- Technical specificity > hand-waving
- Undersell, overdeliver
- "We built X because Y didn't exist" > "We're excited to launch X"
- Limitations section is NOT optional
