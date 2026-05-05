# Architecture

## System Overview

Deliberate_Agents is a multi-agent coordination framework that runs multiple Claude Code sessions as autonomous agents, coordinated through filesystem-based state management.

```
┌──────────────────────────────────────────────────────────────────┐
│                           Human                                    │
│                (Reviews in Cursor, makes decisions)                │
└─────────────────────────────┬────────────────────────────────────┘
                              │ decisions/, review
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                      Orchestrator (bash)                           │
│          Polls state, launches agents, routes by agent_type        │
│                     Runs in tmux window                            │
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

### Orchestrator (Shell Script)

The orchestrator is intentionally NOT an AI agent. It is a deterministic bash script that:

1. **Polls** `.deliberate/queue/` and `.deliberate/assignments/` every N seconds
2. **Detects** state transitions (new initiatives, completed tasks, blocked work)
3. **Launches** the appropriate AI agent via `claude --agent <role>` in a new tmux window
4. **Monitors** agent health via tmux window existence and heartbeat staleness
5. **Routes** completed work to the next pipeline stage

This design keeps the coordination layer cheap (zero API cost), deterministic (no LLM variance), and observable (pure state machine).

### AI Agents

Each AI agent runs as an independent Claude Code session using native agent definitions. 30 agents are organized into 7 teams:

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

**Orchestrator** (`agents/orchestrator.md`):

- **Orchestrator**: Persistent coordinator — manages initiative queue, daily work log, team routing, Slack communication.

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

- `queue/` — Initiative lifecycle (QUEUED → ... → COMPLETE)
- `assignments/` — Developer task assignments (assigned → in_progress → complete)
- `status/` — Agent heartbeats, activity reports, and compiled report (`report.md`)
- `decisions/` — Items requiring human input (with `.notified` markers for Slack tracking)
- `logs/` — Session output logs

See `state/README.md` for the full protocol specification.

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

### Agent Isolation

Each agent runs in its own:
- **tmux window** (separate terminal)
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
| Orchestration | Bash script | Deterministic, zero API cost, easy to debug |
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
