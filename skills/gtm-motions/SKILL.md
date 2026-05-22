---
name: gtm-motions
description: Evaluate GTM motions — PLG, SLG, CLG, Channel/Partner, Hybrid — with fit criteria, resource requirements, timeline to revenue, and phased launch plans
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:acquisition"
---

# GTM Motions & Launch Strategy

## Objective

Evaluate and recommend the optimal go-to-market motion for the product, including a phased launch plan. The GTM motion determines how the product reaches customers — through the product itself, a sales team, a community, partners, or some combination.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What product or feature is being launched?
   - What stage is the product in (alpha, beta, GA)?
   - What existing distribution exists (users, traffic, sales team, partnerships)?
   - What budget and team resources are available?
   - What is the target customer profile?

2. **Assess product-market fit signals**:

   Before recommending a motion, evaluate PMF readiness:

   | Signal | Weak PMF | Moderate PMF | Strong PMF |
   |--------|----------|-------------|------------|
   | Sean Ellis test | <20% "very disappointed" | 20-40% | >40% |
   | Retention | Declining cohorts | Flat cohorts | Improving cohorts |
   | Organic growth | No word-of-mouth | Some referrals | Significant organic |
   | Usage patterns | Low engagement | Regular use | Daily/habitual use |
   | Willingness to pay | Price resistance | Moderate conversion | High conversion |
   | Pull vs. push | Need to push hard | Balanced | Inbound demand |

   If PMF signals are weak, recommend validating PMF before scaling any GTM motion.

3. **Evaluate each GTM motion type**:

   ### Product-Led Growth (PLG)
   **Model**: Product is the primary acquisition, activation, and expansion vehicle.
   **Fit criteria**:
   - Product delivers value before purchase decision
   - Low barrier to try (self-serve sign-up, freemium/free trial)
   - Individual user can adopt without organizational buy-in
   - Usage data provides expansion and conversion signals
   - Value increases with more users (network effects or collaboration)
   **Resource requirements**: Product/engineering investment in onboarding, activation flows, usage analytics, self-serve billing
   **Timeline to first revenue**: 3-6 months to meaningful self-serve revenue
   **Key metrics**: Sign-ups, activation rate, time-to-value, PQL conversion, net revenue retention
   **Example playbook**: Free tier → activation triggers → PQL scoring → sales-assist for expansion → enterprise upsell

   ### Sales-Led Growth (SLG)
   **Model**: Sales team drives acquisition through outbound and inbound pipeline.
   **Fit criteria**:
   - High ACV (>$10K/year) justifies sales cost
   - Complex buying process with multiple stakeholders
   - Product requires customization, integration, or implementation
   - Customers expect human interaction during evaluation
   - Regulatory or compliance requirements in the purchase
   **Resource requirements**: SDRs, AEs, sales enablement, CRM, demo environment, proposal/contract tooling
   **Timeline to first revenue**: 1-3 months for first deal, 6-12 months for repeatable pipeline
   **Key metrics**: Pipeline generated, win rate, deal cycle length, ACV, CAC payback
   **Example playbook**: Content/SEO → MQL → SDR qualification → AE demo → POC → close → CS onboarding

   ### Community-Led Growth (CLG)
   **Model**: Community of users/practitioners drives awareness, education, and adoption.
   **Fit criteria**:
   - Product serves a passionate practitioner community
   - Use case benefits from shared knowledge and templates
   - Strong existing community or adjacent communities to tap
   - Product has educational or thought leadership potential
   - Low-touch, high-volume is the target
   **Resource requirements**: Community manager, content creation, community platform, events budget
   **Timeline to first revenue**: 6-12 months (community building is slow but compounds)
   **Key metrics**: Community size, engagement rate, community-sourced leads, content contribution, NPS
   **Example playbook**: Open-source/free tool → community building → education content → commercial features → enterprise

   ### Channel/Partner-Led Growth
   **Model**: Partners, resellers, integrators, or marketplace listings drive distribution.
   **Fit criteria**:
   - Product is complementary to a larger platform or workflow
   - Partners have existing relationships with target customers
   - Product can be white-labeled or embedded
   - Partner economics work (margin for partner + margin for you)
   - Target customers already buy through channel
   **Resource requirements**: Partner program, co-marketing, integration engineering, partner portal, revenue sharing infrastructure
   **Timeline to first revenue**: 3-9 months (partner recruitment and enablement)
   **Key metrics**: Partners recruited, partner-sourced pipeline, partner revenue %, integration adoption
   **Example playbook**: Marketplace listing → integration partnership → co-selling → OEM/embed

   ### Hybrid Motion
   **Model**: Combine two or more motions, typically PLG + SLG.
   **Fit criteria**:
   - Product serves multiple segments with different buying behaviors
   - Self-serve works for smaller accounts, sales needed for enterprise
   - PLG creates pipeline that sales converts to larger deals
   - Clear handoff criteria between motions
   **Resource requirements**: Both PLG infrastructure AND sales team, with PQL/MQL routing
   **Key metrics**: Segment-specific metrics + blended CAC/LTV

4. **Score each motion** against the product's specific situation:

   | Criterion | PLG | SLG | CLG | Channel | Hybrid |
   |-----------|-----|-----|-----|---------|--------|
   | Product fit (1-5) | | | | | |
   | Customer fit (1-5) | | | | | |
   | Resource feasibility (1-5) | | | | | |
   | Time to revenue (1-5) | | | | | |
   | Scalability (1-5) | | | | | |
   | Defensibility (1-5) | | | | | |
   | **Total** | | | | | |

5. **Recommend the primary GTM motion** with rationale:
   - Why this motion fits the product, market, and team
   - What the runner-up motion was and why it lost
   - Key assumptions that must hold for the recommendation to be valid
   - When to consider adding a secondary motion

6. **Build the phased launch plan**:

   **Phase 1: Foundation** (pre-launch):
   - Infrastructure and tooling requirements
   - Content and asset creation
   - Team hiring or allocation
   - Metrics and tracking setup

   **Phase 2: Soft Launch** (limited audience):
   - Target audience for soft launch
   - Success criteria for proceeding to broader launch
   - Feedback collection mechanisms
   - Iteration plan

   **Phase 3: General Availability**:
   - Launch channels and tactics
   - Launch day and launch week plan
   - PR and announcement strategy
   - Support readiness

   **Phase 4: Scale**:
   - When to add secondary GTM motion
   - Expansion playbook
   - Team scaling triggers
   - Budget scaling model

## Output

Write deliverable to `.deliberate/reports/{slug}/gtm-motions.md` including:
- PMF signal assessment
- Motion-by-motion evaluation (fit criteria, resources, timeline, metrics, playbook)
- Scoring matrix
- Recommended primary motion with rationale
- Phased launch plan (Foundation → Soft Launch → GA → Scale)
- Key assumptions and validation plan
- Resource and budget implications

## Constraints

- Do not recommend a motion that requires resources the team does not have and cannot acquire
- Be honest about PMF readiness — scaling a GTM motion without PMF wastes money
- Every motion recommendation must account for the product's current stage, not its aspiration
- Hybrid motions are complex — only recommend when the product genuinely serves multiple segments
- Channel/partner motions require giving up margin and control — flag these trade-offs explicitly
- Include a "kill criteria" for each phase — what signals mean the motion isn't working

## Transition

GTM motion selection feeds into `/growth-plan` (tactical execution), `/gtm-messaging` (motion-specific messaging), and `/growth-loops` (loop design aligned with the motion).
