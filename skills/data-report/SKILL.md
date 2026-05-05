---
name: data-report
description: Build structured reports with findings, visualizations, and recommendations
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Step 2: Build Report

## Objective

Transform query results into a structured, actionable report that stakeholders can use for decisions.

## Instructions

1. **Structure the report** in `.deliberate/reports/{initiative-or-topic}/`:
   - Executive summary (2-3 sentences, the headline finding)
   - Key metrics table
   - Detailed findings with supporting data
   - Trends and comparisons (period-over-period, cohort-vs-cohort)
   - Recommendations (what to do based on the data)
   - Methodology (queries used, data range, assumptions)

2. **Present metrics clearly**:
   - Always include the time period and comparison period
   - Use absolute numbers AND percentages (e.g., "142 users, 23% of total")
   - Include confidence indicators — is the sample size meaningful?
   - Highlight changes with direction and magnitude ("up 15% from last month")

3. **Describe visualizations**:
   - For each chart/graph needed, write a specification:
     - Chart type (line, bar, funnel, cohort heatmap)
     - Axes and labels
     - Data series
     - Key callouts or annotations
   - Include the raw data table so visualizations can be built

4. **Make recommendations actionable**:
   - Connect each finding to a specific product or business decision
   - Prioritize by impact and confidence level
   - Flag findings that need deeper investigation
   - Note any caveats or limitations

5. **Write the report** to `.deliberate/reports/{slug}/report.md`

## Output

- Structured report in markdown
- Raw data tables for visualization
- Queries used (for reproducibility)

## Transition

Report complete. Update assignment status.
