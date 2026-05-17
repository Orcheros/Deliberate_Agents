---
name: marketing-ideas
description: Brainstorm and prioritize 5 creative, cost-effective marketing ideas with implementation plans, success metrics, and expected ROI
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Marketing Ideas

## Objective

Brainstorm and prioritize five creative, cost-effective marketing ideas tailored to the product's stage, audience, and budget. Each idea should be actionable, measurable, and feasible with available resources. Emphasis on high-ROI, unconventional approaches — not generic "run Facebook ads" advice.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What product or feature needs marketing?
   - What is the target audience and ICP?
   - What is the budget range (bootstrapped, seed-funded, growth-funded)?
   - What channels have been tried and what were the results?
   - What is the primary goal (awareness, sign-ups, activation, revenue)?

2. **Assess current marketing context**:
   - Review existing marketing assets and channels
   - Identify what's working and what's not (if data available)
   - Understand the competitive landscape and what competitors are doing
   - Identify unique assets, relationships, or advantages the company has
   - Note constraints: team size, budget, timeline, brand guidelines

3. **Brainstorm across channel categories** (generate 10-15 raw ideas, then narrow to 5):

   Ensure the final 5 include a mix from these categories:

   **Organic / Content**:
   - Interactive tools, calculators, or assessments
   - Research reports or original data studies
   - SEO-driven comparison or alternative pages
   - Video series, podcast, or newsletter
   - Template libraries or resource hubs

   **Community / Partnerships**:
   - Community sponsorship or participation
   - Co-marketing with complementary products
   - Guest content swaps (blog, podcast, newsletter)
   - Open-source contributions or tools
   - Event hosting (virtual or local meetups)

   **Paid / Performance**:
   - Targeted micro-campaigns on niche platforms
   - Retargeting with high-value content (not just product ads)
   - Sponsorship of niche newsletters or communities
   - Influencer or creator partnerships

   **Guerrilla / Creative**:
   - Stunt marketing or provocative content
   - Product-as-marketing (embeddable, shareable outputs)
   - Referral or incentive programs with creative mechanics
   - Data-driven PR (newsworthy findings from product data)
   - Challenge campaigns or competitions

4. **Develop each of the 5 selected ideas** with this structure:

   For each idea:

   **Concept Description**: 2-3 sentences explaining the idea clearly.

   **Target Audience**: Who specifically this idea reaches and why they'll care.

   **Channel(s)**: Primary and secondary distribution channels.

   **Expected Reach**: Realistic estimate of impressions, views, or audience size. Cite benchmarks or comparable examples.

   **Estimated Cost**:
   - Dollar cost (tools, ads, production)
   - Time cost (team hours)
   - Opportunity cost (what else could be done instead)

   **Success Metrics**:
   - Primary metric (tied to the marketing goal)
   - Secondary metrics (engagement, brand lift, pipeline)
   - How to measure (tracking, attribution, surveys)

   **Implementation Steps**:
   1. Step-by-step execution plan
   2. Each step with a responsible party
   3. Dependencies and prerequisites

   **Timeline**: Key milestones from start to results measurement.

   **Risks**:
   - What could go wrong
   - Mitigation strategies
   - Minimum viable version if full execution isn't feasible

5. **Prioritize by expected ROI**:

   | Idea | Est. Cost | Est. Reach | Est. Conversions | ROI Score | Rank |
   |------|----------|-----------|-----------------|-----------|------|
   | ... | ... | ... | ... | ... | ... |

   ROI Score = (Expected Value of Conversions) / (Total Cost including time)

   Rank ideas 1-5 and explain the ranking rationale, including why #1 should be done first.

6. **Create a quick-start recommendation**:
   - Which idea to start this week
   - The minimum viable version that tests the concept
   - What success looks like after the first iteration
   - Decision point: when to double down or abandon

## Output

Write deliverable to `.deliberate/reports/{slug}/marketing-ideas.md` including:
- Marketing context summary
- 5 detailed marketing ideas (concept, audience, channel, reach, cost, metrics, steps, timeline, risks)
- ROI-ranked priority table
- Quick-start recommendation
- Ideas considered but not selected (brief notes on why)

## Constraints

- Ideas must be feasible with the stated budget and team size
- "Run Google Ads" or "post on social media" alone are not ideas — they're channels; the idea is what you do on that channel
- Every reach and conversion estimate must cite a benchmark or be flagged as assumption
- Include at least one idea that costs <$100 to test
- Include at least one idea that leverages an unfair advantage specific to this product or team
- Do not recommend ideas that require capabilities the team doesn't have without noting the gap

## Transition

Selected marketing ideas feed into `/growth-plan` (campaign execution planning), `/experiment-design` (testing the ideas), and `/gtm-messaging` (messaging for each campaign).
