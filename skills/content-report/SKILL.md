---
name: content-report
description: Generate weekly content performance report with metrics, trends, and strategic recommendations
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Content Report

## Objective

Produce a weekly content performance report covering the last 7 days. Includes key metrics, top/worst performers, trend analysis, and actionable double-down recommendations. Delivered as a markdown report and Slack summary.

## Process

### Step 1: Gather Data

1. Query Notion for all posts published in the last 7 days
2. Query Notion for all posts in "Tracking" status (historical comparison)
3. Read `content/warm-leads.yaml` for lead generation metrics
4. Read `.deliberate/reports/content/hot-posts.yaml` for flagged high-performers
5. Read previous week's report (if exists) for week-over-week comparison

### Step 2: Calculate Metrics

**This Week's Numbers:**
- Total posts published
- Total impressions (sum)
- Average engagement rate
- Total new followers (if available via API)
- Total warm leads generated
- Comments received
- Shares received

**Week-over-Week Delta:**
- Impressions: +X% or -X%
- Engagement rate: +X pp or -X pp
- Posts published: N vs N-1
- Warm leads: +N new

### Step 3: Identify Top and Worst Performers

**Top 3 posts** (by engagement rate):
| Post | Impressions | ER | Pillar | Format | Hook |
|---|---|---|---|---|---|

**Worst 3 posts** (by engagement rate, minimum 500 impressions):
| Post | Impressions | ER | Pillar | Format | Hook |

### Step 4: Pattern Analysis

Break down performance by:

**By Pillar:**
| Pillar | Posts | Avg ER | Trend |
|---|---|---|---|

**By Format:**
| Format | Posts | Avg ER | Trend |
|---|---|---|---|

**By Hook Type:**
| Hook | Posts | Avg ER | Trend |
|---|---|---|---|

**By Day of Week:**
| Day | Posts | Avg ER |
|---|---|---|

### Step 5: Generate Recommendations

Based on the data, produce 3-5 actionable recommendations:

1. **Double-down**: Which pillar/format/hook combinations are outperforming? Suggest increasing frequency.
2. **Retire or pivot**: Which combinations consistently underperform? Suggest reducing or reimagining.
3. **Experiment**: Untested combinations worth trying based on audience signals.
4. **Timing**: Any day-of-week patterns to optimize posting schedule.
5. **Warm leads**: Notable engagement patterns worth sales follow-up.

Each recommendation must cite specific data points.

### Step 6: Write Report

Output to `.deliberate/reports/content/weekly-{YYYY-MM-DD}.md`:

```markdown
# Content Performance Report — Week of {date}

## Summary
- Posts published: N
- Total impressions: N
- Average engagement rate: X%
- Warm leads generated: N
- Week-over-week: [better/worse/flat]

## Top Performers
[table]

## Worst Performers
[table]

## Breakdown by Pillar
[table]

## Breakdown by Format
[table]

## Breakdown by Hook Type
[table]

## Recommendations
1. [recommendation with data citation]
2. ...

## Warm Lead Highlights
- N new warm leads this week
- Notable: [any particularly engaged prospects]

## Next Week Focus
- [specific content priorities based on data]
```

### Step 7: Post Slack Summary

Post condensed version to Slack:
```
📊 Weekly Content Report — {date}

Posts: N | Impressions: N | Avg ER: X%
WoW: [+X% / -X%] impressions, [+X pp / -X pp] engagement

🏆 Top: "[post title]" (X% ER)
📉 Worst: "[post title]" (X% ER)

💡 Key insight: [most actionable recommendation in 1 sentence]

Full report: .deliberate/reports/content/weekly-{date}.md
```

## Constraints

- Report must be data-driven — no recommendations without supporting metrics
- Minimum 500 impressions to include a post in worst-performers (avoid penalizing fresh posts)
- Week-over-week requires previous week's report to exist (skip delta on first run)
- Never include actual lead names in Slack summary (privacy)
- Report file naming must be consistent for historical lookup

## Output

- `.deliberate/reports/content/weekly-{date}.md` — full report
- Slack message — condensed summary
- Log entry in `.deliberate/logs/content-report.log`

## Transition

Weekly report feeds into → content-researcher (performance scan mode uses these insights) and → human strategic decisions about content direction.
