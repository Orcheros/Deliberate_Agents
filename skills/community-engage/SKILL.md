---
name: community-engage
description: Monitor and engage across community platforms (Reddit, HN, ProductHunt) with valuable contributions
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
aaaerrr-zone: "flywheel:engagement"
---

# Community Engage

Monitor community platforms for relevant discussions and engage with genuine, value-adding contributions.

## Process

### Step 1: Scan for Opportunities

Check for discussions related to our domain:
- Reddit: Monitor target subreddits for relevant threads
- HackerNews: Check front page and /new for relevant topics
- ProductHunt: Check discussions on competing/complementary products

Pull recent discussions via provider integrations:
```bash
./integrations/social/start.sh --platform reddit --list-posts
./integrations/social/start.sh --platform hackernews --list-posts
```

### Step 2: Evaluate Fit

For each potential engagement opportunity, score:
- **Relevance** (1-5): How related to our expertise?
- **Timing** (1-5): Is the discussion still active?
- **Value-add** (1-5): Can we contribute something nobody else has said?
- **Risk** (1-5): Could engagement be seen as self-promotion?

Only engage if: Relevance ≥3 AND Value-add ≥3 AND Risk ≤2

### Step 3: Craft Response

Use platform-specific writer skills:
- Reddit → invoke `/reddit-writer` patterns
- HN → invoke `/hackernews-writer` patterns
- ProductHunt → invoke `/producthunt-writer` patterns

### Step 4: Engagement Tracking

Record all engagements in Notion:
- Platform + thread URL
- Our comment/post
- Response received
- Engagement metrics (upvotes, replies)

### Step 5: Warm Lead Detection

Flag any engagement that shows:
- Direct questions about our product/space
- Pain points we specifically solve
- Requests for recommendations in our category

Add to `content/warm-leads.yaml` with context.

### Step 6: Report

Weekly summary:
- Communities engaged: N
- Comments/posts made: N
- Total karma/upvotes earned: N
- Warm leads identified: N
- Top-performing engagement (by responses)

## Constraints

- NEVER self-promote unless explicitly asked "what do you use?"
- Minimum 24-hour gap between posts in same subreddit
- Maximum 3 engagements per community per day
- If downvoted, pause and reassess (don't double down)
- Always disclose affiliation if asked directly
- Quality over quantity — one great comment > ten mediocre ones
