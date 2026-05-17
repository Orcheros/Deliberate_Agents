---
name: business-model-canvas
description: Build a Strategyzer Business Model Canvas to map the complete value creation, delivery, and capture system for an established or scaling product
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Business Model Canvas

## Objective

Produce a Business Model Canvas (Alexander Osterwalder / Strategyzer) that maps the complete business model — how the organization creates, delivers, and captures value. The BMC is the standard strategic tool for established products and scaling businesses where operational elements (partnerships, resources, activities) are as critical as customer-facing elements.

While the Lean Canvas focuses on early-stage hypothesis testing, the Business Model Canvas provides a holistic operational view suitable for products with proven demand that need to optimize their business system. Use this skill when the product has moved past initial validation and needs to formalize its business model.

## Process

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Identify the product or business unit to canvas
   - Check for existing lean-canvas or product-strategy-canvas that provides foundational inputs
   - Note the current business stage and whether this is a new canvas or an update

2. **Block 1 — Customer Segments**:
   - Identify all distinct customer segments the business model serves
   - For each segment, classify the market type:
     - **Mass market**: No distinction between segments (commodity)
     - **Niche market**: Specialized, tailored to specific requirements
     - **Segmented**: Slightly different needs and problems
     - **Diversified**: Serves unrelated segments with different needs
     - **Multi-sided platform**: Serves 2+ interdependent segments (e.g., buyers and sellers)
   - For each segment: define the archetype, size estimate, growth trajectory, and strategic importance
   - Identify which segments are currently served vs. planned

3. **Block 2 — Value Propositions**:
   - For each customer segment, define the value proposition
   - Map value elements using these categories:
     - **Quantitative**: Price, speed, cost reduction, risk reduction
     - **Qualitative**: Design, brand, status, convenience, usability
   - Apply the Value Proposition Canvas: Jobs (functional, social, emotional) -> Pains -> Gains
   - Rank value elements by importance to the customer (must-have, performance, delighter)
   - Identify which value propositions are proven (customer-validated) vs. hypothesized

4. **Block 3 — Channels**:
   - Map the complete channel strategy across 5 phases:
     - **Awareness**: How do customers learn about us?
     - **Evaluation**: How do customers evaluate our value proposition?
     - **Purchase**: How do customers buy?
     - **Delivery**: How do we deliver the value proposition?
     - **After-sales**: How do we provide post-purchase support?
   - For each phase, identify: owned channels, partner channels, and channel economics
   - Assess channel-segment fit — not every channel works for every segment

5. **Block 4 — Customer Relationships**:
   - Define the type of relationship for each customer segment:
     - **Personal assistance**: Human interaction (sales, support)
     - **Dedicated personal assistance**: Named account management
     - **Self-service**: No direct relationship, provide tools
     - **Automated services**: AI/ML-driven personalization
     - **Communities**: User communities, forums, peer support
     - **Co-creation**: Customers participate in value creation
   - Identify the relationship motivation: acquisition, retention, or upsell
   - Map the cost of each relationship type against customer LTV

6. **Block 5 — Revenue Streams**:
   - For each customer segment, identify revenue mechanisms:
     - **Asset sale**: Selling ownership of a physical/digital product
     - **Usage fee**: Pay per use
     - **Subscription fee**: Recurring access
     - **Licensing**: Permission to use IP
     - **Brokerage fee**: Intermediation commission
     - **Advertising**: Attention monetization
   - Define pricing mechanisms: fixed (list, segment-dependent, volume) vs. dynamic (negotiation, auction, yield management)
   - Estimate revenue contribution by segment and stream
   - Identify revenue concentration risks

7. **Block 6 — Key Resources**:
   - Identify the critical assets required to make the business model work:
     - **Physical**: Infrastructure, hardware, facilities
     - **Intellectual**: Patents, IP, proprietary data, brand, partnerships
     - **Human**: Key talent, specialized expertise
     - **Financial**: Cash, credit, stock option pool
   - Distinguish between owned, leased, and partner-provided resources
   - Identify resource gaps that constrain growth

8. **Block 7 — Key Activities**:
   - Define the most important activities the company must perform:
     - **Production**: Designing, building, delivering the product
     - **Problem-solving**: Consulting, professional services
     - **Platform/network**: Platform management, network cultivation, matchmaking
   - Map activities to value propositions — every activity should contribute to value delivery
   - Identify which activities are core (must own) vs. non-core (can outsource)

9. **Block 8 — Key Partnerships**:
   - Map the partnership ecosystem:
     - **Strategic alliances**: Non-competitors collaborating
     - **Coopetition**: Competitors partnering on specific initiatives
     - **Joint ventures**: New business creation with partners
     - **Supplier relationships**: Reliable supply chain
   - For each partnership, identify the motivation:
     - Optimization and economy of scale
     - Reduction of risk and uncertainty
     - Acquisition of specific resources or activities
   - Assess partnership dependency risk — what happens if a key partner leaves?

10. **Block 9 — Cost Structure**:
    - Classify the overall model:
      - **Cost-driven**: Minimize costs wherever possible (commodity, low-price value proposition)
      - **Value-driven**: Focus on value creation, premium positioning
    - Map cost categories:
      - **Fixed costs**: Salaries, rent, infrastructure (don't change with volume)
      - **Variable costs**: COGS, transaction costs, commissions (scale with volume)
    - Identify economies of scale and scope
    - Calculate key ratios: gross margin, contribution margin, burn rate
    - Flag the top 3 cost risks

11. **Analyze business model patterns**:
    - Assess which established patterns the model employs:
      - **Freemium**: Free basic tier, paid premium
      - **Long tail**: Many niche products vs. few bestsellers
      - **Multi-sided platform**: Value from connecting distinct user groups
      - **Razor and blade**: Low-cost base product, recurring consumable revenue
      - **Open business model**: Value creation through external collaboration
    - Identify pattern tensions or opportunities for pattern innovation

12. **Validate internal consistency**:
    - Check that value propositions address real customer needs
    - Verify that channels reach the right segments efficiently
    - Confirm that revenue streams cover cost structure with healthy margins
    - Ensure key resources and activities support the value proposition
    - Identify the weakest block — where is the business model most vulnerable?
    - Stress-test: what breaks first if a competitor undercuts on price? If a key partner leaves? If customer acquisition costs double?

## Output

Write deliverable to `.deliberate/reports/{slug}/business-model-canvas.md` including:
- Visual Business Model Canvas in markdown table format (single-page view)
- Detailed analysis for each of the 9 blocks
- Business model pattern assessment
- Internal consistency analysis
- Vulnerability assessment (weakest blocks)
- Stress-test results (3 scenarios)
- Revenue and cost projections framework
- Comparison to Lean Canvas if both exist (highlighting evolution of thinking)

## Constraints

- Every block must reference real information or clearly flag assumptions
- Do not skip blocks — the BMC is a system, and gaps create blind spots
- Customer Segments must be specific and observable, not vague categories
- Revenue Streams must include pricing mechanisms, not just "subscription"
- Key Partnerships should reflect actual or actively pursued relationships, not wishlists
- Cost Structure must distinguish fixed from variable — this is critical for unit economics
- If the product is early-stage, consider using lean-canvas instead and note the recommendation

## Transition

The Business Model Canvas feeds into monetization-strategy for revenue model deep-dives, pricing-strategy-analysis for pricing optimization, and market-scan for competitive business model comparison. It serves as a reference for the product-manager agent when assessing cross-functional impact.
