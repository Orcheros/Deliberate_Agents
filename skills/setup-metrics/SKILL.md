---
name: setup-metrics
description: Design a product metrics dashboard — North Star Metric, input metrics, health guardrails, alert thresholds, and data source specifications
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Setup Metrics

## Objective

Design a comprehensive product metrics framework and dashboard specification. Identify the North Star Metric, derive input metrics, set health and guardrail metrics, define alert thresholds, and specify data sources — so the team knows exactly what to measure, why, and how.

## Instructions

1. **Identify the business game type**:
   - Read the product context, vision docs, and initiative materials
   - Classify the product into one of three game types (Sean Ellis / Amplitude framework):
     - **Attention game**: Success = time spent, engagement depth, return frequency (e.g., social media, content, news)
     - **Transaction game**: Success = number of transactions, conversion rate, revenue per user (e.g., e-commerce, marketplace, SaaS with usage-based pricing)
     - **Productivity game**: Success = tasks completed, efficiency gained, time saved (e.g., tools, SaaS platforms, workflow automation)
   - The game type determines which metric patterns are most relevant
   - Note: some products blend game types — identify the primary one and acknowledge secondary dynamics

2. **Define the North Star Metric (NSM)**:
   - The NSM must satisfy all three criteria:
     - **Reflects customer value**: When this number goes up, customers are getting more value
     - **Reflects business value**: When this number goes up, the business is healthier
     - **Measurable**: Can be tracked with existing or buildable instrumentation
   - Examples by game type:
     - Attention: Weekly Active Users with >N minutes engagement
     - Transaction: Weekly transactions per active user
     - Productivity: Weekly tasks completed per active user
   - Write the NSM as a precise, unambiguous statement: "[Metric name]: [definition], measured [frequency], from [data source]"

3. **Derive 3-5 input metrics**:
   - Input metrics are the levers that drive the NSM — the controllable upstream factors
   - Use the input tree technique: decompose the NSM into its component parts
   - Example decomposition for "Weekly Active Subscribers":
     - New subscriber activation rate
     - Returning subscriber retention (week-over-week)
     - Feature adoption breadth (features used per session)
     - Session depth (actions per session)
     - Resurrection rate (dormant users returning)
   - For each input metric, define:
     - **Name and definition**: Precise, no ambiguity
     - **Why it matters**: How it connects to the NSM
     - **Current baseline**: What we know today (or "unknown — needs instrumentation")
     - **Target**: Where we want it to be and by when
     - **Owner**: Which team or function is responsible

4. **Set health and guardrail metrics**:
   - **Health metrics** track the overall system and business health — things that should stay stable:
     - Error rates, latency (p50, p95, p99), uptime
     - Revenue, margin, unit economics
     - Customer satisfaction (NPS, CSAT)
     - Support ticket volume
   - **Guardrail metrics** are "do not cross" lines — if these degrade, something is wrong regardless of NSM movement:
     - User churn rate
     - Revenue churn rate
     - Page load time
     - Data quality / integrity
     - Compliance violations
   - For each, define: metric name, acceptable range, and what action to take if breached

5. **Define alert thresholds and response protocol**:
   - For each guardrail metric, set:
     - **Warning threshold**: "Investigate within 24 hours"
     - **Critical threshold**: "Investigate immediately, consider rollback"
   - For the NSM and input metrics, set:
     - **Anomaly detection**: Significant deviation from trailing 4-week average
     - **Trend alert**: Sustained decline over 2+ consecutive periods
   - Define the response protocol:
     - Who is notified (role, not person)
     - What is the expected investigation workflow
     - When to escalate

6. **Specify data sources and instrumentation**:
   - For each metric (NSM, inputs, health, guardrails), document:
     - **Data source**: Database table, analytics event, API endpoint, third-party tool
     - **Instrumentation status**: Already tracked / needs new event / needs new pipeline
     - **Calculation logic**: SQL query, formula, or aggregation method
     - **Refresh frequency**: Real-time, hourly, daily, weekly
     - **Known limitations**: Sampling, delays, data quality issues
   - Flag any metrics that require new instrumentation and estimate effort to implement

7. **Produce the dashboard specification**:
   - Layout the dashboard structure:
     - **Top row**: NSM with trend line and target
     - **Second row**: Input metrics with sparklines and targets
     - **Third row**: Health metrics with status indicators (green/yellow/red)
     - **Fourth row**: Guardrail metrics with threshold markers
   - Specify visualization type for each metric (counter, line chart, bar chart, gauge, table)
   - Note the recommended tool (if applicable): Metabase, Looker, Amplitude, custom dashboard
   - Write to the initiative directory or `.deliberate/reports/{slug}/metrics-dashboard-spec.md`

## Output

- A metrics dashboard specification document containing:
  - Business game type classification
  - North Star Metric definition with rationale
  - 3-5 input metrics with baselines, targets, and owners
  - Health and guardrail metrics with acceptable ranges
  - Alert thresholds and response protocol
  - Data source and instrumentation inventory
  - Dashboard layout specification

## Constraints

- The NSM must be a single metric — resist the temptation to have multiple "north stars"
- Input metrics must be actionable — each should have a clear owner and lever to pull
- Guardrail thresholds must be set before launching new features, not after
- Do not invent baselines — if current data is unknown, mark it as "needs measurement" rather than guessing
- Do not modify application code — this produces documentation only

## Transition

The metrics specification informs `/experiment-design` (what metrics experiments should track), `/pm-expand-prd` (metrics section of the PRD), and engineering implementation of analytics instrumentation.
