# Deliberate Agents — Skills Cheat Sheet

166 skills across 43 agents. Invoke any skill with `/skill-name` in a Claude Code session.

---

## Discovery & Research

| Command | Description | Agent |
|---|---|---|
| `/brainstorm-ideas` | Multi-perspective ideation (PM, Designer, Engineer lenses) | Product Manager |
| `/identify-assumptions` | Map & prioritize riskiest assumptions (Impact x Evidence matrix) | Product Manager |
| `/design-experiments` | Pretotype experiments — Fake Door, Concierge, Wizard of Oz, etc. | Product Manager |
| `/opportunity-solution-tree` | Teresa Torres OST — outcome → opportunities → solutions → experiments | Product Manager |
| `/project-learn` | Extract business context from codebase — discovers/scaffolds `.documentation/`, produces product brief | Project Discoverer |
| `/customer-interview-guide` | Interview scripts with JTBD probing questions & logistics | Market Researcher |
| `/interview-synthesis` | Transcripts → structured insights, JTBD patterns, opportunity statements | Market Researcher |
| `/prioritize-features` | Score & rank feature requests by theme, impact, effort, risk, alignment | Product Manager |
| `/setup-metrics` | North Star + input metrics + guardrails + alert thresholds | Product Manager |

## Strategy

| Command | Description | Agent |
|---|---|---|
| `/product-vision` | Inspiring product vision statement (Moore framework + press release) | Product Strategist |
| `/product-strategy-canvas` | 9-section canvas: vision → defensibility | Product Strategist |
| `/lean-canvas` | Ash Maurya Lean Canvas — 9 blocks for early-stage validation | Product Strategist |
| `/business-model-canvas` | Strategyzer BMC — 9 blocks for value creation & capture | Product Strategist |
| `/market-scan` | SWOT + PESTLE + Porter's Five Forces + Ansoff Matrix combined | Product Strategist |
| `/monetization-strategy` | 3-5 monetization models with validation experiments | Product Strategist |
| `/pricing-strategy-analysis` | Research-focused: Van Westendorp, Gabor-Granger, price elasticity | Product Strategist |
| `/brainstorm-okrs` | Team OKRs aligned to company objectives (Radical Focus) | Product Strategist |
| `/outcome-roadmap` | Feature list → outcome-focused Now/Next/Later roadmap | Product Strategist |
| `/stakeholder-map` | Power x Interest grid with communication plan per quadrant | Product Strategist |

## Market Research

| Command | Description | Agent |
|---|---|---|
| `/user-personas` | 3+ personas with JTBD, pains, gains, anti-personas | Market Researcher |
| `/user-segmentation` | Behavioral, needs-based, value-based segmentation with targeting | Market Researcher |
| `/customer-journey-map` | Awareness → Advocacy journey with touchpoints, emotions, pain points | Market Researcher |
| `/analyze-feedback` | Sentiment + theme extraction at scale from NPS, reviews, tickets | Market Researcher |
| `/competitive-teardown` | 12-dimension scorecard, feature matrix, SWOT, positioning maps | Market Researcher / Growth Strategist |

## Data Analytics

| Command | Description | Agent |
|---|---|---|
| `/ab-test-analysis` | Statistical significance, confidence intervals, ship/extend/stop | Data Analyst |
| `/cohort-analysis` | Retention curves, feature adoption, engagement trends by cohort | Data Analyst |
| `/sql-query-generation` | Natural language → SQL (BigQuery, PostgreSQL, MySQL) | Data Analyst |
| `/dummy-dataset` | Realistic test data — CSV, JSON, SQL, Python with distributions | Data Analyst |
| `/data-query` | Explore data sources and write queries | Data Analyst |
| `/data-report` | Structured reports with findings and visualizations | Data Analyst |
| `/data-investigate` | Deep-dive into metric anomalies or trends | Data Analyst |
| `/saas-metrics` | ARR, MRR, churn, CAC, LTV, NRR benchmarking | Data Analyst |
| `/product-analytics` | KPI dashboards, cohort analysis, feature adoption | Data Analyst |

