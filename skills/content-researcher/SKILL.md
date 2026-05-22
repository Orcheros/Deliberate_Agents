---
name: content-researcher
description: Research content ideas through trend scanning, performance analysis, and customer insight mining
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
aaaerrr-zone: "funnel:awareness"
---

# Content Researcher

## Objective

Generate high-quality content ideas by combining three research modes. Output is Notion pages with Status = Idea, ready for human review and approval.

## Mode Selection

Run one or more modes depending on the assignment. If no mode is specified, run all three.

---

## Mode 1: Trend Scan

Identify what's resonating in your industry right now.

### Instructions

1. Review recent high-engagement posts from competitors and thought leaders
2. Identify trending topics, formats, and angles in your space
3. Look for gaps — topics everyone discusses superficially that you can go deeper on
4. Check industry news, product launches, regulatory changes for timely hooks
5. Cross-reference with content pillars (Thought Leadership, Product, Community, Behind-the-Scenes)

### Output per idea

- **Title**: Working headline (specific, not generic)
- **Pillar**: Which content pillar this serves
- **Format**: Recommended format (Text, Carousel, Video, Poll, Article)
- **Angle**: What makes this take unique — your POV, not a summary
- **Timeliness**: Why now? (evergreen is valid but state it)
- **Hook suggestion**: Initial hook direction (reference hooks.md archetypes)

---

## Mode 2: Performance Scan

Mine your own data for what's already working.

### Instructions

1. Query Notion for published posts with metrics (use engagement-track data)
2. Rank by engagement rate (not raw impressions)
3. Identify patterns in top performers:
   - Which pillars outperform?
   - Which formats get most engagement?
   - Which hook types drive comments vs likes?
   - What topics generate conversation?
4. Generate "double-down" ideas — variations, sequels, deeper dives on winning topics
5. Identify underperforming pillars that need fresh angles

### Output per idea

- **Title**: Working headline for the double-down
- **Source**: Which post this builds on (link/reference)
- **Why it'll work**: What pattern from the original suggests this will perform
- **Differentiation**: How this is distinct enough to not feel repetitive

---

## Mode 3: Customer Scan

Turn real user language and problems into content.

### Instructions

1. Mine available sources for content angles:
   - Support tickets / FAQ patterns
   - Sales call notes and objections
   - User interviews and feedback
   - Product usage data and activation blockers
   - Community discussions
2. Extract recurring themes, questions, and pain language
3. Frame each as a content angle that serves both audience value and brand positioning
4. Prioritize topics where your product's POV is genuinely differentiated

### Output per idea

- **Title**: Working headline
- **Customer signal**: What real data point sparked this (anonymized)
- **Pain level**: How acute is this problem for the audience?
- **Product tie-in**: Natural (not forced) connection to your offering (or none — pure value is fine)

---

## Delivery

For each approved idea, create a Notion page via the integration:

```
Title: [working headline]
Status: Idea
Pillar: [selected pillar]
Format: [recommended format]
Channel: [LinkedIn, and/or others]
Hook Type: [suggested archetype]
```

Include research notes in the page body: angle, supporting evidence, suggested structure.

## Quality Gates

- Minimum 5 ideas per research session
- No more than 3 ideas from any single pillar (maintain variety)
- Every idea must have a clear angle — "write about X" is not an idea
- Discard anything that requires inventing facts or expertise you don't have
- Run /slop-scrub on all titles and descriptions before saving

## Transition

Ideas created → Human reviews in Notion → Approved ideas trigger linkedin-copywriter on next scheduled run.
