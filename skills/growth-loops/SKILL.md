---
name: growth-loops
description: Design sustainable growth loops and flywheels — viral, content, paid, sales, and product loops with cycle metrics and amplification analysis
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Growth Loops

## Objective

Design sustainable, compounding growth loops (flywheels) that drive acquisition, engagement, and retention. Unlike linear funnels, loops reinvest their output as new input — creating compounding growth rather than diminishing returns.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What product or feature are we designing growth loops for?
   - What is the current primary acquisition channel?
   - What growth stage is the product in (pre-PMF, early growth, scaling)?
   - What data is available on current growth mechanics?

2. **Identify candidate loops across five types**:

   **Viral Loops** (user actions bring new users):
   - Invite loops: user invites others to collaborate → new users onboard
   - Social sharing: user creates content → shares externally → drives sign-ups
   - Word-of-mouth: user experiences value → tells peers → referrals
   - Embedded virality: product output contains product branding → viewers become users

   **Content Loops** (content creation drives discovery):
   - User-generated content → SEO indexing → organic traffic → new users → more content
   - Company content → organic/social distribution → traffic → sign-ups → usage data → better content
   - Community content → engagement → search visibility → new members → more content

   **Paid Loops** (revenue funds acquisition):
   - Revenue → ad spend → new customers → revenue (sustainable when LTV > CAC)
   - Revenue → affiliate/referral payouts → new customers → revenue
   - Revenue → sponsorship/partnerships → exposure → new customers → revenue

   **Sales Loops** (customers enable more sales):
   - Customer success → case study → prospect trust → new customer → new case study
   - Customer → reference call → prospect conversion → new customer → new reference
   - Expansion revenue → customer success investment → more expansion

   **Product Loops** (product usage drives more usage):
   - Data network effects: more users → more data → better product → more users
   - Marketplace: more supply → more buyers → more supply
   - Platform: more integrations → more value → more users → more integrations

3. **Map each candidate loop** with the four-step structure:

   ```
   TRIGGER → ACTION → OUTPUT → RE-TRIGGER
   ```

   For each loop, define:
   - **Trigger**: What initiates the loop? (e.g., user completes onboarding)
   - **Action**: What does the user do? (e.g., invites 3 teammates)
   - **Output**: What result is produced? (e.g., 3 invitation emails sent)
   - **Re-trigger**: How does the output become a new trigger? (e.g., invitee signs up and completes onboarding)

   Create an ASCII diagram for each loop:

   ```
   ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
   │ TRIGGER  │───>│  ACTION  │───>│  OUTPUT  │───>│RE-TRIGGER│
   │          │    │          │    │          │    │          │
   │ User     │    │ Invites  │    │ 3 emails │    │ Invitee  │
   │ onboards │    │ team     │    │ sent     │    │ signs up │
   └──────────┘    └──────────┘    └──────────┘    └─────┬────┘
        ^                                                │
        └────────────────────────────────────────────────┘
   ```

4. **Evaluate each loop quantitatively**:

   | Metric | Definition | How to Measure |
   |--------|-----------|----------------|
   | **Cycle time** | How long one full loop takes | Time from trigger to re-trigger |
   | **Conversion at each step** | % that complete each step | Step N output / Step N input |
   | **Amplification factor** | Users out per user in | Re-triggers / initial triggers |
   | **Cost per cycle** | $ to run one loop iteration | Total cost / completions |
   | **Loop efficiency** | Overall loop conversion | End-to-end completion rate |
   | **Payback period** | Time to recoup cycle cost | Cost per cycle / revenue per user |

   **Amplification factor is the key metric**:
   - < 1.0: Loop decays (needs external input to sustain)
   - = 1.0: Loop sustains (steady state)
   - > 1.0: Loop compounds (viral growth)
   - Most loops are < 1.0 and work as amplifiers of other channels, not standalone engines

5. **Identify primary and secondary loops**:
   - **Primary loop**: The one loop that will drive the majority of growth. Must be the most defensible, highest-amplification, and most aligned with the product's core value.
   - **Secondary loops**: Supporting loops that amplify the primary loop or serve specific segments
   - **Interaction effects**: How loops reinforce each other (e.g., content loop feeds awareness for the viral loop)

6. **Design the metrics framework**:
   - Define leading indicators for each step of the primary loop
   - Set targets for cycle time, conversion rates, and amplification factor
   - Identify the bottleneck step (lowest conversion) and recommend experiments to improve it
   - Define monitoring cadence (daily/weekly/monthly per metric)

7. **Produce growth loop implementation plan**:
   - Prioritize loops by: current feasibility, amplification potential, alignment with product stage
   - For the primary loop: specific product/marketing changes needed to activate it
   - Quick experiments to validate loop mechanics before full investment
   - Dependencies and sequencing (which loops require which capabilities)

## Output

Write deliverable to `.deliberate/reports/{slug}/growth-loops.md` including:
- Candidate loop inventory (all types considered)
- ASCII loop diagrams for top 3-5 loops
- Quantitative evaluation table (cycle time, conversions, amplification factor, cost)
- Primary loop selection with rationale
- Secondary loop recommendations
- Loop interaction map
- Metrics framework with targets
- Implementation plan with prioritized experiments

## Constraints

- Be honest about amplification factors — most loops are sub-1.0 amplifiers, not viral engines
- Do not confuse a linear funnel with a loop — the output must re-trigger input
- Every conversion estimate must be flagged as "measured" or "assumed"
- Loops must be grounded in the product's actual mechanics, not theoretical possibilities
- Account for loop decay — early adopters behave differently than later cohorts
- Do not recommend more than one primary loop — focus is essential

## Transition

Growth loops feed into `/experiment-design` (to validate loop mechanics), `/north-star-metric` (loops should drive the NSM), and `/growth-plan` (loops become the core of the growth plan).
