---
name: competitive-teardown
description: Analyze competitor products — feature comparison, pricing breakdown, SWOT analysis, positioning maps, and action plan
allowed-tools: Read, Write, Glob, Grep, Bash
---

# Competitive Teardown

## Objective

Produce structured competitive intelligence that drives product and go-to-market decisions.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Which 2-4 competitors to analyze?
   - Which is the primary focus?
   - What decisions will this analysis inform?

2. **Collect data from multiple sources per competitor**:
   - **Website**: pricing tiers, feature lists, CTA, case studies, integration logos, trust signals
   - **App store reviews**: praise (defend these), feature requests (opportunity gaps), bugs (quality signals), UX complaints (friction to beat)
   - **Job postings**: engineering volume (scaling?), tech stack mentions, sales/CS ratio (PLG vs. sales-led?), data/ML roles (AI features incoming?)
   - **SEO signals**: top organic keywords, domain authority, blog cadence
   - **Social mentions**: recurring praise, complaints, feature requests

3. **Score each competitor using 12-dimension rubric** (1-5 scale):

   | # | Dimension | 1 (Weak) | 3 (Average) | 5 (Best-in-class) |
   |---|-----------|----------|-------------|-------------------|
   | 1 | Features | Core only, gaps | Solid coverage | Comprehensive + unique |
   | 2 | Pricing | Confusing / overpriced | Market-rate, clear | Transparent, flexible |
   | 3 | UX | Confusing, friction | Functional | Delightful, minimal friction |
   | 4 | Performance | Slow, unreliable | Acceptable | Fast, high uptime |
   | 5 | Docs | Sparse, outdated | Decent | Comprehensive, searchable |
   | 6 | Support | Email only, slow | Chat + email | 24/7, great response |
   | 7 | Integrations | 0-5 | 6-25 | 26+ or deep ecosystem |
   | 8 | Security | No mentions | SOC2 claimed | SOC2 Type II, ISO 27001 |
   | 9 | Scalability | No enterprise tier | Mid-market ready | Enterprise-grade |
   | 10 | Brand | Generic | Decent positioning | Strong, differentiated |
   | 11 | Community | None | Forum / Slack | Active, vibrant |
   | 12 | Innovation | No recent releases | Quarterly | Frequent, meaningful |

   Every score must have supporting evidence.

4. **Generate analysis outputs**:

   **Feature comparison matrix**: rows = features, columns = our product + competitors, score 1-5 each.

   **Pricing analysis**: model type, entry/mid/enterprise prices, free trial length, price leader vs. value leader.

   **SWOT per competitor**: 3-5 bullets per quadrant, every bullet anchored to a data signal.

   **Positioning map**: 2×2 axes (e.g., Simple↔Complex × Low Value↔High Value), place each competitor.

5. **Build prioritized action plan**:

   | Horizon | Effort | Examples |
   |---------|--------|---------|
   | Quick wins (0-4 wks) | Low | Comparison landing page, review badges |
   | Medium-term (1-3 mo) | Moderate | Free tier, onboarding improvement, top integration |
   | Strategic (3-12 mo) | High | New market entry, API v2, SOC2 Type II |

## Output

Write deliverable to `.deliberate/reports/{slug}/competitive-teardown.md` including:
- 12-dimension scorecard for each competitor
- Feature comparison matrix
- Pricing analysis summary
- SWOT per competitor
- Positioning map (ASCII)
- Prioritized action plan by horizon
