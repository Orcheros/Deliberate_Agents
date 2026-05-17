---
name: interview-synthesis
description: Synthesize customer interview transcripts into structured insights — JTBD patterns, unmet needs, opportunity statements, and evidence-backed findings
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Interview Synthesis

## Objective

Transform raw interview transcripts and notes into structured, actionable insights. Extract Jobs-to-Be-Done patterns, identify unmet needs, map the emotional journey, and generate opportunity statements grounded in direct evidence (quotes). This skill merges summarization and synthesis into a single pass.

## Instructions

1. **Gather and read all interview materials**:
   - Read all available transcripts, notes, recordings summaries, and debrief documents
   - Identify the number of participants, their segments, and screening criteria used
   - Note the research objectives the interviews were designed to answer
   - If transcripts are partial or notes are sparse, flag gaps explicitly

2. **Extract JTBD patterns**:
   - For each interview, identify:
     - **Core job**: What the person was ultimately trying to accomplish
     - **Functional job**: The practical task or workflow
     - **Emotional job**: How they wanted to feel during/after
     - **Social job**: How they wanted to be perceived by others
   - Look for **trigger events** — what prompted the person to seek a solution or change behavior
   - Identify **push factors** (frustration with current state) and **pull factors** (attraction to new state)
   - Map **anxieties** (concerns about switching) and **habits** (inertia keeping them in current state)
   - Cluster similar jobs across participants and note frequency

3. **Identify satisfaction and dissatisfaction signals**:
   - Code each interview for moments of:
     - **Satisfaction**: positive language, relief, delight, efficiency gains
     - **Dissatisfaction**: frustration, confusion, workarounds, abandonment, emotional language
     - **Surprise**: unexpected behaviors, novel use cases, unintended usage patterns
   - Tag each signal with a direct quote and participant identifier (anonymized)
   - Count signal frequency across participants — patterns appearing in 3+ interviews are strong signals

4. **Map the emotional journey**:
   - For the primary workflow or task discussed, map the participant's emotional arc:
     - Stages: Awareness → Consideration → First Use → Regular Use → Expansion/Churn
     - At each stage: what they felt, what went well, what was frustrating
   - Identify the highest-friction moments (where most dissatisfaction clusters)
   - Identify moments of delight (where satisfaction peaks)

5. **Find unmet needs and generate opportunity statements**:
   - From the dissatisfaction signals, workarounds, and wish-list items, extract unmet needs
   - Convert each unmet need into an opportunity statement:
     - Format: "[User segment] needs a way to [desired outcome] when [context/trigger], but currently [pain/gap]"
   - Score each opportunity on:
     - **Frequency**: How many participants mentioned it (n/total)
     - **Intensity**: How strongly they felt about it (scale: mild annoyance → blocking problem)
     - **Evidence quality**: Direct quotes vs. inferred from behavior
   - Rank opportunities by frequency x intensity

6. **Compile the evidence base**:
   - For each key finding, assemble 2-3 supporting quotes with participant identifiers
   - Group quotes thematically so readers can see patterns, not just individual data points
   - Note any contradictions between participants and offer possible explanations
   - Flag findings that are based on a single participant as "tentative — needs more data"

7. **Write the synthesis report**:
   - Structure:
     - **Executive summary**: 3-5 key findings in plain language
     - **Research context**: Objectives, participant demographics, methodology
     - **JTBD patterns**: Core/functional/emotional/social jobs with frequency
     - **Satisfaction/dissatisfaction map**: Signals with quotes
     - **Emotional journey**: Stage-by-stage map
     - **Opportunity statements**: Ranked list with evidence
     - **Open questions**: What we still don't know, suggested follow-up research
   - Write to the initiative directory or `.deliberate/reports/{slug}/interview-synthesis.md`

## Output

- A synthesis report containing:
  - Executive summary of key findings
  - JTBD patterns with frequency data
  - Satisfaction/dissatisfaction signals with supporting quotes
  - Emotional journey map
  - Ranked opportunity statements with evidence strength
  - Open questions and recommended next steps

## Constraints

- Every finding must be backed by at least one direct quote — no unsupported claims
- Do not infer intent beyond what participants actually said or did; flag inferences explicitly
- Maintain participant anonymity — use identifiers like P1, P2, etc.
- Distinguish between what participants say they do vs. what they actually do (stated vs. revealed preference)
- Do not modify application code — this produces documentation only

## Transition

Opportunity statements feed into `/opportunity-solution-tree` to build the tree, or into `/brainstorm-ideas` to generate solution concepts. JTBD patterns inform `/customer-interview-guide` for follow-up research rounds.
