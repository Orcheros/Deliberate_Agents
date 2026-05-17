---
name: brainstorm-okrs
description: Draft team-level OKRs aligned with company objectives using Radical Focus methodology
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Brainstorm OKRs

## Objective

Generate team-level Objectives and Key Results aligned with company-level objectives. Based on Christina Wodtke's Radical Focus methodology — OKRs should be ambitious, time-bound, and start at 50% confidence (if you're 90% confident, the OKR isn't ambitious enough).

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What team or product area is this for?
   - What company-level objectives must these OKRs ladder up to?

2. **Read company objectives and context**:
   - Find the company objectives document or initiative context
   - Understand the strategic priorities and timeline
   - Identify what "winning" looks like at the company level this quarter/half

3. **Identify team-level outcomes that contribute**:
   - Map the team's capabilities to company objectives
   - Determine where the team can have the highest leverage
   - Avoid activity-based objectives — focus on outcomes

4. **Write 2-3 Objectives**:
   - Each Objective must be qualitative, inspiring, and time-bound
   - Objectives should be memorable and motivating — not metrics
   - Format: a short aspirational statement that describes what success looks like
   - Bad: "Increase revenue by 20%" — Good: "Become the go-to platform for small team collaboration"

5. **Define 3-5 Key Results per Objective**:
   - Each Key Result must be quantitative and measurable
   - Include current baseline and target value
   - Key Results are evidence that the Objective is being achieved
   - Format: `KR: [metric] from [baseline] to [target]`
   - Ensure Key Results are outcomes, not tasks or outputs

6. **Apply confidence scoring**:
   - Rate each OKR set at initial confidence (should be ~50%)
   - If confidence is above 70%, the OKR is not ambitious enough — stretch it
   - If confidence is below 30%, it may be unrealistic — scope it down
   - Document the reasoning behind the confidence score

7. **Define tracking cadence**:
   - Specify weekly check-in format (traffic light: green/yellow/red)
   - Define mid-quarter review checkpoint
   - Set end-of-quarter grading criteria (0.0-1.0 scale, target 0.6-0.7)

## Output

Write deliverable to `.deliberate/reports/{slug}/okrs.md` including:
- Company objectives being laddered to
- 2-3 team Objectives with 3-5 Key Results each
- Baselines and targets for every Key Result
- Confidence score per OKR set with reasoning
- Tracking cadence and grading criteria

## Constraints

- Do not create activity-based or task-based Key Results
- Do not set confidence above 70% — stretch the ambition
- Every Key Result must have a numeric baseline and target
- Objectives must be qualitative and inspiring, never metric-only

## Transition

OKRs feed into `/outcome-roadmap` for roadmap alignment and `/retro` for end-of-quarter grading.
