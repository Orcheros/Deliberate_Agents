---
name: ideal-customer-profile
description: Build a detailed Ideal Customer Profile with firmographics, technographics, behavioral signals, JTBD, and a lead scoring rubric
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Ideal Customer Profile

## Objective

Build a comprehensive Ideal Customer Profile (ICP) that sales, marketing, and product can use to focus efforts on the highest-value prospects. The ICP defines who your best customers are, how to identify them, and — equally important — who to disqualify.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What product or service is the ICP for?
   - Is there an existing beachhead segment analysis to build from?
   - What customer data (usage, revenue, churn, NPS) is available?

2. **Analyze existing best customers** (if data exists):
   - Identify top 10-20% of customers by value (revenue, engagement, NPS, expansion)
   - Look for shared characteristics across firmographic, technographic, and behavioral dimensions
   - Identify patterns in how they bought (channel, deal cycle, champion role)
   - Note what they have in common that weaker customers lack

3. **Define firmographic profile**:
   - **Industry/vertical**: specific industries or sub-verticals (e.g., "B2B SaaS, Series A-C" not just "tech")
   - **Company size**: employee count range and/or revenue range
   - **Geography**: regions, countries, or markets
   - **Growth stage**: startup / scale-up / mid-market / enterprise
   - **Organizational structure**: centralized vs. decentralized decision-making
   - **Budget indicators**: typical spend in your category, fiscal year timing

4. **Define technographic profile**:
   - **Current tech stack**: tools and platforms they already use
   - **Integration requirements**: systems your product must connect to
   - **Technical maturity**: engineering team size, DevOps sophistication
   - **Data infrastructure**: what data they generate and store
   - **Complementary tools**: products that signal readiness for yours

5. **Define behavioral signals** (buying triggers and readiness indicators):
   - **Trigger events**: hiring surges, funding rounds, product launches, compliance deadlines, vendor contract renewals
   - **Evaluation process**: how they discover, evaluate, and purchase (self-serve vs. committee)
   - **Decision-making unit (DMU)**:
     - **Champion**: who finds you and pushes internally
     - **Decision maker**: who signs the contract
     - **Influencer**: who has input but not authority
     - **Blocker**: who might veto and why
     - **End user**: who uses the product daily
   - **Deal velocity indicators**: signals that predict faster close (e.g., inbound vs. outbound, specific pain articulation)

6. **Define Jobs-to-be-Done and pain points**:
   - **Primary JTBD**: the core job the customer hires your product to do
   - **Secondary JTBD**: adjacent jobs your product also fulfills
   - **Pain points**: specific, quantifiable pains (time wasted, money lost, risk exposure)
   - **Current alternatives**: what they do today without your product (spreadsheets, manual process, competitor, nothing)
   - **Desired outcomes**: what success looks like in their words

7. **Define the negative ICP** (who to disqualify):
   - Firmographic disqualifiers (too small, wrong industry, wrong geography)
   - Behavioral red flags (price shoppers, feature tourists, no budget authority)
   - Technical mismatches (incompatible stack, security requirements you can't meet)
   - Cultural mismatches (expectations you can't deliver on)
   - Historical churn patterns (customer types that consistently churn)

8. **Build lead scoring rubric**:

   | Signal Category | Signal | Points | Weight |
   |----------------|--------|--------|--------|
   | Firmographic fit | Matches industry | +10 | High |
   | Firmographic fit | Right company size | +10 | High |
   | Technographic fit | Uses complementary tool | +5 | Medium |
   | Behavioral | Trigger event detected | +15 | High |
   | Behavioral | Champion identified | +10 | High |
   | Engagement | Visited pricing page | +5 | Medium |
   | Disqualifier | Wrong industry | -20 | Hard |
   | Disqualifier | No budget authority | -15 | Hard |

   - Define score thresholds: Hot (80+), Warm (50-79), Cool (25-49), Disqualify (<25)
   - Map each threshold to a recommended action (e.g., Hot = immediate outreach, Disqualify = no pursuit)

## Output

Write deliverable to `.deliberate/reports/{slug}/ideal-customer-profile.md` including:
- ICP summary (one-paragraph executive summary)
- Firmographic profile
- Technographic profile
- Behavioral signals and buying triggers
- Decision-making unit map
- JTBD and pain points
- Negative ICP (disqualification criteria)
- Lead scoring rubric with thresholds
- Persona sketch (a named, specific example that embodies the ICP)

## Constraints

- The ICP must be specific enough that a sales rep can identify a qualifying prospect in under 2 minutes
- Every dimension must distinguish ICP from non-ICP — if a characteristic is true of everyone, it's not useful
- Negative ICP is required, not optional — knowing who to reject is as valuable as knowing who to pursue
- Flag dimensions where data is insufficient and recommend how to validate
- Do not create multiple ICPs unless explicitly asked — focus on the primary ICP first

## Transition

The ICP feeds into `/competitive-battlecard` (competitor comparison from ICP perspective), `/gtm-messaging` (ICP-specific messaging), and `/growth-loops` (acquisition loops targeting the ICP).
