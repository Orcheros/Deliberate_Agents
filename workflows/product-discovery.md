# Product Discovery

## Purpose

Transform a new opportunity or unvalidated backlog item into a validated, prioritized set of features ready for initiative intake. This workflow moves from strategic framing through user research, assumption testing, and evidence-based prioritization — ensuring that what enters the build pipeline has been de-risked through discovery.

## Trigger

New opportunity identified (market signal, user research finding, strategic pivot) or existing backlog item needs validation before committing engineering resources.

## Agent Sequence

```
Trigger (opportunity or unvalidated backlog item)
  ↓
Product Strategist
  /product-vision → /product-strategy-canvas → /market-scan
  ↓ Strategic foundation
  ↓
Market Researcher
  /user-personas → /customer-journey-map → /analyze-feedback
  ↓ User research complete
  ↓
Product Manager (Discovery Mode)
  /brainstorm-ideas → /identify-assumptions → /design-experiments
  ↓ Experiments designed
  ↓
[HUMAN GATE: Run experiments, collect data]
  ↓
Product Manager
  /opportunity-solution-tree → /prioritize-features
  ↓ Priority backlog ready
  ↓
/pm-intake (creates one-pager)
  ↓
Initiative enters backlog/ → normal initiative-build workflow
```

### Step 1: Product Strategist — Strategic Foundation

**Input:** Opportunity description or unvalidated backlog item
**What happens:**
1. `/product-vision` — Establish or refine the product vision relevant to this opportunity. Clarify the long-term direction and how this opportunity fits.
2. `/product-strategy-canvas` — Map the strategic landscape: value proposition, customer segments, channels, competitive position, key metrics, and unfair advantages.
3. `/market-scan` — Scan the competitive and market environment. Identify trends, competitor moves, regulatory shifts, and timing factors that affect this opportunity.

**Output:** Strategic context documents — vision alignment, strategy canvas, market scan report
**Decision Gate:** Does the opportunity align with product vision and strategy? If not, park it with rationale. If yes, proceed.

### Step 2: Market Researcher — User Research

**Input:** Strategic context from Step 1
**What happens:**
1. `/user-personas` — Build or update personas relevant to this opportunity. Identify who has the problem, their context, and their current alternatives.
2. `/customer-journey-map` — Map the current customer journey around the problem space. Identify pain points, moments of truth, and emotional highs/lows.
3. `/analyze-feedback` — Analyze existing feedback data (support tickets, NPS comments, reviews, survey responses) for signals related to this opportunity.

**Output:** Persona documents, journey map, feedback analysis report
**Decision Gate:** Is there sufficient evidence of real user need? If evidence is thin, trigger `/customer-interview-guide` and conduct interviews before proceeding. If evidence is strong, proceed.

### Step 3: Product Manager (Discovery Mode) — Ideation and Experiment Design

**Input:** Strategic context + user research from Steps 1-2
**What happens:**
1. `/brainstorm-ideas` — Generate solution ideas from PM, Designer, and Engineer perspectives. Produce a ranked idea list.
2. `/identify-assumptions` — Map all assumptions underlying the top ideas. Prioritize by Impact x Evidence risk score.
3. `/design-experiments` — Design lightweight validation experiments (pretotyping, prototype tests, surveys) for the highest-risk assumptions.

**Output:** Brainstorm document, assumption map, experiment plan with cards
**Decision Gate:** Are experiments feasible with available resources? If experiments require resources or access the team doesn't have, escalate or adjust scope.

### Step 4: Human Gate — Run Experiments

**Input:** Experiment plan from Step 3
**What happens:**
- Humans execute the designed experiments: run fake door tests, conduct usability sessions, launch surveys, build prototypes, analyze data
- Results are documented with actual data, observations, and learnings
- Experiment cards are updated with outcomes (validated / invalidated / inconclusive)

**Output:** Experiment results documentation
**This step requires human execution — agents cannot run experiments with real users.**

### Step 5: Product Manager — Synthesis and Prioritization

**Input:** Experiment results + all prior context
**What happens:**
1. `/opportunity-solution-tree` — Build an Opportunity Solution Tree from the validated learnings. Map the outcome, opportunities (validated), solutions (tested), and remaining experiments.
2. `/prioritize-features` — Take the validated solutions and prioritize them using RICE scoring, strategic alignment, and evidence strength.

**Output:** Opportunity Solution Tree document, prioritized feature backlog
**Decision Gate:** Is there at least one Tier 1 feature with strong evidence and strategic alignment? If yes, proceed to intake. If no, either run more experiments or park the opportunity.

### Step 6: Initiative Intake

**Input:** Top-priority validated feature(s) from Step 5
**What happens:**
1. `/pm-intake` — Create a formal one-pager for the highest-priority validated feature. The one-pager is grounded in discovery evidence, not speculation.

**Output:** One-pager in `backlog/`, queue file with status `QUEUED`
**The initiative now enters the normal initiative-build workflow** (see [Initiative Discovery](initiative-discovery.md) and Initiative Lifecycle).

## Decision Gates

| Gate | Location | Question | If No |
|------|----------|----------|-------|
| Strategic Fit | After Step 1 | Does this align with vision and strategy? | Park with rationale |
| User Need | After Step 2 | Is there evidence of real user need? | Run interviews first |
| Experiment Feasibility | After Step 3 | Can we run these experiments? | Adjust scope or escalate |
| Validation Strength | After Step 5 | Do we have validated evidence? | Run more experiments or park |

## Exit Condition

One-pager exists in `backlog/` with status `QUEUED`, backed by discovery evidence (experiment results, user research, strategic analysis). The initiative is ready for the founder to select for grooming, at which point it enters the Initiative Build workflow.

## Timing

Multi-session workflow spanning multiple agent runs. The Human Gate (Step 4) introduces a pause of days to weeks depending on experiment complexity. Steps 1-3 and Steps 5-6 can each be completed in single agent sessions.
