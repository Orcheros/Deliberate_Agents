# Initiative Lifecycle — Directory Promotion Rules

## Purpose

Define the rules that govern how initiatives move through the filesystem-as-kanban lifecycle. Each directory in `.documentation/initiatives/` names what the initiative **needs next**. Promotion is a binary check — does the required artifact exist? Yes → move. No → stay.

This workflow is the ruleset that all other workflows (initiative-discovery, initiative-build, development-execution, quality-assurance) operate within. It does not define agent sequences — it defines the promotion logic that those workflows trigger.

## Directory ↔ Status Mapping

| Directory | STATUS.yaml State | Deliberate Status | Owner |
|---|---|---|---|
| `backlog/` | `backlog` | `QUEUED` | — (idea pool) |
| `needs-prd/` | `needs-prd` | `PM_IN_PROGRESS` | Product Manager |
| `needs-architecture/` | `needs-architecture` | `PRD_COMPLETE` | Architect |
| `needs-design-study/` | `needs-design-study` | `ARCH_COMPLETE` | Product Designer |
| `needs-design/` | `needs-design` | `DESIGN_PENDING_ARTIFACTS` | Human + Claude Design |
| `needs-stories/` | `needs-stories` | `DESIGN_COMPLETE` or `SPECIFIED` | Scrum Master |
| `needs-engineering/` | `needs-engineering` | `READY_FOR_DEV` | Engineering Team |
| `needs-qa/` | `needs-qa` | `DEV_COMPLETE` | QA Team |
| `shipped/` | `shipped` | `QA_COMPLETE` → released | — (terminal) |
| `retired/` | `retired` | — | — (terminal) |

## Promotion Rules

### Rule 1: backlog → needs-prd

**Check:** Human decision.
**Trigger:** Founder selects initiative for build.
**Action:** Move folder from `backlog/` to `needs-prd/`. Update STATUS.yaml state.
**Workflow:** Triggers [Initiative Build](initiative-build.md).

This is the only promotion that is not an artifact-existence check.

### Rule 2: needs-prd → needs-architecture (or skip)

**Check:** Does `{slug}-prd.md` exist?
**Conditional:** Read `requires_architecture` from STATUS.yaml.

| PRD exists? | requires_architecture | Action |
|---|---|---|
| Yes | `true` | Move to `needs-architecture/` |
| Yes | `false` | Skip — apply Rule 3 logic immediately |
| No | — | Stay in `needs-prd/` |

**Who sets the flag:** Product Manager, when writing the PRD.
**Criteria:** 3+ new models, new service layers, external integrations, auth/multi-tenancy changes → `true`.

### Rule 3: needs-architecture → needs-design-study (or skip)

**Check:** Does `{slug}-architecture.md` exist?
**Conditional:** Read `requires_design_study` from STATUS.yaml.

| Arch exists? | requires_design_study | Action |
|---|---|---|
| Yes | `true` | Move to `needs-design-study/` |
| Yes | `false` | Skip — apply Rule 4 skip logic (→ `needs-stories/`) |
| No | — | Stay in `needs-architecture/` |

**Who sets the flag:** Product Manager, when writing the PRD.
**Criteria:** Initiative has user-facing UX changes → `true`.

### Rule 4: needs-design-study → needs-design (or skip)

**Check:** Does `{slug}-design-study.md` exist?
**Conditional:** Read `requires_design` from STATUS.yaml.

| Study exists? | requires_design | Action |
|---|---|---|
| Yes | `true` | Move to `needs-design/` |
| Yes | `false` | Skip → `needs-stories/` |
| No | — | Stay in `needs-design-study/` |

**Who sets the flag:** Product Designer, when writing the design study.
**Criteria:** Design study identifies work needing external tools (mockups, prototypes, visual exploration) → `true`.

### Rule 5: needs-design → needs-stories

**Check:** Is `design_complete: true` in STATUS.yaml?

| Flag | Action |
|---|---|
| `true` | Move to `needs-stories/` |
| `false` | Stay |

**Who sets the flag:** Human, after completing design artifacts in Claude Design and committing them.

### Rule 6: needs-stories → needs-engineering

**Check:** Does a stories artifact exist? (`{slug}-stories.md`, `{slug}-backlog.md`, or `stories/` subdirectory)

| Artifact exists? | Action |
|---|---|
| Yes | Move to `needs-engineering/` |
| No | Stay |

**Who creates it:** Scrum Master agent.
**Workflow:** End of [Initiative Build](initiative-build.md), beginning of [Development Execution](development-execution.md).

### Rule 7: needs-engineering → needs-qa

**Check:** Is `engineering_complete: true` in STATUS.yaml?

| Flag | Action |
|---|---|
| `true` | Move to `needs-qa/` |
| `false` | Stay |

**Who sets the flag:** Project Manager, after all tasks pass code review.
**Note:** Engineering includes code review. Rework loops stay in `needs-engineering/`.
**Workflow:** End of [Development Execution](development-execution.md), triggers [Quality Assurance](quality-assurance.md).

### Rule 8: needs-qa → shipped

**Check:** Is `qa_passed: true` in STATUS.yaml?

| Flag | Action |
|---|---|
| `true` | Move to `shipped/` |
| `false` | Stay |

**Who sets the flag:** QA Lead, after GO recommendation + human approval.
**Workflow:** End of [Quality Assurance](quality-assurance.md), triggers [Release](release.md).

## Conditional Skip Logic

