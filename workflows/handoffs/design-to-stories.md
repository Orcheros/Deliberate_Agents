# Handoff: Product Designer → Scrum Master

## Trigger

Design brief complete. All specification artifacts (one-pager, PRD, architecture doc, design brief) are ready.

## Sender's Obligations ("Done for us")

- [ ] Design brief exists with component specifications
- [ ] All UI states covered (loading, empty, error, success, disabled)
- [ ] Responsive behavior specified per breakpoint
- [ ] Accessibility requirements noted (WCAG 2.1 AA minimum)
- [ ] Design references real Tailwind classes / component patterns from codebase

## Receiver's Expectations ("Ready for them")

- [ ] All spec artifacts are co-located in initiative directory
- [ ] PRD task breakdown exists (even if rough)
- [ ] Architecture build sequence defines implementation order
- [ ] No unresolved open questions that block decomposition

## Timebox

Story decomposition: 1 agent session (typically 10-20 minutes).

## Mechanics

1. Scrum Master agent launched after design completion
2. Reads all artifacts: one-pager, PRD, arch doc, design brief
3. Decomposes into stories with acceptance criteria per story
4. Stories sized so each is completable by one developer agent in one session
5. Dependencies between stories mapped
6. Story breakdown written to `{slug}-stories.md`
7. Initiative status updated to signal readiness for development
