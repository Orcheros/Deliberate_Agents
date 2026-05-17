---
name: monetization-strategy
description: Brainstorm and evaluate 3-5 monetization strategies with pricing structures, revenue projections, validation experiments, and a comparison matrix
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Monetization Strategy

## Objective

Brainstorm, structure, and evaluate 3-5 viable monetization strategies for a product or initiative. Each strategy must include a concrete pricing structure, revenue projection framework, validation experiment, and risk assessment. The output is a comparison matrix that enables an informed decision about which monetization approach to pursue.

This skill goes beyond selecting a pricing model — it examines the full monetization system: what value is captured, from whom, through what mechanism, at what price point, and how the model evolves as the product scales. The goal is to find the monetization approach that maximizes long-term value capture while aligning incentives between the company and its customers.

## Process

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Identify the product or initiative requiring monetization analysis
   - Note the current stage: pre-revenue, early revenue, scaling revenue
   - Check for existing lean-canvas, business-model-canvas, or pricing research

2. **Assess the value landscape**:
   - What value does the product create for customers? (cost savings, revenue increase, time savings, risk reduction, delight)
   - Quantify the value where possible — if the product saves 10 hours/week at $50/hour, the value is $26,000/year
   - Identify the "value metric" — the unit of value that correlates most strongly with customer willingness to pay
   - Common value metrics: per user, per transaction, per GB, per API call, per project, per outcome
   - Map value delivery across the customer lifecycle — when does value accrue?

3. **Brainstorm monetization models**:
   - Generate 3-5 distinct monetization strategies from these archetypes:
     - **SaaS Subscription**: Flat monthly/annual fee, tiered by feature or usage
     - **Usage-Based**: Pay per unit of consumption (API calls, storage, transactions)
     - **Freemium + Premium**: Free base tier with paid upgrades
     - **Per-Seat Licensing**: Price scales with number of users
     - **Transaction Fee**: Percentage or flat fee per transaction processed
     - **Marketplace Commission**: Take-rate on transactions between parties
     - **Platform + Add-ons**: Base platform with paid extensions/integrations
     - **Outcome-Based**: Price tied to measurable customer outcomes
     - **Hybrid Models**: Combine 2+ models (e.g., base subscription + usage overage)
   - For each model, consider: does this align incentives? (Customer success = company revenue)
   - Eliminate models that create perverse incentives or misalign with the product's value delivery

4. **Structure each monetization strategy (repeat for each of 3-5 strategies)**:

   **a) Model Definition**:
   - Name the strategy clearly (e.g., "Tiered SaaS Subscription" not just "Subscription")
   - Define the value metric and pricing unit
   - Describe how the customer pays (monthly, annually, per-event, hybrid)
   - Define tiers or pricing levels if applicable

   **b) Pricing Structure**:
   - Set specific price points (even if preliminary — ranges are acceptable)
   - Apply pricing psychology principles:
     - Anchoring: position the target tier between a cheaper and expensive option
     - Decoy effect: include a tier that makes the target tier look like the best deal
     - Price ending: $49 vs. $50 vs. $47 — consider signaling
   - Define what's included and excluded at each tier
   - Set annual vs. monthly pricing (typically 15-20% annual discount)
   - Identify the "land" price (initial adoption) vs. "expand" triggers (upsell moments)

   **c) Revenue Projection Framework**:
   - Define the revenue formula: Revenue = Customers x ARPU x Retention Rate
   - Estimate realistic customer acquisition rates by channel
   - Project ARPU based on tier mix assumptions
   - Model 3 scenarios: conservative, base case, optimistic
   - Calculate key metrics: MRR, ARR, net revenue retention, expansion revenue
   - Identify the revenue scale needed for business viability (break-even point)

   **d) Validation Experiment**:
   - Design a specific experiment to test the model before full commitment
   - Experiment types:
     - **Fake door test**: Present pricing page, measure click-through
     - **Willingness-to-pay survey**: Van Westendorp or Gabor-Granger method
     - **Beta pricing**: Offer early adopters the pricing model, measure conversion and feedback
     - **A/B test pricing pages**: Test different price points or tier structures
     - **Concierge pricing**: Manually price and bill early customers, learn from interactions
   - Define success criteria: what conversion rate or willingness-to-pay level validates this model?
   - Estimate time and cost to run the experiment

   **e) Risk Assessment**:
   - Identify the top 3 risks for this model:
     - **Customer risk**: Will customers accept this pricing structure?
     - **Competitive risk**: Can competitors undercut or offer a different model?
     - **Execution risk**: Can we technically implement this billing model?
     - **Retention risk**: Does this model encourage churn or lock-in?
     - **Growth risk**: Does the model scale or create growth ceilings?
   - For each risk, assess likelihood (high/medium/low) and impact (high/medium/low)
   - Identify mitigations for the highest-impact risks

5. **Build the comparison matrix**:
   - Create a table comparing all strategies across these dimensions:
     - Revenue potential (low/medium/high)
     - Time to revenue (immediate/short/medium/long)
     - Implementation complexity (low/medium/high)
     - Customer alignment (how well incentives align)
     - Competitive differentiation (does this model itself create advantage?)
     - Scalability (does revenue scale with value delivery?)
     - Predictability (how stable and forecastable is the revenue?)
     - Expansion potential (natural upsell/cross-sell opportunities)
   - Score each dimension 1-5 and calculate a weighted total
   - Define the weights based on current company priorities (e.g., if runway is short, weight "time to revenue" heavily)

6. **Recommend a primary strategy and contingency**:
   - Select the top-scoring strategy as the primary recommendation
   - Select a contingency strategy in case the primary model fails validation
   - Define the decision criteria for switching from primary to contingency
   - Outline the implementation sequence: what to build first, what to validate, when to commit

7. **Map the monetization evolution path**:
   - How does the monetization strategy evolve across company stages?
   - Early stage: simple pricing, manual billing acceptable, focus on learning
   - Growth stage: self-serve billing, tier optimization, expansion revenue
   - Scale stage: enterprise pricing, volume discounts, custom deals, platform fees
   - Identify the transition triggers — when does the model need to evolve?

## Output

Write deliverable to `.deliberate/reports/{slug}/monetization-strategy.md` including:
- Executive summary with primary recommendation
- Value landscape assessment
- 3-5 fully structured monetization strategies (model, pricing, projections, experiment, risks)
- Comparison matrix with scoring
- Primary recommendation with rationale
- Contingency strategy and switching criteria
- Monetization evolution roadmap
- Validation experiment priority and sequence
- Key assumptions and sensitivity analysis

## Constraints

- Always generate at least 3 distinct strategies — avoid fixating on the obvious choice
- Price points must be justified by value analysis, not pulled from air or competitor copying
- Revenue projections must state assumptions explicitly — never present projections as facts
- Do not recommend "free forever" without a clear monetization path — sustainability matters
- Consider the billing implementation cost — a perfect model that takes 6 months to build may not be optimal
- Distinguish between pricing (what you charge) and monetization (how you capture value from the entire business model)
- Flag when a strategy requires infrastructure the product doesn't have (payment processing, usage metering, etc.)

## Transition

Artifacts feed into pricing-strategy-analysis for deeper pricing optimization, experiment-design for running validation experiments, and business-model-canvas for updating the Revenue Streams block. The recommended strategy informs brainstorm-okrs revenue targets.
