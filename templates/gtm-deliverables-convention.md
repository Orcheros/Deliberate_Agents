# GTM Deliverables Convention

## Output Directory

GTM deliverables for an initiative live at:

```
{initiative-dir}/gtm/
```

For initiative-independent GTM work (ongoing strategy, channel management):

```
.deliberate/reports/gtm/
```

## Numbered Naming Convention

Within the `gtm/` directory, deliverables follow a phase-numbered naming scheme
for browsability. Each file maps to the skill that produces it.

### Pre-Build (Validation Phase)

| # | File | Skill |
|---|------|-------|
| 01 | `01-assumption-map.md` | `/identify-assumptions` |
| 02 | `02-experiment-plan.md` | `/design-experiments` |
| 03 | `03-experiment-results.md` | Human-documented results |

### Strategy (Growth Strategist)

| # | File | Skill |
|---|------|-------|
| 04 | `04-growth-assessment.md` | `/growth-assess` |
| 05 | `05-growth-strategy.md` | `/growth-strategy` |
| 06 | `06-gtm-motions.md` | `/gtm-motions` |
| 07 | `07-positioning.md` | `/positioning-statement` |
| 08 | `08-messaging-framework.md` | `/gtm-messaging` |

### Execution Planning

| # | File | Skill |
|---|------|-------|
| 09 | `09-growth-plan.md` | `/growth-plan` |
| 10 | `10-launch-plan.md` | `/launch-strategy` |
| 11 | `11-community-strategy.md` | `/community-strategy` |
| 12 | `12-partnership-program.md` | `/partnership-design` |
| 13 | `13-pr-press-kit.md` | `/pr-press` |

### Content & Sales

| # | File | Skill |
|---|------|-------|
| 14 | `14-content-brief.md` | `/content-brief` |
| 15 | `15-email-sequences.md` | `/email-sequence` |
| 16 | `16-sales-research.md` | `/sales-research` |
| 17 | `17-competitive-battlecard.md` | `/competitive-battlecard` |

### Post-Launch

| # | File | Skill |
|---|------|-------|
| 18 | `18-release-measure.md` | `/release-measure` |
| 19 | `19-growth-loops.md` | `/growth-loops` |
| 20 | `20-referral-program.md` | `/referral-program` |

## Usage

This convention is **recommended, not required**. It provides structure for
initiatives where GTM is a significant workstream. Skills currently write to
`.deliberate/reports/{slug}/` — the `gtm/` subdirectory adds organization
without breaking existing output paths.

Not every initiative will produce all 20 deliverables. Skip numbers that don't
apply — the gaps signal which GTM phases were not needed for this initiative.
