# Deliberate Agents

**Turn an idea into working software using a team of AI agents.**

You describe what you want built in plain language. Deliberate Agents assembles a virtual team — a Product Manager, Project Manager, developers, reviewers, and specialists — that plans the work, writes the code, and delivers it for your review. You stay in control of every decision that matters.

## How It Works (The Big Picture)

Think of Deliberate Agents like hiring a small company to build your feature:

```
 You write a         A Product Manager        A Project Manager        Specialist agents       You review
 one-pager  ──────►  turns it into a    ──────►  breaks it into   ──────►  do the work      ──────►  the finished
 describing          detailed plan              tasks and assigns          (code, content,          product in
 what you want       (called a PRD)             them to the right          docs, security...)       Cursor
                                                team members
```

1. **You** write a short description of what you want (a "one-pager")
2. **The Product Manager** expands your idea into a full plan with requirements, success metrics, and scope
3. **The Project Manager** breaks the plan into specific tasks and assigns each one to the right specialist
4. **Specialist agents** execute their tasks — writing code, configuring tools, creating content, reviewing security, and more
5. **A Reviewer** validates that everything meets the original requirements
6. **You** review the completed work in [Cursor](https://cursor.sh/) and merge it when you're satisfied

The whole process is coordinated by a simple script called the **orchestrator** that watches for completed work and launches the next step automatically. No databases, no servers — just files on your computer.

---

## The Team

Deliberate Agents comes with 15 specialist agents, each with a specific role:

### Core Pipeline

| Agent | What They Do |
|-------|-------------|
| **Product Manager** | Reads your one-pager and writes a detailed product requirements document (PRD) covering everything the team needs to know |
| **Project Manager** | Reads the PRD, breaks it into individual tasks, and assigns each task to the right specialist |
| **Developer** | Writes the code. Works on one task at a time in an isolated copy of your project (called a "worktree") |
| **Reviewer** | Checks that the completed work actually matches what was planned. Writes a summary so you know exactly what changed |

### Specialists

| Agent | What They Do |
|-------|-------------|
| **Integrations Engineer** | Configures third-party tools — CRM, analytics, email providers, payment systems |
| **Content Writer** | Writes copy — email sequences, landing pages, in-app messaging, marketing content |
| **Technical Writer** | Creates runbooks, API documentation, and internal reference material |
| **Compliance Analyst** | Audits for privacy, legal, and regulatory requirements. Documents compliance needs |
| **DevOps Engineer** | Sets up CI/CD pipelines, infrastructure, monitoring, and deployment |
| **Security Analyst** | Reviews for security vulnerabilities, builds threat models, assesses risks |
| **Sales Development Rep** | Researches prospects, prepares outreach, maintains pipeline data |
| **Account Executive Assistant** | Supports deals with proposals, competitive analysis, and account research |
| **Customer Success** | Monitors account health, identifies churn risks and expansion opportunities |
| **Onboarding Specialist** | Designs onboarding flows tailored to different customer types |
| **SEO Specialist** | Optimizes for search — traditional SEO, featured snippets, AI overviews, and LLM citations |

Each agent knows its role and stays in its lane. The Developer never touches the PRD. The Product Manager never writes code. This prevents conflicts and keeps work organized.

---

## Getting Started

### What You'll Need

Before starting, make sure you have these tools installed:

| Tool | What It Is | How to Check | How to Install |
|------|-----------|-------------|---------------|
| **macOS** | Your operating system | — | — |
| **tmux** | A terminal multiplexer (lets agents run in separate windows) | `tmux -V` (need 3.0+) | `brew install tmux` |
| **Claude Code** | The AI that powers the agents | `claude --version` | [Install guide](https://docs.anthropic.com/en/docs/claude-code) |
| **git** | Version control for your code | `git --version` | `brew install git` |
| **Node.js** | Only needed if you want cross-LLM code review | `node --version` | `brew install node` |

Not sure if you have everything? Run:

```bash
./scripts/install-deps.sh --check-only
```

It will tell you what's missing.

### Step 1: Get Deliberate Agents

```bash
cd ~/Development
git clone https://github.com/Orcheros/Deliberate_Agents.git
cd Deliberate_Agents
```

### Step 2: Connect It to Your Project

Deliberate Agents doesn't live inside your project — it's a separate tool that you **point at** your project. Think of it like plugging your project into a workstation.

```bash
./scripts/init.sh \
  --name "My App" \
  --repo ~/Development/my-app \
  --worktrees ~/Development/my-app-worktrees
```

**What just happened?**

- A `.deliberate/` folder was created in your worktrees directory. This is where agents coordinate — it contains their task queue, progress tracking, and logs.
- Agent definitions and skills were copied into your project so they have the context they need.
- A config file was generated with your project's settings.

**Customizing for your project:**

| Setting | Default | What It Means |
|---------|---------|--------------|
| `--main-branch` | `main` | Your production branch |
| `--dev-branch` | `dev` | Where agent work gets merged (the development branch) |
| `--test-cmd` | `bin/rails test` | How to run your unit tests |
| `--system-test-cmd` | `bin/rails test:system` | How to run your end-to-end tests |

> **About branches:** Most mature apps use three branches — `dev` (active work), `staging` (pre-production testing), and `main` (production). Agents work on `dev`. Promoting code to `staging` and `main` is always your call.

### Step 3: Start the Orchestrator

The orchestrator is the coordinator. It watches for work that needs to be done and launches the right agent at the right time.

```bash
./orchestration/orchestrate.sh ~/Development/my-app-worktrees/.deliberate/config.yaml
```

This will keep running in your terminal. Open a new terminal tab or window for your next steps.

### Step 4: Give It Something to Build

Create a file describing what you want. This is your "one-pager" — it doesn't need to be long, just clear about what you want:

```bash
cat > ~/Development/my-app-worktrees/.deliberate/queue/user-auth.yaml << 'EOF'
initiative: user-auth
status: QUEUED
title: "Add user authentication"
one_pager: |
  We need login/logout functionality with email and password.
  Users should be able to reset their password via email.
  Include a "remember me" option for staying logged in.
created_at: 2026-04-30
EOF
```

The orchestrator will detect this new initiative and start the pipeline automatically:

```
Your idea is queued
  → Product Manager writes the PRD
    → Project Manager creates tasks
      → Developer agents write code
        → Reviewer checks the work
          → Ready for your review
```

### Step 5: Check on Progress

```bash
./orchestration/status.sh ~/Development/my-app-worktrees/.deliberate/config.yaml
```

This shows you what's happening: which agents are active, how far along each initiative is, and whether anything needs your attention.

### Step 6: Review and Approve

When the work is done, you'll see the initiative status change to `REVIEW_READY`. Open it in Cursor:

```bash
cursor ~/Development/my-app-worktrees/<worktree-name>
```

Look through the changes, run the tests, try it out. When you're happy, merge it into your `dev` branch.

---

## Using Deliberate Agents with Multiple Projects

One copy of Deliberate Agents can manage as many projects as you want. Each project is completely independent.

### Adding Another Project

```bash
# From the Deliberate_Agents directory
./scripts/init.sh \
  --name "My Other App" \
  --repo ~/Development/other-app \
  --worktrees ~/Development/other-app-worktrees \
  --test-cmd "npm test" \
  --system-test-cmd "npm run test:e2e"
```

Notice you can change the test commands — Deliberate Agents isn't locked to any specific programming language or framework.

### Running Multiple Projects at Once

Each project needs its own orchestrator running in its own terminal:

```bash
# Terminal 1
./orchestration/orchestrate.sh ~/Development/my-app-worktrees/.deliberate/config.yaml

# Terminal 2
./orchestration/orchestrate.sh ~/Development/other-app-worktrees/.deliberate/config.yaml
```

Projects never interfere with each other. They have separate state, separate agents, and separate workspaces.

### Adapting to Your Stack

Deliberate Agents ships with [Ruby on Rails](https://rubyonrails.org/) conventions (Tailwind CSS, Stimulus JS, Minitest), but you can adapt it to any stack:

1. **Agent definitions** in `.claude/agents/*.md` — tell agents about your framework's patterns
2. **Skills** in `.claude/skills/*/SKILL.md` — adjust workflow steps for your tooling
3. **Config** — set your test commands and branch names

See [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md) for details.

---

## What's in This Repo

```
Deliberate_Agents/
│
├── .claude/agents/     Who's on the team — one file per agent defining
│                       their role, personality, and capabilities
│
├── skills/             What each agent knows how to do — step-by-step
│                       workflow instructions loaded on demand
│
├── orchestration/      The coordination scripts that launch agents,
│                       monitor progress, and keep things moving
│
├── scripts/            Setup tools — initialize projects, check
│                       dependencies, clean up when done
│
├── templates/          Starter files that get copied into your project
│                       during initialization
│
├── state/              Documentation for how agents communicate with
│                       each other through files
│
├── mcp-servers/        Optional add-ons for cross-LLM capabilities
│                       (e.g., getting OpenAI to review Claude's code)
│
└── docs/               Detailed documentation
    ├── ARCHITECTURE.md     How the system is designed
    ├── GETTING-STARTED.md  Extended setup walkthrough
    └── CUSTOMIZATION.md    Making it work with your stack
```

Each directory has its own README explaining what's inside and how to use it.

---

## Key Concepts

A few terms that come up often:

| Term | What It Means |
|------|--------------|
| **Initiative** | A feature or project you want built. It starts as your one-pager and moves through the pipeline until it's done. |
| **PRD** | Product Requirements Document. The detailed plan that the Product Manager writes from your one-pager. |
| **Worktree** | A separate copy of your project's code where an agent can work without affecting the main codebase. Think of it like a sandbox. |
| **Orchestrator** | The bash script that coordinates everything. It watches for completed work and launches the next agent in line. It doesn't use AI — it's just a simple script, so it costs nothing to run. |
| **Skill** | A step-by-step instruction set that an agent follows for a specific task. Skills are loaded only when needed, keeping agents focused. |
| **State** | The collection of files in `.deliberate/` that track what's happening — which initiatives are active, which tasks are assigned, which agents are running. |
| **Decision** | Something that needs your input before agents can continue. Agents will pause and wait rather than guess. |

---

## Design Principles

- **You're always in control.** Agents pause and ask when they're unsure. Merging code is always your decision. Nothing ships without your approval.
- **Agents work independently.** Each agent runs in its own session and communicates through files, not messages. This means they can't accidentally step on each other's work.
- **Everything is observable.** Every action is logged. Every state is visible. You can check what any agent is doing at any time.
- **It works with any project.** Initialize once and point it at any codebase. The same agents work whether you're building a Rails app, a Node.js API, or a static site.
- **Cost-conscious.** The orchestrator is a bash script — zero AI cost. Only the agent sessions themselves use the API. Skills are loaded on demand, not all at once.

---

## Project Status

| Phase | What It Covers | Done? |
|-------|---------------|-------|
| Foundation | Core agents, orchestration, templates, state protocol | Yes |
| Native Refactor | Migrated to Claude Code's native agent system | Yes |
| Full Roster | 15 agents with 38 skills across all business functions | Yes |
| Execution | First end-to-end autonomous initiative | Next |

---

## Inspiration

Built on patterns from [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD) — agent personas, step-based workflows, progressive context loading — extended into fully autonomous multi-agent coordination.

## License

MIT
