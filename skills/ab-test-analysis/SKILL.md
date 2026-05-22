---
name: ab-test-analysis
description: Analyze A/B test results — validate test setup, calculate statistical significance, check practical significance, and produce ship/extend/stop recommendations
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
aaaerrr-zone: "flywheel:engagement"
---

# A/B Test Analysis

## Objective

Analyze A/B test results with statistical rigor. Validate the test setup, calculate significance and confidence intervals, check for practical (not just statistical) significance, analyze segment-level effects, and produce a clear ship/extend/stop recommendation with supporting evidence.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What experiment is being analyzed?
   - What was the hypothesis (If/Then/Because)?
   - What are the primary, guardrail, and secondary metrics?
   - What was the minimum detectable effect (MDE) and success threshold?

2. **Validate test setup**:
   - **Randomization**: confirm users were randomly assigned to control and treatment
   - **Sample ratio mismatch (SRM)**: check that the control/treatment split matches the intended ratio (e.g., 50/50). Use chi-squared test: if p < 0.01, flag SRM — results are unreliable
   - **Sample size**: compare actual sample to pre-experiment power calculation. If underpowered, flag and note implications
   - **Duration**: confirm the test ran for the planned duration (at least 1-2 full business cycles to account for day-of-week effects)
   - **Contamination**: check for cross-group contamination (shared accounts, device switching)
   - **Pre-period check**: if available, verify that control and treatment groups had similar baseline metrics before the test started

3. **Calculate statistical significance**:

   **For proportion metrics** (conversion rates, click rates):
   - Z-test for two proportions
   - `Z = (p1 - p2) / sqrt(p_pool * (1 - p_pool) * (1/n1 + 1/n2))`
   - Where `p_pool = (x1 + x2) / (n1 + n2)`
   - Two-tailed p-value from Z statistic
   - 95% confidence interval: `(p1 - p2) +/- Z_0.025 * SE`

   **For continuous metrics** (revenue, session duration):
   - Welch's t-test (unequal variance assumed)
   - `t = (mean1 - mean2) / sqrt(s1^2/n1 + s2^2/n2)`
   - 95% confidence interval: `(mean1 - mean2) +/- t_0.025 * SE`

   **Report for each metric**:
   - Control mean/rate vs. treatment mean/rate
   - Absolute difference and relative lift (%)
   - Confidence interval (95%)
   - p-value
   - Whether statistically significant at alpha = 0.05

4. **Check practical significance**:
   - Statistical significance alone is not enough — a 0.1% lift can be significant with large N but meaningless
   - Compare the observed effect to the pre-defined MDE:
     - Effect >= MDE: practically significant
     - Effect > 0 but < MDE: statistically significant but too small to act on
     - Confidence interval includes 0: inconclusive
   - Estimate business impact: translate the effect into revenue, users, or engagement units
   - Check if the confidence interval is narrow enough for a confident decision

5. **Analyze guardrail metrics**:
   - For each guardrail metric, check for statistically significant degradation
   - Even if the primary metric improved, a guardrail violation may block shipping
   - Use one-sided tests for guardrails (only care about degradation)
   - Flag any guardrail within 1 SE of the degradation threshold as a warning

6. **Check for heterogeneous effects across segments**:
   - Break results down by pre-defined segments: platform, geography, plan tier, tenure, acquisition channel
   - Look for segments where the effect is significantly different from the overall (interaction effects)
   - Flag if the treatment helps one segment but hurts another
   - Caution: segment analysis is exploratory — more segments = more false positives. Apply Bonferroni correction or treat as hypothesis-generating

7. **Check for novelty and primacy effects**:
   - Plot the treatment effect over time (by day or week)
   - If the effect is strongest in the first few days and decays, this is a novelty effect — the true long-run effect is smaller
   - If the effect grows over time, the feature may need a learning period
   - Recommend extending the test if temporal patterns are unclear

8. **Produce recommendation**:
   - **Ship**: primary metric improved by >= MDE, statistically significant, no guardrail violations, no novelty decay, consistent across key segments
   - **Extend**: promising direction but underpowered, unclear temporal pattern, or need more data on a specific segment
   - **Stop / Revert**: no significant improvement, guardrail violation, negative effect, or novelty effect with no residual benefit
   - **Iterate**: the direction is right but the effect is below MDE — consider a stronger treatment
   - Include confidence level in the recommendation (high/medium/low)

## Sample Size Calculation Reference

For planning future tests, include these formulas:

**Proportions** (conversion rates):
`n = (Z_alpha/2 + Z_beta)^2 * (p1*(1-p1) + p2*(1-p2)) / (p1 - p2)^2`

**Means** (continuous metrics):
`n = (Z_alpha/2 + Z_beta)^2 * 2 * sigma^2 / delta^2`

Where:
- Z_alpha/2 = 1.96 for 95% confidence
- Z_beta = 0.84 for 80% power
- p1, p2 = baseline and expected conversion rates
- sigma = standard deviation of the metric
- delta = minimum detectable effect

## Output

Write deliverable to `.deliberate/reports/{slug}/ab-test-analysis.md` including:
- Test summary: hypothesis, metrics, duration, sample sizes
- Setup validation: SRM check, sample adequacy, duration adequacy
- Results table: metric, control, treatment, absolute diff, relative lift, CI, p-value, significant?
- Guardrail metrics status
- Segment analysis: notable differences across key segments
- Temporal analysis: effect stability over time
- Recommendation: ship / extend / stop / iterate with confidence level and rationale
- Appendix: sample size formulas for future test planning

## Constraints

- Never declare significance without checking practical significance — a tiny effect with p < 0.05 is not a win
- Never run multiple comparisons without correction — flag exploratory analyses as hypothesis-generating
- Never ignore guardrail violations — a primary win with a guardrail loss needs careful judgment
- Always check for SRM before interpreting results — if randomization failed, results are invalid
- Report confidence intervals, not just p-values — the range of plausible effects matters more than a binary yes/no

## Transition

A/B test results feed into product decisions (ship/iterate), `/experiment-design` for follow-up experiments, and `/cohort-analysis` for long-term impact tracking.
