# Feedback Loop

## Purpose

Close the build-measure-learn loop after an initiative ships. Collect data, synthesize feedback, run a retrospective, and decide whether to iterate, expand, or move on.

## Trigger

Initiative reaches shipped/ status (or post-launch review scheduled).

## Agent Sequence

```
Data Analyst
  /setup-metrics → /cohort-analysis → /ab-test-analysis
  ↓
Market Researcher
  /analyze-feedback → /interview-synthesis
  ↓
Product Manager
  /retro → /summarize-meeting
  ↓
Decision Gate
```

### Step 1: Data Analyst — `/setup-metrics` → `/cohort-analysis` → `/ab-test-analysis`

**Input:** Shipped initiative with tracking in place
**What happens:**
1. Configure and validate metric tracking for the shipped feature
2. Analyze user cohorts to understand adoption and retention patterns
3. Evaluate experiment results if A/B tests were running

**Output:** Metrics report with cohort analysis and experiment results
**Status:** Data collected and analyzed

### Step 2: Market Researcher — `/analyze-feedback` → `/interview-synthesis`

**Input:** Data analyst report + user feedback channels
**What happens:**
1. Synthesize user feedback from support tickets, surveys, and product analytics
2. Conduct or analyze user interview data for qualitative insights

**Output:** Feedback synthesis report with qualitative and quantitative findings
**Status:** Feedback analyzed

### Step 3: Product Manager — `/retro` → `/summarize-meeting`

**Input:** Data analyst report + feedback synthesis
**What happens:**
1. Run retrospective on the initiative — what went well, what didn't, action items
2. Document learnings and decisions from the review meeting

**Output:** Retro document + meeting summary with decision record
**Status:** Learnings documented

## Decision Gate

Product Manager + Founder decide:

- **Iterate**: `/brainstorm-ideas` → `/identify-assumptions` → (back to product-discovery workflow)
- **Expand**: promote to new initiative via `/pm-intake`
- **Ship & move on**: archive and proceed to next initiative

## Exit Condition

Retro documented, decision recorded, next action queued.

## Timing

Three-agent sequence. Data Analyst and Market Researcher can run in parallel. PM runs after both complete.
