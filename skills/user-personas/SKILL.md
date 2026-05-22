---
name: user-personas
description: Create refined user personas from research data — demographics, goals, frustrations, JTBD, behavioral patterns, and anti-personas
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:awareness"
---

# User Personas

## Objective

Create a minimum of 3 refined user personas from research data that ground product decisions in real user needs. Each persona synthesizes qualitative and quantitative research into an actionable archetype. Based on Alan Cooper's persona methodology and Anthony Ulwick's Jobs-to-be-Done framework.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What product or feature area are these personas for?
   - What research data is available (interviews, surveys, analytics, support tickets)?
   - Are there existing personas to refine or is this a fresh creation?

2. **Gather and synthesize research inputs**:
   - Customer interview transcripts or synthesis documents
   - Survey data and NPS/CSAT responses
   - Product usage analytics (feature adoption, session patterns, retention curves)
   - Support ticket themes and frequency
   - Sales call notes and objection patterns
   - Demographic and firmographic data
   - Flag gaps in available data and note assumptions made

3. **Identify persona clusters through behavioral patterns**:
   - Group users by behavior, not demographics — what they do matters more than who they are
   - Look for natural breakpoints in: usage frequency, feature adoption, workflow complexity, value derived
   - Validate clusters against multiple data sources (triangulation)
   - Aim for 3-5 distinct personas — enough to capture variation, few enough to be actionable
   - Each persona must represent a meaningfully different user need or behavior pattern

4. **Build each persona with full detail**:
   - **Name and photo description**: realistic, memorable, avoid stereotypes
   - **Demographics**: age range, location type, education level, income bracket
   - **Role and title**: job title, company size, industry, reporting structure
   - **Goals**: what they are trying to achieve (both with the product and in their broader role)
   - **Frustrations**: current pain points, workarounds, unmet needs
   - **Jobs-to-be-Done**:
     - Functional JTBD: the practical task they need to accomplish
     - Emotional JTBD: how they want to feel during and after
     - Social JTBD: how they want to be perceived by others
   - **Tech proficiency**: comfort level with technology, tools currently used
   - **Preferred channels**: how they discover, evaluate, and adopt new tools
   - **Key quotes**: 2-3 representative quotes (real or synthesized from research patterns)
   - **Behavioral patterns**: usage frequency, session length, feature preferences, upgrade triggers

5. **Define anti-personas** (who is NOT the user):
   - Identify 1-2 anti-personas — user types the product is explicitly not designed for
   - For each: describe who they are, why they are not the target, and what would need to change to serve them
   - Anti-personas prevent scope creep and keep the team focused on core users

6. **Prioritize personas**:
   - Rank personas by strategic importance: revenue potential, market size, product fit
   - Identify the primary persona (the one you design for first)
   - Note where persona needs conflict and how to resolve trade-offs

7. **Validate and document methodology**:
   - List all data sources used and sample sizes
   - Note confidence level for each persona (high/medium/low based on data quality)
   - Identify what additional research would strengthen the personas
   - Document when personas should be revisited (trigger events or time-based)

## Output

Write deliverable to `.deliberate/reports/{slug}/user-personas.md` including:
- 3-5 fully detailed personas (all fields from step 4)
- 1-2 anti-personas with rationale
- Persona priority ranking with justification
- Methodology section: data sources, sample sizes, confidence levels
- Recommendations for additional research to fill gaps

## Constraints

- Never fabricate research data — synthesize from available sources, flag assumptions clearly
- Every persona must be grounded in at least 2 data sources (triangulation)
- Avoid demographic stereotypes — personas are behavioral archetypes, not caricatures
- Do not create personas for user types with no supporting evidence
- Respect PII — use synthesized quotes and anonymized data only

## Transition

Personas feed directly into `/user-segmentation` for quantitative sizing and `/customer-journey-map` for experience mapping. They also inform ICP definitions used by Growth and GTM agents.
