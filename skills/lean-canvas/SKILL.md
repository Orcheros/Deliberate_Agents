---
name: lean-canvas
description: Build an Ash Maurya Lean Canvas to validate business model hypotheses for early-stage products and new initiatives
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Lean Canvas

## Objective

Produce a Lean Canvas (Ash Maurya's adaptation of the Business Model Canvas for startups) that captures the riskiest assumptions in a new product or initiative on a single page. The Lean Canvas is designed for speed and learning — it prioritizes problem-solution fit over operational completeness.

Unlike the Business Model Canvas, the Lean Canvas replaces Key Partners, Key Activities, Key Resources, and Customer Relationships with Problem, Solution, Key Metrics, and Unfair Advantage — reflecting the reality that early-stage ventures need to validate demand before optimizing operations.

## Process

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Identify the product, feature, or initiative to canvas
   - Note the current stage (idea, pre-launch, early traction, scaling)
   - Check for existing strategy documents, one-pagers, or product-strategy-canvas output

2. **Start with Customer Segments (right side first)**:
   - List all possible customer segments
   - Identify the beachhead segment — the narrowest viable audience with the most urgent need
   - Distinguish between users (who use the product) and customers (who pay)
   - For the beachhead: describe their context, constraints, and current behavior
   - Apply the "would they take a meeting?" test — is the problem urgent enough that they'd invest time to hear your pitch?

3. **Define the Problem (top 3)**:
   - List the top 3 problems for the beachhead segment, ranked by severity
   - For each problem, describe:
     - The current situation and why it's painful
     - How customers currently solve it (existing alternatives)
     - Why existing alternatives are inadequate
   - Apply the Problem Severity Scale:
     - **Level 1 — Latent**: Customer has the problem but doesn't know it
     - **Level 2 — Passive**: Customer knows but isn't actively seeking a solution
     - **Level 3 — Active**: Customer is actively searching for a solution
     - **Level 4 — Urgent**: Customer has budget allocated and a deadline
   - Focus on Level 3-4 problems for the beachhead

4. **Identify Existing Alternatives**:
   - For each problem, list what customers do today (including "do nothing")
   - Include direct competitors, indirect competitors, and manual workarounds
   - Note what each alternative gets right and where it falls short
   - This is competitive intelligence — be specific, not generic

5. **Craft the Unique Value Proposition**:
   - Write a single, clear sentence that explains why you are different AND worth paying attention to
   - Use the formula: "[End result customer wants] without [pain/cost of current approach]"
   - Test against the "so what?" challenge — does it pass?
   - The UVP is NOT a feature list — it's the promise
   - Include a high-concept pitch: "[Known thing] for [target market]" (e.g., "Flickr for video" = YouTube)

6. **Define the Solution**:
   - For each of the top 3 problems, describe the simplest solution that addresses it
   - Resist the urge to over-specify — the Lean Canvas solution is a hypothesis, not a spec
   - Focus on the minimum feature set that delivers the UVP
   - Bind each solution element to a specific problem — no orphan features
   - Note which solutions are validated vs. assumed

7. **Map Channels**:
   - Identify the path to reaching the beachhead segment
   - Distinguish between:
     - **Inbound channels**: content, SEO, community, word-of-mouth
     - **Outbound channels**: sales, ads, partnerships, events
     - **Product channels**: virality, PLG, referral loops
   - For each channel, estimate: reach, cost, conversion potential, and time to results
   - Start with channels that allow direct customer contact (for learning)

8. **Define Revenue Streams**:
   - Identify the primary revenue model (subscription, usage, transaction, license, etc.)
   - Set initial pricing based on value delivered, not cost
   - Apply the 10x rule: price should be < 1/10th of the value the customer receives
   - Estimate revenue per customer and target number of customers for viability
   - Note whether pricing is validated or assumed
   - For freemium: define the free-to-paid conversion trigger

9. **Define Cost Structure**:
   - List the major cost categories: people, infrastructure, marketing, operations
   - Identify fixed costs vs. variable costs
   - Calculate burn rate and runway implications
   - Determine the break-even point (number of customers or revenue needed)
   - Flag the largest cost risks

10. **Define Key Metrics**:
    - Identify the one metric that matters most at the current stage:
      - **Problem-solution fit stage**: engagement, retention, qualitative feedback
      - **Product-market fit stage**: retention, NPS, organic growth
      - **Scale stage**: unit economics, channel efficiency, market share
    - Map 3-5 supporting metrics to the pirate funnel (AARRR)
    - Set concrete targets for each metric with a time horizon

11. **Articulate Unfair Advantage**:
    - Define what cannot be easily copied or bought by competitors
    - Valid unfair advantages: insider knowledge, proprietary data, network effects, community, existing customers, team expertise, regulatory advantage
    - Invalid unfair advantages: features (can be copied), first-mover (rarely durable), passion (not a moat)
    - Be honest — most early-stage ventures don't have one yet, and that's okay
    - If none exists, describe the planned path to developing one

12. **Identify and rank riskiest assumptions**:
    - Extract the top 3-5 assumptions that, if wrong, would invalidate the canvas
    - Categorize: customer risk, problem risk, solution risk, market risk, business model risk
    - For each assumption, propose a validation experiment
    - Order experiments by: most critical assumption first, cheapest test first

## Output

Write deliverable to `.deliberate/reports/{slug}/lean-canvas.md` including:
- Visual Lean Canvas in markdown table format (single-page view)
- Detailed analysis for each of the 9 blocks
- Existing alternatives analysis
- Riskiest assumptions ranked with validation experiments
- Stage assessment (which risks have been de-risked, which remain)
- Recommended next experiments to run

## Constraints

- The canvas should fit conceptually on one page — if any section requires more than a paragraph, you're over-specifying
- Do not treat the canvas as a plan — it is a set of hypotheses to test
- Customer Segments must be specific enough to find in real life (not "SMBs" — which SMBs?)
- Never list a feature as an Unfair Advantage unless it involves proprietary technology that takes years to replicate
- If data is unavailable, state assumptions clearly and flag for validation
- The canvas is a snapshot — include the date and note that it should be revised after each pivot or major learning

## Transition

The Lean Canvas feeds into experiment-design for validating riskiest assumptions, monetization-strategy for deeper revenue model exploration, and market-scan for competitive validation. Assumptions flagged here should be tracked and updated as evidence accumulates.
