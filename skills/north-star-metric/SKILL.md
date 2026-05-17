---
name: north-star-metric
description: Define North Star Metric and supporting input metrics using Sean Ellis's growth framework — classify business type, derive input metrics, set targets and monitoring cadence
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# North Star Metric

## Objective

Define the North Star Metric (NSM) — the single metric that best captures the core value your product delivers to customers — along with the 3-5 input metrics that drive it. Based on Sean Ellis and Morgan Brown's growth framework from *Hacking Growth*.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What product or business is this for?
   - What stage is the product in?
   - What metrics are currently tracked?
   - What does the team believe the NSM should be (if any hypothesis exists)?

2. **Classify the business game type**:

   Every product plays one of three "games" — this determines what category of NSM makes sense:

   | Game Type | Core Value | NSM Category | Examples |
   |-----------|-----------|-------------|---------|
   | **Attention** | Time spent = value delivered | Active usage (DAU, MAU, time in app) | Social media, news, entertainment, messaging |
   | **Transaction** | Each transaction = value delivered | Transaction volume or revenue | E-commerce, marketplaces, fintech, food delivery |
   | **Productivity** | Efficiency gained = value delivered | Tasks completed, time saved, output produced | SaaS tools, dev tools, project management, analytics |

   Most B2B SaaS plays the Productivity game. Identify which game your product plays and defend the classification.

3. **Define the North Star Metric**:

   The NSM must satisfy ALL of these criteria:
   - [ ] **Measures value delivered to customers** (not revenue to the company)
   - [ ] **Leading indicator of revenue** (if NSM grows, revenue follows)
   - [ ] **Measurable** (can be tracked with current or near-term instrumentation)
   - [ ] **Actionable** (teams can influence it through product and marketing changes)
   - [ ] **Simple** (can be explained to anyone in one sentence)
   - [ ] **Not gameable** (can't be inflated without actually delivering value)

   **Good NSM examples**:
   - Slack: messages sent in organizations with 2000+ messages
   - Airbnb: nights booked
   - Spotify: time spent listening
   - HubSpot: weekly active teams using 5+ features
   - Amplitude: weekly learning users (users who share a chart/insight)

   **Bad NSM examples** (and why):
   - Revenue (lagging, measures extraction not value)
   - Sign-ups (vanity, no indication of value delivery)
   - NPS (infrequent, subjective, not actionable)
   - Page views (measures activity, not value)

4. **Derive 3-5 input metrics that drive the NSM**:

   Input metrics are the levers teams can pull to move the NSM. They should map to the AARRR framework:

   | Input Metric | AARRR Stage | Drives NSM By... | Owner |
   |-------------|-------------|-------------------|-------|
   | New activated users/week | Acquisition + Activation | More users delivering value | Growth |
   | Feature adoption rate | Activation | Deeper engagement per user | Product |
   | Weekly active rate | Retention | Users continuing to get value | Product |
   | Expansion triggers/month | Revenue | More value per account | Sales/CS |
   | Referral invites sent | Referral | New users via existing users | Growth |

   For each input metric:
   - Define precisely how it's calculated
   - Explain the causal link to the NSM (not just correlation)
   - Identify who owns moving this metric
   - Set a current baseline (measured or estimated)

5. **Build the metric tree**:

   ```
                    ┌─────────────────────┐
                    │   NORTH STAR METRIC  │
                    │   [Your NSM here]    │
                    └──────────┬──────────┘
                               │
            ┌──────────┬───────┴───────┬──────────┐
            │          │               │          │
       ┌────▼────┐ ┌───▼────┐ ┌───────▼──┐ ┌────▼────┐
       │ Input 1 │ │Input 2 │ │ Input 3  │ │Input 4  │
       │         │ │        │ │          │ │         │
       └─────────┘ └────────┘ └──────────┘ └─────────┘
   ```

   Show the tree with actual metric names and current values.

6. **Set targets and monitoring cadence**:

   | Metric | Current | 30-day Target | 90-day Target | Cadence | Alert Threshold |
   |--------|---------|--------------|--------------|---------|-----------------|
   | NSM | ... | ... | ... | Weekly | < X% decline |
   | Input 1 | ... | ... | ... | Daily/Weekly | ... |
   | Input 2 | ... | ... | ... | Daily/Weekly | ... |

   Define:
   - **Review cadence**: How often each metric is reviewed and by whom
   - **Alert thresholds**: What triggers investigation (e.g., 10% week-over-week decline)
   - **Reporting format**: Dashboard, weekly email, standup metric

7. **Validate the NSM choice**:

   Run these validation checks:
   - **Correlation test**: Does historical NSM movement correlate with revenue?
   - **Manipulation test**: Can the NSM be inflated without delivering real value?
   - **Completeness test**: Does the NSM capture the majority of value delivery?
   - **Stability test**: Is the NSM stable enough to track but sensitive enough to respond to changes?
   - **Alignment test**: Would optimizing for this NSM lead to decisions the team would be proud of?

   If any check fails, revisit the NSM definition.

## Output

Write deliverable to `.deliberate/reports/{slug}/north-star-metric.md` including:
- Business game type classification with rationale
- North Star Metric definition (precise calculation, rationale, validation)
- 3-5 input metrics with definitions, causal links, and owners
- Metric tree diagram (ASCII)
- Targets and monitoring cadence table
- Validation checks (pass/fail with explanation)
- Counter-metrics / guardrails (what must NOT degrade as NSM grows)
- Implementation recommendations (instrumentation, dashboards)

## Constraints

- There can be only one North Star Metric — if you need two, you haven't found the right one
- The NSM must measure customer value, not company revenue
- Input metrics must have a causal relationship to the NSM, not just correlation
- All targets must be grounded in current baselines, not aspirational fantasies
- If the product lacks instrumentation to measure the NSM, include instrumentation as a prerequisite
- Counter-metrics are required — every NSM can be gamed without guardrails

## Transition

The NSM feeds into `/experiment-design` (experiments should move input metrics), `/growth-loops` (loops should drive the NSM), and `/growth-plan` (all growth activities measured against NSM).
