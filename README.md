# Deliberate Agents

**Turn an idea into working software using a team of AI agents.**

You describe what you want built in plain language. Deliberate Agents assembles a virtual team — a Product Manager, Project Manager, developers, reviewers, and specialists — that plans the work, writes the code, and delivers it for your review. You stay in control of every decision that matters.

## How It Works (The Big Picture)

Think of Deliberate Agents like hiring a small company to build your feature:

```
 You have an         The Integrator           A Product Manager        A Project Manager        Specialist agents       You review
 idea         ──────►  validates it,     ──────►  turns it into a    ──────►  breaks it into   ──────►  do the work      ──────►  the finished
                       prioritizes it,           detailed plan              tasks and assigns          (code, content,          product in
                       and sequences it          (called a PRD)             them to the right          docs, security...)       Cursor
                       against what's                                       team members
                       already in flight
```

1. **You** describe what you want — a raw idea, a bug, a "what if we..."
2. **The Integrator** evaluates your idea against everything already in flight, decides whether to accept, defer, or reject it, and slots it into the priority stack
3. **The Product Manager** expands the accepted idea into a full plan with requirements, success metrics, and scope (called a PRD)
4. **Optionally, the Architect and Designer step in** — for technical features, the Architect creates an architecture document covering system design, data models, and API contracts. For UI-heavy initiatives, the Product Designer reviews the PRD (and arch doc) and produces a design study. That design study gets sent to [Claude Design](https://claude.ai) for visual design execution, and the resulting design artifacts come back to the Designer to be folded into the PRD and arch doc before anything moves forward.
5. **The Project Manager** breaks the plan into specific tasks and assigns each one to the right specialist
6. **Specialist agents** execute their tasks — writing code, configuring tools, creating content, reviewing security, and more
7. **A Reviewer** validates that everything meets the original requirements
8. **You** review the completed work in [Cursor](https://cursor.sh/) and merge it when you're satisfied
9. **The Integrator tracks it to completion** — code in production isn't done. The Integrator ensures docs, marketing, and support enablement ship alongside the feature

Not every initiative needs the Architect or Designer — a backend API change might go straight from PRD to tasks, while a new dashboard feature would go through the full design cycle. The Product Manager's PRD determines which steps are needed.

The whole process is coordinated by two layers: the **Integrator** decides *what* to work on and *in what order*, while the **Orchestrator** handles the mechanics — watching for completed work and launching the next step automatically. No databases, no servers — just files on your computer.

For the full detail on each workflow — including decision gates, optional branches, and handoff conditions — see the [workflows/](workflows/) directory.

---

## The Team

Deliberate Agents comes with 31 specialist agents organized into 7 teams plus a strategic layer, backed by 99 skills:

### Product Team (definition phase)

| Agent | What They Do |
|-------|-------------|
| **Product Manager** | Reads your one-pager and writes a detailed product requirements document (PRD) covering everything the team needs to know |
| **Architect** | *(When needed)* Creates an architecture document — system design, data models, API contracts, and technical decisions for complex or technical features |
| **Product Designer** | *(When needed)* Reviews the PRD and arch doc, produces a design study for UI-heavy features. Sends the study to Claude Design for visual execution, then folds the design artifacts back into the product docs |
| **Scrum Master** | Bridges product → engineering. Shards PRDs into Epics, Sprints, and Stories |

### Engineering Team (execution phase)

| Agent | What They Do |
|-------|-------------|
| **Project Manager** | Reads the PRD, breaks it into individual tasks, and assigns each task to the right specialist |
| **Developer** | Writes the code. Works on one task at a time in an isolated copy of your project (called a "worktree") |
| **Database Specialist** | Schema design, migrations, indexing, and query performance |
| **Integrations Engineer** | Configures third-party tools — CRM, analytics, email providers, payment systems (Stripe lifecycle) |
| **DevOps Engineer** | Sets up CI/CD pipelines, infrastructure, monitoring, observability, and incident command |

### QA Team

| Agent | What They Do |
|-------|-------------|
| **QA Lead** | Plans test strategy, assigns test work, coordinates QA across initiatives |
| **Integration Tester** | Tests cross-system behavior — API contracts, data flows, webhook pipelines |
| **Security Analyst** | Reviews for security vulnerabilities, dependency audits, incident response |
| **UX/UI Reviewer** | Validates design fidelity, WCAG 2.1 AA accessibility, responsive behavior |

### Support Team (cross-cutting)

| Agent | What They Do |
|-------|-------------|
| **Reviewer** | Checks that completed work matches what was planned. Reviews API design quality. Writes summaries for human review |
| **Data Analyst** | SaaS metrics, product analytics, cohort analysis, funnel reporting |
| **Compliance Analyst** | Audits for privacy, legal, and regulatory requirements (GDPR, SOC2). Documents compliance needs |
| **Help Desk** | Triages support tickets, drafts responses, escalates product issues |

### Release Team

| Agent | What They Do |
|-------|-------------|
| **Release Manager** | Plans releases, makes go/no-go recommendations, tracks release metrics, runs retrospectives |
| **Release Engineer** | Executes deployments — preflight checks, deploy, post-deploy verification and rollback |
| **Release Comms** | Writes changelogs, release notes, and internal/external announcements |
| **Release Marketer** | Plans launch campaigns, creates marketing content, measures adoption |

### GTM Team (go-to-market)

| Agent | What They Do |
|-------|-------------|
| **Growth Strategist** | Pricing strategy, experiment design, referral programs, competitive analysis |
| **Content Writer** | Writes copy — email sequences, landing pages, in-app messaging, marketing content |
| **Technical Writer** | Creates runbooks, API documentation, and internal reference material |
| **Sales Development Rep** | Researches prospects, prepares outreach, maintains pipeline data |
| **Account Executive Assistant** | Supports deals with proposals, competitive analysis, and account research |
| **Customer Success** | Monitors account health, identifies churn risks and expansion opportunities |
| **Onboarding Specialist** | Designs onboarding flows, activation metrics, and trial-to-paid conversion |
| **SEO Specialist** | Optimizes for search — traditional SEO, featured snippets, AI overviews, and LLM citations |

### Integrator & Orchestrator (strategic + coordination layer)

| Agent | What They Do |
|-------|-------------|
| **Integrator** | Strategic executor — sits between you (the Visionary) and the Orchestrator. Validates new ideas against everything in flight, prioritizes the pipeline, sequences execution, and holds every initiative accountable through its full lifecycle: validated → built → shipped → marketed → supported |
| **Orchestrator** | Tactical router — two modes: the `orchestrate.sh` bash script runs autonomously as a polling loop, while `/orchestrate` gives you an interactive command center for dispatching work and tracking progress. Reads the Integrator's priority stack and executes accordingly |

Each agent knows its role and stays in its lane. The Developer never touches the PRD. The Product Manager never writes code. The Integrator decides *what* to build; the Orchestrator handles *how* to build it. This prevents conflicts and keeps work organized.

---

## Getting Started

### What You'll Need

Before starting, make sure you have these tools installed on your Mac. Open **Terminal** (you'll find it in Applications → Utilities, or search for it with Spotlight) and run each check command:

| Tool | What It Is | How to Check | How to Install |
|------|-----------|-------------|---------------|
| **Homebrew** | A package manager for macOS (installs the other tools) | `brew --version` | [Install Homebrew](https://brew.sh/) — paste the command from their site into Terminal |
| **tmux** | Lets agents run in separate windows behind the scenes | `tmux -V` (need 3.0+) | `brew install tmux` |
| **Claude Code** | The AI that powers the agents | `claude --version` | [Install guide](https://docs.anthropic.com/en/docs/claude-code) |
| **git** | Version control for your code | `git --version` | `brew install git` |
| **it2** | iTerm2 CLI for split-pane agent teams | `it2 --version` | `pip3 install it2` |
| **iTerm2** | Terminal with native split-pane support for agent teams | Open iTerm2 | [Download iTerm2](https://iterm2.com/) — enable Python API in Settings → General → Magic |
| **Node.js** | Only needed if you want cross-LLM code review | `node --version` | `brew install node` |

### Step 1: Download Deliberate Agents

Open **Terminal** and run these commands. This downloads the Deliberate Agents code into a folder called `Deliberate_Agents` inside your `Development` folder:

```bash
# Go to your Development folder (create it first if you don't have one)
mkdir -p ~/Development
cd ~/Development

# Download Deliberate Agents from GitHub
git clone https://github.com/Orcheros/Deliberate_Agents.git

# Move into the Deliberate Agents folder
cd Deliberate_Agents
```

**Where you are now:** `~/Development/Deliberate_Agents/`

You can verify everything is installed correctly by running the dependency checker from here:

```bash
./scripts/install-deps.sh --check-only
```

It will tell you if anything is missing.

### Step 2: Connect It to Your Project

Deliberate Agents doesn't live inside your project — it's a separate tool that you **point at** your project. You give it two paths: where your main codebase lives, and where agents should do their work.

**Why two folders?** Your main project repository holds your production code — the `main`, `staging`, and `dev` branches that you deploy from. You don't want agents editing files directly in there. Instead, agents work in **worktrees** — separate copies of your code where they can make changes safely without affecting your main branches. Think of worktrees like scratch pads that are linked to your repo but isolated from it.

Here's a real example of how this looks on disk:

```
~/Development/
├── Deuterophos/              ← The main repo (main + staging branches live here)
├── Deuterophos-worktrees/    ← Where agents do their work (one folder per initiative)
│   ├── .deliberate/          ← Agent coordination files (queue, status, logs)
│   ├── user-auth/            ← Worktree for the "user auth" initiative
│   └── dashboard-v2/         ← Worktree for the "dashboard v2" initiative
└── Deliberate_Agents/        ← This framework (you're here)
```

Make sure you're still in the Deliberate Agents folder (`~/Development/Deliberate_Agents/`), then run:

```bash
./scripts/init.sh \
  --name "My App" \
  --repo ~/Development/my-app \
  --worktrees ~/Development/my-app-worktrees
```

> **What are these paths?**
> - `--repo` is your main project repository — the one you already have, where your `main` and `staging` branches live. Agents read from it but don't work in it directly.
> - `--worktrees` is a **separate folder** next to your repo where agents create isolated workspaces for each initiative. You don't need to create this folder — the script will set it up.
>
> **Naming convention:** We recommend putting them side by side with matching names: `my-app/` and `my-app-worktrees/`. This makes it obvious which worktrees belong to which repo.

**What just happened?**

- A `.deliberate/` folder was created inside your worktrees directory. This is where agents coordinate — it contains their task queue, progress tracking, and logs.
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

The orchestrator is the coordinator — it watches for work that needs to be done and launches the right agent at the right time.

Still in the Deliberate Agents folder (`~/Development/Deliberate_Agents/`), run:

```bash
./orchestration/orchestrate.sh ~/Development/my-app-worktrees/.deliberate/config.yaml
```

You'll see output confirming it's running. **This keeps running** — it needs to stay open to coordinate agents. Leave this terminal window alone and open a **new terminal tab** (Cmd+T) or **new terminal window** (Cmd+N) for the next steps.

### Step 4: Give It Something to Build

In your **new terminal window**, create a file describing what you want built. This is your "one-pager" — it doesn't need to be long, just clear about what you want:

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

> **What just happened?** You created a small YAML file in the queue folder. The orchestrator (still running in your other terminal) will detect this new file within 30 seconds and start the pipeline automatically.

The progress looks like this:

```
Your idea is queued
  → Product Manager writes the PRD
    → Architect / Designer step in (if needed)
      → Project Manager creates tasks
        → Developer agents write code
          → Reviewer checks the work
            → Ready for your review
```

### Step 5: Check on Progress

From any terminal window, run this to see what's happening:

```bash
# You can run this from anywhere — just give it the full path to your config
~/Development/Deliberate_Agents/orchestration/status.sh \
  ~/Development/my-app-worktrees/.deliberate/config.yaml
```

This shows you which agents are active, how far along each initiative is, and whether anything needs your attention (like a decision that agents can't make without you).

### Step 6: Review and Approve

When the work is done, the initiative status will change to `REVIEW_READY`. Open the finished work in Cursor to review it:

```bash
cursor ~/Development/my-app-worktrees/<worktree-name>
```

Look through the changes, run the tests, try it out. When you're happy, merge it into your `dev` branch. The orchestrator will mark the initiative as complete.

### The Command Center (`/orchestrate`)

The orchestrator bash script (Step 3) runs autonomously — it watches the queue and launches agents on its own. But sometimes you want to drive. The `/orchestrate` command gives you an interactive command center inside any Claude Code session.

**How to use it:** Open Claude Code in a project that's been initialized with Deliberate Agents, then type `/orchestrate`.

The command center:
- **Starts with a briefing** — running agents, initiative queue, items needing your attention
- **Offers a guided menu** — pick from Product, Engineering, Growth, or Operations workflows
- **Accepts free-text dispatch** — skip the menu and say what you want: "intake this bug about login failing on Safari" or "start dev on story 3a"
- **Tracks every dispatch** in a daily journal at `.deliberate/logs/dispatch-journal-YYYYMMDD.md`
- **Stays alive** — it's a persistent session that waits for your next instruction after each dispatch

Ask "what's running?" for a status check, or "what did we do today?" for a summary of everything dispatched.

See [docs/DAILY-USE.md](docs/DAILY-USE.md) for everyday workflows and tips.

---

## Using Deliberate Agents with Multiple Projects

One copy of Deliberate Agents can manage as many projects as you want. Each project is completely independent.

### Adding Another Project

Open Terminal and navigate to your Deliberate Agents folder, then run init again with the new project's details:

```bash
cd ~/Development/Deliberate_Agents

./scripts/init.sh \
  --name "My Other App" \
  --repo ~/Development/other-app \
  --worktrees ~/Development/other-app-worktrees \
  --test-cmd "npm test" \
  --system-test-cmd "npm run test:e2e"
```

Notice you can change the test commands — Deliberate Agents isn't locked to any specific programming language or framework.

### Running Multiple Projects at Once

Each project needs its own orchestrator running in its own terminal window. Open two separate Terminal windows:

```bash
# Terminal window 1 — start orchestrator for Project A
cd ~/Development/Deliberate_Agents
./orchestration/orchestrate.sh ~/Development/my-app-worktrees/.deliberate/config.yaml

# Terminal window 2 — start orchestrator for Project B
cd ~/Development/Deliberate_Agents
./orchestration/orchestrate.sh ~/Development/other-app-worktrees/.deliberate/config.yaml
```

Projects never interfere with each other. They have separate state, separate agents, and separate workspaces.

### Adapting to Your Stack

Deliberate Agents ships with [Ruby on Rails](https://rubyonrails.org/) conventions (Tailwind CSS, Stimulus JS, Minitest), but you can adapt it to any stack:

1. **Agent definitions** in `.claude/agents/*.md` — tell agents about your framework's patterns
2. **Skills** in `.claude/skills/*/SKILL.md` — adjust workflow steps for your tooling
3. **Config** — set your test commands and branch names
4. **Permission mode** — agents default to `auto` (safe, scoped permissions). Set `permission_mode: "unrestricted"` in your config for zero-friction unattended execution. See [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md) for details.

See [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md) for details.

---

## What's in This Repo

```
Deliberate_Agents/
│
├── agents/             Who's on the team — one file per agent defining
│                       their role, model, and capabilities
│
├── skills/             What each agent knows how to do — step-by-step
│                       workflow instructions loaded on demand
│
├── workflows/          How agents coordinate — end-to-end sequences
│                       with triggers, handoffs, and decision gates
│
├── orchestration/      The coordination scripts that launch agents,
│                       monitor progress, and keep things moving
│
├── scripts/            Setup tools — initialize projects, check
│                       dependencies, clean up when done
│
├── commands/           Slash commands for Claude Code — the /orchestrate
│                       command center lives here
│
├── templates/          Starter files that get copied into your project
│                       during initialization
│
├── state/              Documentation for how agents communicate with
│                       each other through files
│
├── integrations/       External system connectors (Slack bot for
│                       question routing and agent unblocking)
│
├── mcp-servers/        Optional add-ons for cross-LLM capabilities
│                       (e.g., getting OpenAI to review Claude's code)
│
└── docs/               Detailed documentation
    ├── ARCHITECTURE.md     How the system is designed
    ├── CUSTOMIZATION.md    Making it work with your stack
    ├── DAILY-USE.md        Everyday workflows and tips
    └── GETTING-STARTED.md  Extended setup walkthrough
```

Each directory has its own README explaining what's inside and how to use it.

---

## Key Concepts

A few terms that come up often:

| Term | What It Means |
|------|--------------|
| **Initiative** | A feature or project you want built. It starts as your one-pager and moves through the pipeline until it's done. |
| **PRD** | Product Requirements Document. The detailed plan that the Product Manager writes from your one-pager. |
| **Worktree** | A separate copy of your project's code where an agent can work without affecting your main branches. Worktrees live in a dedicated folder next to your repo (e.g., `my-app-worktrees/`) — one worktree per initiative. Think of them like sandboxes linked to your repo. |
| **Integrator** | The strategic executor — an AI agent that evaluates new ideas against everything in flight, prioritizes the pipeline, and tracks initiatives through their full lifecycle (built → shipped → marketed → supported). Owns `.deliberate/priority-stack.yaml`. |
| **Orchestrator** | The bash script that coordinates everything. It reads the Integrator's priority stack, watches for completed work, and launches the next agent in line. It doesn't use AI — it's just a simple script, so it costs nothing to run. |
| **Command Center** | The `/orchestrate` slash command running as a persistent session. It dispatches work to agents, records every dispatch in a journal, and stays alive for follow-up commands. |
| **Dispatch Journal** | A daily markdown log at `.deliberate/logs/dispatch-journal-YYYYMMDD.md` that records every task dispatched, its status, and outcome. |
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
| Full Roster | 30 agents with 99 skills across 7 teams | Yes |
| Execution | First end-to-end autonomous initiative | Next |

---

## Inspiration

Built on patterns from [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD) — agent personas, step-based workflows, progressive context loading — extended into fully autonomous multi-agent coordination.

## TODO — Content Automation Setup

- [ ] Populate `content/corpus/` with 15-30 top-performing LinkedIn posts (one file per post, see `content/corpus/README.md` for format)
- [ ] Create Notion integration database with schema from `integrations/notion/schema.md`
- [ ] Set environment variable `NOTION_TOKEN` (create at https://www.notion.so/my-integrations)
- [ ] Set environment variable `NOTION_CONTENT_DB` (database ID from Notion URL)
- [ ] Share Notion database with your integration
- [ ] Set environment variables `UNIPILE_API_KEY` and `UNIPILE_ACCOUNT_ID` (or evaluate alternative LinkedIn providers)
- [ ] Test Notion integration: `./integrations/notion/start.sh --test`
- [ ] Test LinkedIn provider: `./integrations/linkedin/start.sh --test --dry-run`
- [ ] Manual test: invoke `/linkedin-copywriter` skill in a Claude Code session to verify corpus loading and slop scrub
- [ ] Run `orchestration/check-schedules.sh` with a schedule set to "now" to verify assignment file creation
- [ ] End-to-end dry run: set schedule to fire immediately → verify researcher creates Notion Idea → mark Approved → copywriter drafts → mark Approved → publisher posts (dry-run mode)
- [ ] Verify backward compatibility: run existing engineering workflow (create initiative, process through PM/dev) with no regressions
- [ ] Review and customize `content/slop-blacklist.yaml` for your voice and industry
- [ ] Update `config.henry.yaml` with your `notion_content_db` value once database is created

## License

MIT
