# Skills — What Each Agent Knows How to Do

Skills are step-by-step instructions that agents follow to complete their work. Think of them like standard operating procedures — each skill walks an agent through a specific task in a specific order.

## Why Skills Exist

Without skills, you'd have to explain everything an agent should do every time it runs. Skills solve this by packaging workflows into reusable instruction sets.

Skills are also **lazy-loaded** — an agent only reads a skill when it actually needs it. This keeps agents focused and efficient. A Developer agent with four skills doesn't load all four at startup; it loads each one as it reaches that step in its workflow.

## How Skills Are Organized

Each skill lives in its own folder with a `SKILL.md` file inside:

```
skills/
├── dev-understand/
│   └── SKILL.md        ← "Read and understand the task requirements"
├── dev-implement/
│   └── SKILL.md        ← "Write the code"
├── dev-test/
│   └── SKILL.md        ← "Write and run tests"
└── dev-complete/
    └── SKILL.md        ← "Verify everything and mark the task done"
```

## Skills by Agent

### Product Manager (6 skills)

| Skill | What It Does |
|-------|-------------|
| `pm-assess` | Read the one-pager and assess what needs to be built |
| `pm-research` | Research the codebase and requirements |
| `pm-expand-prd` | Write the full PRD (22 sections covering everything the team needs) |
| `pm-architecture` | Document the technical architecture |
| `pm-cross-functional` | Identify impact on other teams (marketing, docs, legal, etc.) |
| `pm-ready-for-dev` | Final review and handoff to the Project Manager |

### Project Manager (3 skills)

| Skill | What It Does |
|-------|-------------|
| `pjm-decompose` | Break the PRD into individual tasks, grouped by agent type |
| `pjm-assign` | Create task assignments and deploy them to worktrees |
| `pjm-coordinate` | Monitor progress and handle coordination |

### Developer (4 skills)

| Skill | What It Does |
|-------|-------------|
| `dev-understand` | Read the task, understand what needs to be built |
| `dev-implement` | Write the code following project conventions |
| `dev-test` | Write tests and make sure everything passes |
| `dev-complete` | Final checks, update status, mark task complete |

### Reviewer (2 skills)

| Skill | What It Does |
|-------|-------------|
| `review-validate` | Check completed work against PRD acceptance criteria |
| `review-summarize` | Write a clear summary for human review |

### Integrations Engineer (3 skills)

| Skill | What It Does |
|-------|-------------|
| `integrations-assess` | Evaluate what integrations are needed |
| `integrations-configure` | Set up and configure the integrations |
| `integrations-verify` | Test that integrations work correctly |

### Content Writer (3 skills)

| Skill | What It Does |
|-------|-------------|
| `content-brief` | Create a content brief from the PRD |
| `content-draft` | Write the content |
| `content-review` | Review and polish the content |

### Technical Writer (2 skills)

| Skill | What It Does |
|-------|-------------|
| `docs-assess` | Assess what documentation is needed |
| `docs-write` | Write the documentation |

### DevOps Engineer (2 skills)

| Skill | What It Does |
|-------|-------------|
| `devops-assess` | Assess infrastructure needs |
| `devops-implement` | Implement infrastructure changes |

### Security Analyst (2 skills)

| Skill | What It Does |
|-------|-------------|
| `security-assess` | Assess security risks and threats |
| `security-review` | Review code and configuration for vulnerabilities |

### Compliance Analyst (2 skills)

| Skill | What It Does |
|-------|-------------|
| `compliance-assess` | Audit for regulatory and legal requirements |
| `compliance-document` | Document compliance findings and needs |

### Sales Development Rep (3 skills)

| Skill | What It Does |
|-------|-------------|
| `sales-research` | Research prospects and companies |
| `sales-outreach-prep` | Prepare outreach materials |
| `sales-pipeline` | Maintain and update the sales pipeline |

### Customer Success (2 skills)

| Skill | What It Does |
|-------|-------------|
| `cs-health-check` | Monitor account health and identify risks |
| `cs-intervention` | Plan and execute retention interventions |

### Onboarding Specialist (2 skills)

| Skill | What It Does |
|-------|-------------|
| `onboarding-assess` | Assess onboarding needs by customer type |
| `onboarding-design` | Design onboarding flows and activation sequences |

### SEO Specialist (3 skills)

| Skill | What It Does |
|-------|-------------|
| `seo-audit` | Audit current search performance |
| `seo-strategy` | Develop search optimization strategy |
| `seo-implement` | Implement SEO improvements |

## Customizing Skills

Like agent definitions, skills are copied into your project during `init.sh`. Edit the copies in your project's `.claude/skills/` directory to match your specific workflows, tools, and conventions.

Each `SKILL.md` file is plain markdown with a YAML header — no special syntax. Just clear instructions that Claude Code follows step by step.
