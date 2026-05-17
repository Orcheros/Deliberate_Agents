---
name: product-strategy-canvas
description: Build a comprehensive 9-section Product Strategy Canvas that connects vision to execution through structured strategic analysis
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Product Strategy Canvas

## Objective

Produce a comprehensive Product Strategy Canvas that synthesizes product vision, customer insight, market positioning, and business model into a single strategic artifact. The canvas serves as the bridge between high-level vision and tactical roadmap decisions.

Unlike a business model canvas (which focuses on the business), the Product Strategy Canvas focuses on the product itself — what it is, who it serves, why it wins, and how it creates and captures value. It is the strategic foundation that PRDs, roadmaps, and OKRs are built upon.

## Process

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Identify the product or initiative requiring strategic analysis
   - Note any existing vision, strategy, or research documents
   - Check for prior canvases that may need updating rather than creating from scratch

2. **Gather inputs**:
   - Read the product vision document if it exists (from product-vision skill)
   - Review existing PRDs, one-pagers, and customer research
   - Examine the codebase README and product documentation for current capabilities
   - Collect any available market data, competitive analysis, or user feedback

3. **Section 1 — Vision**:
   - State the product vision (from product-vision skill or founder input)
   - Define the time horizon (3-5 years)
   - Articulate the "big bet" — what must be true for this vision to succeed?
   - Guiding question: "What future are we creating?"

4. **Section 2 — Target Customer**:
   - Define primary and secondary customer segments using Jobs-to-be-Done framework
   - For each segment: demographic, psychographic, behavioral characteristics
   - Identify the beachhead segment (first to win, highest urgency + lowest switching cost)
   - Map the buyer vs. user vs. influencer for each segment
   - Guiding question: "Who are we building for, and who do we win first?"

5. **Section 3 — Problem / Need**:
   - Articulate the top 3 problems or unmet needs for each target segment
   - Rank by severity (hair-on-fire vs. nice-to-have) using the Problem Stack framework
   - Identify how customers currently solve these problems (existing alternatives)
   - Quantify the cost of the current solution (time, money, frustration, risk)
   - Guiding question: "What pain are we relieving or gain are we creating?"

6. **Section 4 — Value Proposition**:
   - Craft a value proposition for each target segment using the Value Proposition Canvas
   - Map: Customer Jobs -> Pains -> Gains against Product Features -> Pain Relievers -> Gain Creators
   - Identify the "must-have" vs. "nice-to-have" value elements
   - Test for clarity: can a customer understand the value in under 10 seconds?
   - Guiding question: "Why will customers choose us?"

7. **Section 5 — Strategic Differentiation**:
   - Position the product on key competitive dimensions
   - Identify the 2-3 dimensions where you will be categorically different (not just better)
   - Apply the "only we" test: "Only [product] does [X] because [Y]"
   - Distinguish between temporary advantages (features) and durable advantages (architecture, data, network effects)
   - Guiding question: "What makes us defensibly different?"

8. **Section 6 — Key Capabilities**:
   - List the 5-7 capabilities the product must have to deliver the value proposition
   - Distinguish between table-stakes capabilities (must have to compete) and differentiating capabilities (must have to win)
   - Map capabilities to the team's current strengths and gaps
   - Identify build vs. buy vs. partner decisions for each capability
   - Guiding question: "What must we be excellent at?"

9. **Section 7 — Revenue Model**:
   - Define the primary monetization mechanism (subscription, usage, transaction, etc.)
   - Identify the value metric — what unit does the customer pay for?
   - Map pricing tiers to customer segments
   - Estimate unit economics: CAC, LTV, payback period targets
   - Guiding question: "How do we capture value?"

10. **Section 8 — Key Metrics**:
    - Define the North Star Metric — the single metric that best captures customer value delivery
    - Identify 3-5 supporting input metrics that drive the North Star
    - Set guardrail metrics that protect against perverse optimization
    - Map metrics to the pirate funnel (Acquisition, Activation, Retention, Revenue, Referral)
    - Guiding question: "How do we know we're winning?"

11. **Section 9 — Defensibility / Moat**:
    - Assess current and planned moat sources:
      - **Network effects**: Does the product get better as more people use it?
      - **Switching costs**: What would a customer lose by leaving?
      - **Scale economies**: Do unit costs decrease with volume?
      - **Brand**: Is there trust or reputation that competitors can't easily replicate?
      - **Data**: Does usage generate proprietary data that improves the product?
      - **Regulatory**: Are there compliance barriers that protect incumbents?
    - Rate each moat source: none / emerging / established / strong
    - Identify the moat-building strategy — what investments deepen defensibility over time?
    - Guiding question: "Why can't a well-funded competitor replicate this in 18 months?"

12. **Synthesize and validate**:
    - Check internal consistency — do all 9 sections reinforce each other?
    - Identify tensions or contradictions between sections
    - Stress-test with "what if" scenarios (competitor response, market shift, technology change)
    - Flag the top 3 strategic risks and proposed mitigations

## Output

Write deliverable to `.deliberate/reports/{slug}/product-strategy-canvas.md` including:
- Executive summary (1-paragraph strategic thesis)
- All 9 canvas sections with detailed analysis
- Visual canvas summary (markdown table format)
- Internal consistency assessment
- Top 3 strategic risks with mitigations
- Key assumptions and validation experiments needed
- Recommended review cadence (quarterly)

## Constraints

- Every section must reference real data or explicitly flag assumptions
- Do not skip sections — an incomplete canvas creates blind spots
- The canvas is a living document, not a one-time exercise — note what needs validation
- Avoid generic statements that could apply to any product ("we provide great customer service")
- Each section should be specific enough that a new team member could understand the strategy without additional context
- Do not confuse strategic differentiation with feature lists — features are tactics, differentiation is positioning

## Transition

The Product Strategy Canvas feeds directly into lean-canvas and business-model-canvas for business model validation, market-scan for competitive analysis, and brainstorm-okrs for goal-setting. It is the primary strategic reference for the product-manager agent when writing PRDs.
