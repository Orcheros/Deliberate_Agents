# Documentation

Detailed reference documentation for Deliberate Agents. Start with the main [README](../README.md) if you're new — come here when you want to go deeper.

## What's Here

### [ARCHITECTURE.md](ARCHITECTURE.md)

How the system is built. Covers:

- The two-window architecture (Integrator + Orchestrator)
- Cross-agent communication system (per-initiative and system-level)
- The full agent roster (31 agents, 99 skills) with model assignments
- Workflow inventory — 8 end-to-end sequences with decision gates
- Dashboard, escalation protocol, and handoff tracking
- Model assignment strategy (Opus vs Sonnet rationale)

Read this if you want to understand **why** things work the way they do.

### [GETTING-STARTED.md](GETTING-STARTED.md)

An extended setup walkthrough with more detail than the main README. Covers:

- Prerequisites and installation
- Initializing your first project
- Opening Claude Code as the Integrator
- Launching the Orchestrator
- Queuing an initiative and monitoring progress
- Reviewing completed work

Read this if the main README's getting started section wasn't enough detail.

### [DAILY-USE.md](DAILY-USE.md)

Everyday workflows once your project is set up. Covers:

- Starting your day with the two-window architecture
- Dispatching work through the Integrator, Orchestrator, or command center
- Checking status via dashboard, direct queries, or status scripts
- Command quick reference for each interface

Read this for the day-to-day experience of using Deliberate Agents.

### [CUSTOMIZATION.md](CUSTOMIZATION.md)

How to adapt Deliberate Agents to your specific project. Covers:

- Editing agent definitions for your stack
- Customizing skills for your workflow
- Configuring project settings
- Enabling MCP servers for cross-LLM capabilities
- Adjusting autonomy levels

Read this when you're ready to tailor the system to your project's conventions and tools.

### [DELIBERATE-WORK.md](DELIBERATE-WORK.md)

The DeliberateWork methodology reference. Covers:

- The 5x5 method (5 Inputs + 5 Outputs per work step)
- AI decision-making framework and execution modes
- AAAERRR growth funnel tagging
- Gate validation and handoff contracts

Read this to understand the methodology that underpins how agents plan and execute work.
