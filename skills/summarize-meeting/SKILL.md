---
name: summarize-meeting
description: Transform a meeting transcript into a structured summary with decisions, action items, and follow-ups
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Summarize Meeting

## Objective

Convert a meeting transcript into a concise, structured summary. Extract decisions, action items, and open questions. Busy people need the essence, not a rehash — keep it tight and actionable.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Where is the transcript file?
   - What type of meeting was this (standup, planning, review, 1:1, stakeholder)?

2. **Read the transcript**:
   - Read the full transcript or meeting notes
   - Identify participants and their roles
   - Note the meeting date and duration if available

3. **Extract key topics discussed**:
   - Group the conversation into 3-7 distinct topics
   - For each topic: one-sentence summary of what was discussed
   - Note where significant time was spent vs. brief mentions

4. **Identify decisions made**:
   - List every explicit decision with the rationale behind it
   - Note who made or approved the decision
   - Format: `Decision: [what was decided] — Rationale: [why] — Decided by: [who]`
   - Distinguish between firm decisions and tentative agreements

5. **Extract action items**:
   - Every action item needs: who, what, when
   - Format: `[Person] will [action] by [deadline]`
   - If no deadline was stated, note "no deadline set"
   - Include implicit commitments ("I'll look into that" = action item)

6. **Note open questions and parking lot items**:
   - Questions raised but not answered
   - Topics deferred to future discussion
   - Items that need more information before a decision

7. **Identify follow-up meetings needed**:
   - Was a follow-up meeting scheduled or mentioned?
   - What topics need dedicated follow-up time?
   - Who needs to be in the follow-up?

## Output

Write deliverable to `.deliberate/reports/{slug}/meeting-summary.md` including:
- Meeting metadata (date, participants, type, duration)
- Key Topics (3-7 bullet summaries)
- Decisions Made (with rationale and decision-maker)
- Action Items (who, what, when)
- Open Questions / Parking Lot
- Follow-up Meetings Needed

## Constraints

- Keep the summary to 1-2 pages maximum — brevity is the point
- Every action item must have an owner
- Do not editorialize or add opinions — report what was said
- Distinguish between decisions and discussions — only confirmed agreements go in Decisions

## Transition

Meeting summaries feed into `/retro` for sprint review and `/stakeholder-map` for communication tracking.
