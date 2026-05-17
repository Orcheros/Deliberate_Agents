---
name: pricing-strategy-analysis
description: Conduct research-focused pricing analysis covering pricing models, competitive pricing, willingness-to-pay estimation, price elasticity, and pricing experiment design
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Pricing Strategy Analysis

## Objective

Conduct a rigorous, research-focused pricing analysis that produces actionable pricing recommendations grounded in competitive intelligence, customer value perception, and economic theory. This skill is distinct from execution-focused pricing skills — it operates upstream, informing pricing decisions before they are implemented.

Pricing is the single highest-leverage variable in a business model. A 1% improvement in pricing typically yields 2-4x the profit impact of a 1% improvement in volume or cost. Yet most teams set prices by copying competitors or guessing. This skill applies structured frameworks to de-risk pricing decisions and identify pricing power the product may not be capturing.

## Process

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Identify the product, feature, or service requiring pricing analysis
   - Note the current pricing (if any) and any known issues or opportunities
   - Check for existing monetization-strategy, lean-canvas, or business-model-canvas

2. **Pricing Models Review**:
   - Assess which pricing model best fits the product's value delivery:
     - **Cost-plus pricing**: Cost + margin (simple, but ignores value)
     - **Value-based pricing**: Price based on customer perceived value (optimal, but requires research)
     - **Competitive pricing**: Price relative to competitors (safe, but surrenders pricing power)
     - **Penetration pricing**: Low initial price to gain market share, then increase
     - **Skimming pricing**: High initial price to capture early adopters, then decrease
     - **Dynamic pricing**: Real-time price adjustment based on demand
     - **Tiered pricing**: Multiple packages at different price points
     - **Per-unit pricing**: Linear scaling with usage
     - **Two-part tariff**: Base fee + per-unit fee (common in SaaS as platform fee + seats)
   - For each relevant model, evaluate:
     - Fit with the product's value metric
     - Customer acceptance (is this model familiar to the buyer?)
     - Implementation complexity
     - Revenue predictability
     - Expansion revenue potential
   - Recommend 2-3 models for deeper analysis

3. **Competitive Pricing Analysis**:
   - Map the competitive pricing landscape:
     - Direct competitors: exact pricing, tiers, packaging, and value metrics
     - Indirect competitors: alternative solutions and their pricing structures
     - Substitute solutions: what customers pay for the current workaround
   - Build a competitive pricing matrix:
     - Rows: competitors and substitutes
     - Columns: entry price, mid-tier price, enterprise price, value metric, billing frequency, free tier details
   - Identify pricing patterns in the market:
     - Is there a "market price" that most competitors converge on?
     - Are there outliers? What justifies their deviation?
     - What value metric is most common? Is there an opportunity to use a different one?
   - Determine positioning strategy:
     - **Premium**: Price above market (requires clear differentiation)
     - **Parity**: Price at market (compete on other dimensions)
     - **Discount**: Price below market (requires cost advantage or land-and-expand strategy)
   - Flag any competitive pricing data that could not be verified — distinguish between published prices and estimated/negotiated prices

4. **Willingness-to-Pay (WTP) Estimation**:
   - Design a WTP research plan using one or more methods:

   **a) Van Westendorp Price Sensitivity Meter**:
   - Four questions to ask target customers:
     1. At what price would this be so cheap you'd question its quality? (too cheap)
     2. At what price would this be a bargain — a great buy? (cheap)
     3. At what price would this start to feel expensive but you'd still consider it? (expensive)
     4. At what price would this be too expensive to consider? (too expensive)
   - Plot the cumulative distributions to find:
     - Point of Marginal Cheapness (PMC): intersection of "too cheap" and "expensive"
     - Point of Marginal Expensiveness (PME): intersection of "cheap" and "too expensive"
     - Optimal Price Point (OPP): intersection of "too cheap" and "too expensive"
     - Acceptable price range: between PMC and PME

   **b) Gabor-Granger Method**:
   - Show the product at a specific price, ask "would you buy at this price?"
   - If yes, increase price and re-ask; if no, decrease and re-ask
   - Build a demand curve mapping price to purchase probability
   - Identify revenue-maximizing price: Price x Purchase Probability = Revenue Index

   **c) Conjoint Analysis Design**:
   - Identify 4-6 product attributes that influence purchase decisions (features, support level, integrations, etc.) plus price
   - Design choice sets where respondents choose between product configurations at different prices
   - Outputs: part-worth utilities for each attribute level and price sensitivity curves
   - Most rigorous method but requires larger sample sizes (n > 100)

   **d) Direct Value Assessment**:
   - When primary research isn't feasible, estimate WTP from:
     - Cost of the problem the product solves (time, money, risk)
     - Price of the closest substitute
     - Customer budget allocation for this category
     - 10x rule: price should be < 10% of the value delivered

   - For each method, specify: target respondents, sample size needed, survey design, analysis plan

