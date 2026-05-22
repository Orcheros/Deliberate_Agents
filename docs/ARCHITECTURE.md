# Architecture

## System Overview

Deliberate_Agents is a multi-agent coordination framework that runs multiple Claude Code sessions as autonomous agents, coordinated through filesystem-based state management.

```
┌──────────────────────────────────────────────────────────────────┐
│                        Human (Visionary)                           │
│                  Ideas, decisions, review in Cursor                │
└─────────────────────────────┬────────────────────────────────────┘
                              │ talks directly to
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│              Integrator (primary Claude Code session)               │
│     Validates ideas, prioritizes pipeline, dispatches directives,  │
│     captures decisions, tracks to shipped-and-supported            │
│            Owns: intake/, priority-stack.yaml, reports/            │
└──────────────┬──────────────────────────────┬────────────────────┘
               │ directives (comms/_system/)   │ escalations
               ▼                               │
┌──────────────────────────────────────────────────────────────────┐
│               Orchestrator (interactive agent in tmux)              │
│      Reads priority stack, launches agents, tracks handoffs,       │
│      writes dashboard, escalates blockers to Integrator            │
│      Fallback: orchestrate.sh bash loop (unattended, zero cost)    │
└───┬───────┬───────┬────────┬──────────┬──────────┬───────────────┘
    │       │       │        │          │          │
    ▼       ▼       ▼        ▼          ▼          ▼
┌──────┐┌──────┐┌──────┐┌────────┐┌─────────┐┌─────────────────┐
│  PM  ││ PjM  ││Dev(s)││Reviewer││ Integ.  ││  Content, Docs, │
│      ││      ││      ││        ││ DevOps  ││  Compliance,    │
│      ││      ││      ││        ││Security ││  Sales, CS,     │
│      ││      ││      ││        ││         ││  Onboarding     │
└──┬───┘└──┬───┘└──┬───┘└───┬────┘└────┬────┘└───────┬─────────┘
   │       │       │        │          │             │
   └───────┴───────┴────────┴──────────┴─────────────┘
                            │
                            ▼
                   ┌────────────────┐
                   │  .deliberate/  │
                   │  (state dir)   │
                   └────────────────┘
```

## Component Roles

### Integrator (Primary Session)

The Integrator is the user's primary Claude Code session — the strategic executor that sits between the founder (Visionary) and the Orchestrator (tactical coordinator). It is automatically established on every session start via the `session-start.sh` hook.

It:

1. **Receives** raw ideas from the founder and captures them in `.deliberate/intake/`
2. **Assesses** every new idea against the full board state — initiatives at every lifecycle stage (backlog, specified, in-progress, shipped, retired)
3. **Validates** ideas for ICP alignment, strategic fit, conflicts with in-flight work, and timing
4. **Prioritizes** the pipeline in `.deliberate/priority-stack.yaml` — the contract the Orchestrator reads
5. **Sequences** execution based on dependencies, resource constraints, and strategic leverage
6. **Dispatches** work to the Orchestrator via system directives (`.deliberate/comms/_system/inbox/orchestrator/`)
7. **Tracks** initiatives through their full lifecycle — code in production isn't done until it's documented, marketed, and supported
8. **Audits** for stalled work, the "80% club" (almost done, drifting), and shipped-but-unsupported initiatives

The Integrator never does agent work (no PRDs, code, designs) — it evaluates, prioritizes, dispatches, and holds accountable. Everything from the conversation is captured: ideas to `intake/`, decisions to `decisions/strategic/`, priorities to `priority-stack.yaml`. Model: Opus.

### Orchestrator (Dual-Mode Coordinator)

The Orchestrator runs in two modes:

**Interactive mode (primary)**: An AI agent running in a pane alongside the Integrator (the "coordination" window), launched via `launch-agent.sh`. It:

1. **Checks** its system inbox for Integrator directives (`.deliberate/comms/_system/inbox/orchestrator/`)
2. **Reads** the Integrator's priority stack to determine execution order
3. **Polls** `.deliberate/queue/` and `.deliberate/assignments/` for state changes
4. **Launches** agents via `launch-agent.sh` as panes in initiative windows
5. **Monitors** agent health via PID files and heartbeat staleness
6. **Records** handoffs at every pipeline transition (via `comms.sh`)
7. **Writes** a structured dashboard to `.deliberate/status/dashboard.md`
8. **Escalates** crashes, gate failures, and stalled initiatives to the Integrator (`.deliberate/comms/_system/inbox/integrator/`)
9. **Responds** to direct user input — the user can type to it for status, unblocking, or manual overrides

