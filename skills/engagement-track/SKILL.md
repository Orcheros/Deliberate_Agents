---
name: engagement-track
description: Track post engagement metrics, update Notion, build warm-lead table, and flag high-performers
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Engagement Track

## Objective

Pull engagement data for all published posts, update Notion metrics, identify warm leads from repeat engagers, and flag high-performing posts for content strategy feedback.

## Process

### Step 1: Gather Metrics

1. Query Notion for all posts with Status = "Published" or "Tracking"
2. For each post with a LinkedIn Post ID:
   - Call `get_post_metrics(post_id)` via LinkedIn provider
   - Capture: impressions, likes, comments, shares, engagement_rate
3. Call `get_recent_engagement(since_hours=24)` for activity feed

### Step 2: Update Notion

For each published post, update the Metrics field:
```
Impressions: 12,450 | Likes: 234 | Comments: 67 | Shares: 23 | ER: 2.6%
Last updated: 2024-03-15
```

For posts that are >7 days old and engagement has plateaued (less than 5% change since last check), update Status to "Tracking" (terminal state — still visible in reports but not actively monitored).

### Step 3: Build Warm-Lead Table

Analyze engagement activity to identify warm leads:

**Warm lead criteria**: 2+ meaningful engagements (comments, shares — likes alone don't qualify)

Update `content/warm-leads.yaml`:
```yaml
leads:
  - name: "Jane Smith"
    user_id: "linkedin-id-123"
    engagement_count: 4
    last_engaged: "2024-03-15"
    engaged_posts:
      - post_id: "abc123"
        type: "comment"
        content: "This resonates..."
      - post_id: "def456"
        type: "share"
    tags: []  # manually added by sales team

  - name: "John Doe"
    user_id: "linkedin-id-456"
    engagement_count: 2
    last_engaged: "2024-03-14"
    engaged_posts:
      - post_id: "abc123"
        type: "comment"
        content: "We had the same experience..."
      - post_id: "ghi789"
        type: "comment"
        content: "How did you handle..."
    tags: []
```

Rules:
- Only add new leads or update existing ones (never remove)
- Sort by engagement_count descending
- Cap content preview at 100 characters
- Include user_id for CRM cross-reference

### Step 4: Flag High Performers

Calculate average engagement rate across all tracked posts.

**Hot post** = engagement rate >2x average OR comments >3x average.

For hot posts:
1. Update Notion page with a note: "🔥 High performer — double-down candidate"
2. Log to `.deliberate/reports/content/hot-posts.yaml`:
   ```yaml
   - post_id: "abc123"
     title: "Post title"
     engagement_rate: 5.4
     vs_average: "2.8x"
     flagged_date: "2024-03-15"
     pillar: "Thought Leadership"
     format: "Text"
     hook_type: "Contrarian"
     double_down_suggested: true
   ```
3. This data feeds back into content-researcher's Performance Scan mode

### Step 5: Summary Log

Write daily tracking summary to `.deliberate/logs/engagement-track.log`:
```
[timestamp] TRACKED posts=12 updated=8 plateaued=3 hot=1 new_leads=2
```

## Constraints

- Rate-limit LinkedIn API calls (max 1 request per second)
- Never modify post content — this is read-only tracking
- Never delete warm leads — only add or update
- Plateau detection requires at least 2 data points (skip first-day posts)
- Engagement rate calculation: (likes + comments + shares) / impressions × 100

## Output

- Updated Notion metrics for all active posts
- Updated `content/warm-leads.yaml`
- Updated `.deliberate/reports/content/hot-posts.yaml`
- Daily log entry

## Transition

Daily tracking feeds into → content-report (weekly) and content-researcher (performance scan mode).
