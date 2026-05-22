# Handoff: Architect → Product Designer

## Trigger

Architecture document complete (or explicitly skipped). Initiative has both PRD and architecture artifacts.

## Sender's Obligations ("Done for us")

- [ ] Architecture doc exists (or null with rationale)
- [ ] If exists: code examples are runnable (not pseudocode)
- [ ] Build sequence defined with phases
- [ ] File manifest lists all new and modified files
- [ ] Integration points with existing codebase documented
- [ ] Key architectural decisions recorded with rationale

## Receiver's Expectations ("Ready for them")

- [ ] PRD user experience section has flow defined
- [ ] Architecture doc identifies which components need UI
- [ ] Data model is stable (designer can reference field names)
- [ ] Design constraints clear (existing patterns, component library, responsive requirements)

## Timebox

Design brief: 1 agent session (typically 10-20 minutes).

## Mechanics

1. PM completes `/pm-architecture`, transitions to design phase
2. Designer agent launched with PRD + arch doc as context
3. Designer reads UI requirements from PRD section 5, component needs from arch doc
4. Design brief written to `{slug}-design-brief.md`
5. `design_brief_path` updated in queue YAML