**Unattended mode (fallback)**: The `orchestrate.sh` bash script — a deterministic polling loop with zero API cost. It handles the same state transitions mechanically but cannot adapt, learn from failures, or respond to user input. Both modes use the same state files and should not run simultaneously.

### AI Agents

Each AI agent runs as an independent Claude Code session using native agent definitions. 31 agents are organized into 7 teams plus a strategic layer:

**Product Team** (`agents/product/`):

- **Product Manager**: Transforms one-pagers into 22-section PRDs with cross-functional requirements. Model: opus.
- **Architect**: Produces architecture documents with system design, data models, and API contracts.
- **Product Designer**: Writes design briefs with component specs, accessibility requirements. Flags human for Claude Design artifacts.
- **Scrum Master**: Bridges product → engineering. Shards PRDs into Epics, Sprints, and Stories.

**Engineering Team** (`agents/engineering/`):

- **Project Manager**: Decomposes PRDs into tasks routed by `agent_type` field. Coordinates multi-agent execution.
- **Developer(s)**: Executes code tasks in isolated worktrees. Writes code, runs tests, produces commits. Multiple can run concurrently.
- **Database Specialist**: Schema design, migrations, indexing, query performance. PostgreSQL expertise.
- **Integrations Engineer**: Configures SaaS tools — CRM, analytics, lifecycle email, payment (Stripe), DNS/email auth.
- **DevOps Engineer**: CI/CD pipelines, infrastructure, monitoring, observability design, incident command.

**QA Team** (`agents/qa/`):

- **QA Lead**: Plans test strategy, assigns test work, coordinates QA across initiatives.
- **Integration Tester**: Tests cross-system behavior — API contracts, data flows, webhook pipelines.
- **Security Analyst**: Threat modeling, security review, dependency audits, incident response. Read-only tools.
- **UX/UI Reviewer**: Validates design fidelity, WCAG 2.1 AA accessibility, responsive behavior.

**Support Team** (`agents/support/`):

- **Reviewer**: Validates completed work against acceptance criteria and API design quality. Read-only tools.
- **Data Analyst**: SaaS metrics, product analytics, cohort analysis, funnel reporting.
- **Compliance Analyst**: Privacy, legal, regulatory audit (GDPR, SOC2). Cites specific regulations.
- **Help Desk**: Support ticket triage, response drafting, escalation.

**Release Team** (`agents/release/`):

- **Release Manager**: Plans releases, go/no-go decisions, release metrics tracking, retrospectives.
- **Release Engineer**: Preflight checks, deployment execution, post-deploy verification and rollback.
- **Release Comms**: Changelogs (with conventional commit parsing), release notes, announcements.
- **Release Marketer**: Launch campaigns, marketing content, adoption measurement.

**GTM Team** (`agents/gtm/`):

- **Growth Strategist**: Pricing strategy, experiment design, referral programs, competitive teardowns.
- **Content Writer**: Copy, email sequences, landing pages, in-app messaging. No Bash access.
- **Technical Writer**: Runbooks, API docs, internal reference material.
- **Sales Development Rep**: Prospect research, outreach preparation, pipeline maintenance.
- **Account Executive Assistant**: Deal support, proposals, competitive analysis, pre-call briefs.
- **Customer Success**: Account health monitoring (Green/Yellow/Red), churn prevention, expansion signals.
- **Onboarding Specialist**: Per-ICP onboarding flows, activation metrics, trial-to-paid optimization.
- **SEO Specialist**: Search optimization — traditional SEO, AEO (featured snippets), AIO (AI Overviews), GEO (LLM citation).

**Strategic Layer** (`agents/integrator.md`, `agents/orchestrator.md`):

- **Integrator**: Primary session agent — the user's Claude Code session. Validates ideas against in-flight work, prioritizes the pipeline, dispatches directives to the Orchestrator, captures conversations to `.deliberate/`, and tracks initiatives to shipped-and-supported. Established automatically via session-start hook. Model: opus.
- **Orchestrator**: Interactive coordinator — runs in a pane alongside the Integrator in the "coordination" window. Manages initiative queue, launches agents (as panes in initiative windows), records handoffs, writes dashboard, escalates blockers to the Integrator via system comms channel. Falls back to `orchestrate.sh` bash loop for unattended operation. Model: opus.

### Skills (Workflow Steps)

Workflow steps are implemented as Claude Code skills in `skills/`. Skills are lazy-loaded — they appear in the agent's awareness but only consume context when invoked. This replaces the previous approach of concatenating all step files into a single system prompt (~8,000 tokens upfront → ~500 tokens baseline).

