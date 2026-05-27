---
name: pr-press
description: Create press releases, media kits, journalist outreach plans, and pitch materials for product launches and company milestones
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:awareness"
---

# PR & Press

## Objective

Create press and media materials for product launches, company milestones, and newsworthy events. Produce a complete press kit that a founder or PR lead can use for media outreach.

## Instructions

1. **Read context**:
   - Read assignment file for what's being announced
   - Read GTM context (injected automatically) for company background, traction, positioning
   - If this is tied to a launch, read the `/launch-strategy` output for launch tier and timing

2. **Determine PR tier** (mirrors launch-strategy tiers):
   - **Tier 1 — Full press push**: New product launch, major funding round, significant partnership, IPO/acquisition. Warrants press release + media kit + journalist outreach + pitch deck.
   - **Tier 2 — Targeted outreach**: Major feature release, notable customer win, industry award. Press release + targeted journalist outreach.
   - **Tier 3 — Press release only**: Minor product update, team milestone, industry commentary. Press release for distribution, no active outreach.

3. **Write the press release** (see `press-release-template.md`):
   - Follow inverted pyramid structure (most important information first)
   - Lead with the news, not the company
   - Include a quantified impact statement where possible
   - Founder/CEO quote that adds perspective (not just restating the news)
   - Customer/partner quote if available and relevant
   - Company boilerplate at the end

4. **Build the media kit** (Tier 1 and 2 only):
   - **Fact sheet**: Company founding date, team size, funding, key metrics, mission
   - **Executive bios**: Founder and key team members (2-3 sentences each, third person)
   - **Product screenshots/assets list**: What visuals are available, where they live
   - **Pricing summary**: Current tiers and positioning (reference GTM context Section 5)
   - **Media contact**: Name, email, phone for press inquiries

5. **Build journalist outreach plan** (Tier 1 and 2 only):
   - **Target list by tier**:
     - Tier A: Top tech press (TechCrunch, The Verge, Wired, etc.) — for Tier 1 launches only
     - Tier B: Industry vertical press — publications covering your specific market
     - Tier C: Niche blogs, newsletters, podcasts — highest response rate, most targeted
   - **Personalized pitch angle** per outlet/journalist:
     - What angle would interest their specific audience?
     - Reference their recent coverage to show relevance
   - **Timing strategy**:
     - Embargo: offer Tier A outlets 24-48h exclusivity for Tier 1 news
     - Day-of: simultaneous outreach to Tier B and C
     - Post-launch: follow-up pitches with early traction data (1-2 weeks after)
   - **Follow-up cadence**: Initial pitch → 3-day follow-up → 7-day final follow-up → stop

6. **Create pitch deck outline** (Tier 1 only):
   - Slide 1: The headline (what's new and why it matters)
   - Slide 2: Market context (the problem in the industry)
   - Slide 3: Product story (what you built and how it works)
   - Slide 4: Traction / social proof (metrics, customers, growth)
   - Slide 5: What's next (roadmap tease, vision)
   - Slide 6: Demo opportunity / media contact

## Constraints

- Never fabricate metrics, user counts, or traction data — use only verified numbers from GTM context
- Never promise exclusives to multiple outlets simultaneously
- Embargo dates must be explicit and clearly communicated
- All claims must be verifiable and defensible
- Include `[HUMAN GATE]` markers for:
  - Actual journalist contact (emails, DMs, calls)
  - Embargo commitments
  - Quote approval from named individuals
  - Any external publication or distribution

## Output

Write the complete press kit to `.deliberate/reports/{slug}/gtm/pr-press-kit.md`, organized by section:
1. Press Release
2. Media Kit (if Tier 1 or 2)
3. Journalist Outreach Plan (if Tier 1 or 2)
4. Pitch Deck Outline (if Tier 1)

## Companion Docs

- `press-release-template.md` — Structural template for the press release with field-by-field guidance.

## Transition

Feeds into:
- `/launch-strategy` — PR activities are part of the broader launch plan
- `/content-draft` — Blog post announcement version of the press release
- `/email-sequence` — Announcement email to customers and prospects
