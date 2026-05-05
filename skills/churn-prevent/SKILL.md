---
name: churn-prevent
description: Reduce voluntary and involuntary churn through cancel flow design, save offers, exit surveys, and dunning sequences
allowed-tools: Read, Write, Glob, Grep
---

# Churn Prevention

## Objective

Design or optimize systems to reduce both voluntary churn (customers who decide to leave) and involuntary churn (failed payments).

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Is this building a cancel flow, optimizing an existing one, or setting up dunning?
   - Current churn rate (voluntary vs. involuntary split if known)
   - Payment processor (Stripe, etc.)

2. **Design the 5-stage cancel flow**:

   ```
   [Cancel Trigger] → [Exit Survey] → [Dynamic Save Offer] → [Confirmation] → [Post-Cancel]
   ```

   **Stage 1 — Cancel Trigger**: Show cancel option clearly (no dark patterns). Begin the flow immediately.

   **Stage 2 — Exit Survey** (1 question, required): "What's the main reason you're cancelling?" Multiple choice, 6-8 reasons. This drives the save offer.

   **Stage 3 — Dynamic Save Offer**: Match offer to reason:

   | Reason | Save Offer |
   |--------|-----------|
   | Too expensive | Discount (1-3 months) or downgrade |
   | Not using enough | Usage tips + pause option |
   | Missing feature | Roadmap share + workaround |
   | Switching to competitor | Competitive comparison |
   | Project ended / seasonal | Pause option (1-3 months) |
   | Too complicated | Onboarding help + human support |
   | Just testing | No offer — let go |

   **Stage 4 — Confirmation**: Clear summary of what happens (access, data, billing). Explicit confirm button. No pre-checked boxes.

   **Stage 5 — Post-Cancel**: Confirmation email with reactivation link. 7-day re-engagement email. 30-day win-back if warranted.

3. **Set up dunning for involuntary churn** (failed payments cause 20-40% of total churn):

   **Smart retry logic:**
   - Retry 1: 3 days after failure
   - Retry 2: 5 days after retry 1
   - Retry 3: 7 days after retry 2
   - Final: 3 days after retry 3, then cancel

   **Dunning email sequence:**

   | Day | Email | Tone | CTA |
   |----|-------|------|-----|
   | 0 | Payment failed | Neutral, factual | Update card |
   | 3 | Action needed | Mild urgency | Update card |
   | 7 | Account at risk | Higher urgency | Update card |
   | 12 | Final notice | Urgent | Update card + support |
   | 15 | Account paused | Matter-of-fact | Reactivate |

   Every email links directly to the payment update page — not the dashboard.

4. **Define metrics and benchmarks**:

   | Metric | Benchmark |
   |--------|-----------|
   | Save rate | 10-15% good, 20%+ excellent |
   | Voluntary churn rate | <2% monthly |
   | Involuntary churn rate | <1% monthly |
   | Recovery rate (failed payments) | 25-35% good |
   | Win-back rate (90-day) | 5-10% |
   | Exit survey completion | >80% |

## Red Flags to Surface

- Instant cancellation with no flow → revenue leaking immediately
- Single generic save offer → map offers to exit reasons instead
- No dunning sequence → 20-40% of churn going unaddressed
- Exit survey optional → make it required (one question, fast)
- Save rate <5% → offers aren't matching reasons

## Output

Write deliverable to `.deliberate/reports/{slug}/churn-prevention.md` including:
- Cancel flow design with copy for each stage
- Save offer mapping table
- Dunning email sequence with subject lines and body copy
- Metrics tracking plan with benchmarks
