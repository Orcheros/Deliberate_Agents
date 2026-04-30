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

Each AI agent runs as an independent Claude Code session using native agent definitions.

**Core Pipeline Agents:**

- **Product Manager** (`.claude/agents/product-manager.md`): Transforms one-pagers into 22-section PRDs with cross-functional requirements for all agent types. Model: opus.
- **Project Manager** (`.claude/agents/project-manager.md`): Decomposes PRDs into tasks routed by `agent_type` field. Coordinates multi-agent execution.
- **Developer(s)** (`.claude/agents/developer.md`): Executes code tasks in isolated worktrees. Writes code, runs tests, produces commits. Multiple can run concurrently.
- **Reviewer** (`.claude/agents/reviewer.md`): Validates completed work against acceptance criteria. Read-only tools.

**Engineering Specialists:**

- **Integrations Engineer** (`.claude/agents/integrations-engineer.md`): Configures SaaS tools — CRM, analytics, lifecycle email, payment, DNS/email auth.
- **DevOps Engineer** (`.claude/agents/devops-engineer.md`): CI/CD pipelines, infrastructure, monitoring, deployment.
- **Security Analyst** (`.claude/agents/security-analyst.md`): Threat modeling, security review, vulnerability assessment. Read-only tools.

**Content & Compliance:**

- **Content Writer** (`.claude/agents/content-writer.md`): Copy, email sequences, landing pages, in-app messaging. No Bash access.
- **Technical Writer** (`.claude/agents/technical-writer.md`): Runbooks, API docs, internal reference material.
- **Compliance Analyst** (`.claude/agents/compliance-analyst.md`): Privacy, legal, regulatory audit. Cites specific regulations.

**GTM & Customer Operations:**

- **Sales Development Rep** (`.claude/agents/sales-development-rep.md`): Prospect research, outreach preparation, pipeline maintenance.
- **Account Executive Assistant** (`.claude/agents/account-executive-assistant.md`): Deal support, proposals, competitive analysis, pre-call briefs.
- **Customer Success** (`.claude/agents/customer-success.md`): Account health monitoring (Green/Yellow/Red), churn/expansion signals.
- **Onboarding Specialist** (`.claude/agents/onboarding-specialist.md`): Per-ICP onboarding flows, activation metrics, email-product coordination.

### Skills (Workflow Steps)

Workflow steps are implemented as Claude Code skills in `skills/`. Skills are lazy-loaded — they appear in the agent's awareness but only consume context when invoked. This replaces the previous approach of concatenating all step files into a single system prompt (~8,000 tokens upfront → ~500 tokens baseline).

Each agent's definition lists its available skills. 35 skills across 14 agents:

- **Developer**: `dev-understand`, `dev-implement`, `dev-test`, `dev-complete`
- **Product Manager**: `pm-assess`, `pm-research`, `pm-expand-prd`, `pm-architecture`, `pm-cross-functional`, `pm-ready-for-dev`
- **Project Manager**: `pjm-decompose`, `pjm-assign`, `pjm-coordinate`, `review-validate`, `review-summarize`
- **Reviewer**: `review-validate`, `review-summarize`
- **Integrations Engineer**: `integrations-assess`, `integrations-configure`, `integrations-verify`
- **Content Writer**: `content-brief`, `content-draft`, `content-review`
- **Compliance Analyst**: `compliance-assess`, `compliance-document`
- **Technical Writer**: `docs-assess`, `docs-write`
- **DevOps Engineer**: `devops-assess`, `devops-implement`
- **Security Analyst**: `security-assess`, `security-review`
- **Sales Development Rep**: `sales-research`, `sales-outreach-prep`, `sales-pipeline`
- **Account Executive Assistant**: `sales-research`, `sales-pipeline`
- **Customer Success**: `cs-health-check`, `cs-intervention`
- **Onboarding Specialist**: `onboarding-assess`, `onboarding-design`

### MCP Servers

MCP (Model Context Protocol) servers enable cross-LLM capabilities. The `codex-review` server (stub) demonstrates using OpenAI for code review while Claude Code remains the primary agent runtime.

### State Directory

The `.deliberate/` directory is the single source of truth for all inter-agent coordination:

- `queue/` — Initiative lifecycle (QUEUED → ... → COMPLETE)
- `assignments/` — Developer task assignments (assigned → in_progress → complete)
- `status/` — Agent heartbeats and activity reports
- `decisions/` — Items requiring human input
- `logs/` — Session output logs

See `state/README.md` for the full protocol specification.

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
| Design | Claude Design | AI-assisted UI/UX design |
| Cross-LLM review | MCP servers | Extensible, protocol-based, multi-model |

## Security Considerations

- Agent sessions run with `--permission-mode auto` for unattended operation
- Agents can read/write files within their working directory
- Developer agents are constrained to their worktree by convention (enforced in agent definition)
- No network access beyond what Claude Code provides
- Secrets should be managed through the project's existing mechanisms (not in `.deliberate/`)
