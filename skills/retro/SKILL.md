---
name: retro
description: Structured sprint retrospective — What Went Well, What Didn't Go Well, Action Items with owners
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Retrospective

## Objective

Facilitate a structured sprint retrospective. Gather observations from team artifacts, categorize into What Went Well and What Didn't Go Well, diagnose root causes, and produce specific action items with owners. Track status of previous retro action items.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What sprint or time period is being reviewed?
   - What initiative(s) were active during this period?

2. **Gather input from team artifacts**:
   - Read recent PRs and commits for velocity and quality signals
   - Check incident logs or bug reports for production issues
   - Review sprint metrics (stories completed vs. planned, carryover)
   - Read any existing feedback or notes from the period
   - Check previous retro action items for follow-through

3. **What Went Well** (celebrate):
   - Identify wins, improvements, and positive patterns
   - Be specific — cite concrete examples, not vague praise
   - Note process improvements that worked
   - Acknowledge individual or team contributions

4. **What Didn't Go Well** (diagnose):
   - Identify problems, friction points, and missed targets
   - Be honest but constructive — focus on systems, not blame
   - Note recurring issues from previous retros
   - Distinguish symptoms from root causes

5. **Root cause analysis for problems**:
   - For each significant problem, ask "why" until you reach a systemic cause
   - Categorize: process issue, tooling gap, communication breakdown, scope creep, dependency, estimation error
   - Identify which problems are within the team's control to fix

6. **Generate action items** (commit):
   - Each action item must be specific and assignable
   - Format: `[Action] — Owner: [who] — Due: [when]`
   - Limit to 3-5 action items — too many means none get done
   - Prioritize actions that address root causes over symptoms
   - Include "stop doing" items, not just "start doing"

7. **Track previous retro action items**:
   - Review action items from the last retro
   - Mark each as: completed, in progress, dropped (with reason)
   - Carry forward incomplete items if still relevant

## Output

Write deliverable to `.deliberate/reports/{slug}/retro.md` including:
- Sprint/period summary (dates, initiatives, key metrics)
- What Went Well (with specific examples)
- What Didn't Go Well (with root cause analysis)
- Action Items (specific, assigned, time-bound, max 5)
- Previous Retro Action Item Status (completed/in progress/dropped)

## Constraints

- Limit action items to 3-5 — focus on highest-leverage changes
- Every action item must have an owner and a deadline
- Do not skip the previous action item review — accountability matters
- Focus on systemic issues, not individual blame

## Transition

Retro action items feed into the next sprint's planning. Recurring themes inform `/pre-mortem` for future initiatives.
