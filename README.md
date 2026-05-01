# Deliberate Agents

A repo-agnostic multi-agent framework for autonomous software development. Point it at any project and get cooperating AI agents that plan, coordinate, and execute work — from idea to shipped code.

```
One-Pager  →  PRD  →  Tasks  →  Cross-Functional Work  →  Review
   (you)       (PM)    (PjM)     (specialist agents)       (you)
```

You write a one-pager describing what you want built. Deliberate Agents takes it from there — a Product Manager expands it into a full PRD, a Project Manager decomposes it into routed tasks, specialist agents execute in parallel, and a Reviewer validates against acceptance criteria. You review the completed work in Cursor.

The orchestrator is a bash script coordinating everything through filesystem-based state. No database, no server, no message queue — just files.

---

## Getting Started

### 1. Prerequisites

| Requirement | Check | Install |
|-------------|-------|---------|
| macOS | — | — |
| tmux 3.0+ | `tmux -V` | `brew install tmux` |
| Claude Code CLI | `claude --version` | [Install Claude Code](https://docs.anthropic.com/en/docs/claude-code) |
| git | `git --version` | `brew install git` |
| Node.js (optional) | `node --version` | `brew install node` (only needed for MCP servers) |

Or run the dependency checker:

```bash
./scripts/install-deps.sh --check-only
```

### 2. Clone Deliberate Agents

```bash
cd ~/Development
git clone https://github.com/Orcheros/Deliberate_Agents.git
cd Deliberate_Agents
```

### 3. Initialize for Your Project

Every project you work on with Deliberate Agents gets its own initialization. This creates the state directory, deploys agent definitions and skills into your project's worktrees, and generates a config file.

```bash
./scripts/init.sh \
  --name "My Project" \
  --repo /path/to/my-project \
  --worktrees /path/to/my-project-worktrees
```

**What this does:**

1. Creates `.deliberate/` inside your worktrees directory with the state protocol structure:
   ```
   .deliberate/
   ├── config.yaml          # Project-specific configuration
   ├── queue/               # Initiative state files
   ├── assignments/         # Task assignments per worktree
   ├── status/              # Agent heartbeat files
   ├── decisions/           # Items needing human input
   └── logs/                # Agent session logs
   ```

2. Deploys agent definitions to `{worktrees}/.claude/agents/` (14 agents)
3. Deploys skills to `{worktrees}/.claude/skills/` (38 skills)
4. Generates a project config from your inputs

**Optional flags:**

| Flag | Default | Purpose |
|------|---------|---------|
| `--main-branch` | `main` | Production branch |
| `--dev-branch` | `dev` | Development branch (agent worktrees branch from here) |
| `--test-cmd` | `bin/rails test` | Unit test command |
| `--system-test-cmd` | `bin/rails test:system` | System test command |

**Branch model for mature apps:**

Most production Rails apps use a three-branch model: `dev` (active development) → `staging` (pre-production validation) → `main` (production). Agent worktrees branch from and merge back into `dev`. Promotion to `staging` and `main` is a human operation outside the agent pipeline.

### 4. Start the Orchestrator

```bash
./orchestration/orchestrate.sh /path/to/my-project-worktrees/.deliberate/config.yaml
```

This starts a tmux session that polls state files every 30 seconds and launches agents as needed. It runs in the foreground — open a new terminal for other work.

### 5. Queue an Initiative

Create a YAML file in the queue directory:

```bash
cat > /path/to/my-project-worktrees/.deliberate/queue/my-feature.yaml << 'EOF'
initiative: my-feature
status: QUEUED
title: "Add user authentication"
one_pager: |
  We need login/logout functionality with email+password.
  Users should be able to reset their password via email.
  Session management with remember-me option.
created_at: 2026-04-30
EOF
```

The orchestrator detects the new initiative and launches the pipeline:

```
QUEUED → PM_IN_PROGRESS → PRD_COMPLETE → PJM_IN_PROGRESS → READY_FOR_DEV →
DEV_IN_PROGRESS → DEV_COMPLETE → REVIEW_IN_PROGRESS → REVIEW_READY
```

### 6. Check Status

```bash
./orchestration/status.sh /path/to/my-project-worktrees/.deliberate/config.yaml
```

Shows: orchestrator health, active tmux windows, initiative status, active assignments, and pending decisions.

### 7. Review Completed Work

When an initiative reaches `REVIEW_READY`, open the worktree in Cursor:

```bash
cursor /path/to/my-project-worktrees/<worktree-name>
```

Review diffs, run tests, validate behavior. Merge when satisfied.

---

## Working on Other Applications

Deliberate Agents is designed to be pointed at any project. One clone of this repo can manage multiple applications simultaneously.

### Adding a New Project

```bash
# From the Deliberate_Agents directory
./scripts/init.sh \
  --name "Second Project" \
  --repo /path/to/second-project \
  --worktrees /path/to/second-project-worktrees \
  --main-branch main \
  --dev-branch develop \
  --test-cmd "npm test" \
  --system-test-cmd "npm run test:e2e"
```

Each project gets its own:
- `.deliberate/` state directory (inside its worktrees)
- `.claude/agents/` and `.claude/skills/` (deployed copies)
- `config.yaml` with project-specific settings
- Independent orchestrator process

### Running Multiple Projects

Each project runs its own orchestrator instance in a separate tmux session:

```bash
# Terminal 1: Project A
./orchestration/orchestrate.sh /path/to/project-a-worktrees/.deliberate/config.yaml

# Terminal 2: Project B
./orchestration/orchestrate.sh /path/to/project-b-worktrees/.deliberate/config.yaml
```

Projects are fully isolated — different state directories, different agent sessions, different worktrees.

### Adapting to a Different Stack

The framework ships with Rails conventions (Tailwind CSS, Stimulus JS, Minitest) but adapts to any stack:

1. **Agent definitions** — edit `.claude/agents/*.md` in your project's worktrees to reflect your stack's patterns and conventions
2. **Skills** — edit `.claude/skills/*/SKILL.md` to match your workflow (e.g., change `bin/rails test` to `npm test`)
3. **CLAUDE.md** — the template at `templates/CLAUDE.md.template` generates the per-worktree instructions. Customize for your stack before running `init.sh`, or edit the deployed copy directly
4. **Config** — set `test_command` and `system_test_command` in your project's config.yaml

See [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md) for detailed customization options.

---

## How It Works

### Agent Roster

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
| SEO Specialist | Search optimization across SEO, AEO, AIO, and GEO | sonnet |

### Architecture

- **Orchestrator** (`orchestration/orchestrate.sh`): Bash script polling state files on an interval. Launches and monitors agents via tmux. Zero API cost.
- **Agents** (`.claude/agents/*.md`): Claude Code sessions using native `--agent` flag with role-specific definitions.
- **Skills** (`skills/`): Workflow steps as Claude Code skills, lazy-loaded when invoked. Agents only consume context for the step they're executing.
- **State** (`.deliberate/`): YAML and markdown files for inter-agent communication. Git-friendly, human-readable.
- **Decisions** (`.deliberate/decisions/`): Items that need human input. Agents halt and wait.
- **MCP Servers** (`mcp-servers/`): Optional cross-LLM capabilities (e.g., OpenAI code review).

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the full technical design.

### Design Principles

- **Autonomous**: Agents run unattended until they need a human decision
- **Coordinated**: Filesystem-based state protocol enables multi-agent cooperation
- **Observable**: Every action is logged, every state is queryable
- **Repo-agnostic**: Initialize once per project, works with any codebase
- **Cost-aware**: Orchestrator is bash (zero API cost). Only agent sessions use the API.
- **Context-efficient**: Skills are lazy-loaded — agents only consume context for the workflow step they're executing

---

## Project Structure

```
Deliberate_Agents/
├── .claude/agents/     Agent definitions (native Claude Code format)
├── skills/             Workflow step skills (deployed to target project)
├── orchestration/      Coordination scripts (bash)
├── templates/          Per-project bootstrapping templates
├── state/              State protocol documentation
├── scripts/            Setup and utility scripts
├── mcp-servers/        MCP server implementations
└── docs/               Documentation
    ├── ARCHITECTURE.md     Full technical design
    ├── GETTING-STARTED.md  Extended walkthrough
    └── CUSTOMIZATION.md    Adapting agents and skills
```

---

## Status

| Phase | Description | Status |
|-------|-------------|--------|
| 1. Foundation | Core agent definitions, orchestration, templates, state protocol | Complete |
| 2. Native Refactor | Migrated to Claude Code native agents and lazy-loaded skills | Complete |
| 3. Full Roster | 15 specialist agents with 38 skills across all functions | Complete |
| 4. Execution | End-to-end autonomous initiative execution | Next |

---

## Inspiration

Extends patterns from [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD) (agent personas, step-file workflows, progressive context) into fully autonomous, multi-process coordination where agents run unattended and communicate through shared state.

## License

MIT