5. **Price Elasticity Analysis**:
   - Estimate how demand changes with price:
     - **Elastic demand** (|E| > 1): Small price increases cause large demand decreases — common in competitive markets with low switching costs
     - **Inelastic demand** (|E| < 1): Price changes have little effect on demand — common with differentiated products, high switching costs, or mission-critical tools
     - **Unit elastic** (|E| = 1): Revenue is constant regardless of price
   - Identify elasticity drivers for this product:
     - Number of available substitutes (more substitutes = more elastic)
     - Proportion of buyer's budget (larger proportion = more elastic)
     - Time horizon (longer = more elastic as alternatives emerge)
     - Necessity vs. luxury (necessity = less elastic)
     - Brand loyalty and switching costs (higher = less elastic)
   - If historical pricing data exists, calculate observed elasticity:
     - E = (% change in quantity demanded) / (% change in price)
   - If no historical data, estimate elasticity range based on:
     - Market category benchmarks (SaaS B2B typically 1.2-1.8 range)
     - Competitive intensity assessment
     - Customer lock-in assessment
   - Model revenue impact at different price points using estimated elasticity:
     - Revenue = Price x Quantity
     - Test 5 price points: -20%, -10%, current, +10%, +20%
     - Identify the revenue-maximizing price point

6. **Pricing Architecture Design**:
   - Design the tier structure:
     - **Good-Better-Best**: 3 tiers targeting different segments (most common, proven effective)
     - **Usage-based tiers**: Tiers defined by consumption thresholds
     - **Role-based tiers**: Different pricing for different user roles
     - **Module-based**: Base platform + add-on modules
   - For each tier, define:
     - Name (signals value, not just "Basic/Pro/Enterprise")
     - Target segment and use case
     - Included features and limits
     - Price point and billing options
     - Upgrade triggers — what makes a customer outgrow this tier?
   - Apply the "fence" principle — tier boundaries should be based on attributes that:
     - Customers self-select into naturally
     - Correlate with willingness to pay
     - Are difficult to game or circumvent
   - Design the free tier (if applicable):
     - What's included — enough to demonstrate value, not enough to satisfy the need fully
     - Conversion trigger — what moment of value realization drives upgrade?
     - Usage limits that create natural upgrade pressure without frustration

7. **Pricing Experiments Design**:
   - Design 2-3 experiments to validate pricing assumptions:

   **a) Price Point Test**:
   - Test 2-3 price points via landing page or checkout A/B test
   - Measure: conversion rate, revenue per visitor, customer satisfaction
   - Required sample: minimum 1,000 visitors per variant for statistical significance
   - Duration: 2-4 weeks minimum

   **b) Tier Packaging Test**:
   - Test different feature bundles across tiers
   - Measure: tier distribution, upgrade rate, feature usage by tier
   - Can be run with existing customers via plan migration offers

   **c) Value Metric Test**:
   - Test different pricing units (per user vs. per project vs. flat rate)
   - Measure: customer comprehension, perceived fairness, conversion rate
   - Often best tested through customer interviews + fake door tests

   - For each experiment: define hypothesis, sample size, duration, success criteria, and decision framework

8. **Synthesize pricing recommendation**:
   - Compile all findings into a pricing recommendation:
     - Recommended pricing model with rationale
     - Specific price points with confidence intervals
     - Tier structure with feature allocation
     - Launch strategy (grandfather existing customers? phase transition? immediate?)
     - Monitoring plan — what metrics confirm the pricing is working?
   - Identify the pricing review cadence — pricing should be revisited quarterly at minimum
   - Flag pricing decisions that should be deferred pending validation experiment results

## Output

Write deliverable to `.deliberate/reports/{slug}/pricing-strategy-analysis.md` including:
- Executive summary with pricing recommendation
- Pricing models assessment and recommended approach
- Competitive pricing matrix and positioning analysis
- Willingness-to-pay research plan and preliminary estimates
- Price elasticity analysis with revenue modeling at multiple price points
- Pricing architecture (tier structure, feature allocation, upgrade triggers)
- Pricing experiment designs with success criteria
- Implementation recommendations (launch strategy, grandfather policy, monitoring)
- Key assumptions and sensitivity analysis
- Recommended pricing review cadence

## Constraints

- Never recommend a price without explaining the rationale — "competitors charge X" is not sufficient alone
- Distinguish between published competitor prices and actual transaction prices (enterprise deals are often heavily discounted)
- WTP estimates are hypotheses until validated — always recommend experiments before committing
- Do not optimize solely for revenue — consider customer perception, fairness, and long-term retention
- Price changes affect existing customers — always address the transition plan
- Acknowledge that pricing is never "done" — it requires ongoing experimentation and adjustment
- If the product is pre-revenue, focus on initial pricing that enables learning over revenue optimization

## Transition

Artifacts feed into monetization-strategy for broader business model context, experiment-design for running pricing validation experiments, and business-model-canvas for updating Revenue Streams. Pricing recommendations inform the product-manager agent when writing PRD pricing sections.
