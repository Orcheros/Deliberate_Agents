---
name: saas-metrics
description: Calculate SaaS health metrics from raw business numbers — ARR, MRR, churn, CAC, LTV, NRR — benchmark against industry standards, and prioritize actions
allowed-tools: Read, Write, Glob, Grep, Bash
---

# SaaS Metrics Analysis

## Objective

Take raw business numbers, calculate key health metrics, benchmark against industry standards, and deliver prioritized actionable advice.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What numbers are available? (MRR, customers, churn, spend)
   - What specific questions need answering?

2. **Collect inputs** (use what's available, note what's missing):
   - Revenue: current MRR, MRR last month, expansion MRR, churned MRR
   - Customers: total active, new this month, churned this month
   - Costs: sales and marketing spend, gross margin %

3. **Calculate metrics** using these formulas:
   - **ARR** = MRR × 12
   - **MRR Growth %** = (Current MRR - Prior MRR) / Prior MRR × 100
   - **Monthly Churn Rate** = Churned customers / Total customers at start of month
   - **ARPA** = MRR / Total customers
   - **LTV** = ARPA / Monthly churn rate
   - **CAC** = Sales & marketing spend / New customers acquired
   - **LTV:CAC Ratio** = LTV / CAC
   - **CAC Payback** = CAC / (ARPA × Gross margin %)
   - **NRR** = (Starting MRR + Expansion - Churned - Contraction) / Starting MRR × 100
   - **Quick Ratio** = (New MRR + Expansion) / (Churned + Contraction)

4. **Benchmark each metric** by segment and stage:

   | Metric | Early Stage | Growth | Scale |
   |--------|------------|--------|-------|
   | MRR Growth | >15% MoM | >10% MoM | >5% MoM |
   | Monthly Churn | <5% (SMB), <2% (Enterprise) | <3% | <1.5% |
   | LTV:CAC | >3:1 | >3:1 | >4:1 |
   | CAC Payback | <18 months | <12 months | <8 months |
   | NRR | >100% | >110% | >120% |
   | Quick Ratio | >2 | >4 | >4 |

   Label each: **HEALTHY** / **WATCH** / **CRITICAL**

5. **Prioritize top 2-3 issues** at WATCH or CRITICAL. For each:
   - What is happening (one sentence, plain English)
   - Why it matters to the business
   - 2-3 specific actions to take this month

## Key Principles

- Be direct. If a metric is bad, say it is bad.
- Cap priority issues at three — more paralyzes action.
- Context changes benchmarks: 5% churn is catastrophic for Enterprise but normal for SMB/PLG.
- Work with partial data. Be explicit about assumptions.

## Output

Write deliverable to `.deliberate/reports/{slug}/saas-health-report.md` using this structure:

```
# SaaS Health Report — {Month Year}

## Metrics at a Glance
| Metric | Your Value | Benchmark | Status |
|--------|------------|-----------|--------|

## Overall Picture
{2-3 sentences, plain English}

## Priority Issues
### 1. {Metric Name}
What is happening: ...
Why it matters: ...
Fix it this month: ...

## What is Working
{1-2 genuine strengths}

## 90-Day Focus
{Single metric to move + specific numeric target}
```
