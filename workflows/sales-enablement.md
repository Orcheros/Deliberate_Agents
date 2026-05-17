# Sales Enablement Pipeline

## Purpose

Build the complete sales toolkit — from ideal customer profile through competitive battlecards, messaging, and outreach sequences. This workflow connects Market Researcher (who the customer is), Growth Strategist (how to position and message), and SDR (how to reach and convert) into a coordinated pipeline that produces ready-to-use sales assets.

## Trigger

- New product or feature launch requires sales materials
- Entering a new market segment or vertical
- Competitive landscape shift (new entrant, competitor pivot, pricing change)
- Sales win rate dropping or deal cycle lengthening
- Quarterly sales enablement refresh
- New SDR onboarding — needs the full toolkit

## Agent Sequence

```
Trigger (sales enablement need)
  ↓
Market Researcher
  /ideal-customer-profile
  ↓ ICP defined with scoring rubric
  ↓
Market Researcher
  /competitive-teardown
  ↓ Competitive intelligence gathered
  ↓
Growth Strategist
  /competitive-battlecard → /value-proposition-statement
    → /positioning-statement → /gtm-messaging
  ↓ Sales assets created
  ↓
SDR
  /sales-research → /sales-outreach-prep
  ↓ Outreach sequences ready
  ↓
Sales assets deployed → pipeline
```

### Step 1: Market Researcher — Ideal Customer Profile

**Input:** Existing customer data (CRM, usage analytics, win/loss records), product positioning, target market definition
**What happens:**
1. `/ideal-customer-profile` — Build a detailed ICP covering firmographics (industry, company size, revenue, geography), technographics (tech stack, tools, integrations), behavioral signals (buying triggers, evaluation process, decision-making unit composition), JTBD, pain points, budget range, and deal velocity indicators. Define the negative ICP (who to disqualify early). Produce a lead scoring rubric with point thresholds for MQL, SQL, and disqualification.

**Output:** ICP document with firmographic/technographic/behavioral profiles, negative ICP, and lead scoring rubric
**Decision Gate:** Is the ICP grounded in actual customer data (not assumptions)? If based on assumptions, flag which attributes need validation through sales conversations or customer research.

### Step 2: Market Researcher — Competitive Intelligence

**Input:** ICP from Step 1 + list of competitors encountered in deals
**What happens:**
1. `/competitive-teardown` — Analyze 2-4 primary competitors using the 12-dimension rubric. Collect data from websites, app store reviews, job postings, SEO signals, and social mentions. Score each competitor. Build feature comparison matrix, pricing analysis, SWOT per competitor, positioning maps, strengths/weaknesses matrix, and win/loss analysis (if deal data available). Identify differentiation opportunities — features competitors lack, positioning angles unclaimed, segments underserved.

**Output:** Competitive teardown report with scorecards, feature matrix, positioning maps, and differentiation opportunities
**Decision Gate:** Do we have sufficient competitive data for the primary competitors? If a key competitor is opaque (no public pricing, limited reviews), flag for human competitive intelligence gathering.

### Step 3: Growth Strategist — Sales Asset Creation

**Input:** ICP from Step 1 + competitive teardown from Step 2
**What happens:**
1. `/competitive-battlecard` — Create 1-2 page battlecards per competitor. Each includes: quick facts, side-by-side positioning comparison, strengths to acknowledge, weaknesses to exploit, top 5 objections with scripted rebuttals, trap-setting discovery questions, win themes, loss patterns, pricing comparison, and migration talking points. Format for quick reference during live sales calls.
2. `/value-proposition-statement` — Craft value proposition statements using the 6-part JTBD template. Produce context-specific versions for: sales pitch (concise, outcome-focused), email outreach (curiosity-driven), demo opening (pain-anchored), and proposal executive summary (ROI-focused).
3. `/positioning-statement` — Define product positioning using April Dunford's framework. Map competitive alternatives, unique attributes, value delivered, target customer characteristics, and market category. Produce positioning canvas and competitive positioning maps.
4. `/gtm-messaging` — Build the complete messaging framework. Define messaging hierarchy (headline, subheadline, 3 key messages, proof points). Create persona-specific messaging variations for each ICP segment. Produce channel-adapted messaging matrix (email, LinkedIn, phone, demo, proposal). Include A/B test variations for the highest-volume touchpoints.

**Output:** Battlecards, value proposition statements, positioning document, messaging framework
**Decision Gate:** Are the battlecards and messaging consistent with each other? Review for contradictions between positioning claims and battlecard comparisons. Ensure value props are grounded in actual product capabilities (not aspirational).

### Step 4: SDR — Outreach Activation

**Input:** ICP + lead scoring rubric from Step 1, messaging framework from Step 3
**What happens:**
1. `/sales-research` — Research the first batch of prospects matching the ICP. Use CRM data, lead records, and public information to build prospect profiles. Score each prospect against the ICP rubric. Identify the decision-making unit members and their likely priorities.
2. `/sales-outreach-prep` — Build personalized outreach sequences for qualified prospects. Each sequence uses the messaging framework but is tailored to the prospect's specific context (industry, role, likely pain points, competitive situation). Define multi-touch cadence: initial outreach, follow-ups, channel mix (email, LinkedIn, phone), and breakup message.

**Output:** Prospect profiles with ICP scores, personalized outreach sequences ready for execution
**Decision Gate:** Are outreach sequences personalized beyond mail-merge level? Each sequence should reference specific prospect context, not just template variables.

## Decision Gates

| Gate | Location | Question | If No |
|------|----------|----------|-------|
| ICP Grounding | After Step 1 | Is the ICP based on real customer data? | Flag assumptions for validation |
| Competitive Coverage | After Step 2 | Do we have data on primary competitors? | Assign human competitive research |
| Asset Consistency | After Step 3 | Are battlecards and messaging aligned? | Reconcile contradictions before distributing |
| Personalization Quality | After Step 4 | Are outreach sequences genuinely personalized? | Revise with more prospect-specific detail |

## Maintenance Cadence

Sales enablement assets decay fast. Schedule refreshes:

| Asset | Refresh Cadence | Trigger for Ad-Hoc Refresh |
|-------|----------------|---------------------------|
| ICP | Quarterly | Win rate shift > 10%, new segment entry |
| Competitive Battlecards | Monthly | Competitor pricing change, feature launch, funding round |
| Value Propositions | Quarterly | Product launch, positioning shift |
| Messaging Framework | Quarterly | Conversion rate drop, new persona identified |
| Outreach Sequences | Monthly | Reply rate drop below threshold |

## Exit Condition

Complete sales toolkit deployed: ICP with scoring rubric, competitive battlecards per competitor, value proposition statements, positioning document, messaging framework, and personalized outreach sequences for the first prospect batch. SDR is equipped to execute.

## Timing

Four-step pipeline. Steps 1-2 (Market Researcher) can run in a single session. Step 3 (Growth Strategist) is one session. Step 4 (SDR) is one session per prospect batch. Full pipeline completes in 3 agent sessions plus any human competitive research time.
