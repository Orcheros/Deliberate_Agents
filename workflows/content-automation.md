---
name: content-automation
description: Multi-platform content production, distribution, and engagement pipeline
trigger: schedule-driven (weekly cadence with daily operations)
agents:
  - content-researcher
  - linkedin-copywriter
  - twitter-copywriter
  - threads-copywriter
  - facebook-copywriter
  - video-producer
  - reddit-writer
  - hackernews-writer
  - producthunt-writer
  - content-publisher
  - engagement-tracker
  - content-reporter
---

# Content Automation

## Purpose

End-to-end content production pipeline spanning 10 platforms across 3 categories:
- **Social Text**: LinkedIn, X/Twitter, Threads, Facebook
- **Video**: YouTube (Shorts + Long), TikTok, Instagram Reels
- **Community**: Reddit, HackerNews, ProductHunt

Research → Draft → Approve → Publish → Track → Report, with human gates at critical decision points.

## Trigger

Schedule-driven via `schedules/*.yaml`. Each schedule fires its designated agent at the configured time. The orchestrator (`orchestration/check-schedules.sh`) evaluates triggers and launches agents.

## Weekly Cadence

```
Monday 08:00 — Content Researcher
  → Generate ideas from Notion sources, tag with Channel recommendations
  ↓ [HUMAN GATE: Approve/reject ideas in Notion]

Tuesday 09:00 — Platform Copywriters (parallel)
  → linkedin-copywriter:  Approved ideas, Channel=LinkedIn
  → twitter-copywriter:   Approved ideas, Channel=Twitter (09:30)
  → threads-copywriter:   Approved ideas, Channel=Threads (09:30)
  → facebook-copywriter:  Approved ideas, Channel=Facebook (10:00)
  → video-producer:       Approved ideas, Format=Video (10:00)
  ↓ [HUMAN GATE: Review/approve drafts in Notion]

Daily 10:00 — Multi-Platform Publisher
  → Publish all Scheduled posts for today
  → Route by Channel field to appropriate provider
  → Stagger: LinkedIn first, Twitter/Threads +30min, Facebook +1hr

Daily 18:00 — Engagement Tracker (all platforms)
  → Pull metrics from all active platforms
  → Update Notion metrics fields
  → Detect warm leads across platforms
  → Flag high performers

Wednesday 14:00 — Community Engagement
  → reddit-writer:      Value posts + comment engagement
  → hackernews-writer:  Monitor + engage on relevant threads

Friday 16:00 — Content Reporter (cross-platform)
  → Aggregate metrics from all platforms
  → Compare cross-platform performance
  → Identify top patterns and recommendations

Ad-hoc — Launch Events
  → producthunt-writer: On product release (triggered manually)
  → hackernews-writer:  Show HN on significant releases
  → reddit-writer:      Relevant subreddit announcements
```

## Agent Sequence

| Order | Agent | Model | Frequency | Platforms |
|---|---|---|---|---|
| 1 | content-researcher | sonnet | Weekly Mon | All |
| 2 | linkedin-copywriter | opus | Weekly Tue | LinkedIn |
| 3 | twitter-copywriter | opus | Weekly Tue | X/Twitter |
| 4 | threads-copywriter | opus | Weekly Tue | Threads |
| 5 | facebook-copywriter | opus | Weekly Tue | Facebook |
| 6 | video-producer | opus | Weekly Tue | YouTube, TikTok, Instagram |
| 7 | content-publisher | sonnet | Daily | All (routed by Channel) |
| 8 | engagement-tracker | sonnet | Daily | All active platforms |
| 9 | reddit-writer | sonnet | Weekly Wed | Reddit |
| 10 | hackernews-writer | sonnet | Weekly Wed | HackerNews |
| 11 | producthunt-writer | sonnet | Ad-hoc | ProductHunt |
| 12 | content-reporter | sonnet | Weekly Fri | All (aggregation) |

## Detailed Steps

### Step 1: Content Research (Monday)

**Agent:** content-researcher | **Model:** Sonnet | **Skills:** `/content-researcher`

1. Gather signals from configured sources (industry news, competitors, trends)
2. Generate 5-10 content ideas per week
3. Tag each idea with recommended Channel(s) and Format
4. Create Notion pages with Status=Idea, Channel recommendations
5. Notify via Slack that ideas are ready for review

**Output:** Notion pages with ideas, each tagged with Channel + Format

### Step 2: Human Review (Monday–Tuesday)

**Actor:** Human (in Notion)

1. Review each Idea page
2. Reject weak ideas (delete or archive)
3. Mark strong ideas → Status: Approved
4. Optionally adjust Channel/Format assignments
5. Add notes: preferred hook, angle emphasis, timing

