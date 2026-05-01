# Agents — The Team

This directory contains the team roster. Each `.md` file defines one agent — who they are, what they're responsible for, and what tools and skills they have access to.

## What Is an Agent?

An agent is an AI session with a specific identity and job. When the orchestrator needs code written, it doesn't just open a generic AI chat — it launches a **Developer agent** that knows it's a developer, follows developer workflows, and stays focused on writing code. The same goes for every other role.

Each agent file tells Claude Code: "You are [role]. Here's what you do, here's how you do it, and here's what you're not allowed to touch."

## The Roster

### Core Pipeline

These four agents handle the main flow from idea to delivered code:

| File | Agent | What They Do |
|------|-------|-------------|
| `product-manager.md` | Product Manager | Turns your one-pager into a detailed product plan (PRD) |
| `project-manager.md` | Project Manager | Breaks the PRD into tasks and assigns them to the right agents |
| `developer.md` | Developer | Writes code, one task at a time, in an isolated workspace |
| `reviewer.md` | Reviewer | Validates that completed work meets the original requirements |

### Specialists

These agents handle specific domains. The Project Manager routes tasks to them based on what the PRD requires:

| File | Agent | What They Do |
|------|-------|-------------|
| `integrations-engineer.md` | Integrations Engineer | Configures third-party tools (CRM, analytics, payments) |
| `content-writer.md` | Content Writer | Writes copy, emails, landing pages, in-app messaging |
| `technical-writer.md` | Technical Writer | Creates runbooks, API docs, internal documentation |
| `compliance-analyst.md` | Compliance Analyst | Audits for privacy, legal, and regulatory needs |
| `devops-engineer.md` | DevOps Engineer | CI/CD, infrastructure, monitoring, deployment |
| `security-analyst.md` | Security Analyst | Threat modeling, vulnerability review, security assessment |
| `sales-development-rep.md` | Sales Dev Rep | Prospect research, outreach prep, pipeline maintenance |
| `account-executive-assistant.md` | AE Assistant | Deal support, proposals, competitive analysis |
| `customer-success.md` | Customer Success | Account health monitoring, churn/expansion signals |
| `onboarding-specialist.md` | Onboarding Specialist | Designs onboarding flows for different customer types |
| `seo-specialist.md` | SEO Specialist | Search optimization across SEO, AEO, AIO, and GEO |

## How Agent Files Work

Each file has two parts:

1. **YAML frontmatter** (the section between `---` marks at the top) — technical settings like which AI model to use, how many steps the agent can take, and which skills it has access to.

2. **Markdown body** — the agent's identity, responsibilities, workflow, and constraints written in plain language that Claude Code reads and follows.

Example structure:

```markdown
---
name: developer
model: sonnet
maxTurns: 100
skills: [dev-understand, dev-implement, dev-test, dev-complete]
---

# Developer Agent

## Identity
You are a Developer agent...

## Workflow
1. Understand the task
2. Write the code
3. Write tests
4. Mark complete

## Constraints
- Never modify files outside your worktree
- Never push to remote
```

## Customizing Agents

When you run `init.sh` to connect Deliberate Agents to your project, copies of these agent files are deployed into your project's `.claude/agents/` directory. You can edit those copies to tailor agents to your specific stack, conventions, or preferences without changing the originals here.

See [../docs/CUSTOMIZATION.md](../docs/CUSTOMIZATION.md) for details.