## GTM & Growth

| Command | Description | Agent |
|---|---|---|
| `/beachhead-segment` | First market segment for launch (Geoffrey Moore criteria) | Product Strategist |
| `/ideal-customer-profile` | ICP: firmographics, technographics, buying signals, scoring rubric | Market Researcher |
| `/competitive-battlecard` | Sales-ready battlecards with objection rebuttals & win strategies | Growth Strategist |
| `/growth-loops` | Viral, content, paid, sales, product loops with amplification metrics | Growth Strategist |
| `/gtm-messaging` | Messaging hierarchy + channel-adapted matrix + A/B variations | Growth Strategist |
| `/gtm-motions` | PLG / SLG / CLG / Channel evaluation with phased launch plan | Growth Strategist |
| `/north-star-metric` | North Star + 3-5 input metrics + business game classification | Product Strategist |
| `/marketing-ideas` | 5 creative, cost-effective ideas ranked by expected ROI | Growth Strategist |
| `/positioning-statement` | April Dunford's "Obviously Awesome" framework + positioning maps | Growth Strategist |
| `/product-naming` | Name brainstorm → evaluation → shortlist with rationale | Growth Strategist |
| `/value-proposition-statement` | 6-part JTBD value prop for marketing, sales, onboarding, investors | Growth Strategist |
| `/growth-assess` | Current market position, competition, growth opportunities | Growth Strategist |
| `/growth-strategy` | Positioning, messaging frameworks, strategic growth plans | Growth Strategist |
| `/growth-plan` | Campaign plans, experiment designs, execution briefs | Growth Strategist |
| `/pricing-strategy` | SaaS pricing design — tiers, value metrics, pricing page | Growth Strategist |
| `/experiment-design` | A/B test design — hypotheses, sample size, ICE scoring | Growth Strategist |
| `/referral-program` | Referral/affiliate program — loop mechanics, incentives, measurement | Growth Strategist |
| `/launch-strategy` | Product launch — phased rollout, channel strategy, launch day | Growth Strategist |

## Product Management

| Command | Description | Agent |
|---|---|---|
| `/pm-intake` | Scoped idea → formal one-pager in backlog | Product Manager |
| `/pm-assess` | Evaluate one-pager for completeness | Product Manager |
| `/pm-research` | Deep codebase & domain dive before PRD | Product Manager |
| `/pm-expand-prd` | Write complete 22-section PRD | Product Manager |
| `/pm-architecture` | Trigger architecture doc with code examples | Product Manager |
| `/pm-cross-functional` | Assess impact across all business functions | Product Manager |
| `/pm-ready-for-dev` | Finalize docs, signal ready for development | Product Manager |
| `/design-before-code` | Brainstorming gate — no coding without a plan | Product Manager |
| `/pre-mortem` | Risk analysis: Tigers / Paper Tigers / Elephants | Product Manager |
| `/prioritization-frameworks` | Reference guide: RICE, ICE, MoSCoW, Kano, WSJF, + 4 more | Product Manager |
| `/job-stories` | When [situation], I want [motivation], so I can [outcome] | Product Manager |
| `/wwas` | Why-What-Acceptance-Signals backlog format | Product Manager |

## Execution & Project Management

| Command | Description | Agent |
|---|---|---|
| `/retro` | Sprint retro: What Went Well / Didn't / Action Items | Product Manager |
| `/summarize-meeting` | Transcript → decisions + action items + follow-ups | Product Manager |
| `/pjm-decompose` | Break PRD into multi-agent work streams | Project Manager |
| `/pjm-assign` | Create task assignments with agent routing | Project Manager |
| `/pjm-coordinate` | Monitor cross-agent progress, handle phase transitions | Project Manager |

## Development

