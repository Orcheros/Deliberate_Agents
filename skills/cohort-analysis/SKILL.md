---
name: cohort-analysis
description: Cohort analysis for retention and engagement — build retention curves, calculate cohort metrics, identify trends, and find engagement predictors
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Cohort Analysis

## Objective

Perform cohort analysis to understand retention, engagement, and lifecycle patterns. Define cohorts by meaningful dimensions, build retention curves, calculate cohort-level metrics, identify trends across cohorts, and surface engagement predictors that inform product and growth strategy.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What question is this cohort analysis answering (retention trends, feature impact, channel quality)?
   - What time range to analyze?
   - What cohort definitions are relevant?
   - What metrics to track across cohorts?

2. **Define cohort dimensions** (use all that apply to the question):

   **Time-based cohorts** (most common):
   - Sign-up week or month — track how retention changes over time as the product evolves
   - Granularity depends on volume: weekly for high-volume, monthly for lower-volume

   **Acquisition channel cohorts**:
   - Organic search, paid ads, referral, direct, social, partnerships
   - Compare retention and engagement quality across channels

   **Plan tier cohorts**:
   - Free, starter, pro, enterprise
   - Track activation and retention differences by willingness to pay

   **Feature adoption cohorts**:
   - Users who adopted feature X in their first week vs. those who did not
   - Isolate whether specific features predict retention

   **Behavioral cohorts**:
   - Based on activation milestones hit (e.g., completed onboarding, invited teammate, created first project)
   - Identify which early behaviors predict long-term retention

3. **Build retention tables**:
   - Rows: cohorts (e.g., each sign-up month)
   - Columns: time periods (Day 1, Day 7, Day 14, Day 30, Day 60, Day 90, etc.)
   - Cell values: percentage of cohort still active in that period
   - Define "active" clearly: logged in? performed core action? both?
   - Include cohort sizes in the table (absolute numbers, not just percentages)

   Example format:
   ```
   Cohort     | Size | D1   | D7   | D14  | D30  | D60  | D90
   Jan 2025   | 450  | 65%  | 42%  | 35%  | 28%  | 22%  | 18%
   Feb 2025   | 520  | 68%  | 45%  | 38%  | 31%  | 25%  | --
   Mar 2025   | 610  | 72%  | 48%  | 40%  | 33%  | --   | --
   ```

4. **Calculate cohort-level metrics**:
   - **Day 1 retention**: percentage returning within 24 hours of signup (activation signal)
   - **Day 7 retention**: first-week stickiness
   - **Day 30 retention**: monthly retention baseline
   - **Activation rate**: percentage completing the defined activation milestone
   - **Time to activation**: median time from signup to activation milestone
   - **Feature adoption rate**: percentage of cohort adopting key features
   - **Expansion rate**: percentage upgrading or adding seats
   - **Churn rate**: percentage churning within the analysis period
   - For each metric, compare across cohorts to identify trends

5. **Identify trends across cohorts**:
   - Are newer cohorts retaining better or worse than older ones?
   - Is activation rate improving over time (product improvements working)?
   - Are specific channels producing increasingly better or worse cohorts?
   - Does seasonality affect cohort quality?
   - Separate product improvements from cohort mix changes (a channel shift can change retention without any product change)

6. **Find engagement predictors**:
   - Correlate early behaviors (first 7 days) with long-term retention (Day 30+)
   - Identify the "aha moment" actions: which early behaviors most predict retention?
   - Example analysis: "Users who complete 3 projects in their first week retain at 2.5x the rate of those who complete 0-1"
   - Look for causal candidates, not just correlations — does the action drive retention, or do already-engaged users just do both?
   - Rank engagement predictors by correlation strength and actionability

7. **Produce cohort analysis report**:
   - Summarize key findings: what's improving, what's declining, what predicts success
   - Visualize retention curves (ASCII or described for implementation)
   - Highlight the most actionable insight: what should the product team focus on?
   - Recommend follow-up analyses or experiments based on findings

## Output

Write deliverable to `.deliberate/reports/{slug}/cohort-analysis.md` including:
- Cohort definitions and rationale for each dimension used
- Retention tables (with absolute cohort sizes)
- Retention curves (ASCII visualization or description)
- Cohort-level metrics comparison table
- Trend analysis: what's improving or declining across cohorts
- Engagement predictors: ranked list of early behaviors that predict retention
- Key findings and recommendations (top 3-5 actionable insights)
- Methodology: "active" definition, data sources, time range, known data gaps

## Constraints

- Always include cohort sizes — percentages without absolute numbers are misleading (50% retention of a 10-person cohort is noise)
- Never compare cohorts of vastly different ages — newer cohorts have less data, don't extrapolate
- Clearly label incomplete data points (cohorts that haven't reached Day 90 yet)
- Distinguish correlation from causation in engagement predictor analysis
- Document the "active" definition used — different definitions produce different retention curves

## Transition

Cohort analysis feeds into `/ab-test-analysis` for long-term experiment tracking, `/user-segmentation` for behavioral segment validation, and product prioritization for onboarding and activation improvements.
