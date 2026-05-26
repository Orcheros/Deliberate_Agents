# Design Review Checklist

Self-review before presenting the design for approval (Step 5). Every item must pass.

---

## Grounded in Reality

- [ ] Every component references real files or patterns from the codebase (not hypothetical)
- [ ] Data flow traces actual model relationships and service interfaces
- [ ] Existing patterns are reused where they fit — new abstractions are justified

## Complete

- [ ] Edge cases are covered, not just the happy path
- [ ] Error states are specified: what the user sees when things fail
- [ ] Empty states are specified: what the user sees before data exists
- [ ] Permission/access cases are specified: what unauthorized users see

## Scoped

- [ ] No placeholder text ("TBD", "to be determined", "similar to X")
- [ ] No speculative features ("we might also want...", "in the future...")
- [ ] Scope is tight — YAGNI (You Aren't Gonna Need It)
- [ ] Every component earns its existence in the current requirements

## Handoff-Ready

- [ ] A developer agent could implement from this doc alone, without asking clarifying questions
- [ ] File paths for new/modified files are named explicitly
- [ ] Open questions are genuine unknowns, not deferred decisions
- [ ] If there are open questions, they won't block implementation of the core path

## Architectural Decisions

- [ ] Any non-obvious decision has a brief rationale ("Why this approach?")
- [ ] If alternatives were considered, note why they were rejected (see `design-alternatives.md`)
- [ ] Significant decisions should be captured as ADRs in `.deliberate/decisions/` using the template at `templates/adr-template.md`