| Command | Description | Agent |
|---|---|---|
| `/dev-understand` | Understand assigned task before coding | Developer |
| `/dev-implement` | Write code following existing patterns | Developer |
| `/dev-test` | Verify implementation with tests | Developer |
| `/dev-complete` | Clean atomic commits, signal completion | Developer |
| `/code-simplify` | Simplify code for clarity and maintainability | Developer |
| `/systematic-debugging` | Root cause investigation — hypothesis testing, 3-fix limit | Developer |
| `/api-design-review` | Review API endpoints for REST conventions, security, DX | Developer |
| `/db-assess` | Review schema design, migration safety, performance | Developer |
| `/db-migrate` | Safe, reversible, zero-downtime migrations | Developer |
| `/db-seed` | Seed data, test fixtures, dev data strategies | Developer |
| `/dep-audit` | Dependencies: vulnerabilities, licenses, outdated packages | Developer |

## Architecture & Design

| Command | Description | Agent |
|---|---|---|
| `/atomic-decompose` | Decompose feature into atomic hierarchy (atoms → pages) | Architect |
| `/atomic-build` | Build components bottom-up following atomic design | Architect |
| `/atomic-audit` | Review code for atomic design violations | Architect |
| `/atomic-inventory` | Classify existing UI into component map | Architect |
| `/frontend-design-rails` | Production-grade Rails UI — ERB, Tailwind v4, Stimulus | Architect |
| `/tailwind-design-system` | Build/extend Tailwind CSS v4 design system | Architect |
| `/observability-design` | SLI/SLO frameworks, golden signals, alerting, dashboards | Architect |

## Quality Assurance

| Command | Description | Agent |
|---|---|---|
| `/qa-plan` | Create comprehensive test plan from all specs | QA Lead |
| `/qa-assign` | Assign test cases to QA teammates | QA Lead |
| `/qa-coordinate` | Monitor QA progress, manage re-tests | QA Lead |
| `/qa-report` | Aggregate QA results, go/no-go recommendation | QA Lead |
| `/qa-branch` | 8-phase QA protocol on a branch | QA Lead |
| `/test-plan-review` | Read test cases, understand scope, identify dependencies | Integration Tester |
| `/test-integration` | Execute integration tests, validate data flows | Integration Tester |
| `/test-report` | Document test results with evidence | Integration Tester |
| `/review-validate` | Verify dev work meets PRD acceptance criteria | Reviewer |
| `/review-summarize` | Write review summary for human review | Reviewer |

## UX Review

| Command | Description | Agent |
|---|---|---|
| `/ux-review-accessibility` | WCAG 2.1 AA audit — keyboard, ARIA, focus, contrast | UX/UI Reviewer |
| `/ux-review-design` | Compare implementation vs design brief, check states | UX/UI Reviewer |
| `/ux-review-report` | Document UX findings, categorize severity | UX/UI Reviewer |
| `/onboarding-assess` | Evaluate onboarding effectiveness by ICP segment | Onboarding Specialist |
| `/onboarding-design` | Design onboarding flows and activation sequences | Onboarding Specialist |
| `/onboarding-optimize` | Optimize post-signup for faster time-to-value | Onboarding Specialist |

## DevOps & Security

| Command | Description | Agent |
|---|---|---|
| `/devops-assess` | Evaluate infrastructure and deployment needs | DevOps Engineer |
| `/devops-implement` | Implement CI/CD, monitoring, deployment config | DevOps Engineer |
| `/security-assess` | Threat model — attack surfaces and security risks | Security Analyst |
| `/security-review` | Code/config vulnerability review with findings report | Security Analyst |
| `/incident-command` | Production incident management and post-incident review | Security Analyst |
| `/incident-respond` | Security incident triage, forensics, escalation | Security Analyst |
| `/soc2-compliance` | SOC 2 prep — Trust Service Criteria, control matrix, gap analysis | Compliance Analyst |
| `/gdpr-compliance` | GDPR assessment — DPIA, data flow mapping, legal basis | Compliance Analyst |

## Release