Each agent's definition lists its available skills. 99 skills across 30 agents:

**Product Team:**
- **Product Manager** (9): `pm-intake`, `pm-assess`, `pm-research`, `pm-expand-prd`, `pm-architecture`, `pm-cross-functional`, `pm-ready-for-dev`, `competitive-teardown`, `design-before-code`
- **Product Designer** (3): `tailwind-design-system`, `frontend-design-rails`, `design-before-code`

**Engineering Team:**
- **Developer** (7): `dev-understand`, `dev-implement`, `dev-test`, `dev-complete`, `tailwind-design-system`, `systematic-debugging`, `code-simplify`
- **Project Manager** (3): `pjm-decompose`, `pjm-assign`, `pjm-coordinate`
- **Database Specialist** (3): `db-assess`, `db-migrate`, `db-seed`
- **Integrations Engineer** (4): `integrations-assess`, `integrations-configure`, `integrations-verify`, `stripe-lifecycle`
- **DevOps Engineer** (4): `devops-assess`, `devops-implement`, `observability-design`, `incident-command`

**QA Team:**
- **QA Lead** (4): `qa-plan`, `qa-assign`, `qa-coordinate`, `qa-report`
- **Integration Tester** (3): `test-plan-review`, `test-integration`, `test-report`
- **Security Analyst** (4): `security-assess`, `security-review`, `dep-audit`, `incident-respond`
- **UX/UI Reviewer** (3): `ux-review-design`, `ux-review-accessibility`, `ux-review-report`

**Support Team:**
- **Reviewer** (3): `review-validate`, `review-summarize`, `api-design-review`
- **Data Analyst** (5): `data-query`, `data-report`, `data-investigate`, `saas-metrics`, `product-analytics`
- **Compliance Analyst** (4): `compliance-assess`, `compliance-document`, `soc2-compliance`, `gdpr-compliance`
- **Help Desk** (3): `support-triage`, `support-respond`, `support-escalate`

**Release Team:**
- **Release Manager** (3): `release-plan`, `release-coordinate`, `release-retro`
- **Release Engineer** (3): `release-preflight`, `release-deploy`, `release-verify`
- **Release Comms** (3): `release-changelog`, `release-notes`, `release-announce`
- **Release Marketer** (4): `release-campaign`, `release-content`, `release-measure`, `launch-strategy`

**GTM Team:**
- **Growth Strategist** (7): `growth-assess`, `growth-strategy`, `growth-plan`, `pricing-strategy`, `experiment-design`, `referral-program`, `competitive-teardown`
- **Content Writer** (4): `content-brief`, `content-draft`, `content-review`, `email-sequence`
- **Technical Writer** (2): `docs-assess`, `docs-write`
- **Sales Development Rep** (3): `sales-research`, `sales-outreach-prep`, `sales-pipeline`
- **Account Executive Assistant** (2): `sales-research`, `sales-pipeline`
- **Customer Success** (3): `cs-health-check`, `cs-intervention`, `churn-prevent`
- **Onboarding Specialist** (3): `onboarding-assess`, `onboarding-design`, `onboarding-optimize`
- **SEO Specialist** (3): `seo-audit`, `seo-strategy`, `seo-implement`

