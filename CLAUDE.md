# CLAUDE.md

## Identity
- Repo: **Deliberate Agents** (`github.com/Orcheros/Deliberate_Agents`)
- Multi-agent orchestration framework — manages autonomous agent teams against any target project
- Framework home: `$DELIBERATE_AGENTS_HOME` (default `~/Development/Deliberate_Agents`)

## Project Discovery

Target projects are discovered via `config.*.yaml` files in the framework root. These can be:
- Regular files created by `scripts/init.sh`
- Symlinks to `.deliberate.yaml` files in target repos (preferred — keeps config with the project)

The `.deliberate.yaml` convention: target repos carry their own config at the repo root. `init.sh --repo-config` creates this file and symlinks it into the framework as `config.{slug}.yaml`.

## Branching Discipline

Each target project defines its own branching rules. General principles enforced by all agents:

- **Protected branches** (typically `main`, `staging`, `dev`): Never commit code directly. Use feature branches or `hotfix/*` branches.
- **Documentation/spec changes** (backlog one-pagers, STATUS.yaml, ROADMAP.md): Allowed directly on the dev branch — low-risk, no runtime impact.
- **Feature work:** Always on worktrees when configured (`{worktrees_root}/{slug}/`).

If the current branch is protected and the task involves changing code files, **stop and create a branch first.** No exceptions. This applies to both this repo and any target repo. Agents spawned by this system must follow it.

## Window & Pane Layout

The Integrator and Orchestrator are separate AI agents launched by `/deliberate` into a tmux "coordination" window — Integrator (top pane) + Orchestrator (bottom pane), both visible and interactive simultaneously. The user's Claude Code session is the Visionary session — it dispatches work and checks status but is not the Integrator. Initiative work spawns separate windows with agent panes inside. They communicate via `.deliberate/comms/_system/`. The `session-start.sh` hook establishes the Visionary session identity and checks for escalations.

## Key Scripts

| Script | Purpose |
|---|---|
| `scripts/init.sh` | Initialize DA for a new target project |
| `scripts/session-start.sh` | SessionStart hook — establishes Integrator, discovers projects, checks escalations, starts services |
| `orchestration/orchestrate.sh` | Unattended orchestrator loop (bash, zero AI cost) |
| `orchestration/launch-agent.sh` | Spawn an agent in a tmux pane (used by Orchestrator) |
| `orchestration/comms.sh` | Cross-agent communication library (per-initiative + system-level messaging) |
| `orchestration/dashboard.sh` | Generate structured status dashboard to `.deliberate/status/dashboard.md` |
| `orchestration/stop-agents.sh` | Graceful shutdown of all agents |
| `orchestration/briefing.sh` | Generate project status briefing |
| `agents/integrator.md` | Integrator agent — primary session, strategic executor |
| `agents/orchestrator.md` | Orchestrator agent — interactive coordinator in tmux |

## Vocabulary

`LANGUAGE.md` defines canonical terms used across all agents, skills, and documentation. When terms are ambiguous (e.g., "initiative" vs. "project" vs. "task"), use the canonical term from LANGUAGE.md. Each entry includes an "Avoid" list of synonyms that cause confusion.

## Invoking from Any Repo

Users can invoke `/orchestrate` from any Claude Code session. This user-level slash command resolves `$DELIBERATE_AGENTS_HOME`, finds or scaffolds a project config, and offers orchestration actions.
