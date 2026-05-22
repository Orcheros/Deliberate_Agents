# DeliberateWork Methodology Reference

A practitioner's reference for agents operating within the Deliberate_Agents framework. Derived from the DeliberateWork methodology.

---

## The 5x5 Method

Every step of work has 5 Inputs and 5 Outputs. "The 5x5 IS the AI prompt" — inputs define what an agent receives, outputs define what it must produce.

### 5 Inputs

| # | Input | What it means |
|---|-------|--------------|
| 1 | **Information** | Knowledge needed to do the work — PRDs, context, specifications |
| 2 | **Artifacts** | Tangible deliverables received from the previous step |
| 3 | **Access** | Systems, repos, environments, tools available |
| 4 | **Conditions** | Prerequisites that must be true before starting ("Ready" gate) |
| 5 | **People** | Who is available for questions, approvals, or collaboration |

### 5 Outputs

| # | Output | What it means |
|---|--------|--------------|
| 1 | **Updated Information** | Knowledge created or refined during the work |
| 2 | **Produced Artifacts** | Tangible deliverables created by this step |
| 3 | **System State Change** | What changed in the environment (status, files, config) |
| 4 | **Commitments Made** | Promises to downstream consumers about what was delivered |
| 5 | **Ready Output** | The specific artifact or state that triggers the next step |

---

## Ready and Done Gates

**Don't start until Ready. Don't stop until Done.**

- **Ready gate**: Validates that all 5 inputs are present before a step begins. If any input is missing, the step cannot start — it gets blocked, not started with partial context.
- **Done gate**: Validates that all 5 outputs are produced before a step is considered complete. Incomplete outputs mean the step isn't done — it goes back, not forward.

Gates are enforced by `orchestration/gates.sh`. The rigor of enforcement scales with risk level.

---

## Execution Modes

Every step has an execution mode that determines how much autonomy the agent has.

| Mode | Name | Behavior |
|------|------|----------|
| 1 | **Human** | No agent launched — instructions written for human execution |
| 2 | **Guided Human** | Agent assists but pauses after each sub-step for human approval |
| 3 | **AI-Assisted** | Agent runs with short leash (reduced max-turns), human nearby |
| 4 | **Gated Autonomous** | Default. Agent runs autonomously, gates validated at boundaries |
| 5 | **Autonomous** | Agent runs with extended turns, intermediate gates skipped |
| 6 | **External** | Work happens outside the system (third-party tool, vendor, etc.) |

Default is mode 4 when not specified. Mode escalation follows risk level.

---

## Handoff Contracts

When work moves between agents, a handoff contract governs the transition:

1. **Trigger** — What event initiates the handoff
2. **Sender's Obligations** ("Done for us") — What the sender must complete
3. **Receiver's Expectations** ("Ready for them") — What the receiver validates
4. **Timebox** — Expected duration for the receiving step
5. **Mechanics** — How it happens in the filesystem (files, status transitions)

Contracts live in `workflows/handoffs/`. The orchestrator enforces them via gate validation.

---

## Work Types

Classify incoming work before routing it. Different types take different paths.

| Type | Description | Pipeline Path |
|------|-------------|--------------|
| **Request** | Standard feature or enhancement | Full pipeline: intake → PRD → arch → design → dev → QA |
| **Recurring Process** | Repeatable work with known pattern | Template-based, skip discovery phases |
| **Project** | Large, multi-initiative effort | Full pipeline with extended governance |
| **Exception** | Urgent, unexpected (bug, incident) | Fast-track with elevated risk level |

The Integrator classifies work at intake.

---

## Risk Levels

Risk determines governance rigor. Higher risk = more oversight.

| Level | Gate Enforcement | Examples |
|-------|-----------------|----------|
| **low** | Log-only — record check, don't block | Config changes, docs, copy updates |
| **medium** | Automated — block on failure, auto-advance on pass | Standard features, UI work |
| **high** | Automated + peer review agent | Auth changes, data model changes, API contracts |
| **critical** | Human approval required | Payment flows, data migrations, security changes |

---

## Responsible vs. Accountable

Every step has exactly one **Responsible** (the agent that executes) and one **Accountable** (the agent that owns the outcome). They are never the same.

- **Responsible**: Does the work. Can be delegated.
- **Accountable**: Ensures the outcome is right. Cannot be delegated. Answers "did this work achieve its intent?"

---

## Three-Metric Observability

Track three categories to detect problems before they compound:

| Category | What to track | Watch for |
|----------|--------------|-----------|
| **Flow** | Cycle time per stage, throughput, WIP count | Bottlenecks, stalled initiatives, WIP overload |
| **Quality** | Rework count, gate failures, bounce-backs | Chronic quality issues in a stage |
| **Health** | Agent crashes, decision backlog, response time | Systemic stress, human bottlenecks |

All three must be balanced. Optimizing flow at the cost of quality creates rework. Optimizing quality at the cost of health creates burnout.

---

## The Deliberate Work Loop

A continuous improvement cycle run by the Integrator:

1. **See** — Read metrics, review decision backlog, scan for stalled work
2. **Design** — Identify the single highest-leverage improvement
3. **Orchestrate** — Dispatch the improvement
4. **Observe** — Measure the effect after implementation
5. **Improve** — Document findings, adjust the system

This is not a one-time exercise. It runs on cadence (weekly) or on-demand when metrics signal a problem.

---

## AAAERRR Framework

Growth-facing agents operate within the AAAERRR funnel:

| Zone | Stages | Focus |
|------|--------|-------|
| **Funnel** | Awareness → Acquisition → Activation | Getting users in and activated |
| **Flywheel** | Engagement → Retention → Revenue → Referral | Keeping users, growing value |
| **Off-Ramp** | Any stage | Where users leave — analyze and address |

Skills that produce growth-related outputs tag their AAAERRR zone in frontmatter so the Integrator can track funnel coverage.

---

## Cross-Agent Communication

Agents communicate through a structured filesystem protocol in `.deliberate/comms/{slug}/`. All communication is append-only, auditable, and scoped per initiative.

### Communication Channels

| Channel | Purpose | Location |
|---------|---------|----------|
| **Handoff Log** | Records every agent-to-agent transition with context | `comms/{slug}/handoff-log.md` |
| **Decision Records** | Agents record significant choices with rationale | `comms/{slug}/decisions/{timestamp}-{role}.md` |
| **Agent Messages** | Agents leave context notes for specific downstream roles | `comms/{slug}/messages/{timestamp}-{from}-to-{to}.md` |
| **Handoff Receipts** | Agents confirm what they received at startup | `comms/{slug}/receipt-{role}.md` |

### When to Record a Decision

- You chose one approach over another
- You scoped something in or out
- You deviated from the pattern reference or architecture doc
- You discovered a constraint that affects downstream work
- You made an assumption that could be wrong

### When to Leave a Message

- The next agent needs to know about a gotcha or constraint
- You found something that affects their work but isn't in the spec
- You want to flag a risk or concern for a specific role

The orchestrator automatically records handoff log entries at every status transition. Agents write their own decision records, messages, and handoff receipts. All artifacts are injected into agent context at launch via `build_comms_context()` in `orchestration/comms.sh`.

---

## Key Principles

- **"Accidental work is the enemy."** Every step should exist by design, not habit.
- **"The 5x5 IS the AI prompt."** Well-defined inputs produce well-defined outputs.
- **"Don't start until Ready. Don't stop until Done."** Gates prevent garbage-in, garbage-out.
- **"Risk-weight your governance."** Low-risk work flows fast. High-risk work gets scrutiny.
- **"One executor, one outcome-owner."** Clear R and A for every step. Never the same person.
