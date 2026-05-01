# Templates — Starter Files for Your Project

When you run `init.sh` to connect Deliberate Agents to a project, these templates are used to generate the initial files. You generally don't need to touch these directly — they're consumed by the setup script.

## The Templates

### `project-config.yaml.tmpl`

Generates the `config.yaml` for your project. Contains your project name, paths, branch names, test commands, and agent settings. The init script fills in your values automatically.

### `CLAUDE.md.template`

Generates the `CLAUDE.md` file that lives in each worktree. This file tells Claude Code about your project — tech stack, conventions, testing commands, and the rules agents must follow. Think of it as the "employee handbook" for agents working in that worktree.

### `PLAN.md.template`

The template for initiative planning documents. The Product Manager uses this structure when writing PRDs — it defines the sections that need to be filled in (problem statement, requirements, user experience, data model, task breakdown, etc.).

### `STATUS.md.template`

A human-readable status board template. The orchestrator can update this to give you a quick overview of what's happening across all initiatives.

### `mcp.json.template`

Configuration for MCP (Model Context Protocol) servers. Currently includes a commented-out entry for the `codex-review` server, which enables cross-LLM code review (having OpenAI review code that Claude wrote). Uncomment it when you're ready to use it.

## Customizing Templates

If you want to change what gets generated for every new project, edit these templates **before** running `init.sh`. For example:

- Change `CLAUDE.md.template` to reflect your company's coding standards
- Adjust `PLAN.md.template` to match your PRD format
- Update `project-config.yaml.tmpl` with different default settings

If you've already initialized a project, you can edit the generated files directly in your project's worktrees directory — you don't need to re-run init.
