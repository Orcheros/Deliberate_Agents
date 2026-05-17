---
name: market-scan
description: Run a combined 4-framework market analysis (SWOT + PESTLE + Porter's Five Forces + Ansoff Matrix) and synthesize strategic implications
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Market Scan

## Objective

Conduct a comprehensive market analysis using four complementary strategic frameworks — SWOT, PESTLE, Porter's Five Forces, and the Ansoff Matrix — then synthesize findings into actionable strategic implications. Each framework illuminates different dimensions of the competitive landscape, and together they provide a 360-degree view of market dynamics.

This skill merges what were previously separate analyses (SWOT analysis, PESTLE analysis, Porter's Five Forces, Ansoff Matrix) into a single, integrated market scan. Running them together prevents siloed thinking and surfaces cross-framework insights that individual analyses miss.

## Process

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Identify the product, market, or initiative to analyze
   - Note the specific strategic questions driving this analysis
   - Check for existing product-strategy-canvas, lean-canvas, or competitive research

2. **Gather market intelligence inputs**:
   - Read all available product documentation, PRDs, and strategy docs
   - Review competitive teardowns if they exist
   - Catalog known market data: size, growth rate, key players, trends
   - Identify information gaps that limit analysis confidence
   - Note the date of analysis — market conditions are time-sensitive

3. **Framework 1 — SWOT Analysis**:
   - **Strengths** (internal, positive):
     - What does the product/team do well?
     - What unique resources or capabilities exist?
     - What do customers cite as reasons for choosing us?
     - What proprietary technology, data, or relationships exist?
   - **Weaknesses** (internal, negative):
     - Where does the product underperform?
     - What resources are lacking (talent, capital, technology)?
     - What do customers complain about?
     - Where are operational inefficiencies?
   - **Opportunities** (external, positive):
     - What market trends favor the product?
     - What competitor weaknesses can be exploited?
     - What underserved segments exist?
     - What regulatory or technology changes create openings?
   - **Threats** (external, negative):
     - What competitors are gaining ground?
     - What market shifts could reduce demand?
     - What regulatory changes could restrict operations?
     - What technology disruptions could make the product obsolete?
   - **SWOT Interaction Matrix**: For each S-O, S-T, W-O, W-T combination, identify strategic actions

4. **Framework 2 — PESTLE Analysis**:
   - **Political**:
     - Government policies affecting the market (trade, taxation, labor)
     - Political stability in key markets
     - Government stance toward the industry (supportive, neutral, restrictive)
   - **Economic**:
     - Macroeconomic conditions (GDP growth, inflation, interest rates)
     - Customer spending patterns and budget pressure
     - Currency and exchange rate impacts (for international markets)
     - Funding environment for the company and competitors
   - **Social**:
     - Demographic shifts affecting the target market
     - Cultural attitudes toward the product category
     - Workforce trends (remote work, gig economy) that create or reduce demand
     - Consumer behavior changes (privacy awareness, sustainability expectations)
   - **Technological**:
     - Emerging technologies that enable new capabilities (AI, blockchain, IoT)
     - Technology adoption curves relevant to the product
     - Infrastructure changes (5G, edge computing) that alter possibilities
     - Open-source or commoditization threats
   - **Legal**:
     - Data protection and privacy regulations (GDPR, CCPA, emerging frameworks)
     - Industry-specific regulations and compliance requirements
     - Intellectual property landscape and patent risks
     - Employment and labor law considerations
   - **Environmental**:
     - Sustainability expectations from customers and investors
     - Environmental regulations affecting operations
     - Climate-related supply chain risks
     - ESG reporting requirements
   - For each PESTLE factor, rate: impact (high/medium/low), likelihood (high/medium/low), time horizon (immediate/near-term/long-term)

5. **Framework 3 — Porter's Five Forces**:
   - **Threat of New Entrants** (barrier analysis):
     - Capital requirements to enter the market
     - Economies of scale advantages of incumbents
     - Brand loyalty and switching costs
     - Access to distribution channels
     - Regulatory and legal barriers
     - Technology and IP barriers
     - Rate the force: weak / moderate / strong
   - **Bargaining Power of Suppliers**:
     - Number and concentration of key suppliers (cloud providers, data sources, API providers)
     - Switching costs between suppliers
     - Availability of substitute inputs
     - Supplier forward-integration threat
     - Rate the force: weak / moderate / strong
   - **Bargaining Power of Buyers**:
     - Buyer concentration and volume
     - Switching costs for buyers
     - Buyer price sensitivity
     - Availability of substitute products
     - Buyer backward-integration threat
     - Rate the force: weak / moderate / strong
   - **Threat of Substitute Products**:
     - Available substitutes (including "do nothing" and manual processes)
     - Price-performance trade-off of substitutes
     - Switching costs to substitutes
     - Buyer propensity to substitute
     - Rate the force: weak / moderate / strong
   - **Competitive Rivalry**:
     - Number and size of competitors
     - Industry growth rate (high growth reduces rivalry)
     - Product differentiation level
     - Exit barriers (high exit barriers intensify rivalry)
     - Strategic stakes and commitment of competitors
     - Rate the force: weak / moderate / strong
   - **Overall industry attractiveness**: Synthesize the five forces into an assessment of whether the industry is structurally attractive for earning above-average returns

6. **Framework 4 — Ansoff Growth Matrix**:
   - **Market Penetration** (existing products, existing markets):
     - Opportunities to increase share in current segments
     - Pricing, promotion, or distribution improvements
     - Competitive displacement strategies
     - Risk level: LOW — assess viability and expected impact
   - **Market Development** (existing products, new markets):
     - New geographic markets
     - New customer segments with similar needs
     - New use cases for the existing product
     - Risk level: MODERATE — assess market readiness and entry barriers
   - **Product Development** (new products, existing markets):
     - Adjacent features or products for current customers
     - Platform extensions and integrations
     - Vertical-specific solutions
     - Risk level: MODERATE — assess technical feasibility and customer demand
   - **Diversification** (new products, new markets):
     - Related diversification (adjacent industry, shared capabilities)
     - Unrelated diversification (new industry, new capabilities)
     - Risk level: HIGH — assess strategic rationale and capability gaps
   - For each quadrant, identify the top 2-3 opportunities and rank by attractiveness vs. risk

7. **Cross-framework synthesis**:
   - Map SWOT strengths to Porter's favorable forces — where do internal capabilities align with structural advantages?
   - Map PESTLE trends to Ansoff opportunities — which macro trends open which growth paths?
   - Identify reinforcing signals: insights that appear across 2+ frameworks carry higher confidence
   - Identify contradictions: where frameworks disagree, investigate why and document the tension
   - Extract the top 5 strategic implications that emerge from the combined analysis

8. **Formulate strategic recommendations**:
   - For each strategic implication, recommend a specific action
   - Classify each recommendation: offensive (seize opportunity) vs. defensive (mitigate threat)
   - Prioritize by: impact (high/medium/low) x urgency (immediate/near-term/can-wait)
   - Identify dependencies between recommendations
   - Flag recommendations that require additional research or validation

## Output

Write deliverable to `.deliberate/reports/{slug}/market-scan.md` including:
- Executive summary (top 5 strategic insights)
- SWOT matrix with interaction analysis
- PESTLE analysis with impact/likelihood ratings
- Porter's Five Forces assessment with industry attractiveness conclusion
- Ansoff Growth Matrix with prioritized opportunities
- Cross-framework synthesis and reinforcing signals
- Strategic recommendations prioritized by impact and urgency
- Information gaps and recommended research to fill them
- Date of analysis and recommended refresh cadence

## Constraints

- Never fabricate market data, competitor information, or industry statistics — clearly label all assumptions
- Each framework must be completed in full — partial frameworks create false confidence
- Distinguish between facts (verified data), estimates (reasonable approximations), and assumptions (unvalidated beliefs)
- The synthesis section is the most valuable part — do not treat it as an afterthought
- Rate confidence level for each major finding: high (multiple data points), medium (some evidence), low (assumption)
- Market conditions change — include the analysis date and recommend when to refresh

## Transition

The Market Scan feeds into product-strategy-canvas for strategic positioning, monetization-strategy for market-informed revenue models, and pricing-strategy-analysis for competitive pricing context. Strategic recommendations should inform brainstorm-okrs and outcome-roadmap prioritization.
