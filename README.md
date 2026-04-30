# Deliberate_Agents

A repo-agnostic multi-agent framework for autonomous software development. Point it at any project and get cooperating AI agents that plan, coordinate, and execute development work — from idea to code.

## What It Does

```
One-Pager  →  PRD  →  Tasks  →  Code + Tests  →  Review
   (you)       (PM)    (PjM)     (Dev agents)      (you)
```

You write a one-pager describing what you want built. Deliberate_Agents takes it from there:

1. **Product Manager agent** expands the idea into a structured PRD
2. **Project Manager agent** breaks the PRD into atomic developer tasks
3. **Developer agent(s)** implement each task in isolated worktrees
4. **You** review the completed work in Cursor

The orchestrator (a bash script) coordinates everything through filesystem-based state management. No database, no server — just files.

## Design Principles

- **Autonomous**: Agents run unattended until they need a human decision
- **Coordinated**: Filesystem-based state protocol enables multi-agent cooperation
- **Observable**: Every action is logged, every state is queryable
- **Repo-agnostic**: Configure once for any project
- **Cost-aware**: Orchestrator is bash (zero API cost). Only agent sessions use the API.

## Architecture

- **Orchestrator**: Bash script polling state files on an interval. Launches and monitors agents via tmux.
- **Agents**: Claude Code sessions running in headless mode, each with a role-specific profile and workflow.
- **State**: YAML and markdown files in `.deliberate/` within your project.
- **Human touchpoint**: `decisions/` directory for items that need your input.

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

Built with Ruby on Rails projects in mind (Tailwind CSS, Stimulus JS, Minitest), but adaptable to any stack by customizing agent profiles and workflow steps. UI/UX designs come from Claude Design. See [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md).

## Requirements

- macOS (tested on Darwin)
- tmux 3.0+
- Claude Code CLI
- git

## Project Structure

```
agents/           Agent profiles (system prompts + config)
workflows/        Step-file workflows (BMAD-inspired)
orchestration/    Coordination scripts (bash)
templates/        Per-project bootstrapping templates
state/            State protocol documentation
scripts/          Setup and utility scripts
docs/             Documentation
```

## Status

**Phase 1 (Foundation)** — Complete. Repo structure, agent profiles, orchestration scripts, workflow steps, templates, and documentation.

**Phase 2 (Developer Agent)** — Next. Prove the autonomous execution model with a single developer agent.

## Inspiration

Extends patterns from [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD) (agent personas, step-file workflows, progressive context) into fully autonomous, multi-process coordination where agents run unattended and communicate through shared state.

## License

MIT
