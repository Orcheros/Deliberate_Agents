# Initiative Pipeline — Master Orchestration

## Purpose

Single workflow that drives an initiative through all lifecycle stages — from `backlog` to `shipped`. Supports two execution modes:

- **`next`** — Run the workflow for the current stage only, promote, stop
- **`full`** — Run all stages sequentially until shipped (pausing at human gates)

This workflow does not duplicate stage-specific logic. It references existing workflows and skills by name and invokes them in sequence. The promotion mechanism is `promote-initiative` from [initiative-lifecycle.md](initiative-lifecycle.md).

## Trigger

- Manual invocation: agent or founder selects an initiative to advance
- After `/initiative-status` identifies stale or ready-to-advance initiatives

## Inputs

| Input | Required | Description |
|---|---|---|
| Initiative slug | Yes | e.g., `1c-metered-billing` |
| Mode | Yes | `next` (one stage) or `full` (all stages until shipped or human gate) |
| initiatives_path | Yes | Path to `.documentation/initiatives/` in the target project |

## Agent Sequence

The pipeline does not own agents — it delegates to the workflow that owns each stage. The orchestrating agent reads STATUS.yaml, determines the current stage, and invokes the appropriate workflow.

| Stage | Workflow / Skill | Primary Agent |
|---|---|---|
| backlog | [Initiative Discovery](initiative-discovery.md) → `/pm-intake` | Product Manager |
| needs-prd | [Initiative Build](initiative-build.md) Steps 1–4 → `/pm-assess` → `/pm-research` → `/pm-expand-prd` → `/pm-cross-functional` | Product Manager |
| needs-architecture | [Initiative Build](initiative-build.md) Step 5a → `/pm-architecture` | Architect |
| needs-design-study | [Initiative Build](initiative-build.md) Step 6a | Product Designer |
| needs-design | **HUMAN GATE** — always pauses | Human + Product Designer |
| needs-stories | [Initiative Build](initiative-build.md) Step 8 | Scrum Master |
| needs-engineering | [Development Execution](development-execution.md) → `/pjm-decompose` → `/pjm-assign` → developers | Project Manager + Developers |
| needs-qa | [Quality Assurance](quality-assurance.md) → 8-phase QA protocol | QA Lead + specialists |
| shipped | [Release](release.md) → deploy → verify → announce → measure → retro | Release team + PM |

## Detailed Steps

### Step 1: Read Current State

1. Read `{initiatives_path}/{stage-directory}/{slug}/STATUS.yaml`
2. Extract `state`, requirement flags, completion flags
3. Read `{initiatives_path}/ROADMAP.md` to confirm the initiative's tier and any noted dependencies or execution-sequence constraints
4. Determine the current stage and validate that the initiative directory matches the declared state
5. If mode is `full`, plan the remaining stages (respecting skip logic from requirement flags)

### Step 2: backlog → needs-prd

**Condition:** `state == "backlog"`
**Invoke:** [Initiative Discovery](initiative-discovery.md) workflow — specifically `/pm-intake`
**What happens:**
1. PM receives the scoped idea and researches the codebase
2. One-pager is created in the initiative directory
3. Founder confirms the initiative is selected for build

**Promote:** Run `promote-initiative {slug}` — moves to `needs-prd/`
**Log:** Append to `history[]` in STATUS.yaml

### Step 3: needs-prd → needs-architecture (or skip)

**Condition:** `state == "needs-prd"`
**Invoke:** [Initiative Build](initiative-build.md) Steps 1–4
**Skills:** `/pm-assess` → `/pm-research` → `/pm-expand-prd` → `/pm-cross-functional`
**What happens:**
1. PM assesses one-pager completeness
2. PM researches codebase and domain deeply
3. PM writes complete 22-section PRD
4. PM evaluates cross-functional impact

**Promote:** Run `promote-initiative {slug}` — Rule 2 logic applies (respects `requires_architecture` flag)
**Log:** Append to `history[]` in STATUS.yaml

### Step 4: needs-architecture → needs-design-study (or skip)

**Condition:** `state == "needs-architecture"`
**Skip if:** `requires_architecture: false` (promotion already skipped this stage)
**Invoke:** [Initiative Build](initiative-build.md) Step 5a
**What happens:**
1. Architect produces `{slug}-architecture.md` with code-grounded design

**Promote:** Run `promote-initiative {slug}` — Rule 3 logic applies (respects `requires_design_study` flag)
**Log:** Append to `history[]` in STATUS.yaml

### Step 5: needs-design-study → needs-design (or skip)

**Condition:** `state == "needs-design-study"`
**Skip if:** `requires_design_study: false` (promotion already skipped this stage)
**Invoke:** [Initiative Build](initiative-build.md) Step 6a
**What happens:**
1. Product Designer produces `{slug}-design-study.md`

**Promote:** Run `promote-initiative {slug}` — Rule 4 logic applies (respects `requires_design` flag)
**Log:** Append to `history[]` in STATUS.yaml

