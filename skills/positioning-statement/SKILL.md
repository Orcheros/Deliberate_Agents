---
name: positioning-statement
description: Craft product positioning using April Dunford's "Obviously Awesome" framework — competitive alternatives, unique attributes, value, target customers, market category, and positioning maps
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Positioning Statement

## Objective

Develop rigorous product positioning using April Dunford's "Obviously Awesome" framework. Positioning is the foundation of all messaging — it defines the context that makes the product's value obvious to the right customers. Bad positioning makes a good product invisible; good positioning makes a good product irresistible.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What product or feature needs positioning?
   - What existing positioning exists (if any)?
   - What customer feedback or win/loss data is available?
   - What competitive context should be considered?

2. **Identify Competitive Alternatives** (Step 1 of Dunford framework):

   Ask: "What would customers do if our product didn't exist?"

   - List all alternatives: direct competitors, indirect competitors, manual processes, status quo (do nothing)
   - For each alternative, note: what it does well, what it does poorly, and how customers currently feel about it
   - Focus on what customers ACTUALLY use today, not what you think they should compare you to
   - The most common alternative is often "do it manually" or "use a spreadsheet," not a competitor

3. **Identify Unique Attributes** (Step 2):

   Ask: "What do we have that the alternatives don't?"

   - List every feature, capability, or characteristic that differentiates from the alternatives identified in Step 1
   - Include: features, technology, business model, approach, team expertise, data assets, integrations
   - Be honest — only include genuinely unique attributes, not table-stakes features
   - Each attribute must be defensible (hard to copy or at least hard to copy well)

4. **Map Value per Attribute** (Step 3):

   Ask: "So what? What does each unique attribute enable for customers?"

   | Unique Attribute | Value to Customer | Evidence |
   |-----------------|-------------------|----------|
   | [Feature X] | [Outcome Y] | [Customer quote, data, demo] |

   - Value must be expressed as a customer outcome, not a feature description
   - "AI-powered" is an attribute; "saves 4 hours/week on report generation" is value
   - Cluster values into 1-3 value themes (the big reasons to choose this product)

5. **Define Target Customer Characteristics** (Step 4):

   Ask: "Who cares the most about the value we deliver?"

   - Define the characteristics that make someone care deeply about your unique value
   - These are not demographics — they're situations, behaviors, and contexts
   - Example: "Teams that currently spend >10 hours/week on manual reporting" not "mid-market companies"
   - The best target customers are those for whom the alternatives are most painful

6. **Determine Market Category** (Step 5):

   Ask: "What market context makes our value obvious?"

   Three positioning strategies:
   - **Head-to-head**: Compete in an existing category (requires clear differentiation)
   - **Subcategory**: Create a niche within an existing category (e.g., "CRM for real estate")
   - **New category**: Define an entirely new category (risky, expensive, but powerful if it works)

   For each strategy, evaluate:
   - Does the category make the product's strengths obvious?
   - Do buyers understand this category and know how to evaluate products in it?
   - Does it trigger the right comparisons (where you win) and avoid wrong ones (where you lose)?

7. **Identify Market Trends** (Step 6, optional):

   If a relevant market trend makes the positioning stronger:
   - Name the trend and evidence it's real (not hype)
   - Explain how the trend makes your product more relevant
   - Only use trends that genuinely help — forced trend-riding weakens positioning

8. **Compose the positioning statement**:

   **Short form** (internal reference):
   > For [target customers] who are dissatisfied with [competitive alternatives], [product name] is a [market category] that [key value proposition]. Unlike [primary alternative], we [primary differentiation].

   **Positioning canvas**:

   | Element | Definition |
   |---------|-----------|
   | Competitive alternatives | What customers would use if we didn't exist |
   | Unique attributes | What we have that alternatives don't |
   | Value themes | Why those attributes matter to customers |
   | Target customer characteristics | Who cares most about this value |
   | Market category | Context that makes our value obvious |
   | Market trend (optional) | Tailwind that increases relevance |

9. **Create a competitive positioning map** (2x2 ASCII):

   Select the two axes that best highlight your product's differentiation:

   ```
                        High [Axis Y]
                             │
                             │
                     ┌───────┼───────┐
                     │  C    │       │
                     │       │   US  │
            Low ─────┼───────┼───────┼───── High [Axis X]
                     │       │       │
                     │  A    │   B   │
                     └───────┼───────┘
                             │
                        Low [Axis Y]
   ```

   - Create 2-3 maps with different axis pairs to show positioning from multiple angles
   - Axes should represent dimensions customers actually evaluate on
   - Every placement must be defensible with evidence

10. **Define messaging tests**:
    - 3 variations of the positioning statement to test with customers
    - For each: what it emphasizes differently
    - Test method: landing page A/B test, customer interviews, sales call testing
    - Success criteria: which variation resonates most and how you'll measure

## Output

Write deliverable to `.deliberate/reports/{slug}/positioning-statement.md` including:
- Competitive alternatives analysis
- Unique attributes inventory
- Value mapping (attributes to customer outcomes)
- Target customer characteristics
- Market category recommendation (head-to-head, subcategory, or new category)
- Market trend alignment (if applicable)
- Positioning statement (short form)
- Positioning canvas (complete framework)
- Competitive positioning maps (2-3, ASCII 2x2)
- Messaging test variations with test plan

## Constraints

- Positioning must start from competitive alternatives, not from the product — this is the core of Dunford's insight
- Unique attributes must be genuinely unique, not aspirational
- Value must be expressed as customer outcomes, not feature descriptions
- Do not pick a market category just because it sounds good — it must trigger the right buyer expectations
- New category creation should be recommended rarely and with strong justification
- Positioning is not messaging — positioning is the strategic foundation; messaging is how it's communicated

## Transition

Positioning feeds directly into `/gtm-messaging` (translating positioning into messaging), `/competitive-battlecard` (positioning vs. competitors), and `/value-proposition-statement` (value prop derived from positioning).
