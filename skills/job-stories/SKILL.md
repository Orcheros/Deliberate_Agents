---
name: job-stories
description: Write job stories in When/I want to/So I can format based on Intercom's JTBD methodology
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Job Stories

## Objective

Write job stories that focus on context and motivation rather than persona. Format: "When [situation/context], I want to [motivation/action], so I can [expected outcome]." Based on Intercom's Jobs-to-be-Done story format — the advantage over user stories is the emphasis on the triggering situation and the user's underlying motivation.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What initiative or feature area needs job stories?
   - What user research or PRD context is available?

2. **Read the initiative context**:
   - Read the PRD, one-pager, or feature description
   - Understand the target users and their workflows
   - Identify the problems being solved

3. **Identify triggering situations**:
   - What specific contexts or moments trigger the need?
   - Focus on the situation, not the persona — "When I'm on a slow connection" not "As a mobile user"
   - Look for anxiety, frustration, time pressure, or workflow breaks
   - Each situation should be concrete and observable

4. **Define the user's motivation in that context**:
   - What does the user want to accomplish in that moment?
   - Express as an action or capability, not a feature
   - The motivation should explain WHY the user cares right now
   - Bad: "I want a search bar" — Good: "I want to find the document I was working on yesterday"

5. **Articulate the desired outcome**:
   - What does success look like for the user?
   - Express as a result or state change
   - The outcome should connect to a higher-level goal
   - "So I can get back to my analysis without losing my train of thought"

6. **Add acceptance criteria per story**:
   - 3-5 testable conditions that define "done" for each story
   - Written from the user's perspective
   - Specific enough to verify, not so specific as to dictate implementation

7. **Group by theme or epic**:
   - Cluster related job stories into themes
   - Order within each theme by user journey or priority
   - Identify dependencies between stories

## Output

Write deliverable to `.deliberate/reports/{slug}/job-stories.md` including:
- Initiative context summary
- Job stories grouped by theme/epic
- Each story in "When / I want to / So I can" format
- Acceptance criteria per story (3-5 conditions)
- Dependencies between stories noted

## Constraints

- Never start with "As a [persona]" — that's user story format, not job story format
- Every story must have a concrete triggering situation, not a generic context
- Outcomes must be user-meaningful, not implementation-specific
- Acceptance criteria must be testable without knowing the implementation

## Transition

Job stories feed into `/wwas` for backlog decomposition and `/prioritization-frameworks` for prioritization.
