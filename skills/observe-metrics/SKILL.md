---
name: observe-metrics
description: Read flow, quality, and health metrics to identify bottlenecks and recommend improvements
allowed-tools: Bash, Read, Glob, Grep, Write
intent: "Enable the Integrator to run the Observe phase of the Deliberate Work Loop"
execution-mode: 4
responsible: integrator
accountable: integrator
risk-level: low
inputs:
  information: ["metrics YAML files", "initiative queue state", "decision backlog"]
  artifacts: ["flow.yaml", "quality.yaml", "health.yaml"]
  access: [".deliberate/metrics/", ".deliberate/queue/", ".deliberate/decisions/"]
  conditions: ["at least one initiative has completed a stage transition"]
  people: []
outputs:
  updated-information: ["bottleneck analysis", "improvement recommendation"]
  produced-artifacts: ["observation report"]
  system-state-change: []
  commitments-made: ["one actionable improvement identified"]
  ready-output: ["report in .deliberate/reports/ for Integrator to act on"]
---

# Observe Metrics

## Objective

Read the three-metric dashboard (Flow, Quality, Health) and produce a focused observation report identifying the single highest-leverage bottleneck and a concrete improvement recommendation.

## Instructions

1. **Read the metrics files**:
   - `.deliberate/metrics/flow.yaml` — stage transitions, timing, WIP
   - `.deliberate/metrics/quality.yaml` — gate pass/fail events
   - `.deliberate/metrics/health.yaml` — crashes, decision backlog

2. **Run the metrics dashboard** for a summary view:
   ```bash
   $DA_HOME/orchestration/metrics.sh <config_path>
   ```

3. **Analyze for bottlenecks**:
   - **Flow**: Which stage has the most items stuck? Where is cycle time longest?
   - **Quality**: Which gate fails most often? Is there a pattern (same initiative, same stage)?
   - **Health**: Are agents crashing? Is the decision backlog growing?

4. **Cross-reference with live state**:
   - Read `.deliberate/queue/*.yaml` to see current initiative states
   - Check `.deliberate/decisions/` for unresolved items
   - Look for stalled initiatives (status unchanged for extended time)

5. **Identify the single highest-leverage improvement**:
   - Not a list. One thing.
   - Prioritize: health problems first (crashes, stalls), then quality problems (gate failures), then flow problems (bottlenecks)
   - The improvement should be actionable — "fix the auth gate validation" not "improve quality"

6. **Write the observation report** to `.deliberate/reports/observe-{date}.md`:

   ```markdown
   # Observation Report — {date}

   ## Metrics Snapshot
   | Category | Key Metric | Value | Status |
   |----------|-----------|-------|--------|
   | Flow     | WIP       | N     | ok/warn/critical |
   | Flow     | Bottleneck | {stage} | {detail} |
   | Quality  | Gate pass rate | N% | ok/warn/critical |
   | Quality  | Top failing gate | {name} | {count} failures |
   | Health   | Agent crashes | N | ok/warn/critical |
   | Health   | Decision backlog | N | ok/warn/critical |

   ## Highest-Leverage Improvement
   **What**: {one-sentence description}
   **Why**: {what data shows this is the top priority}
   **How**: {concrete action — which file to change, which process to adjust}
   **Expected impact**: {what metric improves and by how much}
   ```

## Output

Observation report at `.deliberate/reports/observe-{date}.md`.

## Transition

The Integrator reviews the report and decides whether to act on the recommendation (Orchestrate phase of the Deliberate Work Loop).
