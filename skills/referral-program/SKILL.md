---
name: referral-program
description: Design, launch, or optimize a referral or affiliate program — loop mechanics, incentive structure, trigger moments, measurement
allowed-tools: Read, Write, Glob, Grep
---

# Referral Program

## Objective

Build a referral system with the right mechanics, triggers, incentives, and measurement to turn customers into an acquisition channel.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - New program design, optimization of existing, or affiliate launch?
   - Available context: LTV, CAC, current referral metrics if any

2. **Choose mechanism — referral vs. affiliate**:

   | | Customer Referral | Affiliate Program |
   |---|---|---|
   | Who promotes | Existing customers | External partners, influencers |
   | Motivation | Loyalty, reward, social currency | Commission, audience alignment |
   | Best for | B2C, prosumer, SMB SaaS | B2B SaaS, high LTV, content niches |
   | Scale | Scales with user base | Scales with partner recruitment |

   Rule of thumb: enthusiastic social customers → referral. Business buyers → affiliates.

3. **Design the 4-stage referral loop**:

   ```
   [Trigger Moment] → [Share Action] → [Referred User Converts] → [Reward Delivered] → [Loop]
   ```

   **Trigger moments** (when to ask — timing is everything):
   - After aha moment (not at signup — too early)
   - After a milestone ("You just saved your 100th hour")
   - After great support (post-resolution NPS 9-10 → referral ask)
   - After renewal

   **Share action** (remove all friction):
   - Pre-filled share message (editable, not locked)
   - Personal referral link
   - One-click send options: email, link copy, social, Slack/Teams for B2B

   **Referred user converts**:
   - Personalized landing ("Your friend Alex invited you")
   - Incentive visible on landing page
   - Attribution tracked from landing to conversion

   **Reward delivered** (fast and clear):
   - Confirm eligibility immediately when referral signs up
   - Notify referrer instantly — don't wait until month-end
   - Status visible in dashboard

4. **Design incentive structure**:

   **Single-sided** (referrer only): Use when referral rate >5% and customers are already enthusiastic.
   **Double-sided** (both get rewarded): Use when referral rate <1% and you need to overcome inertia.

   | Type | Best For | Example |
   |------|----------|---------|
   | Account credit | SaaS / subscription | "Get $20 credit" |
   | Discount | Usage-based | "Get 1 month free" |
   | Cash | High LTV, B2C | "$50 per referral" |
   | Feature unlock | Freemium | "Unlock advanced analytics" |

   Sizing: reward ≥10% of first month's value for credit. Cash cap at 30% of first payment.

   **Tiered rewards** (optional, for power referrers):
   ```
   1 referral  → $20 credit
   3 referrals → $75 credit + bonus feature
   10 referrals → $300 cash + ambassador status
   ```

5. **Define measurement framework**:

   | Metric | Formula | Benchmark |
   |--------|---------|-----------|
   | Program awareness | Active users who know it exists | >40% |
   | Active referrers % | Users who sent ≥1 / total active | 5-15% |
   | Share rate | Those who see it and share | 20-40% |
   | Referred conversion rate | Converts / referrals sent | 15-25% |
   | CAC via referral | Reward cost / new customers | Should be < other channels |
   | Virality coefficient (K) | Referrals per user × conversion rate | K >1 = viral |

## Red Flags to Surface

- Asking at signup → move trigger to post-aha moment
- Reward too small relative to LTV (<5% and low referral rate) → increase reward
- No reward notification → loop breaks without instant feedback
- Generic share message → rewrite in first-person customer voice
- No attribution past landing page → referrals being undercounted

## Output

Write deliverable to `.deliberate/reports/{slug}/referral-program.md` including:
- Program type (referral vs. affiliate) with rationale
- 4-stage loop design with trigger moments
- Incentive structure with sizing justification
- Implementation requirements (what to build)
- Measurement plan with benchmarks
