---
name: design-before-code
description: Explore intent, requirements, and design before implementation — brainstorming gate that prevents coding without a plan
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
intent: "Prevent implementation without design review — hard gate for creative work"
execution-mode: 3
responsible: architect
accountable: product-manager
risk-level: medium
inputs:
  information: ["PRD or task description", "existing code patterns"]
  artifacts: ["PRD", "assignment"]
  access: ["codebase read access"]
  conditions: ["creative work identified, not a mechanical fix"]
  people: ["human reviewer for approval gate"]
outputs:
  updated-information: ["design decisions"]
  produced-artifacts: ["design document"]
  system-state-change: ["design gate passed"]
  commitments-made: ["approach selected and approved"]
  ready-output: ["approved design ready for implementation"]
---

# Design Before Code

## Objective

Explore the user's intent, requirements, and design before writing any implementation code. This is a hard gate — no implementation starts until the design is reviewed and approved.

## When to Use

Before any creative work: creating features, building components, adding functionality, or modifying behavior that affects user experience.

**Do NOT use** for: bug fixes with clear root causes, mechanical refactors, test additions, or configuration changes.

## Instructions

### Step 1: Explore Context

1. Read the PRD, assignment, or task description
2. Read the relevant existing code to understand current patterns
3. Identify what already exists that can be reused

### Step 2: Ask Clarifying Questions

Before proposing anything, identify gaps in your understanding. Ask questions **one at a time** — don't dump a list. Prefer multiple choice over open-ended:

**Good:** "Should the notification appear as a toast (auto-dismiss after 5s) or as a persistent banner the user must close?"
**Bad:** "What are your thoughts on the notification UX?"

### Step 3: Propose Approaches

Present 2-3 concrete approaches, each with:
- **What**: One-sentence description
- **Trade-off**: The main advantage and disadvantage
- **Complexity**: Relative effort (small / medium / large)

Don't propose approaches that you wouldn't actually recommend. Every option should be defensible.

### Step 4: Write the Design

Once an approach is selected, write a brief design doc covering:

```markdown
## Design: {Feature Name}

### Approach
{1-2 sentences describing what we're building and why this approach}

### Components
{What files/classes/modules will be created or modified}

### Data Flow
{How data moves through the system for the key user action}

### Edge Cases
{What happens when things go wrong — empty states, errors, permissions}

### Open Questions
{Anything still unresolved that will be decided during implementation}
```

### Step 5: Self-Review

Before presenting the design, check:
- [ ] No placeholder text ("TBD", "to be determined", "similar to X")
- [ ] All components reference real files/patterns from the codebase
- [ ] Edge cases are covered, not just the happy path
- [ ] Scope is tight — YAGNI (You Aren't Gonna Need It)
- [ ] The design could be handed to a developer agent as-is

### Step 6: Approval Gate

Present the design for review. **Do not begin implementation until approved.**

If working autonomously (no human in loop), write the design to the initiative directory and proceed. If a human is available, wait for their confirmation.

## Output

Design document written to the assignment or initiative directory. Implementation proceeds only after the design gate is passed.
