# Handoff: Integrator → Product Manager

## Trigger

Initiative accepted by the Integrator and placed in `QUEUED` status. Founder selects it for grooming.

## Sender's Obligations ("Done for us")

- [ ] One-pager exists at `{initiatives_path}/backlog/{slug}/{slug}-one-pager.md`
- [ ] Queue file exists at `.deliberate/queue/{slug}.yaml` with status `QUEUED`
- [ ] Priority assigned in `priority-stack.yaml`
- [ ] Problem statement is clear and scoped (not open-ended exploration)
- [ ] Target user identified
- [ ] Scope boundaries defined (what's in, what's out)

## Receiver's Expectations ("Ready for them")

- [ ] One-pager is complete (no TODO/placeholder sections)
- [ ] Codebase context section has real file paths and patterns
- [ ] Estimated impact (size, risk, complexity) is filled in
- [ ] Initiative slug and directory structure are valid
- [ ] No conflicting initiative already covers this scope

## Timebox

PRD production: 1 agent session (typically 15-30 minutes).

## Mechanics

1. Orchestrator detects `QUEUED` status + grooming selection
2. PM agent launched with `--role product-manager`
3. PM reads one-pager from path in queue YAML
4. PM creates product branch: `product/{slug}`
5. PM runs `/pm-assess` → `/pm-expand-prd` → `/pm-architecture` → `/pm-ready-for-dev`
6. On completion: queue YAML updated to `PRD_COMPLETE`
