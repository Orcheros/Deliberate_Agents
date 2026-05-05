# Initiative Discovery

## Purpose

Transform a scoped idea from the founder into a formal one-pager in the backlog. This is intake — fast, lightweight, and focused on capturing intent clearly enough that the idea can be evaluated later.

## Trigger

Founder provides a scoped idea (via conversation, document, or Slack).

## Agent Sequence

```
Founder (idea)
  ↓
Product Manager
  /pm-intake
  ↓
One-pager in backlog/
  ↓
Queue file created (status: QUEUED)
```

### Step 1: Product Manager — `/pm-intake`

**Input:** Scoped idea from founder
**What happens:**
1. Research the codebase to understand what exists and what the idea touches
2. Research existing initiatives to avoid duplication
3. Identify dependencies, risks, and open questions
4. Write a formal one-pager in `backlog/{slug}/`
5. Create queue file at `.deliberate/queue/{slug}.yaml` with status `QUEUED`

**Output:** One-pager markdown + queue file
**Status:** `QUEUED`

## Decision Gates

None — this is a one-agent workflow. The PM makes judgment calls about scope and framing but doesn't need human approval to create a one-pager.

## Exit Condition

One-pager exists in `backlog/` and queue file has status `QUEUED`. The initiative sits in the backlog until the founder selects it for grooming, which triggers the **Initiative Build** workflow.

## Timing

Single PM session. Should complete in one agent run.
