---
name: product-naming
description: Creative product naming — brainstorm names across categories, evaluate on memorability, pronounceability, domain strategy, trademark risk, and emotional associations
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Product Naming

## Objective

Generate, evaluate, and recommend product or feature names through a structured creative process. Good names are memorable, meaningful, and available. This skill applies to products, features, company names, and project codenames.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What is being named (product, feature, company, project)?
   - What is the product's positioning and value proposition?
   - What is the target audience?
   - Are there any naming constraints (must include a word, must avoid a word, character limits)?
   - What existing brand names or naming patterns exist in the company?

2. **Define naming criteria**:

   **Brand values**: What 3-5 attributes should the name evoke? (e.g., speed, precision, warmth, innovation)

   **Audience expectations**: What naming conventions does the target audience expect?
   - Developer tools: often short, technical, lowercase (git, docker, rust)
   - Enterprise SaaS: professional, trustworthy, sometimes compound (Salesforce, Workday)
   - Consumer: friendly, memorable, sometimes playful (Spotify, Slack, Notion)

   **Tone**: Where on the spectrum?
   - Serious ←→ Playful
   - Technical ←→ Approachable
   - Established ←→ Disruptive
   - Descriptive ←→ Abstract

   **Practical constraints**:
   - Maximum character length
   - Must work internationally (no negative connotations in key markets)
   - Must fit with existing product family naming
   - Domain extension preferences (.com, .io, .dev, .ai)

3. **Brainstorm names across five categories** (generate 30-50 raw candidates):

   **Descriptive names**: Directly describe what the product does.
   - Pros: immediately clear, SEO-friendly
   - Cons: generic, hard to trademark, limiting as product evolves
   - Examples: Booking.com, The Weather Channel, General Motors

   **Suggestive names**: Evoke a quality or benefit without directly describing.
   - Pros: memorable, trademarkable, room to grow
   - Cons: may require explanation initially
   - Examples: Slack (casual communication), Stripe (seamless), Notion (ideas)

   **Abstract names**: Invented words with no inherent meaning.
   - Pros: highly trademarkable, unique, ownable
   - Cons: require brand building to create meaning, no inherent SEO value
   - Examples: Xerox, Kodak, Spotify

   **Acronym names**: Derived from longer phrases.
   - Pros: short, professional
   - Cons: forgettable, may conflict with existing acronyms, no emotional resonance
   - Examples: IBM, AWS, SAP

   **Founder/Origin names**: Based on people, places, or origin stories.
   - Pros: humanizing, story-driven, unique
   - Cons: may not scale, hard to spell if unusual
   - Examples: Bloomberg, Hewlett-Packard, Patagonia

4. **First-pass filter** (narrow 30-50 to 15-20):
   - Eliminate names that are impossible to spell or pronounce
   - Eliminate names with obvious negative connotations
   - Eliminate names too similar to well-known brands
   - Eliminate names that don't pass the "phone test" (can you say it on a phone call without spelling it?)

5. **Evaluate remaining candidates** (score 1-5 on each criterion):

   | Criterion | Weight | Description |
   |-----------|--------|-------------|
   | **Memorability** | High | Would someone remember it after hearing it once? |
   | **Pronounceability** | High | Can anyone say it correctly on first try? |
   | **Spellability** | High | Can someone type it after hearing it? |
   | **Domain availability strategy** | Medium | Is exact .com available? If not, is there a workable alternative? |
   | **Trademark risk** | High | Any existing marks in the same class? Initial assessment only — not legal advice. |
   | **International considerations** | Medium | Negative meanings in key markets? Pronounceable across languages? |
   | **Emotional associations** | Medium | What feelings or images does it evoke? Are they aligned with brand values? |
   | **Distinctiveness** | Medium | Does it stand out from competitors' names? |
   | **Scalability** | Low | Will the name still work if the product scope expands? |
   | **SEO potential** | Low | Is the name search-friendly? Can you own it in search results? |

6. **Shortlist 5-10 names with detailed rationale**:

   For each shortlisted name:
   - Category (descriptive, suggestive, abstract, acronym, founder)
   - Scores on all criteria
   - Why it works (1-2 sentences)
   - Potential concerns (1-2 sentences)
   - Domain strategy: preferred domain and alternatives
   - Tagline pairing: a suggested tagline that complements the name
   - Visual impression: how the name might look as a wordmark (all-caps, lowercase, mixed)

7. **Produce recommendation**:
   - Top 3 recommended names with ranking rationale
   - For each: the case for and the case against
   - Recommended next steps: domain registration, trademark search, customer testing
   - Naming alternatives if top choices are unavailable

## Output

Write deliverable to `.deliberate/reports/{slug}/product-naming.md` including:
- Naming criteria and brand values
- Full brainstorm list organized by category (30-50 names)
- First-pass filter results (what was cut and why)
- Detailed evaluation of shortlisted names (5-10)
- Scoring matrix
- Top 3 recommendation with rationale per name
- Domain strategy per recommended name
- Next steps (trademark search, testing, registration)

## Constraints

- This is creative brainstorming, not legal advice — all trademark assessments are preliminary and require professional validation
- Domain availability suggestions are strategies, not verified availability — checking requires actual registration lookups
- Names must be evaluated in context of the product's positioning and audience, not in the abstract
- Do not recommend a name solely because it's clever — it must serve the brand strategy
- International considerations are especially important for products with global ambitions
- Include at least one "safe" choice (clearly descriptive) and one "bold" choice (more creative) in the final recommendation

## Transition

Product naming feeds into `/gtm-messaging` (the name becomes part of the messaging framework), `/positioning-statement` (name must align with positioning), and brand identity work.
