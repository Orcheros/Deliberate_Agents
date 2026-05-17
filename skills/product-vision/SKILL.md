---
name: product-vision
description: Craft an inspiring, achievable product vision statement grounded in market reality and customer insight
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Product Vision

## Objective

Craft a compelling product vision statement that aligns the organization around a shared future state. The vision must be inspiring enough to motivate, specific enough to guide decisions, and grounded enough to be achievable.

A strong product vision answers "where are we going and why does it matter?" It serves as the North Star for product strategy, roadmap prioritization, and cross-functional alignment. This skill produces a vision document that withstands scrutiny from investors, motivates the team, and resonates with target customers.

## Process

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Identify the product or initiative requiring a vision statement
   - Note any existing vision, mission, or strategy documents referenced
   - Understand the stage of the company (pre-product, early, growth, mature)

2. **Gather product context**:
   - Read existing product documentation, PRDs, and one-pagers
   - Identify the core product capabilities and technology
   - Review customer segments and their primary jobs-to-be-done
   - Catalog the key problems the product solves today
   - Note any founder intent or strategic direction already established

3. **Analyze market position**:
   - Identify the product category and adjacent categories
   - Map the competitive landscape — who else serves these customers?
   - Determine the current market stage (nascent, emerging, growing, mature, declining)
   - Identify macro trends (technology, regulatory, behavioral) that create tailwinds or headwinds
   - Assess where the market is heading in 3-5 years

4. **Define the vision time horizon**:
   - Select an appropriate time horizon (typically 3-5 years for startups, 5-10 for established)
   - Consider the pace of change in the market — faster markets need shorter horizons
   - Ensure the horizon is far enough to be aspirational but close enough to be credible

5. **Craft the vision statement using the Moore framework**:
   - For `[target customer]`
   - Who `[statement of need or opportunity]`
   - `[Product name]` is a `[product category]`
   - That `[key benefit / compelling reason to adopt]`
   - Unlike `[primary competitive alternative]`
   - Our product `[statement of primary differentiation]`

   Then distill into a concise vision statement (1-2 sentences) that captures the essence without the scaffolding.

6. **Develop supporting vision narratives**:
   - Write a "future press release" (Amazon-style working backwards) describing the product at the vision horizon
   - Create 2-3 customer stories showing how the vision manifests in daily use
   - Articulate the "world is better because" statement — what changes if the vision succeeds?

7. **Validate against quality criteria**:
   - **Inspiring**: Does it motivate the team and excite customers?
   - **Achievable**: Is it realistic given resources, technology, and market dynamics?
   - **Differentiating**: Does it carve a unique position, not just describe the category?
   - **Customer-centric**: Is it framed around customer outcomes, not product features?
   - **Memorable**: Can someone repeat it from memory after hearing it once?
   - **Decision-enabling**: Does it help say "no" to things that don't align?
   - **Time-bound**: Does it imply a horizon without being a deadline?

8. **Produce the vision document**:
   - Compile the vision statement, supporting narratives, and validation assessment
   - Include the strategic context that informed the vision
   - Document assumptions and risks that could invalidate the vision
   - Suggest a cadence for vision review and refresh

## Output

Write deliverable to `.deliberate/reports/{slug}/product-vision.md` including:
- Executive summary with the vision statement
- Moore framework breakdown (target, need, category, benefit, alternative, differentiator)
- Condensed vision statement (1-2 sentences)
- Future press release narrative
- Customer stories illustrating the vision
- "World is better because" statement
- Validation scorecard against the 7 quality criteria
- Strategic context and assumptions
- Recommended review cadence

## Constraints

- Never invent market data or competitive information — flag assumptions explicitly
- The vision must be grounded in real customer problems, not technology capabilities
- Avoid jargon and buzzwords — the vision should be understandable by anyone in the organization
- Do not conflate vision (where we're going) with mission (why we exist) or strategy (how we'll get there)
- If the product is pre-launch, acknowledge uncertainty and frame the vision as a hypothesis to validate
- Keep the condensed vision statement under 25 words

## Transition

Artifacts feed into product-strategy-canvas, lean-canvas, and business-model-canvas as the foundational "Vision" input. The vision document also informs north-star-metric selection and OKR development.
