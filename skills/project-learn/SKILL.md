---
name: project-learn
description: Extract business context, audience signals, and product positioning from an existing codebase and its documentation
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Project Learn

## Objective

Produce a structured product brief by reading an existing codebase and its documentation. This is not a technical architecture review (that's `onboard.sh`) — this skill extracts *business-facing* knowledge: what the product does, who it's for, how it positions itself, and how it makes money.

Every project should have a `.documentation/` directory at its root — the canonical home for all business, product, and strategy artifacts. This skill checks for it first, ingests what exists, and scaffolds missing subdirectories. Only infer from code when curated sources are absent or incomplete.

## Process

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Identify the target project and its root directory
   - Note any hints about where business context lives (founder may have specified paths)
   - Check if `.deliberate/onboarding.md` exists — read it for technical context

2. **Discover or scaffold the `.documentation/` directory**:
   - Check for `.documentation/` at the project root — this is the canonical location
   - If it exists, inventory its contents. Standard subdirectories:
     - `northstar/` — product vision, mission, values, execution patterns, zone definitions
     - `initiatives/` — ROADMAP.md, TRACKER.md, individual initiative dirs (PRDs, architecture, design studies), Initiative Templates/
     - `vision/` — product positioning, ICP profiles, architecture specs, SEO/content strategy
     - `design/` — UI mockups, design specs, component prototypes
     - `marketing/` — messaging, campaigns, landing page copy, brand guidelines
     - `sales/` — sales playbooks, objection handling, demo scripts, case studies
     - `finance/` — pricing models, revenue projections, unit economics, funding materials
     - `plans/` — implementation plans, build plans
   - If `.documentation/` does not exist, **create it** with the standard subdirectories listed above (empty dirs with a `.gitkeep` in each)
   - Also check legacy locations: `.northstar/`, `config/northstar/`, `.product/`, `docs/product/`, `docs/strategy/`
   - If curated artifacts are found in any location, ingest them as primary sources — they override inferences
   - `.deliberate/reports/` — check for prior Deliberate_Agents outputs (vision, personas, etc.)
   - Any directory the founder specified in the assignment or project config

3. **Read foundational project files**:
   - README, CLAUDE.md, CONTRIBUTING.md — product description, setup, positioning language
   - CHANGELOG or release notes — feature evolution and maturity signals
   - Landing page content, marketing copy, or `docs/` site if present
   - `.deliberate.yaml` or project config — may contain product metadata

4. **Extract audience and positioning signals**:
   - UI copy, onboarding flows, welcome emails — who the product talks to and how
   - Documentation tone and assumed knowledge level — developer tool vs. consumer app vs. enterprise
   - Signup/registration flows — individual vs. team vs. org signals
   - Pricing page, plan names, feature gating — who pays and for what tier
   - Error messages and help text — assumed user sophistication

5. **Extract revenue model signals**:
   - Billing code, subscription logic, payment provider integrations (Stripe, Paddle, etc.)
   - Plan/tier definitions in config or database schema
   - Usage metering, credit systems, rate limiting — usage-based pricing signals
   - Free tier / trial logic — freemium or free-trial model
   - If no billing code exists, note this as pre-revenue or open-source

6. **Scan for ecosystem and integration signals**:
   - Third-party integrations (analytics, CRM, support, payment, auth providers)
   - API surface area — is this a platform, a tool, or a standalone app?
   - Webhook/event systems — does it integrate into workflows?
   - OAuth scopes and permissions — what data does it access?

7. **Assess product maturity**:
   - Git history depth and contributor count — age and team size
   - Test coverage presence and CI/CD configuration — engineering maturity
   - Feature flag system — rapid iteration or careful rollout signals
   - Database migration count — feature accumulation over time
   - Deployment configuration — single instance vs. multi-tenant vs. self-hosted

8. **Synthesize into a product brief**:
   - Compile all findings — prioritize curated artifacts over inferences
   - Flag which sections came from existing documents vs. codebase inference
   - Identify gaps where neither curated sources nor code signals exist
   - Note contradictions between stated positioning and actual implementation

## Output

Write deliverable to `.documentation/vision/product-brief.md` (and symlink or copy to `.deliberate/reports/{slug}/product-brief.md` for agent compatibility) including:

- **Source Inventory** — which curated business artifacts were found and ingested (with paths)
- **Product Summary** — what it does, core capabilities, primary value delivered
- **Target Audience** — who it's for, based on curated docs or inferred from UI/docs/code signals
- **Positioning** — how it describes itself, tagline, category, differentiation language
- **Revenue Model** — pricing structure, billing approach, or pre-revenue status
- **Feature Surface Area** — major feature groups and their relative maturity
- **Integration Ecosystem** — third-party services and platform characteristics
- **Product Maturity Assessment** — launch stage, scale signals, engineering maturity
- **Gaps and Unknowns** — what couldn't be determined from available sources
- **Contradiction Log** — where stated positioning diverges from implementation reality

## Constraints

- Never invent business context — flag gaps explicitly rather than guessing
- `.documentation/` artifacts take priority over code-inferred signals; legacy locations (`.northstar/`, `config/northstar/`) are checked as fallbacks
- Clearly distinguish between "stated by the project" and "inferred from code" for every claim
- Do not duplicate technical architecture content — that's in `.deliberate/onboarding.md`
- If the founder has provided business context verbally or in the assignment, treat it as highest-priority input
- Do not read every file in the codebase — scan strategically for signal-rich locations
- Keep the brief under 2000 words — this is a reference document, not an analysis

## Transition

The product brief feeds directly into the project-onboarding workflow: `/product-vision` uses it as primary input, `/user-personas` builds on the audience signals, `/market-scan` starts from the positioning and competitive mentions, and `/ideal-customer-profile` refines the target audience section. All downstream agents should read this brief before producing their artifacts.
