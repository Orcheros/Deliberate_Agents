# Project Onboarding

## Purpose

Take a project from "I know nothing about this app" to "I have a complete product brief with vision, personas, ICPs, positioning, and competitive context" — with minimal manual input. This workflow combines technical onboarding, business context extraction, and strategic discovery into a single end-to-end pipeline.

Unlike product-discovery (which validates a specific opportunity or backlog item), this workflow establishes the foundational understanding of an entire project. Run it once when adopting a new project, or re-run when the product has significantly evolved.

## Trigger

New project adopted into Deliberate_Agents (via `scripts/init.sh` or `scripts/onboard.sh`), or existing project needs a strategic refresh after major pivot or feature expansion.

## Agent Sequence

```
Trigger (new project adopted or strategic refresh needed)
  ↓
Step 1: Technical Onboarding
  onboard.sh
  produces .deliberate/onboarding.md
  ↓ Codebase understood
  ↓
Step 2: Project Discoverer
  /project-learn
  discovers/scaffolds .documentation/, produces .documentation/vision/product-brief.md
  ↓ Product brief drafted
  ↓
Step 3: Product Strategist
  /product-vision → /market-scan → /beachhead-segment
  ↓ Strategic foundation drafted
  ↓
Step 4: Market Researcher
  /user-personas → /ideal-customer-profile → /competitive-teardown
  ↓ Audience & competition mapped
  ↓
[HUMAN GATE: Review & correct all drafts]
  ↓
Step 5: Product Strategist
  /positioning-statement → /business-model-canvas
  ↓ Final positioning & business model
  ↓
Discovery complete — project is fully briefed
```

### Step 1: Technical Onboarding

**Input:** Project config file (`config.{slug}.yaml` or `.deliberate.yaml`)
**What happens:**
1. `scripts/onboard.sh` explores the codebase — architecture, models, routes, services, tech stack, git state, documentation inventory, and initiative catalog.

**Output:** `.deliberate/onboarding.md` — structured technical brief available to all agents
**Decision Gate:** Is the onboarding brief complete enough to understand the product? If key areas are blank or the codebase is too large for a single pass, re-run with `--refresh` and more targeted exploration.

### Step 2: Project Discoverer — Business Context Extraction

**Input:** Technical onboarding brief + the codebase itself
**What happens:**
1. `/project-learn` — Discovers or scaffolds the `.documentation/` directory (with standard subdirs: `northstar/`, `initiatives/`, `vision/`, `design/`, `marketing/`, `sales/`, `finance/`, `plans/`). Ingests any existing curated artifacts. Reads foundational project files, extracts audience signals from UI/docs/copy, identifies revenue model from billing code, assesses product maturity.

**Output:** `.documentation/vision/product-brief.md` — structured product brief with source attribution (also copied to `.deliberate/reports/{slug}/product-brief.md`)
**Decision Gate:** Are there enough business signals in the codebase and existing docs to draft strategy? If the product brief has major gaps (no audience signals, no positioning language, pre-revenue with no pricing intent), ask the founder to provide missing context before proceeding.

### Step 3: Product Strategist — Strategic Foundation

**Input:** Technical onboarding brief + product brief from Steps 1-2
**What happens:**
1. `/product-vision` — Craft or refine the product vision, grounded in the product brief's audience and positioning signals.
2. `/market-scan` — Scan the competitive and market environment, using competitor mentions and positioning from the product brief as starting points.
3. `/beachhead-segment` — Identify the beachhead market segment based on current traction signals and audience data.

**Output:** Vision document, market scan report, beachhead segment analysis
**Decision Gate:** Do vision, market scan, and beachhead form a coherent picture? If the vision targets one audience but the beachhead analysis points to another, reconcile before proceeding.

### Step 4: Market Researcher — Audience & Competition

**Input:** All prior artifacts (onboarding brief, product brief, vision, market scan, beachhead)
**What happens:**
1. `/user-personas` — Build personas grounded in the audience signals from the product brief and beachhead segment.
2. `/ideal-customer-profile` — Define the ICP using revenue model signals, audience data, and beachhead analysis.
3. `/competitive-teardown` — Deep analysis of competitors identified in the market scan.

**Output:** Persona documents, ICP definition, competitive teardown reports
**Decision Gate:** Do personas, ICP, and competitive positioning tell a consistent story? If contradictions exist (e.g., personas suggest SMB but ICP points enterprise), flag for human review.

### Step 5: Human Gate — Review & Correct Drafts

**Input:** All artifacts from Steps 1-4
**What happens:**
- Founder reviews the product brief, vision, personas, ICP, market scan, beachhead, and competitive teardown
- Corrects any misread signals, wrong assumptions, or missing context
- Confirms or adjusts the target audience, positioning direction, and competitive framing
- Provides any business context that couldn't be extracted from code (revenue targets, strategic partnerships, founder intent)

**Output:** Validated and corrected artifacts
**This step requires human review — agents cannot validate business assumptions without founder input.**

### Step 6: Product Strategist — Final Positioning & Business Model

**Input:** Human-validated artifacts from Step 5
**What happens:**
1. `/positioning-statement` — Craft the positioning statement using validated vision, personas, and competitive context.
2. `/business-model-canvas` — Build the Business Model Canvas using validated ICP, revenue model, and market context.

**Output:** Positioning statement, Business Model Canvas
**The project is now fully briefed** — all downstream workflows (product-discovery, initiative-build, GTM) can reference these foundational artifacts.

## Decision Gates

| Gate | Location | Question | If No |
|------|----------|----------|-------|
| Codebase Clarity | After Step 1 | Is the onboarding brief complete enough to understand the product? | Re-run onboard.sh with --refresh |
| Product Signal Strength | After Step 2 | Are there enough business signals to draft strategy? | Ask founder to provide missing context |
| Strategic Coherence | After Step 3 | Do vision, market scan, and beachhead form a coherent picture? | Reconcile contradictions before proceeding |
| Audience Consistency | After Step 4 | Do personas, ICP, and competitive analysis align? | Flag contradictions for human review |
| Human Approval | After Step 5 | Has the founder validated the drafts? | Iterate on specific artifacts per founder feedback |

## Exit Condition

All foundational artifacts exist and have been human-validated: technical onboarding brief, product brief, product vision, market scan, beachhead segment, user personas, ICP, competitive teardown, positioning statement, and business model canvas. The project is ready for any downstream workflow — product-discovery, initiative planning, GTM strategy, or growth experiments.

## Timing

Multi-session workflow. Steps 1-2 (technical + business extraction) are automated and can run in a single session. Steps 3-4 (strategic drafting) require separate agent sessions. Step 5 (human gate) pauses for founder review — hours to days depending on availability. Step 6 runs after human approval.
