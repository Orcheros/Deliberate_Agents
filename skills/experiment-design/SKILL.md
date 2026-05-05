---
name: experiment-design
description: Plan product experiments — write testable hypotheses, estimate sample size, prioritize tests with ICE scoring, interpret A/B outcomes
allowed-tools: Read, Write, Glob, Grep, Bash
---

# Experiment Design

## Objective

Design, prioritize, and evaluate product experiments with clear hypotheses and defensible decisions.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What metric or behavior is being tested?
   - What change or intervention is proposed?

2. **Write hypothesis in If/Then/Because format**:
   - If we change `[intervention]`
   - Then `[metric]` will change by `[expected direction/magnitude]`
   - Because `[behavioral mechanism]`

   **Quality checklist:**
   - [ ] Contains explicit intervention and audience
   - [ ] Specifies measurable metric change
   - [ ] States plausible causal reason
   - [ ] Includes expected minimum effect
   - [ ] Defines failure condition

3. **Define metrics before running test**:
   - **Primary metric**: single decision metric
   - **Guardrail metrics**: quality/risk protection (things that must NOT degrade)
   - **Secondary metrics**: diagnostics only, not decision-making

4. **Estimate sample size**:
   - Identify baseline conversion or baseline mean
   - Set minimum detectable effect (MDE) — the smallest change worth acting on
   - Choose significance level (alpha, typically 0.05) and power (typically 0.8)
   - Calculate: `n = (Z_α + Z_β)² × 2 × p(1-p) / MDE²` for proportions

5. **Prioritize experiments with ICE scoring**:
   - **Impact**: potential upside (1-10)
   - **Confidence**: evidence quality supporting the hypothesis (1-10)
   - **Ease**: cost/speed/complexity to run (1-10)
   - ICE Score = (Impact × Confidence × Ease) / 10
   - Rank experiments by ICE score and run the highest first

6. **Set stopping rules before launch**:
   - Decide fixed sample size or fixed duration in advance
   - No peeking without proper sequential testing method
   - Monitor guardrails continuously

7. **Interpret results**:
   - Statistical significance ≠ business significance
   - Compare point estimate + confidence interval to decision threshold
   - Investigate novelty effects and segment heterogeneity
   - p < alpha = evidence against null, not guaranteed truth
   - Wide confidence intervals = low precision even when significant

## Common Pitfalls

- Underpowered tests leading to false negatives
- Running too many simultaneous changes without isolation
- Changing targeting or implementation mid-test
- Stopping early on random spikes
- Declaring success from p-value without effect-size context

## Output

Write deliverable to `.deliberate/reports/{slug}/experiment-plan.md` including:
- Hypothesis for each experiment (If/Then/Because)
- Primary, guardrail, and secondary metrics
- Sample size requirements and expected duration
- ICE-scored priority ranking
- Stopping rules and success criteria
