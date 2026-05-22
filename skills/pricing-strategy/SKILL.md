---
name: pricing-strategy
description: Design, audit, or restructure SaaS pricing — tier structure, value metrics, price points, and pricing page design
allowed-tools: Read, Write, Glob, Grep
aaaerrr-zone: "flywheel:revenue"
---

# Pricing Strategy

## Objective

Design or optimize pricing that captures the value delivered, converts at a healthy rate, and scales with customers.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Is this a new pricing design, optimization of existing pricing, or a price increase?
   - What specific deliverables are expected?

2. **Gather context**:
   - Read `marketing-context.md` if available
   - Current pricing (plans, price points, billing model)
   - Conversion rate from trial/free to paid
   - Average revenue per customer and monthly churn rate
   - Competitor pricing and positioning

3. **Select the value metric** — what you charge for determines how pricing scales:

   | Metric | Best For | Example |
   |--------|---------|---------|
   | Per seat / user | Collaboration tools, CRMs | Salesforce, Notion |
   | Per usage | API tools, infrastructure, AI | Stripe, Twilio |
   | Per feature | Platform plays, add-ons | HubSpot |
   | Flat fee | Unlimited-feel, SMB tools | Basecamp |
   | Hybrid | Mix of above | Most mature SaaS |

   **Choose by answering:** What makes a customer willing to pay more? Does it scale with their success? Is it easy to understand? Is it hard to game?

4. **Design Good-Better-Best tiers**:
   - **Entry (Good)**: Captures the price-sensitive segment; limited features/usage; covers costs
   - **Middle (Better)**: Where most customers land; 2-3x entry price; call out as recommended
   - **Top (Best)**: Enterprise needs — SSO, audit logs, SLA, dedicated support; may be "Contact us"

   | Feature Category | Entry | Better | Best |
   |----------------|-------|--------|------|
   | Core product | Limited | Full | Full |
   | Usage limits | Low | Medium | High / unlimited |
   | Users/seats | 1-3 | 5-unlimited | Unlimited |
   | Support | Email | Priority | Dedicated CSM |
   | Admin features | — | — | SSO, audit log, SCIM |

5. **Set price points using value-based pricing**:
   - Price between the next-best alternative and perceived value delivered
   - Heuristic: price at 10-20% of documented value delivered
   - Conversion rate signals: >40% trial-to-paid = likely underpriced; 15-30% = healthy; <10% = too high or funnel friction

6. **Design the pricing page** (if applicable):
   - Above fold: plan names, price with billing toggle, 3-5 bullet differentiators, CTA per plan, "Most popular" badge
   - Below fold: full feature comparison table, FAQ (5 objections), social proof, security badges
   - Show annual pricing by default with explicit savings ("Save 20%" or "2 months free")

7. **If planning a price increase**:
   - Calculate new MRR at 100%, 80%, 70% retention
   - Segment by risk (annual contracts, champions vs. detractors)
   - 60-90 days notice for existing; offer lock-in for annual commitment
   - Communicate specific reason (new features, rising costs)
   - Expected churn from 20-30% increase: 5-15%

## Red Flags to Surface

- Conversion rate >40% trial-to-paid → underpriced, test 20-30% increase
- All customers on middle tier → no upsell path, enterprise tier needed
- Price unchanged in 2+ years → inflation alone justifies 10-15% increase
- Only one pricing option → no anchoring, no upsell

## Output

Write deliverable to `.deliberate/reports/{slug}/pricing-strategy.md` including:
- Recommended tier structure with value metric rationale
- Feature grid showing what's in each tier
- Price points with justification
- Pricing page copy recommendations
- If price increase: rollout plan with communication templates