### Step 3: Platform-Specific Drafting (Tuesday)

**Agents:** Platform copywriters (parallel) | **Model:** Opus

Each copywriter picks up Approved ideas tagged with its platform:
- `linkedin-copywriter`: Channel=LinkedIn → draft LinkedIn posts
- `twitter-copywriter`: Channel=Twitter → draft tweets/threads
- `threads-copywriter`: Channel=Threads → draft Threads posts
- `facebook-copywriter`: Channel=Facebook → draft Facebook posts
- `video-producer`: Format=Video → write scripts, submit renders

Each agent:
1. Loads voice corpus
2. Selects hooks and structures per platform rules
3. Drafts content in platform-native format
4. Runs platform-specific slop scrub
5. Writes draft to Notion page body
6. Updates Status: Approved → Drafting → Review

### Step 4: Human Approval (Tuesday–Whenever)

**Actor:** Human (in Notion)

1. Review drafts for each platform
2. Edit if desired (tone, details, timing)
3. Approve: Status → Scheduled, set Publish Date
4. Reject: Status → Approved (back to drafting pool)

### Step 5: Multi-Platform Publishing (Daily)

**Agent:** content-publisher | **Model:** Sonnet | **Skills:** `/content-publish`

1. Query Notion for Status=Scheduled, Publish Date=today
2. For each post, read Channel field
3. Route to appropriate provider via `integrations/social/`
4. Publish with platform-specific formatting
5. Write back platform Post ID to Notion
6. Update Status: Scheduled → Published
7. Stagger publishing (LinkedIn first, others follow)

**Platform Rate Limits:**
- LinkedIn: 2/day
- Twitter: 10/day
- Threads: 5/day
- Facebook: 2/day
- YouTube: 6/day
- TikTok: 25/day
- Instagram: 25/day

### Step 6: Engagement Tracking (Daily)

**Agent:** engagement-tracker | **Model:** Sonnet | **Skills:** `/engagement-track`

1. Query Notion for all Published posts (any platform)
2. For each post, check which platform IDs are populated
3. Call matching provider's `get_post_metrics()`
4. Update Notion Metrics field
5. Build cross-platform warm-lead table
6. Flag high performers (>2x average engagement)
7. Detect content plateaus

**Output:** Updated metrics, warm-leads.yaml, hot-posts alerts

### Step 7: Community Engagement (Wednesday)

**Agents:** reddit-writer, hackernews-writer | **Model:** Sonnet

1. Scan target communities for relevant discussions
2. Evaluate engagement opportunities (relevance × value-add)
3. Craft platform-appropriate responses
4. Post contributions
5. Track engagements in Notion
6. Identify warm leads from interactions

### Step 8: Weekly Report (Friday)

**Agent:** content-reporter | **Model:** Sonnet | **Skills:** `/content-report`

1. Gather 7-day metrics from all platforms
2. Calculate cross-platform KPIs
3. Compare platform performance
4. Identify patterns by pillar, format, hook type, platform, day-of-week
5. Generate recommendations
6. Write full report + Slack summary

**Output:** `.deliberate/reports/content/weekly-{date}.md`, Slack summary

## Decision Gates

| Gate | Owner | Decision | Next State |
|---|---|---|---|
| Idea Review | Human | Approve/Reject | Approved / Archived |
| Draft Review | Human | Approve/Edit/Reject | Scheduled / Approved |
| Video Review | Human | Approve rendered video | Ready for publish |
| Launch Trigger | Human | Initiate PH/HN launch | Launch sequence |

## State Machine (Notion Status)

```
Idea → [Human: approve] → Approved → [Agent: draft] → Drafting → Review
Review → [Human: approve] → Scheduled → [Agent: publish] → Published → Tracking
Review → [Human: reject] → Approved (re-draft)

Video-specific:
Approved → [Agent: script] → Drafting → Review → Scheduled
Scheduled → [Agent: render] → Rendering → Complete → [Human: approve] → Published
```

## Infrastructure

- **Schedules:** `schedules/*.yaml` — recurring task definitions
- **State:** `.deliberate/schedules/*.last` — prevents double-execution
- **Notion:** `integrations/notion/` — database client
- **Social:** `integrations/social/` — unified provider layer (10 platforms)
- **Video:** `integrations/video/` — render provider layer (HeyGen, Runway, Manual)
- **Assets:** `content/corpus/`, `content/slop-rules/`
- **Reports:** `.deliberate/reports/content/`
- **Config:** `config.henry.yaml` — platform-specific settings

## Exit Condition

This workflow is continuous — it doesn't "exit." It runs weekly in perpetuity. To pause:
- Set `schedules_enabled: false` in config
- Remove/disable specific schedule YAML files
- Set individual platform `enabled: false` in config
