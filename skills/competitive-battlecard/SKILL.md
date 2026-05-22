---
name: competitive-battlecard
description: Create sales-ready competitive battlecards with positioning comparisons, objection rebuttals, trap-setting questions, and win/loss themes
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:acquisition"
---

# Competitive Battlecard

## Objective

Produce sales-ready competitive battlecards that enable reps to confidently handle competitive situations during discovery calls, demos, and negotiations. Each battlecard should be a 1-2 page quick-reference document a rep can scan in 60 seconds before a call.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Which competitors need battlecards?
   - Is there an existing competitive teardown to build from?
   - What win/loss data is available?
   - What are the most common competitive situations reps encounter?

2. **Gather competitive intelligence per competitor**:
   - Review existing competitive teardown (`.deliberate/reports/{slug}/competitive-teardown.md`) if available
   - Product website: features, pricing, positioning, customer logos
   - Review sites: G2, Capterra, TrustRadius — recurring praise and complaints
   - Recent announcements: funding, launches, pivots, leadership changes
   - Social and community signals: what users love and hate

3. **Build the battlecard for each competitor** with these sections:

   **Quick Facts Box**:
   - Company: name, founded, HQ, funding, estimated revenue/ARR
   - Product: one-line description of what they do
   - Target market: who they sell to
   - Pricing: model and approximate tiers
   - Recent news: 1-2 bullet points on latest moves

   **Positioning Comparison (Us vs. Them)**:
   | Dimension | Us | Them |
   |-----------|-----|------|
   | Core value prop | ... | ... |
   | Primary audience | ... | ... |
   | Approach | ... | ... |
   | Key differentiator | ... | ... |

   **Strengths to Acknowledge**:
   - 3-5 genuine strengths of the competitor
   - Frame: "They're good at X, but here's why that matters less than Y..."
   - Never trash the competitor — credibility comes from honest acknowledgment

   **Weaknesses to Exploit**:
   - 3-5 weaknesses with evidence (reviews, feature gaps, customer complaints)
   - For each: the question to ask that surfaces this weakness naturally

   **Common Objections with Rebuttals**:
   | Objection | Rebuttal | Proof Point |
   |-----------|----------|-------------|
   | "Competitor X has more features" | ... | ... |
   | "Competitor X is cheaper" | ... | ... |
   | "We already use Competitor X" | ... | ... |
   | "Competitor X has bigger customers" | ... | ... |

   **Trap-Setting Questions for Discovery**:
   - Questions that expose competitor weaknesses without naming the competitor
   - Example: "How much time does your team spend on [thing competitor handles poorly]?"
   - 5-7 questions, each tied to a specific competitive advantage
   - Frame as genuine curiosity about the prospect's workflow

   **Win Themes** (why we win against this competitor):
   - 3-5 recurring reasons deals are won
   - Supporting evidence or customer quotes where available

   **Loss Patterns** (why we lose against this competitor):
   - 3-5 recurring reasons deals are lost
   - What to watch for early in the deal cycle
   - How to preempt each loss pattern

   **Pricing Comparison**:
   - Side-by-side pricing at comparable tiers
   - Hidden costs the competitor has (implementation, seats, overages)
   - TCO comparison if favorable
   - How to handle "they're cheaper" when they are

   **Migration Talking Points**:
   - How to pitch switching from this competitor
   - Data migration story (easy/hard, supported/manual)
   - Switching cost framing (cost of staying vs. cost of switching)
   - Implementation timeline comparison
   - Risk mitigation (trial period, parallel run, rollback plan)

4. **Format for quick reference**:
   - Use headers, bold, and tables for scannability
   - Keep each battlecard to 1-2 pages when printed
   - Lead with the most commonly needed sections
   - Include a "cheat sheet" summary at the top: 3 things to say, 3 things to ask, 3 things to avoid

5. **Create a competitive landscape summary**:
   - One-page overview of all competitors analyzed
   - When to use which battlecard (based on deal signals)
   - Overall competitive positioning statement

## Output

Write deliverables to `.deliberate/reports/{slug}/` including:
- `battlecard-{competitor-name}.md` for each competitor
- `competitive-landscape-summary.md` with overview and positioning

## Constraints

- Battlecards must be factual — never fabricate competitor capabilities or pricing
- Acknowledge competitor strengths honestly; credibility with reps requires truthfulness
- If win/loss data is unavailable, note this and recommend how to collect it
- Objection rebuttals must be conversational, not scripted — reps need talking points, not scripts
- Update recommendation: battlecards should be refreshed quarterly or after major competitor moves
- Trap-setting questions must feel natural in conversation, not manipulative or aggressive

## Transition

Battlecards are used by sales directly. They also feed into `/gtm-messaging` (competitive positioning in marketing) and `/growth-strategy` (strategic response to competitive landscape).
