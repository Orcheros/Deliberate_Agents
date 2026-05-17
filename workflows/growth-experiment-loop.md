# Growth Experiment Loop

## Purpose

Design, execute, and analyze growth experiments in a continuous cycle. This workflow connects the Growth Strategist (experiment design), Data Analyst (measurement), and Growth Strategist again (iteration) into a closed loop that systematically improves growth metrics.

The Feedback Loop workflow covers post-ship product iteration. This workflow covers growth-specific experimentation — acquisition, activation, retention, revenue, and referral experiments that run continuously alongside product development.

## Trigger

- New North Star Metric defined or existing NSM plateauing
- Growth strategist identifies a testable growth lever
- Quarterly growth planning cycle
- Underperforming funnel stage identified (e.g., activation rate drop)
- New channel or growth loop hypothesis to validate

## Agent Sequence

```
Trigger (growth lever identified)
  ↓
Product Strategist
  /north-star-metric
  ↓ NSM and input metrics defined
  ↓
Growth Strategist
  /growth-assess → /growth-loops → /experiment-design
  ↓ Experiments designed and prioritized
  ↓
[HUMAN GATE: Implement and run experiments]
  ↓
Data Analyst
  /ab-test-analysis → /cohort-analysis
  ↓ Results analyzed
  ↓
Growth Strategist
  /growth-plan
  ↓ Next iteration planned
  ↓
Decision Gate → loop back or graduate
```

### Step 1: Product Strategist — Metric Foundation

**Input:** Business context, current growth data, strategic objectives
**What happens:**
1. `/north-star-metric` — Define or validate the North Star Metric. Classify the business game (attention, transaction, productivity). Derive 3-5 input metrics that drive the North Star. Set baselines and targets. Establish monitoring cadence.

**Output:** North Star Metric document with input metrics, baselines, and targets
**Decision Gate:** Is the NSM clearly defined with measurable input metrics? If the team can't agree on the NSM, this needs founder resolution before proceeding.

### Step 2: Growth Strategist — Experiment Design

**Input:** NSM document from Step 1 + current funnel data + competitive intelligence
**What happens:**
1. `/growth-assess` — Analyze current growth state. Identify which input metrics are underperforming relative to benchmarks. Map the funnel to find the highest-leverage bottleneck.
2. `/growth-loops` — Design candidate growth loops targeting the identified bottleneck. Evaluate viral, content, paid, sales, and product loops. Select primary and secondary loops based on cycle time and amplification factor.
3. `/experiment-design` — Design 3-5 experiments to test the selected growth loops. For each experiment: write If/Then/Because hypothesis, define primary and guardrail metrics, estimate sample size, set stopping rules, prioritize with ICE scoring.

**Output:** Growth assessment, growth loop diagrams, prioritized experiment plan
**Decision Gate:** Are the top experiments feasible with current resources and traffic? If sample size requirements exceed available traffic, adjust MDE or consider qualitative validation instead.

### Step 3: Human Gate — Run Experiments

**Input:** Prioritized experiment plan from Step 2
**What happens:**
- Engineering implements the highest-priority experiment (feature flags, landing page variants, flow changes)
- Experiment runs for the planned duration — no early stopping without sequential testing
- Guardrail metrics are monitored continuously
- All implementation details and any deviations from the plan are documented

**Output:** Raw experiment data, implementation notes, any incidents during the test period
**This step requires human execution — agents cannot implement production experiments or manage traffic splitting.**

### Step 4: Data Analyst — Results Analysis

**Input:** Raw experiment data from Step 3
**What happens:**
1. `/ab-test-analysis` — Validate test setup (randomization check, sample ratio mismatch detection). Calculate statistical significance. Compute confidence intervals. Check for practical significance (not just p-value). Analyze segment-level effects (do power users respond differently than new users?). Check for novelty effects. Produce ship/extend/stop recommendation.
2. `/cohort-analysis` — Analyze the experiment's impact on cohort-level metrics. Build retention curves for treatment vs. control. Check if the experiment affects long-term behavior (Day 7, Day 30 retention) or only short-term (Day 1). Identify which cohorts benefit most.

**Output:** Experiment analysis report with statistical results, cohort impact, and recommendation
**Decision Gate:** Is the result statistically and practically significant? If inconclusive, determine whether to extend the test, increase sample size, or redesign the experiment.

### Step 5: Growth Strategist — Iteration Planning

**Input:** Analysis report from Step 4 + original growth assessment
**What happens:**
1. `/growth-plan` — Based on experiment results, plan the next iteration. If the experiment succeeded: plan rollout and design the next experiment in the sequence. If it failed: diagnose why, update the growth loop model, and design an alternative approach. Update the input metric targets based on observed lift. Document learnings in the growth playbook.

**Output:** Updated growth plan with next experiment slate, revised targets, and learnings
**This feeds back into Step 2 for the next cycle.**

## Decision Gates

| Gate | Location | Question | If No |
|------|----------|----------|-------|
| Metric Clarity | After Step 1 | Is the NSM defined with measurable inputs? | Resolve with founder before proceeding |
| Experiment Feasibility | After Step 2 | Can we run these experiments with current traffic? | Adjust MDE or use qualitative methods |
| Statistical Validity | After Step 4 | Is the result significant and trustworthy? | Extend test, increase sample, or redesign |
| Loop Continuation | After Step 5 | Is there more growth leverage in this loop? | Graduate to next bottleneck or loop type |

## Loop Graduation Criteria

Exit the experiment loop for a given growth lever when:
- The input metric has reached its target (within 10%)
- Three consecutive experiments on the same lever show diminishing returns
- A higher-leverage bottleneck has been identified elsewhere in the funnel
- The growth loop is self-sustaining and no longer requires active experimentation

When graduating, the Growth Strategist documents the playbook for the optimized loop and shifts focus to the next input metric or bottleneck.

## Exit Condition

Growth plan updated with results, learnings documented, next experiment slate queued. If the loop is graduating, a playbook is written and the team shifts to the next growth lever.

## Timing

Continuous cycle. Steps 1-2 and 4-5 are single agent sessions. The Human Gate (Step 3) runs 1-4 weeks depending on required sample size and traffic volume. Healthy teams run 2-4 experiment cycles per quarter.
