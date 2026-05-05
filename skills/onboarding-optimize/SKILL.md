---
name: onboarding-optimize
description: Optimize post-signup onboarding for faster time-to-value — activation definition, flow design, checklist patterns, empty states, and stalled user recovery
allowed-tools: Read, Write, Glob, Grep
---

# Onboarding Optimization

## Objective

Help users reach their "aha moment" as quickly as possible and establish habits that lead to long-term retention.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What's the current post-signup experience?
   - Where do users drop off?
   - Is there an activation definition?

2. **Define the activation event** — the action that most strongly correlates with retention:
   - What do retained users do that churned users don't?
   - What's the earliest indicator of future engagement?
   - Examples: project management → create first project + add team member; analytics → install tracking + see first report; marketplace → complete first transaction

   **Activation metrics to track:**
   - % of signups who reach activation
   - Time to activation
   - Steps to activation
   - Activation by cohort/source

3. **Design the immediate post-signup experience** (first 30 seconds):

   | Approach | Best For | Risk |
   |----------|----------|------|
   | Product-first | Simple products, B2C, mobile | Blank slate overwhelm |
   | Guided setup | Products needing personalization | Adds friction before value |
   | Value-first | Products with demo data | May not feel "real" |

   Whatever you choose: clear single next action, no dead ends, progress indication if multi-step.

4. **Design onboarding checklist** (if multi-step setup required):
   - 3-7 items (not overwhelming)
   - Order by value (most impactful first)
   - Start with quick wins
   - Progress bar / completion %
   - Celebration on completion
   - Dismiss option (don't trap users)

5. **Design empty states** — every empty state is an onboarding opportunity:
   - Explain what this area is for
   - Show what it looks like with data (preview/example)
   - Clear primary action to add first item
   - Optional: pre-populate with example data

6. **Plan multi-channel coordination**:

   **Trigger-based emails:**
   - Welcome (immediate)
   - Incomplete onboarding (24h, 72h)
   - Activation achieved (celebration + next step)
   - Feature discovery (days 3, 7, 14)

   Email should reinforce in-app actions, not duplicate them. Drive back to product with specific CTA.

7. **Handle stalled users**:
   - Define "stalled" criteria (X days inactive, incomplete setup)
   - Email re-engagement: reminder of value, address blockers, offer help
   - In-app recovery: welcome back message, pick up where they left off
   - Human touch: for high-value accounts, personal outreach

8. **Map the funnel and find biggest drops**:
   ```
   Signup → Step 1 → Step 2 → Activation → Retention
   100%      80%       60%       40%         25%
   ```
   Focus optimization effort on the biggest drop-off point.

## Core Principles

- **Time-to-value is everything** — remove every step between signup and core value
- **One goal per session** — focus first session on one successful outcome
- **Do, don't show** — interactive > tutorial; doing the thing > learning about it
- **Progress creates motivation** — show advancement, celebrate completions

## Output

Write deliverable to `.deliberate/reports/{slug}/onboarding-optimization.md` including:
- Activation event definition with success metric
- Onboarding flow design (step-by-step)
- Checklist items (if applicable) with copy
- Empty state designs with copy
- Email trigger map with timing
- Funnel analysis with optimization priorities