**Standalone skills** (not assigned to a specific agent's workflow but available for reference):
- `founder-coach`, `saas-metrics`, `product-analytics`, `pricing-strategy`, `experiment-design`, `referral-program`, `launch-strategy`, `churn-prevent`, `email-sequence`, `onboarding-optimize`, `soc2-compliance`, `gdpr-compliance`, `dep-audit`, `incident-respond`, `observability-design`, `incident-command`, `competitive-teardown`, `api-design-review`, `stripe-lifecycle`, `tailwind-design-system`

### MCP Servers

MCP (Model Context Protocol) servers enable cross-LLM capabilities. The `codex-review` server (stub) demonstrates using OpenAI for code review while Claude Code remains the primary agent runtime.

### State Directory

The `.deliberate/` directory is the single source of truth for all inter-agent coordination:

- `intake/` — Raw idea capture from the founder (Integrator writes, founder reviews)
- `priority-stack.yaml` — Ranked pipeline owned by the Integrator, read by the Orchestrator
- `queue/` — Initiative lifecycle (QUEUED → ... → COMPLETE)
- `assignments/` — Developer task assignments (assigned → in_progress → complete)
- `status/` — Agent heartbeats, dashboard (`dashboard.md`), compiled report (`report.md`)
- `decisions/` — Items requiring human input (with `.notified` markers for Slack tracking)
- `decisions/strategic/` — Integrator-level strategic decisions captured from conversations
- `reports/` — Integrator audit reports and board state snapshots
- `comms/` — Cross-agent communication (per-initiative and system-level)
- `logs/` — Session output logs

See `state/README.md` for the full protocol specification.

### Cross-Agent Communication

The communication system (`orchestration/comms.sh`) provides structured messaging at two levels:

**Per-initiative communication** (`.deliberate/comms/{slug}/`):
- `handoff-log.md` — Append-only record of every pipeline transition with context
- `decisions/` — Decision records scoped to a specific initiative
- `messages/` — Agent-to-agent messages (blocker notifications, context sharing)
- `receipts/` — Handoff confirmations with artifact verification

**System-level communication** (`.deliberate/comms/_system/`):
- `inbox/integrator/` — Messages TO the Integrator (escalations, status updates from Orchestrator)
- `inbox/orchestrator/` — Messages TO the Orchestrator (directives, priority changes from Integrator)
- `ack/` — Acknowledged messages (audit trail)

Each message is an individual markdown file with typed metadata (from, to, type, urgency, status). Messages move from `inbox/` to `ack/` after processing. This provides a reliable, observable, asynchronous communication channel between the two coordination layers.

### Dashboard

The Orchestrator generates a structured dashboard (`.deliberate/status/dashboard.md`) via `orchestration/dashboard.sh`. It shows:
- Active agents with elapsed time and role
- Pipeline summary (count and list of initiatives per stage)
- Items needing attention (blockers, pending decisions)
- Recent transitions from today's orchestrator log
- System message counts (integrator and orchestrator inboxes)

### Notification & Reporting Layer

The orchestrator integrates with external notification channels (currently Slack) for real-time visibility:

- **`orchestration/notify.sh`** — Dispatches notifications to configured channels. Decision notifications route through the Bot API (for threaded reply tracking); all other types use Incoming Webhooks. Supports five message types: `decision`, `transition`, `alert`, `report`, `progress`.
- **`orchestration/compile-report.sh`** — Reads all state files and produces a summary. Outputs markdown (persisted to `status/report.md`) or Slack-formatted text. Called every poll cycle.
- **`integrations/slack/bot.py`** — Python Slack bot running in Socket Mode (outbound WebSocket, no public URL). Posts decision questions with Block Kit formatting, listens for threaded replies, writes responses back to decision files, and unblocks the waiting agent. Launched automatically by the orchestrator when `slack_enabled: true`.
- **`integrations/slack/start.sh`** — Launcher that creates a Python venv, installs dependencies, and starts the bot in a tmux window.

Configuration lives in `config.yaml` under `notifications:` (see `config.example.yaml` and `integrations/README.md`).

### Workflows

End-to-end agent sequences are documented in `workflows/`. Each file defines the trigger, agent routing, decision gates, and exit condition for a specific type of work. The orchestrator and humans reference these to understand what happens when.

| Workflow | What It Covers |
|----------|---------------|
| `initiative-discovery.md` | Idea → PM intake → one-pager in backlog |
| `initiative-build.md` | One-pager → PRD → arch doc → design study → scrum master → SPECIFIED |
| `development-execution.md` | PjM → parallel developers → specialist agents → review |
| `review-protocol.md` | Standard `/review` vs `/ultrareview` escalation |
| `quality-assurance.md` | QA Lead → Security + Integration + UX → go/no-go |
| `release.md` | Plan → preflight → deploy → verify → comms → retro |
| `go-to-market.md` | Growth strategy → content + sales + CS + onboarding |
| `incident-response.md` | Severity classification → rollback/hotfix → post-mortem |

### Model Assignment Strategy

Agents use Opus or Sonnet based on the cost of mistakes:

**Opus** — where errors are expensive, irreversible, or require deep reasoning:

| Agent | Why Opus |
|-------|---------|
| Product Manager | Strategic reasoning, 22-section PRD synthesis |
| Architect | System design decisions, implementation-ready specs |
| Product Designer | Design judgment, accessibility, UX decisions |
| Developer | Code quality prevents expensive downstream rework |
| Database Specialist | Migration mistakes are dangerous and hard to reverse |
| Growth Strategist | Strategy requires market synthesis and judgment |
| Security Analyst | Missing vulnerabilities is high-cost |
| Compliance Analyst | Missing compliance gaps has legal consequences |
| Integrator | Pipeline prioritization, conflict detection, lifecycle accountability |
| Orchestrator | Central coordination, judgment about routing and escalation |

**Sonnet** — where work is structured, procedural, or human-reviewed before impact:

| Agent | Why Sonnet |
|-------|-----------|
| Scrum Master | Structured decomposition following PRD patterns |
| Project Manager | Task routing and coordination with defined criteria |
| QA Lead | Test planning is procedural, go/no-go criteria explicit |
| Release Manager | Checklist coordination, criteria well-defined |
| Reviewer | Pattern matching for standard review (Opus via `/ultrareview` for high-risk) |
| All GTM agents (except Growth) | Content drafting, human reviews before publish |
| All remaining specialists | Procedural execution, well-scoped tasks |

## Execution Model

### Agent Launch

Agents are launched using Claude Code's native `--agent` flag:

```bash
claude --print --agent developer --permission-mode auto --max-turns 100 \
  --append-system-prompt "$DYNAMIC_CONTEXT" \
  'Begin your assigned task.'
```

The `--append-system-prompt` carries only dynamic runtime context (~200 tokens): initiative name, worktree path, state file locations. The agent's identity, workflow knowledge, and skills are handled by the agent definition file.

### Window & Pane Layout

The visual layout uses tmux **windows** (separate terminal views) and **panes** (splits within a window). All panes in a window are visible and interactive simultaneously — no tab-switching.

```
┌── Coordination Window ──────────────────────────────────┐
│  Integrator (your session)   │  Orchestrator            │
│  Top pane — talk, decide     │  Bottom pane — coordinate │
└──────────────────────────────┴──────────────────────────┘

┌── Initiative "auth" Window ─────────────────────────────┐
│  PM Agent     │  Developer    │  Reviewer               │
│  (complete)   │  (working)    │  (waiting)              │
└───────────────┴───────────────┴─────────────────────────┘

┌── Initiative "billing" Window ──────────────────────────┐
│  Architect    │  Developer                              │
│  (working)    │  (working)                              │
└───────────────┴─────────────────────────────────────────┘
```

- **Coordination window**: Integrator + Orchestrator panes (always present)
- **Initiative windows**: one per active initiative, with a pane per agent working on it
- **Ops window**: agents without a specific initiative (system-wide work)

`launch-agent.sh` handles pane creation automatically — if the target window exists, it adds a pane; if not, it creates the window.

### Agent Isolation

Each agent runs in its own:
- **tmux pane** within the initiative's window (visible alongside other agents on the same initiative)
- **Claude Code session** (separate context/conversation)
- **Working directory** (repo root for PM/PjM/Reviewer, worktree for developers)

Agents never share Claude Code context. All communication is through the state files.

### Skill-Based Workflows

Each agent follows a skill-based workflow. Skills are invoked as `/skill-name` and provide structured instructions for each step. This provides:
- **Context efficiency** — skills load only when needed, not upfront
- **Consistency** — agents follow the same process every time
- **Transparency** — you can read the skill files to understand what the agent will do
- **Customizability** — modify skill files to change agent behavior

### Worktree-Based Development

Developer agents work in git worktrees, providing:
- **Isolation** — each task gets its own checkout, no conflicts
- **Parallelism** — multiple developers can work simultaneously
- **Clean history** — each worktree produces its own commits on its own branch

## Technology Choices

| Component | Technology | Rationale |
|-----------|-----------|-----------|
| Agent runtime | Claude Code (`--agent` native) | Best autonomous coding agent available; native support for agents, skills, permissions |
| Process management | tmux | Lightweight, scriptable, observable |
| State management | Filesystem (YAML/MD) | No database needed, git-friendly, human-readable |
| Orchestration | Interactive agent (primary) / Bash script (fallback) | Interactive mode adapts and learns; bash fallback is deterministic, zero API cost |
| Cross-agent comms | Filesystem (markdown messages in comms/) | Observable, auditable, async, no external dependencies |
| Human review | Cursor | Visual diffs, inline comments, familiar IDE |
| Notifications | Slack (Incoming Webhooks) | Real-time question routing, progress visibility, decision tracking |
| Design | Claude Design | AI-assisted UI/UX design |
| Cross-LLM review | MCP servers | Extensible, protocol-based, multi-model |

## Security Considerations

- Agent sessions run with `--permission-mode auto` for unattended operation
- Agents can read/write files within their working directory
- Developer agents are constrained to their worktree by convention (enforced in agent definition)
- No network access beyond what Claude Code provides
- Secrets should be managed through the project's existing mechanisms (not in `.deliberate/`)