| Command | Description | Agent |
|---|---|---|
| `/release-plan` | Identify what's ready to ship, assess risk | Project Manager |
| `/release-preflight` | Pre-deploy verification — tests, migration dry-run, staging | DevOps Engineer |
| `/release-deploy` | Execute deployment with logging and monitoring | DevOps Engineer |
| `/release-verify` | Post-deploy verification, monitoring, rollback if needed | DevOps Engineer |
| `/release-coordinate` | Manage release team, go/no-go recommendation | Project Manager |
| `/release-changelog` | Generate changelog from git history | Technical Writer |
| `/release-notes` | User-facing release notes | Technical Writer |
| `/release-announce` | Internal and external announcements | Content Writer |
| `/release-campaign` | Launch marketing approach for significant releases | Growth Strategist |
| `/release-content` | Blog posts, email sequences, social for launch | Content Writer |
| `/release-measure` | Success metrics and measurement plan for launch | Data Analyst |
| `/release-retro` | Post-release retrospective | Project Manager |

## Content & Social

| Command | Description | Agent |
|---|---|---|
| `/content-researcher` | Trend scanning, performance analysis, idea mining | Content Researcher |
| `/content-brief` | Understand communication need, audience, brand context | Content Writer |
| `/content-draft` | Write copy for all assigned communications | Content Writer |
| `/content-review` | Self-review against brand constraints and quality | Content Writer |
| `/content-repurpose` | Transform master content into channel-specific variants | Content Writer |
| `/content-publish` | Multi-platform publishing with rate limiting | Content Publisher |
| `/content-report` | Weekly performance report with metrics and trends | Content Reporter |
| `/slop-scrub` | Scan/clean content against platform slop blacklists | Content Writer |
| `/linkedin-copywriter` | LinkedIn posts — voice corpus, hooks, structural patterns | LinkedIn Copywriter |
| `/twitter-copywriter` | X/Twitter posts and threads — platform-native patterns | Twitter Copywriter |
| `/threads-copywriter` | Threads posts — casual, conversational, platform-native | Threads Copywriter |
| `/facebook-copywriter` | Facebook posts — Pages/Groups optimized, link-preview aware | Facebook Copywriter |
| `/reddit-writer` | Reddit posts/comments that add community value | Reddit Writer |
| `/hackernews-writer` | HN submissions — zero marketing, max technical depth | HN Writer |
| `/producthunt-writer` | ProductHunt launch copy, maker comments, engagement | PH Writer |
| `/video-scriptwriter` | Video scripts with timing, hooks, visual cues | Video Producer |
| `/video-produce` | Orchestrate video production from script to render | Video Producer |
| `/video-publish` | Upload to YouTube, TikTok, Instagram with metadata | Video Producer |
| `/engagement-track` | Multi-platform metrics collection, warm-lead detection | Engagement Tracker |
| `/email-sequence` | Email sequences — welcome, nurture, re-engagement, drips | Content Writer |

## Sales & Customer Success

| Command | Description | Agent |
|---|---|---|
| `/sales-research` | Research prospects from CRM, leads, discovery sessions | SDR |
| `/sales-outreach-prep` | Personalized outreach sequences for qualified prospects | SDR |
| `/sales-pipeline` | Pipeline hygiene — stage accuracy, stale deals, data quality | Account Executive |
| `/cs-health-check` | Customer health signals, at-risk and expansion-ready accounts | Customer Success |
| `/cs-intervention` | Intervention strategies for at-risk, expansion plays for healthy | Customer Success |
| `/support-triage` | Categorize, prioritize, route incoming user feedback | Support |
| `/support-respond` | Draft support responses, help articles, FAQs | Support |
| `/support-escalate` | Route issues to product/engineering with full context | Support |
| `/churn-prevent` | Cancel flow design, save offers, exit surveys, dunning | Customer Success |
| `/stripe-lifecycle` | Stripe subscriptions — webhooks, metered billing, tier management | Integrations Engineer |

## Compliance & Documentation

| Command | Description | Agent |
|---|---|---|
| `/compliance-assess` | Privacy, legal, regulatory implications | Compliance Analyst |
| `/compliance-document` | Policy drafts, data flow docs, recommendations | Compliance Analyst |
| `/draft-nda` | NDA template with jurisdiction-appropriate clauses | Compliance Analyst |
| `/privacy-policy` | GDPR/CCPA/COPPA privacy policy template | Compliance Analyst |
| `/docs-assess` | Identify documentation requirements for initiative | Technical Writer |
| `/docs-write` | Runbooks, API docs, internal reference | Technical Writer |

