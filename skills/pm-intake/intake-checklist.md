# Intake Quality Checklist

Review before committing the one-pager. Every item must pass. If one fails, fix it before proceeding.

---

## Problem Statement

- [ ] Describes a user pain or unmet need, not a missing feature
- [ ] Names who is affected (specific segment, not "users")
- [ ] Quantifies impact if data is available (frequency, severity, user count)

## Proposed Solution

- [ ] High-level approach, not implementation details
- [ ] References existing codebase patterns discovered during research
- [ ] Could be understood by someone who hasn't read the code

## Target User

- [ ] Names a specific user segment or persona
- [ ] If multiple segments, identifies primary vs. secondary

## Desired Outcome

- [ ] Describes observable change in user behavior or business metric
- [ ] Is measurable (even if the measurement method isn't defined yet)
- [ ] Is not just "the feature exists"

## Codebase Context

- [ ] References actual file paths, models, or services found during research
- [ ] Identifies existing features that overlap or interact
- [ ] Notes patterns that this initiative extends or breaks

## Technical Feasibility

- [ ] Lists specific constraints or dependencies discovered
- [ ] Notes whether this extends existing patterns or requires new architecture
- [ ] Is not empty or "should be straightforward"

## Scope Boundaries

- [ ] Has explicit inclusions (what's in)
- [ ] Has explicit exclusions with rationale (what's out and why)
- [ ] Exclusions prevent scope creep, not just list obvious non-goals

## Estimated Impact

- [ ] Size, risk, and complexity are justified, not guessed
- [ ] Justification references codebase findings (e.g., "reuses existing X" for low complexity)

## Structural

- [ ] Initiative slug follows naming convention (`{number}-{kebab-case}`)
- [ ] Directory created at `{initiatives_path}/backlog/{slug}/`
- [ ] Queue YAML created at `.deliberate/queue/{slug}.yaml` with status `QUEUED`
- [ ] Committed to current branch with message: `"Intake: {Title} — one-pager created in backlog"`
