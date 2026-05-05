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

### Product Team

#### Product Manager (9 skills)

| Skill | What It Does |
|-------|-------------|
| `pm-intake` | Receive scoped ideas and create formal one-pagers in the backlog |
| `pm-assess` | Evaluate the one-pager for completeness when selected for grooming |
| `pm-research` | Deep-dive into codebase and domain context |
| `pm-expand-prd` | Write the full PRD (22 sections covering everything the team needs) |
| `pm-architecture` | Trigger and coordinate the Architect for technical features |
| `pm-cross-functional` | Identify impact across all business functions |
| `pm-ready-for-dev` | Final review and handoff to the Scrum Master |
| `competitive-teardown` | 12-dimension competitive analysis with scoring rubric |
| `design-before-code` | Explore intent, requirements, and design before implementation |

#### Product Designer (3 skills)

| Skill | What It Does |
|-------|-------------|
| `tailwind-design-system` | Build/extend the Tailwind CSS v4 design system — tokens, components, ERB partials, Stimulus controllers |
| `frontend-design-rails` | Create distinctive, production-grade UIs in ERB + Tailwind + Stimulus |
| `design-before-code` | Explore intent, requirements, and design before implementation |

### Engineering Team

#### Project Manager (3 skills)

| Skill | What It Does |
|-------|-------------|
| `pjm-decompose` | Break the PRD into individual tasks, grouped by agent type |
| `pjm-assign` | Create task assignments and deploy them to worktrees |
| `pjm-coordinate` | Monitor progress and handle coordination |

#### Developer (7 skills)

| Skill | What It Does |
|-------|-------------|
| `dev-understand` | Read the task, understand what needs to be built |
| `dev-implement` | Write the code following project conventions |
| `dev-test` | Write tests (TDD discipline: red-green-refactor) and make sure everything passes |
| `dev-complete` | Verification gate, clean commits, update status, mark task complete |
| `tailwind-design-system` | Tailwind CSS v4 design system patterns for UI implementation |
| `systematic-debugging` | Root cause investigation — no fixes without evidence, 3-fix limit |
| `code-simplify` | Simplify recently modified code for clarity without changing behavior |

#### Database Specialist (3 skills)

| Skill | What It Does |
|-------|-------------|
| `db-assess` | Assess schema design needs and data model requirements |
| `db-migrate` | Write safe, zero-downtime database migrations |
| `db-seed` | Create seed data and fixtures |

#### Integrations Engineer (4 skills)

| Skill | What It Does |
|-------|-------------|
| `integrations-assess` | Evaluate what integrations are needed |
| `integrations-configure` | Set up and configure the integrations |
| `integrations-verify` | Test that integrations work correctly |
| `stripe-lifecycle` | Stripe subscription lifecycle — Pay gem, webhooks, metered billing, tier management |

#### DevOps Engineer (4 skills)

| Skill | What It Does |
|-------|-------------|
| `devops-assess` | Assess infrastructure needs |
| `devops-implement` | Implement infrastructure changes |
| `observability-design` | SLI/SLO definitions, golden signals, dashboards, alerts, structured logging |
| `incident-command` | Production incident management — severity classification, communication, rollback |

### QA Team

#### QA Lead (4 skills)

| Skill | What It Does |
|-------|-------------|
| `qa-plan` | Plan test strategy for the initiative |
| `qa-assign` | Create and assign test cases to testers |
| `qa-coordinate` | Coordinate QA across multiple test streams |
| `qa-report` | Compile QA findings into a structured report |

#### Integration Tester (3 skills)

| Skill | What It Does |
|-------|-------------|
| `test-plan-review` | Review assigned test cases and identify dependencies |
| `test-integration` | Execute integration and cross-system tests |
| `test-report` | Document test results and failures |

#### Security Analyst (4 skills)

| Skill | What It Does |
|-------|-------------|
| `security-assess` | Assess security risks and threats |
| `security-review` | Review code and configuration for vulnerabilities |
| `dep-audit` | Vulnerability scanning, license compliance, supply chain risk |
| `incident-respond` | Security incident taxonomy, severity framework, forensic evidence collection |

#### UX/UI Reviewer (3 skills)

| Skill | What It Does |
|-------|-------------|
| `ux-review-design` | Compare implementation against design brief |
| `ux-review-accessibility` | Audit WCAG 2.1 AA compliance |
| `ux-review-report` | Compile findings with severity-graded issues |

### Support Team

#### Reviewer (3 skills)

| Skill | What It Does |
|-------|-------------|
| `review-validate` | Check completed work against PRD acceptance criteria |
| `review-summarize` | Write a clear summary for human review |
| `api-design-review` | Audit API endpoints for REST conventions, consistency, security, and DX |

#### Data Analyst (5 skills)

| Skill | What It Does |
|-------|-------------|
| `data-query` | Write and execute analytical queries |
| `data-report` | Produce formatted reports from data |
| `data-investigate` | Investigate data anomalies and patterns |
| `saas-metrics` | Calculate ARR/MRR/churn/CAC/LTV/NRR with benchmarks |
| `product-analytics` | AARRR/North Star/HEART frameworks, cohort analysis, retention curves |

#### Compliance Analyst (4 skills)

