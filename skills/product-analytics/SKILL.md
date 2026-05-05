---
name: product-analytics
description: Define product KPIs by stage, design metric dashboards, run cohort and retention analysis, interpret feature adoption trends
allowed-tools: Read, Write, Glob, Grep, Bash
---

# Product Analytics

## Objective

Define, track, and interpret product metrics appropriate to the current product stage.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What stage is the product? (Pre-PMF, Growth, Mature)
   - What specific metric questions need answering?

2. **Select metric framework**:
   - **AARRR** (Pirate Metrics): for growth loops and funnel visibility — Acquisition, Activation, Retention, Revenue, Referral
   - **North Star**: for cross-functional strategic alignment — single metric that captures core value delivery
   - **HEART**: for UX quality — Happiness, Engagement, Adoption, Retention, Task success

3. **Define stage-appropriate KPIs**:

   **Pre-PMF:**
   - Activation rate
   - Week-1 retention
   - Time-to-first-value
   - Problem-solution fit interview score

   **Growth:**
   - Funnel conversion by stage
   - Monthly retained users
   - Feature adoption among new cohorts
   - Expansion / upsell proxy metrics

   **Mature:**
   - Net revenue retention aligned metrics
   - Power-user share and depth of use
   - Churn risk indicators by segment

4. **Design dashboard layers**:
   - **Executive layer**: 5-7 directional metrics (trends, not isolated numbers)
   - **Product health layer**: acquisition, activation, retention, engagement
   - **Feature layer**: adoption, depth, repeat usage, outcome correlation

   **Dashboard principles:**
   - Show trends, not isolated point estimates
   - One owner per KPI
   - Pair each KPI with target, threshold, and decision rule ("if below X, then Y")
   - Use cohort and segment filters by default

5. **Run cohort analysis** (if data available):
   - Define cohort anchor event (signup, activation, first purchase)
   - Define retained behavior (active day, key action, repeat session)
   - Build retention matrix by cohort week/month
   - Compare curve shapes across cohorts
   - Flag early drop points and investigate friction

6. **Interpret retention curves**:
   - Sharp early drop, low plateau → onboarding mismatch or weak initial value
   - Moderate drop, stable plateau → healthy core with predictable churn
   - Flattening at low level → occasional use, revisit value metric
   - Improving newer cohorts → onboarding/positioning improvements working

## Anti-Patterns to Flag

| Anti-pattern | Fix |
|---|---|
| Vanity metrics (pageviews without activation context) | Pair acquisition with activation rate |
| Single-point retention ("30-day is 20%") | Compare retention curves across cohorts |
| Dashboard overload (30+ metrics) | Executive: 5-7. Feature: per-feature only |
| No decision rule on KPIs | Every KPI needs target, threshold, owner, action |
| Averaging across segments | Always segment by cohort, plan, channel |

## Output

Write deliverable to `.deliberate/reports/{slug}/product-analytics.md` including:
- Selected framework with rationale
- KPI definitions with targets and owners
- Dashboard spec (layers, metrics per layer)
- Cohort analysis findings (if data available)
- Recommended actions per metric insight
