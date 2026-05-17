---
name: gtm-messaging
description: Build a GTM messaging and positioning framework with messaging hierarchy, persona-specific variations, channel-adapted messaging matrix, and A/B test recommendations
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# GTM Messaging Framework

## Objective

Create a comprehensive messaging and positioning framework that ensures consistent, compelling communication across all channels and personas. The framework gives every team member — marketing, sales, product, support — the same core story told in the right way for their context.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What product, feature, or launch needs messaging?
   - What existing positioning or messaging exists?
   - What personas/ICPs have been defined?
   - What competitive context should the messaging address?

2. **Define the target audience**:
   - Primary persona(s) with role, seniority, and daily context
   - What they care about (outcomes, not features)
   - How they describe their problems (in their language, not yours)
   - Where they are in the awareness spectrum: Unaware → Problem-Aware → Solution-Aware → Product-Aware → Most Aware

3. **Articulate the core value proposition**:
   - **For** [target customer]
   - **Who** [statement of need or opportunity]
   - **Our product is** [product category]
   - **That** [key benefit / reason to believe]
   - **Unlike** [primary competitive alternative]
   - **We** [primary differentiation]

   Test the value prop against these criteria:
   - [ ] Specific (not generic enough to apply to any product)
   - [ ] Differentiated (couldn't be said by a competitor)
   - [ ] Valuable (articulates a benefit the customer cares about)
   - [ ] Believable (supported by evidence or demonstrable)
   - [ ] Concise (can be communicated in under 10 seconds)

4. **Craft the messaging hierarchy**:

   **Headline** (5-8 words):
   - Captures the primary benefit or transformation
   - Passes the "so what?" test
   - Creates curiosity or recognition

   **Subheadline** (15-25 words):
   - Explains how the headline is achieved
   - Introduces the product category or approach
   - Addresses the primary objection or question

   **Three Key Messages** (1-2 sentences each):
   - Each addresses a different dimension of value (e.g., speed, cost, quality)
   - Each is supported by a proof point (stat, case study, demo)
   - Together they form a complete argument for the product

   **Proof Points** (per key message):
   - Quantitative: metrics, benchmarks, ROI calculations
   - Social: customer quotes, logos, case studies
   - Demonstrable: feature demos, free trial, sample output

5. **Create persona-specific messaging variations**:

   For each persona defined in step 2:

   | Element | Persona A (e.g., VP Engineering) | Persona B (e.g., IC Developer) |
   |---------|----------------------------------|-------------------------------|
   | Hook | What grabs their attention | What grabs their attention |
   | Pain | Their specific pain point | Their specific pain point |
   | Benefit | Outcome they care about | Outcome they care about |
   | Proof | Evidence that resonates | Evidence that resonates |
   | CTA | Action that makes sense for them | Action that makes sense for them |
   | Objection | Their primary concern | Their primary concern |
   | Rebuttal | How to address it | How to address it |

6. **Define tone and voice guidelines**:
   - **Voice attributes**: 3-5 adjectives that define the brand voice (e.g., confident, precise, human)
   - **Voice anti-attributes**: what the voice is NOT (e.g., not corporate, not casual, not aggressive)
   - **Writing rules**: specific do's and don'ts
   - **Vocabulary**: preferred terms vs. avoided terms
   - **Example sentences**: "We say X, not Y"

7. **Build the channel messaging matrix**:

   | Element | Website | Email | Social | Sales Deck | Product UI |
   |---------|---------|-------|--------|------------|------------|
   | Headline | ... | Subject line | Hook | Slide title | Tooltip/banner |
   | Key message | ... | Body copy | Post | Talking point | Feature description |
   | Proof point | ... | CTA context | Social proof | Demo | Onboarding tip |
   | CTA | ... | Button text | Link/reply | Next step | Action button |
   | Tone | ... | ... | ... | ... | ... |
   | Length | ... | ... | ... | ... | ... |

8. **Create before/after messaging for A/B testing**:
   - For each key message, provide 2-3 variations at different levels:
     - **Benefit-led** vs. **Feature-led** vs. **Social-proof-led**
     - **Direct** vs. **Curiosity-driven** vs. **Problem-agitation**
   - Define test hypotheses: "Version A will outperform B because..."
   - Specify measurement: what metric determines the winner (CTR, conversion, engagement)

## Output

Write deliverable to `.deliberate/reports/{slug}/gtm-messaging.md` including:
- Target audience definition
- Core value proposition (tested against criteria)
- Messaging hierarchy (headline, subheadline, 3 key messages, proof points)
- Persona-specific messaging variations
- Tone and voice guidelines
- Channel messaging matrix
- A/B test variations with hypotheses
- Messaging do's and don'ts

## Constraints

- All messaging must use customer language, not internal jargon
- Features are never messages — they support messages (the benefit is the message)
- Every claim must have a proof point or be flagged as needing validation
- Messaging must be differentiated — if a competitor could say the same thing, it's not good enough
- Do not create messaging for personas that haven't been validated
- Keep the framework practical — a 50-page messaging doc that nobody reads is worse than a 3-page one that everyone uses

## Transition

Messaging framework feeds into `/competitive-battlecard` (competitive messaging), `/growth-plan` (campaign messaging), and is used directly by Content Writer and SDR agents for execution.
