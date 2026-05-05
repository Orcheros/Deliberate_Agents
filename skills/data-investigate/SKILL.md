---
name: data-investigate
description: Deep-dive investigation into metric anomalies, trends, or specific business questions
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Step 3: Investigate

## Objective

Conduct a deep-dive investigation into a specific metric anomaly, unexpected trend, or business question that requires analysis beyond standard reporting.

## Instructions

1. **Define the investigation scope**:
   - What specifically is unexpected or needs explaining?
   - When did the anomaly start? (narrow the time window)
   - What's the baseline expectation vs. what's observed?

2. **Hypothesis-driven analysis**:
   - List 3-5 plausible explanations for the observation
   - For each hypothesis, identify what data would confirm or refute it
   - Test hypotheses in order of likelihood and ease of verification

3. **Segmentation analysis**:
   - Break the anomaly down by user segment (plan tier, signup date, geography, acquisition channel)
   - Is the effect uniform or concentrated in a specific segment?
   - Check for external factors (deployment dates, marketing campaigns, seasonal patterns)

4. **Correlate with events**:
   - Check git log for deployments around the anomaly start date
   - Check for marketing campaigns or external events
   - Look for infrastructure incidents (error rates, latency spikes)
   - Check for data pipeline issues (missing events, duplicate events)

5. **Document findings**:
   - Write investigation report with:
     - **Finding**: What happened and why (supported by data)
     - **Impact**: Quantified effect on the business
     - **Root Cause**: Most likely explanation with confidence level
     - **Recommendation**: What to do about it
     - **Follow-up**: Any monitoring or further analysis needed

## Output

- Investigation report in `.deliberate/reports/{slug}/investigation.md`
- Supporting queries and data
- Recommendations with priority

## Transition

Investigation complete. Update assignment status.
