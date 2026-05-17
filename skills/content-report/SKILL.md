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

1. Query Notion for all posts published in the last 7 days across ALL platforms
2. For each post, collect metrics from every platform where it was published:
   - LinkedIn, Twitter, Threads, Facebook, Instagram, YouTube, TikTok, Reddit, HackerNews, ProductHunt
3. Query Notion for all posts in "Tracking" status (historical comparison)
4. Read `content/warm-leads.yaml` for cross-platform lead generation metrics
5. Read `.deliberate/reports/content/hot-posts.yaml` for flagged high-performers
6. Read previous week's report (if exists) for week-over-week comparison
7. Gather per-platform API metrics via: `./integrations/social/start.sh --platform {platform} --metrics {post_id}`

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

### Step 5: Cross-Platform Comparison

Compare performance across all active platforms:

**By Platform:**
| Platform | Posts | Avg ER | Total Impressions | Top Post | Warm Leads |
|---|---|---|---|---|---|

**Cross-Platform Insights:**
- Which platform drives the highest engagement rate?
- Which platform generates the most warm leads per post?
- Are there content types that perform better on specific platforms?
- Identify content that succeeded on one platform but not others (repurpose opportunity)

**Platform Health:**
- Audience growth rate per platform (week-over-week)
- Best performing day/time per platform
- Platform-specific engagement trends (growing, stable, declining)

### Step 6: Generate Recommendations

Based on the data, produce 3-5 actionable recommendations:

1. **Double-down**: Which pillar/format/hook combinations are outperforming? Suggest increasing frequency.
2. **Retire or pivot**: Which combinations consistently underperform? Suggest reducing or reimagining.
3. **Experiment**: Untested combinations worth trying based on audience signals.
4. **Timing**: Any day-of-week patterns to optimize posting schedule.
5. **Warm leads**: Notable engagement patterns worth sales follow-up.

Each recommendation must cite specific data points.

### Step 7: Write Report

Output to `.deliberate/reports/content/weekly-{YYYY-MM-DD}.md`:

```markdown
# Content Performance Report — Week of {date}

## Summary
- Posts published: N (across M platforms)
- Total impressions: N
- Average engagement rate: X%
- Warm leads generated: N
- Best performing platform: {platform} (X% ER)
- Week-over-week: [better/worse/flat]

## Breakdown by Platform
| Platform | Posts | Impressions | Avg ER | Warm Leads | Trend |
|---|---|---|---|---|---|
| LinkedIn | N | N | X% | N | [up/down/flat] |
| Twitter | N | N | X% | N | [up/down/flat] |
| Threads | N | N | X% | N | [up/down/flat] |
| Facebook | N | N | X% | N | [up/down/flat] |
| YouTube | N | N | X% | N | [up/down/flat] |
| TikTok | N | N | X% | N | [up/down/flat] |
| Instagram | N | N | X% | N | [up/down/flat] |
| Reddit | N | N | X% | N | [up/down/flat] |

## Cross-Platform Comparison
- Best ER: {platform} at X%
- Most impressions: {platform} with N
- Most warm leads: {platform} with N
- Rising platform: {platform} (+X% WoW)
- Declining platform: {platform} (-X% WoW)

## Platform-Specific Recommendations
- {platform}: [specific recommendation based on data]
- {platform}: [specific recommendation based on data]

## Top Performers
[table — include platform column]

## Worst Performers
[table — include platform column]

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
- N new warm leads this week (across N platforms)
- Notable: [any particularly engaged prospects]
- Cross-platform leads: [leads appearing on multiple platforms]

## Next Week Focus
- [specific content priorities based on data]
- [platform-specific priorities]
```

### Step 8: Post Slack Summary

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
