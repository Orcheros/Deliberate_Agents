# Closed-Loop Communication Protocol

Open loops are not allowed. Every sender gets confirmation that the receiver received, understood, and acted. You MUST follow all four rules below.

## Rule 1: Assignment Receipt (FIRST action)

After reading your inputs, IMMEDIATELY write a receipt confirming what you received:

**File**: `.deliberate/comms/{slug}/receipt-{role}.md`

```markdown
# Receipt: {role}

- **Agent**: {agent-name}
- **Role**: {role}
- **Initiative**: {slug}
- **At**: {ISO-8601 timestamp}
- **Status**: complete | partial

## Received
- {artifact path} — confirmed readable

## Missing
- {expected input not found, or "none"}

## Understanding
{1-2 sentences confirming your understanding of the scope}
```

If any inputs are missing, set Status to `partial` and list them under Missing. Do not proceed with assumptions about missing inputs — flag them.

## Rule 2: Completion Signal (LAST action)

As your LAST action before the session ends, write a completion signal:

**File**: `.deliberate/comms/{slug}/completion-{role}.md`

```markdown
# Completion: {role}

- **Agent**: {agent-name}
- **Role**: {role}
- **Initiative**: {slug}
- **Status**: success | partial | blocked | failed
- **At**: {ISO-8601 timestamp}

## Summary
{2-5 sentences: what was accomplished}

## Artifacts Produced
- {absolute path} — {one-line description}

## Open Items
- {anything unfinished, risky, or needing attention}

## Handoff Notes
{specific context the downstream agent needs to know}
```

**Status values**:
- `success` — all acceptance criteria met, artifacts produced
- `partial` — some work done but not all criteria met
- `blocked` — cannot proceed, needs human or upstream resolution
- `failed` — unrecoverable error encountered

This file is MANDATORY. If you do not write it, your work will be treated as a crash and may be re-dispatched.

## Rule 3: Message Acknowledgment

When you receive a message addressed to you:

1. Read the message
2. Update its `- **Status**: unread` field to `acknowledged`
3. When you have fully addressed it, move it to the `ack/` directory

Every message has three states: `unread` → `acknowledged` → `resolved`. Do not leave messages in `unread` state after reading them.

## Rule 4: Decision Recording

When you make a non-obvious choice, record it:

**File**: `.deliberate/comms/{slug}/decisions/{timestamp}-{role}.md`

```markdown
# Decision: {title}

- **By**: {role}
- **At**: {ISO-8601 timestamp}

## What was decided
{rationale}

## Alternatives considered
{what else you looked at and why you rejected it}

## Impact on downstream agents
{what the next agent needs to know about this choice}
```

**When to record**: You chose one approach over another. You scoped something in or out. You deviated from the spec. You discovered a constraint. You made an assumption.

**Note**: This path (`.deliberate/comms/{slug}/decisions/`) is for per-initiative agent reasoning — recording why you chose one approach over another. Global escalations requiring human resolution go to `.deliberate/decisions/` — those are created by the orchestrator and gate system, not by individual agents. Do not write to `.deliberate/decisions/` directly.

**When to leave a message** for the next agent: Write to `.deliberate/comms/{slug}/messages/{timestamp}-{role}-to-{target-role}.md` when you have context they will need.
