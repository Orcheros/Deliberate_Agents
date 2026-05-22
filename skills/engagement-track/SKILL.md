---
name: engagement-track
description: Multi-platform engagement metrics collection, warm-lead detection, and performance flagging
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
aaaerrr-zone: "flywheel:engagement"
---

# Engagement Track

## Objective

Track engagement metrics across all platforms where content is published. Build a unified view of performance, detect warm leads, and flag high-performing content for amplification.

## Process

### Step 1: Gather Metrics (All Platforms)

1. Query Notion for all posts with Status = "Published"
2. For each post, check which platform Post ID fields are populated
3. For each populated platform ID, call the matching provider:

```bash
./integrations/social/start.sh --platform {platform} --metrics {post_id}
```

Platform → Field mapping:
| Platform | Notion Field | Provider |
|---|---|---|
| LinkedIn | LinkedIn Post ID | linkedin |
| Twitter | Twitter Post ID | twitter |
| Threads | Threads Post ID | threads |
| Facebook | Facebook Post ID | facebook |
| Instagram | Instagram Post ID | instagram |
| YouTube | YouTube Video ID | youtube |
| TikTok | TikTok Video ID | tiktok |
| Reddit | Reddit Post ID | reddit |
| HackerNews | HN Item ID | hackernews |
| ProductHunt | PH Post ID | producthunt |

### Step 2: Update Notion

For each post, update the Metrics field with aggregated data:
```
LI: 5.2k imp, 127 likes, 23 comments | TW: 12k imp, 89 likes, 45 RT | FB: 2.1k reach
```

Format: `{Platform abbrev}: {key metrics} | {next platform}...`

### Step 3: Build Warm-Lead Table

A warm lead = someone who engaged 2+ times across any platform.

Cross-platform aggregation:
1. Collect all engagements from `get_recent_engagement()` across platforms
2. Group by user identity (name/handle)
3. Anyone with ≥2 engagements in 7 days = warm lead

Output to `content/warm-leads.yaml`:
```yaml
warm_leads:
  - name: "Jane Smith"
    platforms: ["linkedin", "twitter"]
    engagements: 4
    last_engagement: "2025-05-15T14:30:00Z"
    context: "Commented on API post, liked 3 others"
    lead_score: 8
  - name: "Bob Johnson"
    platforms: ["hackernews"]
    engagements: 2
    last_engagement: "2025-05-14T09:15:00Z"
    context: "Technical discussion on Show HN"
    lead_score: 5
```

### Step 4: Flag High Performers

Calculate average engagement rate per platform. Flag posts exceeding 2x average:

```yaml
# .deliberate/reports/content/hot-posts.yaml
hot_posts:
  - title: "Post title"
    platform: "linkedin"
    engagement_rate: 12.4
    average_rate: 5.2
    multiplier: 2.4
    action: "repurpose to twitter and threads"
```

Recommendations for hot posts:
- Repurpose to other platforms (via content-repurpose)
- Boost/promote if paid social enabled
- Create follow-up content on same topic

### Step 5: Detect Plateaus

For posts >7 days old with no engagement growth in 3 days:
- Transition Status: Published → Tracking
- Stop active polling (move to weekly check)

### Step 6: Cross-Platform Comparison

Generate per-platform performance summary:
```
Platform Performance (7-day):
  LinkedIn:  12 posts, 5.2% avg engagement, 45k total impressions
  Twitter:   28 tweets, 3.1% avg engagement, 89k total impressions
  Threads:   8 posts, 7.8% avg engagement, 12k total impressions
  Reddit:    3 posts, 42 upvotes avg, 2 warm leads
```

### Step 7: Summary Log

Write to `.deliberate/logs/engagement-{date}.md`:
- Posts tracked: N (per platform breakdown)
- New warm leads: N
- Hot posts flagged: N
- Plateaus detected: N

## Constraints

- Only track posts with valid Post IDs (skip empty fields)
- Rate limit API calls (max 60/minute per provider)
- Don't track posts older than 30 days (diminishing returns)
- Warm lead detection is cross-platform (someone on LinkedIn + Twitter = 1 lead)
- If a provider API fails, log and continue (don't block other platforms)

## Output

- Updated Notion Metrics fields
- `content/warm-leads.yaml` — cross-platform warm leads
- `.deliberate/reports/content/hot-posts.yaml` — high performers
- `.deliberate/logs/engagement-{date}.md` — daily summary

## Transition

Hot posts → content-repurpose skill for amplification. Warm leads → sales pipeline.
