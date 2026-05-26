# One-Pager Template

Use this template when creating a one-pager during `/pm-intake`. Each section has field-by-field guidance and common mistakes to avoid.

---

```markdown
# {Initiative Title}

## Problem

What doesn't work today. Who is affected and how.

## Proposed Solution

What we're building. High-level approach grounded in what we found in the codebase.

## Target User

Who benefits. Which ICP segment(s) or internal roles.

## Desired Outcome

What "done" looks like. Observable changes in user behavior or system capability.

## Codebase Context

What already exists that this builds on. Key models, services, and patterns discovered.
Existing features that overlap or interact with this initiative.

## Technical Feasibility Notes

Constraints, risks, or dependencies discovered during research.
Whether this extends existing patterns or requires new architecture.

## Scope Boundaries

What's included. What's explicitly excluded and why.

## Estimated Impact

Size: S / M / L / XL
Risk: Low / Medium / High
Complexity: Low / Medium / High
```

---

## Field Guidance

### Problem
**Good**: Describes a user's pain or unmet need. Specific about who and how often.
**Bad**: Describes a missing feature ("We don't have X"). Features are solutions, not problems.

**Example** (good): "Free-tier users who outgrow their allocation have no visibility into what they'd get by upgrading. 40% of churned free users never saw the upgrade page."

**Example** (bad): "We need a paywall page."

### Proposed Solution
**Good**: High-level approach that references existing patterns in the codebase. Says what we're building, not how we're building it.
**Bad**: Implementation details (specific models, endpoints, SQL). That belongs in the PRD and architecture doc.

### Target User
**Good**: Names a specific segment: "Tier 0 users who have created at least one diagnosis card."
**Bad**: "All users" or "everyone." If the target is truly everyone, name the primary segment and secondary segments.

### Desired Outcome
**Good**: Observable behavior change: "Users who see the upgrade prompt convert at 2x the current rate."
**Bad**: System capability: "The system can display upgrade prompts." That's a feature, not an outcome.

### Codebase Context
**Good**: References actual file paths, models, and existing patterns discovered during research: "Builds on `Subscription` model and `TierGuard` concern. Reuses the `app/views/shared/_pricing_card.html.erb` component."
**Bad**: Vague references: "Builds on existing billing infrastructure."

### Technical Feasibility Notes
**Good**: Specific constraints: "Stripe webhook latency means upgrade status may lag 2-5 seconds. The `AnthropicClient` cost tracking already exists via `AiUsageLine`."
**Bad**: No feasibility section, or "Should be straightforward."

### Scope Boundaries
**Good**: Explicit inclusions AND exclusions with rationale: "Includes: upgrade prompt on dashboard. Excludes: downgrade flow (separate initiative, different user journey)."
**Bad**: Only inclusions. Every scope needs explicit exclusions to prevent creep.

### Estimated Impact
**Good**: Justified estimates: "Size: M (new view + controller + Stimulus, reuses existing Stripe integration). Risk: Low (no schema changes)."
**Bad**: Guessed without justification: "Size: L."
