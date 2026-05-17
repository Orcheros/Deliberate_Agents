# Customer Research Pipeline

## Purpose

Conduct end-to-end customer research — from interview preparation through synthesis, persona creation, segmentation, and journey mapping. Produces a complete research package that feeds strategy, product discovery, and GTM decisions.

This workflow is the deep-dive counterpart to the research step in Product Discovery. Use Product Discovery for breadth (strategic scan + lightweight research + experiments). Use this workflow when you need rigorous, primary research grounded in direct customer conversations.

## Trigger

- Product Discovery reveals thin user evidence (Decision Gate after Step 2)
- New market entry requires foundational customer understanding
- Persona refresh needed (quarterly or after significant market shift)
- Pre-launch research for a major initiative
- Churn spike or engagement anomaly requires qualitative investigation

## Agent Sequence

```
Trigger (research need identified)
  ↓
Market Researcher
  /customer-interview-guide
  ↓ Interview scripts ready
  ↓
[HUMAN GATE: Recruit participants, conduct interviews]
  ↓
Market Researcher
  /interview-synthesis
  ↓ Raw insights extracted
  ↓
Market Researcher
  /user-personas → /user-segmentation → /customer-journey-map
  ↓ Research package complete
  ↓
Product Manager
  /analyze-feedback (merge quant signals with qual findings)
  ↓
Research artifacts feed into:
  → Product Discovery (/brainstorm-ideas, /identify-assumptions)
  → Strategy (/product-strategy-canvas, /positioning-statement)
  → GTM (/ideal-customer-profile, /beachhead-segment)
```

### Step 1: Market Researcher — Interview Preparation

**Input:** Research objectives — what questions need answering, which customer segments to target, what decisions the research will inform
**What happens:**
1. `/customer-interview-guide` — Build structured interview scripts tailored to the research objectives. Define participant criteria, warm-up questions, JTBD probing sequences, pain point deep-dives, and closing protocol. Produce logistics checklist (recording consent, scheduling, incentives).

**Output:** Interview guide document with scripts, participant criteria, and logistics plan
**Decision Gate:** Are research objectives clear and participant criteria specific enough to recruit? If criteria are too broad, refine before proceeding.

### Step 2: Human Gate — Conduct Interviews

**Input:** Interview guide from Step 1
**What happens:**
- Recruit 8-12 participants matching the defined criteria (minimum 5 per segment)
- Conduct interviews using the prepared scripts (45-60 minutes each)
- Record and transcribe all sessions (with participant consent)
- Take field notes on non-verbal cues, environment context, and emotional reactions

**Output:** Interview transcripts, field notes, recordings
**This step requires human execution — agents cannot conduct interviews with real users.**

### Step 3: Market Researcher — Interview Synthesis

**Input:** Interview transcripts and field notes from Step 2
**What happens:**
1. `/interview-synthesis` — Process all transcripts through structured analysis. Extract JTBD patterns (functional, emotional, social jobs). Code satisfaction and dissatisfaction signals with verbatim quotes as evidence. Map emotional journeys across participants. Identify unmet needs and generate opportunity statements. Score opportunities by frequency x intensity.

**Output:** Interview synthesis report with JTBD patterns, opportunity statements, and evidence matrix
**Decision Gate:** Do patterns emerge clearly across participants? If findings are contradictory or inconclusive, consider additional interviews targeting the ambiguous segments.

### Step 4: Market Researcher — Persona & Segmentation

**Input:** Synthesis report from Step 3 + any existing quantitative data (analytics, surveys, CRM)
**What happens:**
1. `/user-personas` — Build 3+ refined personas grounded in interview evidence. Each persona includes demographics, goals, frustrations, JTBD (functional + emotional + social), behavioral patterns, and key quotes. Include anti-personas to clarify who is NOT the target user.
2. `/user-segmentation` — Segment the user base using behavioral, needs-based, and value-based approaches informed by the qualitative research. Size each segment, estimate growth trajectory, and score product fit.
3. `/customer-journey-map` — Map the end-to-end journey for each primary persona. Cover all stages from Awareness through Advocacy (or Churn), documenting touchpoints, emotions, pain points, and opportunities at each stage.

**Output:** Persona documents, segmentation matrix, journey maps
**Decision Gate:** Do personas and journey maps align with the opportunity statements from synthesis? If personas reveal a segment not represented in interviews, flag for follow-up research.

### Step 5: Product Manager — Quantitative Validation

**Input:** Research package from Steps 3-4 + product analytics and feedback data
**What happens:**
1. `/analyze-feedback` — Analyze existing quantitative feedback (NPS responses, support tickets, app store reviews, survey data) to validate or challenge qualitative findings. Look for convergence between what users say in interviews and what they signal through behavior and feedback at scale.

**Output:** Validated research package — qualitative findings cross-referenced with quantitative signals
**Decision Gate:** Do qualitative and quantitative signals converge? Document any divergences as open questions for future investigation.

## Decision Gates

| Gate | Location | Question | If No |
|------|----------|----------|-------|
| Objectives Clarity | After Step 1 | Are research objectives and participant criteria specific? | Refine criteria before recruiting |
| Pattern Emergence | After Step 3 | Do clear patterns emerge across participants? | Conduct additional interviews |
| Persona Alignment | After Step 4 | Do personas align with opportunity statements? | Flag gaps for follow-up research |
| Qual/Quant Convergence | After Step 5 | Do qualitative and quantitative signals agree? | Document divergences as open questions |

## Exit Condition

Complete research package exists: interview synthesis, validated personas, segmentation matrix, and journey maps — all cross-referenced with quantitative data. Artifacts are ready to feed into Product Discovery, Strategy, or GTM workflows.

## Timing

Multi-session workflow. Steps 1 and 3-5 are single agent sessions each. The Human Gate (Step 2) spans 1-3 weeks depending on recruitment and scheduling. Steps 4a-4c (personas, segmentation, journey map) can run sequentially in one Market Researcher session.
