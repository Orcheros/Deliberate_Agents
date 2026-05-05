---
name: observability-design
description: Design observability strategy — SLI/SLO frameworks, golden signals monitoring, alerting optimization, dashboard design, and runbook generation
allowed-tools: Read, Write, Glob, Grep, Bash
---

# Observability Design

## Objective

Design production-ready observability covering metrics, logs, and traces with SLI/SLO frameworks and actionable alerting.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What services need observability?
   - Current monitoring stack (Prometheus, Grafana, Datadog, etc.)?
   - What's missing — metrics, logs, traces, or alerting?

2. **Define SLIs and SLOs for each service**:

   **Service Level Indicators** — measurable signals of service health:
   - Availability: % of successful requests
   - Latency: P50, P95, P99 response times
   - Correctness: % of responses with correct data
   - Throughput: requests per second at capacity

   **Service Level Objectives** — reliability targets:
   - Set based on user expectations, not perfection
   - 99.9% availability = 43 min downtime/month
   - 99.95% = 22 min/month, 99.99% = 4 min/month
   - Calculate error budget: 100% - SLO = allowed error rate

3. **Implement golden signals monitoring**:

   | Signal | What to Monitor | Key Metrics |
   |--------|----------------|-------------|
   | **Latency** | Request duration | P50, P95, P99; separate success vs. error latency |
   | **Traffic** | Request volume | RPS, active sessions, bandwidth |
   | **Errors** | Failure rate | 4xx rate, 5xx rate, error budget consumption |
   | **Saturation** | Resource usage | CPU, memory, disk, connection pools, queue depth |

   For request-driven services, also use **RED method**: Rate, Errors, Duration.
   For resource services, use **USE method**: Utilization, Saturation, Errors.

4. **Design dashboard hierarchy**:

   | Level | Audience | Content | Panels |
   |-------|----------|---------|--------|
   | Overview | On-call, leadership | Service health, SLO status | 5-7 max |
   | Service | Engineers | Golden signals per service | 7-10 max |
   | Component | Debugging | Detailed per-component metrics | As needed |

   **Design principles:**
   - Max 7±2 panels per screen (cognitive load)
   - 80% operational metrics, 20% exploratory
   - Red = critical, amber = warning, green = healthy
   - Include SLO target reference lines
   - Default to meaningful time windows (4h for incidents, 7d for trends)

5. **Design alerts to minimize fatigue**:

   **Classification:**
   - **Critical**: Service down, SLO burn rate high → page immediately
   - **Warning**: Approaching thresholds, non-user-facing → ticket
   - **Info**: Deployments, capacity planning → dashboard only

   **Rules:**
   - Every alert must have a clear response action — if no one needs to act, it's not an alert
   - Use hysteresis (different thresholds for firing and resolving)
   - Suppress dependent alerts during known outages
   - Group related alerts into single notifications
   - Use multi-window burn rate alerting for SLO protection

6. **Design structured logging**:
   - JSON format with consistent fields: timestamp, level, service, request_id, user_id, message
   - Use correlation IDs for distributed tracing
   - Log levels: DEBUG (dev only), INFO (normal operations), WARN (unexpected but handled), ERROR (requires attention), FATAL (service failing)
   - Sample high-volume logs to manage cost

7. **Generate runbook template** for each critical alert:
   - What the alert means and why it fired
   - Impact assessment checklist
   - Investigation steps (ordered, with time estimates)
   - Resolution actions (common fixes)
   - Escalation procedure
   - Post-incident follow-up tasks

## Output

Write deliverable to `.deliberate/reports/{slug}/observability-design.md` including:
- SLI/SLO definitions per service
- Golden signals monitoring spec
- Dashboard specs (overview + per-service)
- Alert rules with classification and routing
- Logging standards
- Runbook templates for critical alerts