## Integrations & Specialist

| Command | Description | Agent |
|---|---|---|
| `/integrations-assess` | Map integration landscape, create config plan | Integrations Engineer |
| `/integrations-configure` | Set up and wire integrations | Integrations Engineer |
| `/integrations-verify` | Verify integrations end-to-end, document results | Integrations Engineer |
| `/seo-audit` | Audit site for SEO, AEO, AIO, GEO dimensions | SEO Specialist |
| `/seo-strategy` | Prioritized search optimization strategy | SEO Specialist |
| `/seo-implement` | Schema markup, content briefs, technical specs | SEO Specialist |
| `/community-engage` | Monitor/engage across Reddit, HN, ProductHunt | Community Manager |
| `/founder-coach` | Founder development — delegation, energy, leadership | Founder Coach |

---

## Workflows (Multi-Agent Pipelines)

### Discovery → Strategy → Research

| Workflow | Trigger | Pipeline |
|---|---|---|
| **Project Onboarding** | New project adopted or strategic refresh | onboard.sh → Project Discoverer (`/project-learn`) → Strategist (vision, market, beachhead) → Researcher (personas, ICP, teardown) → [Human Gate] → Strategist (positioning, BMC) |
| **Product Discovery** | New opportunity identified | Strategist → Researcher → PM (ideation) → [Human Gate] → PM (prioritize) → Intake |
| **Initiative Discovery** | Founder provides scoped idea | PM `/pm-intake` → One-pager in backlog |
| **Customer Research** | Thin user evidence or new market entry | Researcher (interview prep) → [Human Gate: conduct interviews] → Researcher (synthesis → personas → segmentation → journey map) → PM (validate) |

### Product Development

| Workflow | Trigger | Pipeline |
|---|---|---|
| **Initiative Lifecycle** | Governs all build workflows | Promotion rules: backlog → needs-prd → needs-architecture → needs-design → needs-stories → needs-engineering → needs-qa → shipped |
| **Initiative Build** | Initiative selected for grooming | PM → Architect → Designer → Scrum Master → Project Manager → Developers |
| **Development Execution** | Status reaches READY_FOR_DEV | PjM (decompose → assign → coordinate) → Developers (parallel worktrees) → Reviewer |
| **Review Protocol** | All dev tasks complete | Reviewer risk assessment → Standard `/review` or [Human Gate] → `/ultrareview` |

### Quality & Release

| Workflow | Trigger | Pipeline |
|---|---|---|
| **Quality Assurance** | Dev complete | QA Lead → Integration Tester → UX Reviewer → QA Report |
| **Release** | QA passed | Plan → Preflight → Deploy → Verify → Announce → Measure → Retro |

### Growth & GTM

| Workflow | Trigger | Pipeline |
|---|---|---|
| **Go-to-Market** | Launch milestone | Growth Strategist → Content → SEO → SDR → Launch |
| **Growth Experiment Loop** | NSM plateaus or new growth lever | Strategist (NSM) → Growth (assess → loops → experiments) → [Human Gate] → Data Analyst (A/B → cohort) → Growth (iterate) |
| **Sales Enablement** | New launch or win-rate drop | Researcher (ICP → teardown) → Growth (battlecards → value props → positioning → messaging) → SDR (research → outreach) |

### Feedback & Iteration

| Workflow | Trigger | Pipeline |
|---|---|---|
| **Feedback Loop** | Initiative reaches shipped status | Data Analyst → Market Researcher → PM retro → Iterate/Expand/Next |

### Operations

| Workflow | Trigger | Pipeline |
|---|---|---|
| **Content Automation** | Weekly schedule | Researcher → Copywriters → Publisher → Tracker → Reporter |
| **Incident Response** | Production incident | Incident Commander → Security Analyst → DevOps → Retro |

---

*Generated from 166 SKILL.md files across the Deliberate_Agents framework.*
