# Scripts — Setup and Utilities

This directory contains the tools for setting up Deliberate Agents with your projects and managing the installation.

## The Scripts

### `session-start.sh` — Session Start Hook

Runs automatically when you open Claude Code (via the SessionStart hook). It:

1. **Discovers projects** — finds all `config.*.yaml` files in the framework directory
2. **Prevents sleep** — starts `caffeinate` to keep the Mac awake during long sessions
3. **Starts Slack** — launches the Slack bot for each project with `slack_enabled: true`
4. **Establishes the Integrator** — sets the system message so Claude Code acts as your Integrator agent
5. **Checks escalations** — scans each project's `.deliberate/comms/_system/inbox/integrator/` for messages from the Orchestrator and surfaces critical/warning items
6. **Shows Orchestrator status** — reports whether the Orchestrator is running and provides the launch command if not
7. **Generates briefings** — calls `orchestration/briefing.sh` for each project

You don't call this directly — it's triggered by the Claude Code hook configuration.

### `init.sh` — Connect to a Project

This is the first script you run when you want to use Deliberate Agents with a project. It sets everything up:

```bash
./scripts/init.sh \
  --name "My App" \
  --repo ~/Development/my-app \
  --worktrees ~/Development/my-app-worktrees
```

**What it does:**

1. Creates a `.deliberate/` directory in your worktrees folder — this is where agents coordinate their work (task queue, assignments, progress tracking, logs)
2. Copies agent definitions into your project (`.claude/agents/`)
3. Copies skills into your project (`.claude/skills/`)
4. Generates a `config.yaml` with your project-specific settings

**Optional settings:**

| Flag | Default | What It Sets |
|------|---------|-------------|
| `--main-branch` | `main` | Your production branch |
| `--dev-branch` | `dev` | Your development branch |
| `--test-cmd` | `bin/rails test` | How to run unit tests |
| `--system-test-cmd` | `bin/rails test:system` | How to run end-to-end tests |

You can run this for as many projects as you want. Each project gets its own independent setup.

### `install-deps.sh` — Check Dependencies

Verifies that all required tools are installed on your machine:

```bash
# Just check (don't install anything)
./scripts/install-deps.sh --check-only

# Check and offer to install missing tools
./scripts/install-deps.sh
```

**Required:** tmux (3.0+), Claude Code CLI, git
**Optional:** Node.js (only for MCP servers), yq, jq

### `teardown.sh` — Clean Up

Removes the `.deliberate/` directory from a project. Use this if you want to start fresh or disconnect Deliberate Agents from a project:

```bash
./scripts/teardown.sh /path/to/your-project-worktrees
```

This only removes the coordination files — it doesn't touch your project's actual code.
