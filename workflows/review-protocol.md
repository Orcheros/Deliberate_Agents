# Review Protocol

## Purpose

Validate that completed developer work meets PRD acceptance criteria before handing off to QA. Includes a risk-based escalation path for expensive deep review.

## Trigger

All developer tasks for an initiative are marked `complete` by the Project Manager.

## Flow

```
All tasks complete
  ↓
Reviewer assesses risk level
  ↓
  ┌─── Risk level? ──────────────────┐
  │                                    │
  │ STANDARD                           │ HIGH
  │ (most work)                        │ (major refactors, auth,
  │                                    │  payments, schema changes,
  │                                    │  10+ files across domains)
  ↓                                    ↓
Run /review                     ASK HUMAN (terminal or Slack):
  /review-validate              "Should I run /review or /ultrareview?"
  /review-summarize                    │
  ↓                             ┌──────┴──────┐
  │                             │ /review      │ /ultrareview
  │                             ↓              ↓
  │                        Run /review    Run /ultrareview
  │                             │         (HAS REAL COST)
  └─────────────┬───────────────┘              │
                ↓                              ↓
         Review complete ←─────────────────────┘
                ↓
         ┌─── Result? ─────────┐
         │                      │
         │ PASS                 │ ISSUES FOUND
         ↓                      ↓
  REVIEW_READY             ┌── Severity? ──┐
  (→ QA)                   │                │
                    MINOR              MAJOR
                    Note in            BLOCKED
                    summary            Create corrective
                    for human          task assignments
```

## Risk Indicators (triggers /ultrareview question)

Any ONE of these makes the work HIGH risk:
- 10+ files changed across multiple domains (models + controllers + views + jobs)
- Database schema changes affecting existing data
- Authentication or authorization changes
- Payment or billing flow modifications
- Public API contract changes
- Core model refactors touching 3+ dependent models

## Rules

1. **Standard work** → Run `/review` automatically. No human involvement needed.
2. **High-risk work** → **MANDATORY** to ask the human before proceeding. Create a decision file or post to Slack:
   > "Initiative {slug} involves {risk description}. Should I run standard /review or /ultrareview?"
3. **NEVER run `/ultrareview` without explicit human approval** — it has real cost.
4. The human chooses. If no response within the orchestrator's timeout, default to `/review` and note the escalation was unanswered.

## Reviewer Skills

### `/review-validate`
1. Re-read the PRD
2. For each task: read commits, verify code matches acceptance criteria, confirm tests exist and pass
3. Cross-task validation: do tasks integrate correctly? Gaps between tasks?
4. Minor issues → note in summary. Major issues → `BLOCKED` with corrective task assignments.

### `/review-summarize`
Write a clear summary for human review in Cursor:
- What changed (files, patterns, key decisions)
- What was tested
- Any concerns or caveats
- Links to relevant commits

### `/api-design-review` (when API endpoints are involved)
Audit REST conventions, consistency, security posture, and developer experience.

## Exit Condition

Initiative status → `REVIEW_READY` (passes) or `BLOCKED` (issues found, corrective tasks created).

`REVIEW_READY` transitions to `DEV_COMPLETE` after human acknowledges the review summary, which triggers the **Quality Assurance** workflow.