### Step 6: needs-design — HUMAN GATE

**Condition:** `state == "needs-design"`
**Action:** **ALWAYS PAUSE** regardless of mode (`next` or `full`)
**What happens:**
1. Notify the founder that design artifacts are needed
2. Human completes design work in Claude Design or external tools
3. Human sets `design_complete: true` in STATUS.yaml when done
4. Pipeline resumes only when re-invoked after the human gate clears

**No automatic promotion.** The human sets the flag. `promote-initiative` detects it on next run.

### Step 7: needs-stories → needs-engineering

**Condition:** `state == "needs-stories"`
**Invoke:** [Initiative Build](initiative-build.md) Step 8
**What happens:**
1. Scrum Master decomposes PRD + architecture + design into stories
2. Stories artifact created (`{slug}-stories.md`, `{slug}-backlog.md`, or `stories/` subdirectory)

**Promote:** Run `promote-initiative {slug}` — Rule 6 logic applies
**Log:** Append to `history[]` in STATUS.yaml

### Step 8: needs-engineering → needs-qa

**Condition:** `state == "needs-engineering"`
**Invoke:** [Development Execution](development-execution.md) workflow
**Skills:** `/pjm-decompose` → `/pjm-assign` → `/pjm-coordinate` → developers (`/dev-understand` → `/dev-implement` → `/dev-test` → `/dev-complete`)
**What happens:**
1. Project Manager decomposes work into multi-agent streams
2. Developers implement in parallel worktrees
3. Code review via [Review Protocol](review-protocol.md)
4. Project Manager sets `engineering_complete: true` when all tasks pass review

**Promote:** Run `promote-initiative {slug}` — Rule 7 logic applies
**Log:** Append to `history[]` in STATUS.yaml

### Step 9: needs-qa → shipped

**Condition:** `state == "needs-qa"`
**Invoke:** [Quality Assurance](quality-assurance.md) workflow
**What happens:**
1. QA Lead creates test plan from all specs
2. Integration testing, UX review, regression testing
3. QA Lead produces go/no-go recommendation
4. QA Lead sets `qa_passed: true` after GO + human approval

**Promote:** Run `promote-initiative {slug}` — Rule 8 logic applies
**Log:** Append to `history[]` in STATUS.yaml

### Step 10: shipped — Release & Feedback

**Condition:** `state == "shipped"`
**Invoke:** [Release](release.md) workflow, then [Feedback Loop](feedback-loop.md) workflow
**What happens:**
1. Release: plan → preflight → deploy → verify → announce → measure → retro
2. Feedback: data analysis → user research → PM retro → iterate/expand/next

**Terminal state.** Pipeline stops after release workflow completes.

### Step 11: After Each Stage — Promote & Log

After every stage completion (Steps 2–10):

1. **Run `promote-initiative {slug}`** to move the directory to the next stage
2. **Append to `history[]`** in STATUS.yaml:
   ```yaml
   history:
     - date: "{ISO date}"
       from: "{previous stage}"
       to: "{new stage}"
       by: "{agent role}"
       reason: "{what completed}"
   ```
3. **Cross-check ROADMAP.md** — if the initiative has noted dependencies in ROADMAP.md, verify they are satisfied before proceeding (warn if not)
4. **If mode is `next`** → stop, report completion of this stage
5. **If mode is `full`** → read updated STATUS.yaml, continue to next stage in loop

## Decision Gates

| Gate | Type | Behavior |
|---|---|---|
| backlog → needs-prd | Human decision | Founder selects initiative for build |
| needs-design | **HUMAN GATE** | Always pauses — design requires external tools |
| needs-qa GO/NO-GO | Human + QA | QA recommends, human approves |

## Exit Conditions

The pipeline stops when any of these occur:

1. **Mode `next`:** Current stage completes and promotes
2. **Human gate reached:** `needs-design` stage always pauses
3. **Terminal state:** Initiative reaches `shipped`
4. **Failure:** A stage workflow fails — pipeline stops, logs the failure, does not promote
5. **Dependency block:** ROADMAP.md indicates a prerequisite initiative that hasn't shipped

## Relationship to Other Workflows

- **[Initiative Lifecycle](initiative-lifecycle.md)** — defines the promotion rules this pipeline triggers
- **[Initiative Discovery](initiative-discovery.md)** — invoked at backlog stage
- **[Initiative Build](initiative-build.md)** — invoked at needs-prd through needs-stories stages
- **[Development Execution](development-execution.md)** — invoked at needs-engineering stage
- **[Quality Assurance](quality-assurance.md)** — invoked at needs-qa stage
- **[Release](release.md)** — invoked at shipped stage
- **[Feedback Loop](feedback-loop.md)** — invoked after release
- **`/initiative-status`** — generates dashboard and reports; use before pipeline to identify which initiatives to advance
