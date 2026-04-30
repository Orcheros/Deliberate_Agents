# Deliberate_Agents

A repo-agnostic multi-agent framework for autonomous software development. Point it at any project and get cooperating AI agents that plan, coordinate, and execute development work — from idea to code.

## What It Does

```
One-Pager  →  PRD  →  Tasks  →  Cross-Functional Work  →  Review
   (you)       (PM)    (PjM)     (14 specialist agents)     (you)
```

You write a one-pager describing what you want built. Deliberate_Agents takes it from there:

1. **Product Manager** expands the idea into a full PRD (22 sections, cross-functional)
2. **Project Manager** decomposes the PRD into tasks routed by agent type
3. **Specialist agents** execute tasks in parallel — development, integrations, content, compliance, docs, DevOps, security, sales ops, CS, and onboarding
4. **Reviewer** validates work against acceptance criteria
5. **You** review the completed work in Cursor

The orchestrator (a bash script) coordinates everything through filesystem-based state management. No database, no server — just files.

### Agent Roster (14 agents)

| Agent | Role | Model |
|-------|------|-------|
| Product Manager | One-pager → full PRD with cross-functional requirements | opus |
| Project Manager | PRD → decomposed tasks, routed to correct agent type | sonnet |
| Developer | Code implementation in isolated worktrees | sonnet |
| Reviewer | Validates completed work against acceptance criteria | sonnet |
| Integrations Engineer | SaaS tool configuration (CRM, analytics, email, payments) | sonnet |
| Content Writer | Copy, email sequences, landing pages, in-app messaging | sonnet |
| Compliance Analyst | Privacy, legal, regulatory audit and documentation | sonnet |
| Technical Writer | Runbooks, API docs, internal reference material | sonnet |
| DevOps Engineer | CI/CD, infrastructure, monitoring, deployment | sonnet |
| Security Analyst | Threat modeling, security review, vulnerability assessment | sonnet |
| Sales Development Rep | Prospect research, outreach prep, pipeline maintenance | sonnet |
| Account Executive Assistant | Deal support, proposals, competitive analysis | sonnet |
| Customer Success | Account health monitoring, churn/expansion signals | sonnet |
| Onboarding Specialist | User activation optimization, per-ICP onboarding flows | sonnet |

## Design Principles

- **Autonomous**: Agents run unattended until they need a human decision
- **Coordinated**: Filesystem-based state protocol enables multi-agent cooperation
- **Observable**: Every action is logged, every state is queryable
- **Repo-agnostic**: Configure once for any project
- **Cost-aware**: Orchestrator is bash (zero API cost). Only agent sessions use the API.
- **Context-efficient**: Skills are lazy-loaded — agents only consume context for the workflow step they're executing

## Architecture

- **Orchestrator**: Bash script polling state files on an interval. Launches and monitors agents via tmux.
- **Agents**: Claude Code sessions using native `--agent` flag with role-specific definitions in `.claude/agents/`.
- **Skills**: Workflow steps as Claude Code skills in `skills/`, lazy-loaded when invoked.
- **State**: YAML and markdown files in `.deliberate/` within your project.
- **Human touchpoint**: `decisions/` directory for items that need your input.
- **MCP Servers**: Extensible cross-LLM capabilities (e.g., OpenAI code review).

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the full technical design.

## Quick Start

```bash
# Check dependencies
./scripts/install-deps.sh

# Initialize for your project
./scripts/init.sh \
  --name "My Project" \
  --repo /path/to/project \
  --worktrees /path/to/project-worktrees

# Start the orchestrator
./orchestration/orchestrate.sh /path/to/project-worktrees/.deliberate/config.yaml

# Check status
./orchestration/status.sh /path/to/project-worktrees/.deliberate/config.yaml
```

See [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md) for the full walkthrough.

## Stack Assumptions

Built with Ruby on Rails projects in mind (Tailwind CSS, Stimulus JS, Minitest), but adaptable to any stack by customizing agent definitions and skill files. UI/UX designs come from Claude Design. See [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md).

## Requirements

- macOS (tested on Darwin)
- tmux 3.0+
- Claude Code CLI
- git
- Node.js (optional, for MCP servers)

## Project Structure

```
.claude/agents/     Agent definitions (native Claude Code format)
skills/             Workflow step skills (deployed to target project)
orchestration/      Coordination scripts (bash)
templates/          Per-project bootstrapping templates
state/              State protocol documentation
scripts/            Setup and utility scripts
mcp-servers/        MCP server implementations
docs/               Documentation
```

## Status

**Phase 1 (Foundation)** — Complete. Core agent definitions, orchestration scripts, templates, and state protocol.

**Phase 2 (Native Refactor)** — Complete. Migrated from custom prompt injection to Claude Code native agents (`.claude/agents/`) and lazy-loaded skills (`skills/`).

**Phase 3 (Full Roster)** — Complete. 14 specialist agents with 35 skills covering engineering, GTM, sales, CS, compliance, and operations.

**Phase 4 (Execution)** — Next. Prove the autonomous execution model with a real initiative end-to-end.

## Inspiration

Extends patterns from [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD) (agent personas, step-file workflows, progressive context) into fully autonomous, multi-process coordination where agents run unattended and communicate through shared state.

## License

MIT
