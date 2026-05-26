# Validation Checkpoint

Before advancing an initiative past assessment, evaluate the evidence base.
This checkpoint documents the current validation state so downstream agents
and the Visionary know what is assumed vs. proven.

## Evidence Inventory

For each major claim in the one-pager, categorize:

### Validated (evidence exists)

| Claim | Evidence | Source |
|-------|----------|--------|
| {claim from one-pager} | {data, experiment result, user quote} | {where this evidence came from} |

### Assumed (no evidence, believed true)

| Assumption | Confidence | Cost if Wrong |
|------------|-----------|---------------|
| {assumption} | High / Medium / Low | High / Medium / Low |

### Unknown (need to find out)

| Question | How to Answer | Blocking? |
|----------|--------------|-----------|
| {open question} | {experiment type, research method} | Yes / No |

## Validation Score

- Validated claims: ___
- Assumed claims: ___
- Unknown claims: ___
- **Validation ratio:** ___% validated

## Recommendation

Select one:

- [ ] **Proceed** — Sufficient validation for this initiative's risk level. Assumptions are low-cost-if-wrong or high-confidence.
- [ ] **Validate first** — High-impact assumptions need testing before PRD investment. Recommended path: `/identify-assumptions` to map and prioritize, then `/design-experiments` to design validation experiments.
- [ ] **Park** — Too many unknowns to proceed. Needs full discovery cycle (see product-discovery workflow).

## Risk-Adjusted Guidance

| Initiative Risk | Minimum Validation Ratio | Recommended Action |
|----------------|-------------------------|-------------------|
| Low (small scope, reversible) | 30%+ | Proceed with assumptions flagged |
| Medium (moderate scope, some risk) | 50%+ | Validate highest-cost assumptions |
| High (large scope, hard to reverse) | 70%+ | Full validation before PRD |

## Prior Validation Work

Link any existing artifacts:
- Assumption maps: {path from `/identify-assumptions`, if any}
- Experiment results: {path from `/design-experiments`, if any}
- User research: {path from `/customer-interview-guide`, `/analyze-feedback`, if any}
- Market scans: {path from `/market-scan`, if any}
- Competitor analysis: {path from `/competitive-teardown`, if any}
