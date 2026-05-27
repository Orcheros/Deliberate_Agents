---
name: partnership-design
description: Design referral, affiliate, integration, and channel partner programs — structure, economics, enablement, and measurement
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "flywheel:referral"
---

# Partnership Program Design

## Objective

Design a comprehensive partnership program covering integration, channel/reseller, technology, and strategic partnerships. This skill produces the strategic program structure — the existing `/referral-program` skill handles the specific mechanics of referral and affiliate programs.

## Instructions

1. **Read context**:
   - Read assignment file for partnership goals
   - Read GTM context (injected automatically) for product, ICP, business model, traction
   - Read existing `/referral-program` output if any (to avoid duplication)
   - Read `/competitive-teardown` output if available (competitor partnership landscape)

2. **Assess partnership readiness**:

   Before designing the program, evaluate whether the product is ready for partnerships:

   | Readiness Factor | Minimum Bar | Notes |
   |-----------------|-------------|-------|
   | Product-market fit | Clear PMF signals | Partners amplify what works; they don't find PMF for you |
   | Integration points | API or webhook available | Partners need something to build on |
   | Unit economics | Positive or clear path | Must support partner margin/commission |
   | Support capacity | Can handle partner-sourced volume | Partners will surface edge cases |
   | Sales process | Repeatable, documented | Partners need a playbook to follow |

   If readiness is insufficient, recommend what to build first before launching partnerships.

3. **Evaluate partnership types**:

   ### Integration Partnerships
   Complementary products whose users would benefit from connecting with yours.

   - **Identify candidates**: Products that share your ICP but don't compete
   - **Integration depth** (start simple, deepen with validation):
     - Level 1: Data sync via API/webhook
     - Level 2: Embedded widget or iframe
     - Level 3: Native integration (deep product work)
   - **Economics**: Free (ecosystem play), rev-share on influenced deals, co-selling
   - **Go-to-market**: Co-marketing, marketplace listing, joint case studies, integration directory

   ### Channel / Reseller Partnerships
   Resellers, consultants, and agencies who serve your ICP and can sell or implement your product.

   - **Identify candidates**: Agencies, consultants, VARs, MSPs serving your target market
   - **Economics**:
     - Discount off list price: {typical 20-40%}
     - Margin percentage: {what partners keep}
     - Deal registration: first-to-register gets deal protection
   - **Enablement requirements**: Product training, demo environment, sales collateral, certification program
   - **Deal flow**: Lead registration process, deal protection rules, conflict resolution procedure

   ### Technology Partnerships
   Platforms you build on or that your product extends.

   - **Identify candidates**: Platforms whose ecosystems you're in or want to be in
   - **Partnership tiers**: Listed partner → preferred partner → strategic partner
   - **Co-development**: Feature requests, API access, roadmap alignment
   - **Marketplace**: App store listing, category placement, featured status

   ### Strategic / Co-Marketing Partnerships
   Joint activities that share audiences without revenue commitment.

   - **Activities**: Joint webinars, co-authored content, shared events, newsletter swaps
   - **Selection criteria**: Audience overlap, brand alignment, reciprocal value
   - **Structure**: Informal MOU, shared metrics, quarterly review
   - **Lowest barrier, fastest to execute** — start here if new to partnerships

4. **Design program structure**:

   ### Tiers

   | Tier | Criteria | Benefits | Requirements |
   |------|----------|----------|--------------|
   | Registered | Sign up, complete onboarding | Deal registration, basic collateral, partner portal access | Profile completion, NDA |
   | Silver | {revenue/deal threshold} | {enhanced margin, co-marketing credits, dedicated Slack channel} | {certification, quarterly review} |
   | Gold | {higher revenue/deal threshold} | {highest margin, MDF, joint planning, early access} | {full certification, dedicated account manager, QBR} |

   ### Partner Portal Requirements
   - Deal registration system
   - Asset library (sales decks, one-pagers, case studies, logos)
   - Training and certification modules
   - Performance dashboard (deals, revenue, pipeline)
   - Communication hub (announcements, updates)

5. **Define partner enablement**:

   ### Onboarding Kit (first 30 days)
   - Product training (self-serve or live, 2-4 hours)
   - Competitive positioning guide (how to position against alternatives)
   - Demo script and sandbox environment
   - Partner FAQ (pricing, support, escalation)

   ### Sales Collateral (co-branded)
   - Partner pitch deck (customizable template)
   - One-pager / solution brief
   - Case studies (partner-specific or co-branded)
   - ROI calculator or value framework

   ### Technical Enablement
   - Integration guide / API documentation
   - Sandbox / test environment access
   - Technical support escalation path
   - Architecture reference for implementation partners

   ### Ongoing Communication
   - Partner newsletter (monthly: product updates, wins, resources)
   - Quarterly Business Review (QBR) for Silver+ partners
   - Partner Advisory Board (annual, top partners shape roadmap)
   - Slack channel or forum for partner community

6. **Measurement framework**:

   | Metric | What It Measures | Target |
   |--------|-----------------|--------|
   | Partner-sourced revenue | Deals originated by partners | {$X or %} |
   | Partner-influenced revenue | Deals where partner was involved but didn't originate | {$X or %} |
   | Partner activation rate | % of registered partners who close first deal | {>30%} |
   | Time to first deal | Days from registration to first closed deal | {<90 days} |
   | Deal velocity | Sales cycle length for partner deals vs. direct | {same or faster} |
   | Partner satisfaction (NPS) | How partners feel about the program | {>50} |
   | Program ROI | Partner revenue / program costs | {>3:1} |

   **Review cadence:** Monthly pipeline review, quarterly program review, annual program redesign.

## Constraints

- **Model partner economics explicitly** — show the math for partner margin at each tier. If the economics don't work for both sides, the program will fail.
- **Never recommend channel partnerships for pre-PMF products** — partners need a repeatable sales motion to replicate. Fix your own sales process first.
- **Start integrations with API/webhook** — don't build native integrations until demand is validated through lightweight integration usage.
- **Include `[HUMAN GATE]`** for: partner recruitment outreach, contract negotiation, program launch, deal conflict resolution.
- **Cross-reference `/referral-program`** for the referral/affiliate sub-component — don't duplicate referral loop design, incentive structures, or measurement.

## Output

Write the partnership program design to `.deliberate/reports/{slug}/gtm/partnership-program.md`.

## Transition

Feeds into:
- `/referral-program` — Referral and affiliate program mechanics (a subset of the broader partnership program)
- `/sales-outreach-prep` — Partner recruitment outreach sequences
- `/growth-loops` — Partner-driven growth loops (co-marketing, integration network effects)
- `/competitive-battlecard` — Partner ecosystem as competitive differentiator
