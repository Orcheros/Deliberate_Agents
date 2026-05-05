---
name: incident-command
description: Manage production incidents — severity classification, timeline reconstruction, communication templates, stakeholder coordination, and post-incident review
allowed-tools: Read, Write, Glob, Grep, Bash
---

# Incident Command

## Objective

Manage production incidents from detection through resolution and post-incident review.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What's happening? (Alert, user report, monitoring signal)
   - What systems are affected?
   - Current severity estimate

2. **Classify severity**:

   | Level | Definition | Response Time | Communication |
   |-------|-----------|--------------|---------------|
   | **SEV1** | Complete service failure, all users affected, data loss, security breach | IC assigned in 5 min, exec notification in 15 min | Every 15 min |
   | **SEV2** | Significant degradation, >25% users affected, partial outage | IC assigned in 30 min, status page in 30 min | Every 30 min |
   | **SEV3** | Limited impact, workarounds available, <25% affected | Response within 2h business hours | At milestones |
   | **SEV4** | Minimal impact, cosmetic, dev/test environment | Response within 1-2 business days | Standard cycle |

3. **Establish incident command** (SEV1/SEV2):
   - Own the response process and coordinate between teams
   - Shield responders from external distractions
   - Maintain situational awareness across all response streams
   - Make decisions; bias toward action over analysis for SEV1

4. **Communicate using templates**:

   **Initial notification:**
   ```
   [SEV{level}] {Service} - {Brief Description}
   Start Time: {timestamp}
   Impact: {what users experience}
   Status: {investigating/mitigating/resolved}
   Response Team: {IC, Tech Lead, SMEs}
   Next Update: {timestamp}
   ```

   **Customer communication:**
   ```
   We are currently experiencing {issue} affecting {scope}.
   Our team was alerted at {time} and is actively working to resolve.
   What we know: {facts}
   What we're doing: {actions}
   Workaround: {if available}
   Next update: {time}
   ```

5. **Reconstruct timeline** during/after incident:
   - Gather timestamped events from logs, alerts, deploys, and team actions
   - Build chronological narrative
   - Identify gaps in the timeline
   - Note decision points and their rationale

6. **Drive rollback decisions**:

   **Rollback triggers:**
   - Error rate >2x baseline within 30 min
   - Performance degradation >50% latency increase
   - Core functionality broken
   - Data corruption detected

   **Prefer rollback over risky fixes under pressure.** Validate fixes before declaring resolution.

7. **Conduct post-incident review** (within 48h for SEV1/2):
   - Timeline of events
   - Root cause analysis (5 Whys or Fishbone)
   - What went well
   - What could be improved
   - Action items with owners and due dates
   - Blameless — focus on system failures, not individual mistakes

## Stakeholder Communication Cadence

| Stakeholder | SEV1 | SEV2 | SEV3 |
|-------------|------|------|------|
| Engineering Leadership | Real-time | 30 min | 4 hrs |
| Executive Team | 15 min | 1 hr | EOD |
| Customer Support | Real-time | 30 min | 2 hrs |
| Customers | 15 min | 1 hr | Optional |

## Output

Write deliverable to `.deliberate/reports/{slug}/incident-report.md` including:
- Severity classification with justification
- Timeline reconstruction
- Communication log (what was sent to whom, when)
- Root cause analysis
- Action items with owners and due dates
- Metrics: time to detection, time to engagement, time to resolution
