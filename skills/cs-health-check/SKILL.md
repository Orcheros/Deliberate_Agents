---
name: cs-health-check
description: Analyze customer health signals and identify at-risk or expansion-ready accounts
allowed-tools: Read, Glob, Grep
---

# Customer Health Check

## Objective

Analyze customer accounts for health signals — identify who's thriving, who's at risk of churning, and who's ready for expansion.

## Instructions

1. **Gather account data**:
   - Usage metrics (sessions, operation maps created/updated, exports, team activity)
   - Subscription status (tier, billing history, trial dates)
   - Support interactions (tickets, decision files, blocked tasks)
   - CRM lifecycle stage and properties
   - Last meaningful product interaction date

2. **Score account health**:
   - **Green (Healthy)**: Regular usage, growing adoption, expanding team
   - **Yellow (At Risk)**: Declining usage, approaching tier limits without upgrading, stale account
   - **Red (Churn Risk)**: No usage in 14+ days, failed payments, support escalations

3. **Identify churn signals**:
   - Usage decline over 2+ weeks
   - Feature abandonment (used feature X, then stopped)
   - Trial ending with low activation
   - Payment failures
   - Support frustration (repeated issues, unresolved blockers)

4. **Identify expansion signals**:
   - Hitting tier limits frequently
   - Adding team members
   - Using advanced features
   - High session frequency
   - Positive feedback or referral activity

5. **Prioritize by impact**:
   - Higher-tier accounts get priority
   - Partner accounts get priority (revenue multiplier)
   - Recent sign-ups in trial get priority (conversion window)

## Output

Write health assessment with account-level scores, risk flags, and expansion signals. Transition to `/cs-intervention`.
