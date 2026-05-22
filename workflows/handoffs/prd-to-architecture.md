# Handoff: Product Manager → Architect

## Trigger

PRD written and quality checks passed. PM proceeds to architecture phase (same agent session, sequential skill invocation).

## Sender's Obligations ("Done for us")

- [ ] PRD exists at `{slug}-prd.md` in the initiative directory
- [ ] All functional requirements have numbered IDs (FR-01, FR-02, ...)
- [ ] Acceptance criteria are testable (Given/When/Then or equivalent)
- [ ] Data model changes identified
- [ ] Cross-functional impact assessed
- [ ] No TODO or placeholder sections remain
- [ ] `prd_path` set in queue YAML

## Receiver's Expectations ("Ready for them")

- [ ] PRD references real codebase paths (not hypothetical)
- [ ] Requirements are scoped (not aspirational wish lists)
- [ ] Failure modes documented
- [ ] Testing strategy outlined at high level

## Timebox

Architecture document: 1 agent session (typically 15-30 minutes). May be skipped if initiative doesn't meet complexity threshold.

## Mechanics

1. PM completes `/pm-expand-prd`, transitions to `/pm-architecture`
2. Architecture skill evaluates whether an arch doc is needed (decision criteria in skill)
3. If needed: arch doc written to `{slug}-architecture.md` alongside PRD
4. If not needed: `architecture_path: null` recorded with rationale
5. `architecture_path` updated in queue YAML
