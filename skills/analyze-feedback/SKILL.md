---
name: analyze-feedback
description: Analyze user feedback at scale — sentiment classification, theme extraction, trend detection, and segment-level insights with actionable recommendations
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Analyze Feedback

## Objective

Process user feedback at scale to extract actionable insights. Ingest feedback from multiple channels (NPS, reviews, support tickets, surveys), classify sentiment, extract themes, detect trends over time, and produce a report with prioritized recommendations. Includes methodology for handling bias in self-reported data.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What feedback sources are available (NPS responses, app store reviews, support tickets, survey results, social mentions)?
   - What time period to analyze?
   - Are there specific questions or hypotheses to investigate?
   - What segments or personas to break down by?

2. **Ingest and normalize feedback data**:
   - Collect feedback from all available channels into a unified format
   - For each feedback item, capture: source, date, user segment (if known), raw text, any numeric score
   - Normalize scoring scales (e.g., NPS -100 to +100, CSAT 1-5, star ratings 1-5)
   - Document source-specific biases:
     - App store reviews skew bimodal (1-star and 5-star overrepresented)
     - NPS captures extremes better than middle
     - Support tickets skew negative (users contact support when frustrated)
     - Surveys suffer from self-selection bias (engaged users overrepresented)
   - Note sample sizes per source and overall coverage

3. **Classify sentiment**:
   - Categorize each piece of feedback: **positive**, **negative**, **neutral**, or **mixed**
   - Assign confidence level: high (clear signal), medium (interpretation needed), low (ambiguous)
   - For mixed feedback, separate the positive and negative components
   - Calculate overall sentiment distribution and compare across sources
   - Flag sentiment shifts over time (improving, declining, stable)

4. **Extract themes and group by topic**:
   - Identify recurring themes across all feedback (e.g., "onboarding confusion", "missing integration", "pricing concerns")
   - Group individual feedback items under each theme
   - For each theme, capture:
     - Theme name and description
     - Number of mentions (frequency)
     - Sentiment breakdown within the theme
     - Representative quotes (3-5 per theme)
     - Affected user segments
   - Use hierarchical grouping: top-level categories (UX, features, pricing, support, performance) with sub-themes

5. **Perform frequency and trend analysis**:
   - Rank themes by frequency (most mentioned to least)
   - Analyze trends over time: which themes are growing, declining, or stable?
   - Identify seasonal patterns or event-driven spikes (e.g., feedback surge after a release)
   - Compare frequency across segments: do different user types raise different themes?
   - Calculate theme velocity: rate of change in mentions over the analysis period

6. **Generate segment-level insights**:
   - Break down sentiment and themes by user segment (plan tier, tenure, role, acquisition channel)
   - Identify segment-specific pain points not visible in aggregate data
   - Find segments with divergent feedback (e.g., enterprise users love feature X, SMB users hate it)
   - Map feedback themes to persona or segment profiles if available

7. **Apply bias correction methodology**:
   - Weight sources by representativeness (support tickets are not representative of all users)
   - Note the "silent majority" — most users never provide feedback; characterize what's missing
   - Flag themes that appear in only one source (may be source-specific, not universal)
   - Distinguish between frequency of feedback and severity of the issue
   - Cross-validate themes across multiple sources for confidence

8. **Produce prioritized recommendations**:
   - For each major theme, recommend a specific action: fix, investigate further, monitor, or accept
   - Prioritize by: frequency of mentions, severity of impact, alignment with strategy, feasibility
   - Link recommendations to specific product areas, features, or teams
   - Estimate potential impact: what would change if this theme were addressed?
   - Identify quick wins (high frequency, easy fix) vs. strategic investments (high impact, high effort)

## Output

Write deliverable to `.deliberate/reports/{slug}/feedback-analysis.md` including:
- Executive summary: top 3-5 findings and recommended actions
- Sentiment overview: distribution across all feedback, by source, and by segment
- Theme analysis: ranked list of themes with frequency, sentiment, quotes, and trends
- Trend analysis: themes over time with velocity indicators
- Segment breakdown: key differences across user segments
- Bias and methodology notes: sources used, sample sizes, known biases, confidence levels
- Prioritized recommendations: action items ranked by impact and feasibility

## Constraints

- Never fabricate or embellish feedback data — use only provided sources
- Always document sample sizes and source biases — small samples get low-confidence flags
- Respect PII — anonymize all user-identifying information in the report
- Do not conflate frequency with severity — a rare but critical issue may outrank a common annoyance
- Separate facts (what users said) from interpretation (what it means) clearly in the report

## Transition

Feedback analysis informs `/user-personas` refinement, `/customer-journey-map` pain point validation, `/experiment-design` hypothesis generation, and product prioritization. Themes map to PRD requirements and backlog items.