| Skill | What It Does |
|-------|-------------|
| `compliance-assess` | Audit for regulatory and legal requirements |
| `compliance-document` | Document compliance findings and needs |
| `soc2-compliance` | Trust Service Criteria mapping, control matrix, gap analysis, readiness scoring |
| `gdpr-compliance` | PII scanning, legal bases mapping, DPIA triggers, data subject rights |

#### Help Desk (3 skills)

| Skill | What It Does |
|-------|-------------|
| `support-triage` | Categorize and prioritize support tickets |
| `support-respond` | Draft support responses |
| `support-escalate` | Escalate product issues to engineering |

### Release Team

#### Release Manager (3 skills)

| Skill | What It Does |
|-------|-------------|
| `release-plan` | Identify what's ready to ship, assess risk, create release plan |
| `release-coordinate` | Manage the team through the checklist, hotfix protocol, go/no-go |
| `release-retro` | Post-release retrospective with release metrics tracking |

#### Release Engineer (3 skills)

| Skill | What It Does |
|-------|-------------|
| `release-preflight` | Pre-deploy verification — tests, migrations, staging validation |
| `release-deploy` | Execute deployment with logging and monitoring |
| `release-verify` | Post-deploy verification, rollback triggers, severity classification |

#### Release Comms (3 skills)

| Skill | What It Does |
|-------|-------------|
| `release-changelog` | Generate changelog from git history with conventional commit parsing |
| `release-notes` | Transform changelog into user-facing release notes |
| `release-announce` | Draft internal and external announcements |

#### Release Marketer (4 skills)

| Skill | What It Does |
|-------|-------------|
| `release-campaign` | Plan launch marketing approach for significant releases |
| `release-content` | Create marketing content — blog, email, social, in-app |
| `release-measure` | Define success metrics and measurement plan |
| `launch-strategy` | Launch tier classification, ORB channels, phased rollout, Product Hunt |

### GTM Team

#### Growth Strategist (7 skills)

| Skill | What It Does |
|-------|-------------|
| `growth-assess` | Assess growth opportunities and constraints |
| `growth-strategy` | Develop growth strategy and positioning |
| `growth-plan` | Create actionable growth plan with experiments |
| `pricing-strategy` | SaaS pricing design — value metrics, tiers, price points, pricing page |
| `experiment-design` | Hypothesis format, sample sizing, ICE scoring, stopping rules |
| `referral-program` | Referral loop design, incentives, K-factor measurement |
| `competitive-teardown` | 12-dimension competitive scoring, feature matrix, positioning map |

#### Content Writer (4 skills)

| Skill | What It Does |
|-------|-------------|
| `content-brief` | Create a content brief from the PRD |
| `content-draft` | Write the content |
| `content-review` | Review and polish the content |
| `email-sequence` | Sequence architecture, complete email drafts, metrics benchmarks |

#### Technical Writer (2 skills)

| Skill | What It Does |
|-------|-------------|
| `docs-assess` | Assess what documentation is needed |
| `docs-write` | Write the documentation |

#### Sales Development Rep (3 skills)

| Skill | What It Does |
|-------|-------------|
| `sales-research` | Research prospects and companies |
| `sales-outreach-prep` | Prepare outreach materials |
| `sales-pipeline` | Maintain and update the sales pipeline |

#### Account Executive Assistant (2 skills)

| Skill | What It Does |
|-------|-------------|
| `sales-research` | Research prospects and companies |
| `sales-pipeline` | Maintain and update the sales pipeline |

#### Customer Success (3 skills)

| Skill | What It Does |
|-------|-------------|
| `cs-health-check` | Monitor account health and identify risks |
| `cs-intervention` | Plan and execute retention interventions |
| `churn-prevent` | Cancel flow design, exit surveys, save offers, dunning sequences |

#### Onboarding Specialist (3 skills)

| Skill | What It Does |
|-------|-------------|
| `onboarding-assess` | Assess onboarding needs by customer type |
| `onboarding-design` | Design onboarding flows and activation sequences |
| `onboarding-optimize` | Activation events, post-signup flows, stalled user recovery |

#### SEO Specialist (3 skills)

| Skill | What It Does |
|-------|-------------|
| `seo-audit` | Audit current search performance |
| `seo-strategy` | Develop search optimization strategy |
| `seo-implement` | Implement SEO improvements |

### Standalone Reference Skills

These skills are available for any agent to load when the domain is relevant:

| Skill | What It Does |
|-------|-------------|
| `founder-coach` | Founder archetype identification, delegation ladder, energy audit, blind spots |
| `systematic-debugging` | Root cause investigation discipline with 3-fix limit |
| `code-simplify` | Code clarity refinement — simplify without changing behavior |
| `design-before-code` | Brainstorming gate — explore requirements and design before implementation |
| `frontend-design-rails` | Distinctive UI design in Rails (ERB + Tailwind + Stimulus) |

## Customizing Skills

Like agent definitions, skills are copied into your project during `init.sh`. Edit the copies in your project's `.claude/skills/` directory to match your specific workflows, tools, and conventions.

Each `SKILL.md` file is plain markdown with a YAML header — no special syntax. Just clear instructions that Claude Code follows step by step.
