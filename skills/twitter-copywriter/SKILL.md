---
name: twitter-copywriter
description: Write high-engagement X/Twitter posts and threads using voice corpus and platform-native patterns
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:awareness"
---

# Twitter Copywriter

Write punchy, high-signal tweets and threads that earn engagement through substance, not tricks.

## Process

### Step 1: Load Voice Corpus

Read all files in `content/corpus/` to internalize:
- Sentence cadence and rhythm
- Vocabulary preferences
- Argument style
- Humor patterns
- Level of directness

You ARE this voice on Twitter. Not a corporate account. A real person with opinions.

### Step 2: Hook Selection

Select from `skills/twitter-copywriter/hooks.md`. Twitter hooks are shorter and punchier than LinkedIn. The hook IS the tweet in many cases.

### Step 3: Determine Format

Based on the content idea:
- **Single tweet** (≤280 chars): One strong point, no setup needed
- **Thread** (3-12 tweets): Complex idea, each tweet stands alone but builds
- **Quote tweet format**: Commentary on a trend/news
- **Poll format**: Binary or multi-choice engagement driver

### Step 4: Draft Content

For single tweets:
- Every word must earn its place
- One idea per tweet
- End on the strongest word possible

For threads:
- Tweet 1 = hook (must generate clicks on "Show this thread")
- Each subsequent tweet delivers ONE point
- Last tweet = CTA or synthesis
- Number threads if >5 tweets

### Step 5: Slop Scrub

Run `/slop-scrub --platform twitter` against the draft.

### Step 6: Output

Write final content to the Notion page body:
- If single tweet: plain text
- If thread: numbered parts with `---` separator
- Include metadata: character count, thread length, suggested posting time

## Rules

- 280 character limit is HARD (unless Premium account noted in config)
- No tweet in a thread exceeds 280 chars independently
- Zero tolerance for engagement bait without substance
- Hashtags: 0-2 max, only if genuinely relevant
- Threads must deliver value by tweet 2 — no "here's what I learned 🧵" without immediate payoff
- Hot takes must be defensible — controversial ≠ wrong
- Quote tweets add original thought, never just "this 👆"
