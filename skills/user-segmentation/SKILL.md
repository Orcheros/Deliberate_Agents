---
name: user-segmentation
description: Segment users from research and feedback data — behavioral, needs-based, value-based, and demographic approaches with sizing and targeting recommendations
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# User Segmentation

## Objective

Segment users into actionable groups using multiple segmentation approaches. Produce a segmentation matrix with size estimates, growth trajectories, and targeting recommendations that inform product prioritization, marketing strategy, and sales focus.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What is the segmentation goal (product prioritization, marketing targeting, pricing tiers)?
   - What data sources are available (usage data, CRM, surveys, analytics)?
   - Are there existing segments to refine or validate?

2. **Collect and prepare segmentation data**:
   - Product usage data: feature adoption, session frequency, workflow complexity
   - Revenue data: plan tier, MRR, expansion history, payment patterns
   - Behavioral data: activation milestones, engagement depth, retention curves
   - Demographic/firmographic: company size, industry, role, geography
   - Feedback data: NPS scores, support tickets, feature requests
   - Acquisition data: channel, referral source, campaign attribution
   - Document data quality issues, missing fields, and coverage gaps

3. **Apply segmentation approaches** (use all that apply):

   **Behavioral segmentation** (usage patterns):
   - Cluster users by: frequency (daily/weekly/monthly), depth (features used), intensity (actions per session)
   - Identify power users, casual users, dormant users, and churned users
   - Map feature adoption sequences and engagement ladders

   **Needs-based segmentation** (JTBD clusters):
   - Group by primary job-to-be-done
   - Identify which user needs are served, underserved, and overserved
   - Map need urgency and willingness to pay for solutions

   **Value-based segmentation** (revenue potential):
   - Segment by current revenue contribution (MRR tier)
   - Estimate lifetime value per segment
   - Calculate acquisition cost per segment
   - Identify high-value vs. high-volume trade-offs

   **Demographic segmentation**:
   - Company size (SMB, mid-market, enterprise)
   - Industry vertical
   - Geography and regulatory environment
   - Role and seniority of primary user

   **Psychographic segmentation**:
   - Technology adoption curve position (innovator, early adopter, early majority, etc.)
   - Decision-making style (data-driven, intuition-driven, consensus-driven)
   - Risk tolerance and change appetite

4. **Size and score each segment**:
   - **Size estimate**: number of users/accounts, percentage of total base
   - **Growth trajectory**: expanding, stable, or contracting (with evidence)
   - **Acquisition cost**: estimated CAC for the segment
   - **Lifetime value**: estimated LTV based on retention and expansion patterns
   - **Product fit score** (1-10): how well the current product serves this segment's needs
   - **Strategic alignment**: how well this segment aligns with company vision and roadmap

5. **Build the segmentation matrix**:
   - Rows: segments identified across all approaches
   - Columns: size, growth, CAC, LTV, product fit, strategic alignment
   - Cross-reference segments across approaches (e.g., behavioral power users who are also high-value)
   - Identify segment overlaps and gaps

6. **Develop targeting recommendations**:
   - Rank segments by attractiveness (LTV/CAC ratio, product fit, strategic alignment)
   - Recommend primary, secondary, and deprioritized segments
   - For each priority segment: what product investment is needed, what marketing approach works, what sales motion fits
   - Identify segments to actively avoid (anti-segments) and why

## Output

Write deliverable to `.deliberate/reports/{slug}/user-segmentation.md` including:
- Segmentation analysis by each applicable approach (behavioral, needs, value, demographic, psychographic)
- Segmentation matrix with all scoring dimensions
- Segment profiles: description, size, growth, CAC, LTV, product fit score
- Targeting recommendations: priority ranking with rationale
- Cross-segment analysis: overlaps, conflicts, and gaps
- Methodology: data sources, assumptions, confidence levels

## Constraints

- Never present estimates as precise figures — always use ranges or qualifiers (approximately, estimated)
- Every segment must have supporting data from at least one source
- Do not create segments too small to act on — minimum viable segment size depends on business context
- Clearly separate observed data from projected/estimated values
- Respect PII — all segment descriptions use aggregated data only

## Transition

Segmentation feeds into persona refinement (`/user-personas`), journey mapping (`/customer-journey-map`), ICP definition (`/ideal-customer-profile`), and pricing strategy (`/pricing-strategy`). Growth and GTM agents use segments for campaign targeting.
