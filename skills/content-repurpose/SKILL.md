---
name: content-repurpose
description: Transform master content into multiple channel-specific variants using hub-and-spoke orchestration
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:awareness"
---

# Content Repurpose

## Objective

Take a single piece of master content (blog post, webinar transcript, long-form article, video script, podcast notes) and produce N channel-optimized variants. Hub-and-spoke model — this skill orchestrates sub-skills for each output channel.

## Input

One of:
- Path to master content file
- Notion page ID containing long-form content
- Pasted content block in the assignment

## Process

### Step 1: Analyze Master Content

1. Read the full source material
2. Extract:
   - Core thesis / main argument (1 sentence)
   - Key supporting points (3-7 items)
   - Best quotes / sound bites
   - Data points / stats
   - Stories / anecdotes
   - Counterarguments addressed
3. Identify the content pillar and primary audience

### Step 2: Plan Variants

Based on the source material, determine which outputs are viable:

| Variant | Viable When | Skill Invoked |
|---|---|---|
| LinkedIn text post | Always — extract the strongest single point | `/linkedin-copywriter` |
| LinkedIn carousel | 3+ sequential points or a framework | `/linkedin-copywriter` |
| Twitter/X thread | Multiple atomic insights that build | `/twitter-copywriter` |
| Threads post | Conversational take, casual insight | `/threads-copywriter` |
| Facebook post | Broad-audience friendly content | `/facebook-copywriter` |
| Short-form video script | Strong story arc or demo-able concept | `/video-scriptwriter` |
| Reddit post | Technical depth, community value | `/reddit-writer` |
| Newsletter section | Adds context or commentary layer | Direct write |
| Blog post | Only if source isn't already a blog | Direct write |
| Poll | Genuinely debatable point in the content | Direct write |

Skip variants that would feel forced. Quality > quantity.

### Step 3: Generate Variants

For each viable variant, invoke the appropriate platform skill:

**LinkedIn posts** — Invoke `/linkedin-copywriter`:
- Pass the extracted thesis + supporting points
- Specify which hook archetype fits best
- Specify structure type
- One post per strong standalone point (may generate 2-3 posts from rich source)

**Twitter/X threads** — Invoke `/twitter-copywriter`:
- 280 chars per tweet, thread if needed, no hashtag spam
- Atomic insights that stand alone but build together
- Platform-native voice and formatting

**Threads posts** — Invoke `/threads-copywriter`:
- Casual, conversational tone
- Shorter format, personality-forward
- Platform-appropriate engagement hooks

**Facebook posts** — Invoke `/facebook-copywriter`:
- Broader audience framing
- Story-driven, shareable format
- Optimized for comments and shares

**Video scripts** — Invoke `/video-scriptwriter`:
- Hook in first 3 seconds, conversational, under 60 seconds
- Strong story arc or demo-able concept
- Platform-specific (YouTube Shorts vs TikTok vs Reels)

**Reddit posts** — Invoke `/reddit-writer`:
- Technical depth, genuine community value
- Subreddit-appropriate tone and formatting
- No self-promotion feel — value-first

**Direct write channels** (no dedicated skill):
- Newsletter: Conversational, adds your POV on top of the content
- Blog: SEO-optimized, structured with headers, 800-1500 words

### Step 4: Slop Scrub

Run `/slop-scrub` on ALL variants before output.

### Step 5: Cross-Check

- No variant should feel like a copy-paste of another
- Each should stand alone — reader of one shouldn't feel they need to see the others
- Maintain consistent voice across variants (same person, different contexts)

## Output

For each variant:
```
---
Channel: [channel name]
Format: [text/carousel/thread/etc.]
Source: [reference to master content]
Hook: [archetype used]
Structure: [structure used]
Word count: [N]
---

[content in fenced code block]
```

Create corresponding Notion pages for each variant with:
- Status: Drafting
- Channel: [appropriate channel]
- Source: [relation to master content page]

## Constraints

- Never generate more than 5 variants from a single source
- If the source is thin (under 500 words, single point), produce maximum 2 variants
- Don't manufacture points that aren't in the source material
- Carousel slides should have max 30 words each
- Respect channel character limits strictly

## Transition

Variants created → Status set to Drafting → Human review in Notion → Approved variants enter publish queue.