Three stages are conditional: architecture, design study, and design. When a stage is skipped, the initiative jumps to the next applicable directory in a single promotion.

```
Full path (all stages):
  backlog → needs-prd → needs-architecture → needs-design-study → needs-design → needs-stories → needs-engineering → needs-qa → shipped

Backend-only (skip design):
  backlog → needs-prd → needs-architecture → needs-stories → needs-engineering → needs-qa → shipped

Small fix (skip arch + design):
  backlog → needs-prd → needs-stories → needs-engineering → needs-qa → shipped
```

The skip decision is encoded in STATUS.yaml requirement flags. A single promotion pass can traverse multiple skips — if an initiative has `requires_architecture: false` and `requires_design_study: false`, promoting from `needs-prd/` lands directly in `needs-stories/`.

## STATUS.yaml Schema

```yaml
# Identity
state: "needs-stories"
id: "1C"
title: "Metered Billing"
updated_at: "2026-05-05"
updated_by: "product-manager"
reason: "Fully specified — PRD, architecture, and design study complete"

# Requirement flags (set when PRD is written, immutable after)
requires_architecture: true
requires_design_study: true
requires_design: false

# Completion flags (set during execution)
design_complete: false
engineering_complete: false
qa_passed: false

# Transition history (appended by initiative-pipeline on each promotion)
history:
  - date: "2026-05-01"
    from: "backlog"
    to: "needs-prd"
    by: "founder"
    reason: "Selected for build — Tier 1 priority"
  - date: "2026-05-03"
    from: "needs-prd"
    to: "needs-architecture"
    by: "product-manager"
    reason: "PRD complete — 22-section spec with cross-functional review"
  - date: "2026-05-05"
    from: "needs-architecture"
    to: "needs-stories"
    by: "architect"
    reason: "Architecture doc complete — design study skipped (requires_design_study: false)"
```

The `history` array is optional and backward compatible. Initiatives without `history` are valid — the array is appended by the [Initiative Pipeline](initiative-pipeline.md) workflow on each promotion. The `/initiative-status` skill reads `history` to generate activity timelines.

### Relationship to ROADMAP.md and TRACKER.md

Each target project maintains two companion documents alongside the stage directories:

- **`ROADMAP.md`** — strategic view of all initiatives with tier/phase assignments, dependency sequencing, and launch-blocking rationale. Maintained by the founder and PM. The roadmap defines *priority and order*; the lifecycle directories define *current state*.
- **`TRACKER.md`** — execution dashboard showing every initiative grouped by lifecycle stage with status details. Auto-generated by `/initiative-status` from STATUS.yaml files. Previously maintained manually — now regenerated on each `/initiative-status` invocation.

The lifecycle directories are the source of truth for initiative state. ROADMAP.md is the source of truth for strategic priority. TRACKER.md is a derived view that combines both.

## Promotion Agent

The `promote-initiative` command reads STATUS.yaml, checks artifact existence, and moves folders.

### Algorithm

```
for each initiative in needs-* directories:
  1. read STATUS.yaml → current state, requirement flags
  2. determine next required artifact for current state
  3. check: artifact exists (file check) or flag is set (boolean check)?
  4. if yes:
     a. determine next state (respect skip logic)
     b. move folder to new directory
     c. update STATUS.yaml: state, updated_at, updated_by, reason
  5. if no: skip
```

### Invocation

```bash
promote-initiative --all              # promote all ready initiatives
promote-initiative 1c-metered-billing  # promote specific initiative
promote-initiative --all --dry-run     # show what would move
```

### Integration with Workflows

| Workflow | Produces Artifact | Triggers Promotion |
|---|---|---|
| Initiative Discovery | `{slug}-one-pager.md` in `backlog/` | None (stays in backlog) |
| Initiative Build (PM) | `{slug}-prd.md` | Rule 2 |
| Initiative Build (Architect) | `{slug}-architecture.md` | Rule 3 |
| Initiative Build (Designer) | `{slug}-design-study.md` | Rule 4 |
| Initiative Build (Human) | `design_complete: true` | Rule 5 |
| Initiative Build (Scrum Master) | stories artifact | Rule 6 |
| Development Execution | `engineering_complete: true` | Rule 7 |
| Quality Assurance | `qa_passed: true` | Rule 8 |

Each workflow is responsible for producing its artifact. The promotion agent is responsible for detecting artifacts and moving folders. These are separate concerns.

## Relationship to Other Workflows

This lifecycle ruleset does not replace the existing workflows — it provides the directory structure they operate within:

- **[Initiative Pipeline](initiative-pipeline.md)** — master orchestrator that drives an initiative through all stages, invoking the workflows below in sequence and running `promote-initiative` between each
- **[Initiative Discovery](initiative-discovery.md)** creates one-pagers in `backlog/`
- **[Initiative Build](initiative-build.md)** produces PRD, arch doc, design study, stories — each artifact triggers the next promotion
- **[Development Execution](development-execution.md)** operates within `needs-engineering/`
- **[Quality Assurance](quality-assurance.md)** operates within `needs-qa/`
- **[Release](release.md)** ships from `needs-qa/` to `shipped/`
- **`/initiative-status`** — reporting skill that scans STATUS.yaml files, cross-references ROADMAP.md, and generates TRACKER.md + activity timelines

The lifecycle directories make initiative state visible in the filesystem. Any agent or human can see where every initiative stands by looking at which directory it's in.
