---
name: brainstorm-ideas
description: Generate solution ideas from multiple perspectives (PM, Designer, Engineer) for both existing and new products
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Brainstorm Ideas

## Objective

Generate a broad, multi-perspective set of solution ideas for a given problem space or opportunity. Avoid premature convergence by forcing ideation through distinct lenses before ranking and filtering.

## Instructions

1. **Frame the problem space**:
   - Read the initiative context, opportunity statement, or assignment file
   - Define the problem clearly: who is affected, what is broken or missing, what outcome we want
   - Identify whether this is an **existing product** enhancement or a **new product/feature** exploration
   - List any known constraints (technical, regulatory, timeline, resource)

2. **PM perspective — value and metrics gaps**:
   - What user pain points are unaddressed or underserved?
   - Where are users dropping off, churning, or expressing frustration?
   - What metrics are stagnant or declining, and what changes could move them?
   - What adjacent problems do users face that we could solve with existing infrastructure?
   - What competitive gaps exist that represent opportunity?
   - Generate 5-10 ideas from this lens

3. **Designer perspective — experience and usability gaps**:
   - Where is the UX creating unnecessary friction or cognitive load?
   - What workflows require too many steps, screens, or context switches?
   - Where are users confused, making errors, or abandoning tasks?
   - What accessibility gaps exist (screen readers, keyboard nav, color contrast, internationalization)?
   - What delightful interactions could differentiate the experience?
   - Generate 5-10 ideas from this lens

4. **Engineer perspective — technical leverage and debt**:
   - What technical debt, if resolved, would unlock faster feature development?
   - What performance bottlenecks are degrading user experience?
   - What infrastructure improvements would enable new capabilities?
   - What existing capabilities are underutilized and could be exposed to users?
   - What emerging technologies or patterns could be applied?
   - Generate 5-10 ideas from this lens

5. **New product exploration** (if applicable, replace steps 2-4 with):
   - **Problem-space exploration**: Who has this problem? How do they solve it today? What are the switching costs? What triggers the need?
   - **Solution brainstorming**: What are radically different approaches? What if we solved only the core job? What would a 10x solution look like vs. a 10% improvement?
   - **Analogy transfer**: How have similar problems been solved in other industries or domains?
   - Generate 10-15 ideas across these sub-lenses

6. **Consolidate and rank**:
   - Merge overlapping ideas across perspectives
   - For each unique idea, note:
     - **Source perspective(s)**: PM / Designer / Engineer
     - **Rationale**: Why this idea has potential (1-2 sentences)
     - **Impact estimate**: High / Medium / Low
     - **Confidence**: High (evidence-backed) / Medium (informed intuition) / Low (speculative)
     - **Effort estimate**: S / M / L / XL
   - Rank by impact-to-effort ratio, with confidence as a tiebreaker
   - Highlight the top 5 ideas as recommended candidates for further exploration

7. **Write the ideation document**:
   - Include: problem framing, ideas by perspective, consolidated ranked list, top 5 recommendations, and suggested next steps
   - Write to the initiative directory or `.deliberate/reports/{slug}/brainstorm-ideas.md`

## Output

- A structured ideation document containing:
  - Problem space definition and constraints
  - Ideas grouped by perspective (PM, Designer, Engineer) or exploration lens
  - Consolidated ranked list with rationale, impact, confidence, and effort per idea
  - Top 5 recommended ideas with suggested next steps (experiment, prototype, or further research)

## Constraints

- Generate at least 15 ideas before filtering — breadth first
- Do not self-censor during generation; wild ideas often seed practical ones
- Every idea must include a rationale — no unexplained entries
- Do not bias toward engineering-heavy solutions; balance across all perspectives
- Do not modify application code — this produces documentation only

## Transition

Top ideas feed into `/identify-assumptions` to map riskiest assumptions, then into `/design-experiments` to validate them. Validated ideas eventually flow into `/pm-intake` or `/opportunity-solution-tree`.
