# Content Automation

## Purpose

Automate the full content lifecycle: research → draft → approve → publish → track → report. Runs on a recurring schedule with human approval gates at critical points. Designed for LinkedIn-first content strategy with extensibility to other channels.

## Trigger

- Automated via recurring schedules (see `schedules/` directory)
- Manual invocation of individual skills at any time
- Human marks content as Approved in Notion (triggers draft/publish pipeline)

## Weekly Cadence

```
Monday 08:00 — Content Researcher
  /content-researcher (trend + performance + customer modes)
  → New Idea pages in Notion
  ↓
  ┌─────────────────────────────────────────────┐
  │ HUMAN GATE                                   │
  │ Review ideas in Notion, mark best → Approved │
  └─────────────────────────────────────────────┘
  ↓
Tuesday 09:00 — LinkedIn Copywriter
  /linkedin-copywriter (for each Approved idea)
  → Draft posts in Notion (Status: Review)
  ↓
  ┌─────────────────────────────────────────────┐
  │ HUMAN GATE                                   │
  │ Review drafts, edit if needed                │
  │ Mark → Approved, set Publish Date            │
  └─────────────────────────────────────────────┘
  ↓
Daily 10:00 — Content Publisher
  /content-publish (Status = Scheduled + today's date)
  → Live on LinkedIn, Notion updated (Status: Published)
  ↓
Daily 18:00 — Engagement Tracker
  /engagement-track
  → Metrics updated in Notion, warm-lead table built
  ↓
Friday 16:00 — Content Reporter
  /content-report
  → Weekly report + double-down recommendations
  → Feeds back into next Monday's research
```

## Agent Sequence

| Time | Agent | Skill | Input | Output |
|---|---|---|---|---|
| Mon 08:00 | content-researcher | /content-researcher | Trends, metrics, customer signals | Notion pages (Status: Idea) |
| Tue 09:00 | linkedin-copywriter | /linkedin-copywriter | Approved ideas from Notion | Draft posts (Status: Review) |
| Daily 10:00 | content-publisher | /content-publish | Scheduled posts for today | Published LinkedIn posts |
| Daily 18:00 | engagement-tracker | /engagement-track | Published post IDs | Updated metrics, warm leads |
| Fri 16:00 | content-reporter | /content-report | 7-day metrics from Notion | Weekly report + Slack summary |

## Detailed Steps

### Step 1: Content Research (Monday)

**Agent:** content-researcher | **Model:** Sonnet | **Skills:** `/content-researcher`, `/slop-scrub`

1. Trend scan — industry posts, competitor content, trending topics
2. Performance scan — analyze past post metrics, identify winning patterns
3. Customer scan — mine support/sales/interviews for authentic angles
4. Create Notion pages with Status = Idea (minimum 5 per session)
5. Slop-scrub all titles and descriptions

**Output:** 5-10 structured ideas in Notion, ready for human review

### Step 2: Human Review (Monday–Tuesday)

**Actor:** Human (in Notion)

1. Review each Idea page
2. Reject weak ideas (delete or archive)
3. Mark strong ideas → Status: Approved
4. Optionally add notes: preferred hook, angle emphasis, timing

### Step 3: Content Drafting (Tuesday)

**Agent:** linkedin-copywriter | **Model:** Opus | **Skills:** `/linkedin-copywriter`, `/content-repurpose`, `/slop-scrub`

1. Read voice corpus to build voice model
2. For each Approved idea:
   - Select hook archetype based on idea angle
   - Select body structure based on content type
   - Draft post in author's voice
   - Run slop scrub
3. Update Notion: Status → Review, post body in page

**Output:** Draft posts in Notion awaiting final human approval

### Step 4: Human Approval (Tuesday–Whenever)

**Actor:** Human (in Notion)

1. Review each draft
2. Edit if needed (tone, accuracy, length)
3. Mark → Status: Approved
4. Set Publish Date (schedule for specific day)
5. System transitions to Status: Scheduled

### Step 5: Publishing (Daily)

**Agent:** content-publisher | **Model:** Sonnet | **Skills:** `/content-publish`

1. Query Notion: Status = Scheduled AND Publish Date = today
2. Verify approval chain (must have passed through Approved)
3. Final slop check
4. Publish via LinkedIn provider
5. Update Notion: Status → Published, write Post ID
6. Notify Slack

**Output:** Live LinkedIn posts, state tracked in Notion

### Step 6: Engagement Tracking (Daily)

**Agent:** engagement-tracker | **Model:** Sonnet | **Skills:** `/engagement-track`

1. Pull metrics for all Published posts
2. Update Notion Metrics fields
3. Build warm-lead table (2+ engagements = warm lead)
4. Flag hot posts (>2x average engagement)
5. Detect plateaus (no growth → transition to Tracking)

**Output:** Updated metrics, warm-leads.yaml, hot-posts.yaml

### Step 7: Weekly Report (Friday)

**Agent:** content-reporter | **Model:** Sonnet | **Skills:** `/content-report`

1. Pull 7-day metrics from Notion
2. Calculate KPIs and week-over-week deltas
3. Analyze by pillar, format, hook type, day-of-week
4. Generate 3-5 actionable recommendations
5. Write full report to `.deliberate/reports/content/weekly-{date}.md`
6. Post condensed summary to Slack

**Output:** Strategic recommendations that feed back into next week's research

## Decision Gates

| Gate | Who Decides | Condition |
|---|---|---|
| Idea → Approved | Human | Idea has clear angle, fits pillar strategy |
| Draft → Approved | Human | Post quality, accuracy, voice match |
| Scheduled → Published | Automated | Approval verified, slop-free, within rate limit |
| Published → Tracking | Automated | Engagement plateaued (>7 days, <5% change) |

## State Machine (Notion Status)

```
Idea → Drafting → Review → Approved → Scheduled → Published → Tracking
                    ↑                                    │
                    └── bounced (slop violations) ───────┘
```

## Infrastructure

- **Schedules:** `schedules/*.yaml` — recurring task definitions
- **State:** `.deliberate/schedules/*.last` — prevents double-execution
- **Notion:** `integrations/notion/` — database client
- **LinkedIn:** `integrations/linkedin/` — provider abstraction
- **Assets:** `content/corpus/`, `content/slop-blacklist.yaml`
- **Reports:** `.deliberate/reports/content/`

## Exit Condition

This workflow is continuous — it doesn't "exit." It runs weekly in perpetuity. To pause, set `schedules_enabled: false` in config or remove schedule YAML files.
