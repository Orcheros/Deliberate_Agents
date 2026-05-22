---
name: customer-journey-map
description: Map the end-to-end customer journey — touchpoints, emotions, pain points, and opportunities across all stages from awareness through advocacy or churn
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:awareness"
---

# Customer Journey Map

## Objective

Produce an end-to-end customer journey map covering every stage from initial awareness through advocacy (or churn). For each stage, document touchpoints, user actions, emotional states, pain points, opportunities, and key metrics. The map serves as a shared reference for product, marketing, support, and success teams.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Which persona or segment is this journey map for?
   - Is this a current-state map, future-state map, or both?
   - What specific journey or use case to focus on (if not the full lifecycle)?

2. **Gather journey data from multiple sources**:
   - User research: interview transcripts, usability studies, session recordings
   - Analytics: funnel data, drop-off rates, time-between-stages
   - Support data: ticket themes by lifecycle stage, common questions at each point
   - Sales data: objections, decision criteria, buying process insights
   - NPS/CSAT: satisfaction scores mapped to lifecycle stage
   - Existing persona documents and segmentation reports
   - Document data gaps and where the map relies on assumptions

3. **Define journey stages and map each one**:

   **Stage 1 — Awareness**:
   - How do users first learn the product exists?
   - Touchpoints: search, social, referral, content, ads, word-of-mouth
   - User actions: searching for solutions, reading comparisons, asking peers
   - Thoughts/emotions: frustration with current solution, curiosity, skepticism
   - Pain points: hard to find, unclear value proposition, too many options
   - Opportunities: content that matches search intent, social proof, clear positioning

   **Stage 2 — Consideration**:
   - How do users evaluate and compare?
   - Touchpoints: website, pricing page, demos, free trial, review sites
   - User actions: comparing features, reading reviews, checking pricing, asking for demos
   - Thoughts/emotions: cautious optimism, comparison fatigue, price sensitivity
   - Pain points: unclear differentiation, hidden pricing, no trial available
   - Opportunities: comparison content, transparent pricing, easy trial start

   **Stage 3 — Acquisition**:
   - What does the sign-up or purchase flow look like?
   - Touchpoints: registration, payment, welcome email, account setup
   - User actions: creating account, entering payment, configuring settings
   - Thoughts/emotions: commitment anxiety, excitement, impatience
   - Pain points: long forms, unclear next steps, payment friction
   - Opportunities: streamlined signup, immediate value, clear onboarding path

   **Stage 4 — Onboarding**:
   - How do users go from sign-up to first value?
   - Touchpoints: setup wizard, first-run experience, docs, support, onboarding emails
   - User actions: completing setup, importing data, learning features, hitting first milestone
   - Thoughts/emotions: overwhelm, confusion, relief when something works
   - Pain points: too many steps, no clear path, unclear terminology, data migration pain
   - Opportunities: guided setup, quick wins, proactive support, progress indicators

   **Stage 5 — Core Usage**:
   - What does regular, successful usage look like?
   - Touchpoints: daily/weekly product use, feature discovery, integrations, support
   - User actions: core workflows, feature exploration, customization, collaboration
   - Thoughts/emotions: productivity, occasional frustration, habit formation
   - Pain points: missing features, performance issues, workflow gaps, learning curve
   - Opportunities: feature education, workflow optimization, power-user features

   **Stage 6 — Expansion**:
   - How do users grow their usage or spend?
   - Touchpoints: upgrade prompts, new feature announcements, usage limits, team invites
   - User actions: inviting teammates, upgrading plans, adopting advanced features
   - Thoughts/emotions: growing investment, budget justification anxiety, ROI questions
   - Pain points: unclear upgrade value, sticker shock, admin complexity
   - Opportunities: usage-based upsell, team collaboration features, ROI documentation

   **Stage 7 — Advocacy (or Churn)**:
   - What determines whether users become advocates or leave?
   - **Advocacy path**: referrals, reviews, case studies, community participation, social sharing
   - **Churn path**: disengagement signals, competitor evaluation, cancellation flow
   - Touchpoints: referral program, review requests, cancellation page, exit survey
   - Thoughts/emotions: loyalty vs. frustration, switching cost calculation, betrayal if broken
   - Pain points: no referral incentive, hard to cancel, ignored feedback, better alternatives
   - Opportunities: referral program, win-back campaigns, exit interviews, proactive retention

4. **Score emotional states across the journey**:
   - Use a -2 to +2 scale at each stage: very negative, negative, neutral, positive, very positive
   - Plot an emotion curve showing highs and lows across the full journey
   - Identify the critical "moments of truth" where emotions swing strongly

5. **Define key metrics per stage**:
   - Awareness: traffic sources, brand search volume, content engagement
   - Consideration: website visits, pricing page views, trial starts, demo requests
   - Acquisition: conversion rate, time-to-signup, signup completion rate
   - Onboarding: activation rate, time-to-first-value, setup completion rate
   - Core Usage: DAU/WAU/MAU, feature adoption, session depth, support ticket rate
   - Expansion: upgrade rate, seat expansion, feature upsell conversion
   - Advocacy/Churn: NPS, referral rate, churn rate, expansion revenue rate

6. **Identify improvement opportunities and prioritize**:
   - List all pain points and opportunities discovered
   - Score each by: impact on conversion/retention (1-5), feasibility (1-5), urgency (1-5)
   - Group into quick wins, medium-term improvements, and strategic investments
   - Link opportunities to specific product, marketing, or support actions

## Output

Write deliverable to `.deliberate/reports/{slug}/customer-journey-map.md` including:
- Journey map table: stages as columns, rows for touchpoints, actions, thoughts/emotions, pain points, opportunities, metrics
- Emotion curve visualization (ASCII or described for implementation)
- Moments of truth: the 3-5 most critical points in the journey
- Improvement recommendations per stage, prioritized by impact and feasibility
- Methodology: data sources, persona/segment mapped, assumptions flagged

## Constraints

- Always specify which persona or segment the journey map represents — avoid generic "the user"
- Never fabricate journey data — synthesize from available research, flag assumptions
- Current-state maps must reflect reality, not aspirations — save aspirations for future-state
- Every touchpoint must be grounded in actual product/marketing/support touchpoints that exist today
- Separate observed behavior from inferred emotions — label each clearly

## Transition

Journey maps feed into product prioritization, onboarding optimization, and campaign planning. They inform `/analyze-feedback` by providing stage context for feedback themes, and connect to `/experiment-design` for testing improvement hypotheses.
