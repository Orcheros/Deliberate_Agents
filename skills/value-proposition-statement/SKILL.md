---
name: value-proposition-statement
description: Craft value proposition statements using JTBD template — produce context-specific statements for marketing, sales, onboarding, and investor pitch with validation criteria
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Value Proposition Statement

## Objective

Craft clear, compelling value proposition statements using the Jobs-to-be-Done (JTBD) framework. Produce context-specific variations for marketing, sales, onboarding, and investor audiences — each telling the same core story adapted for its context.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What product or feature needs a value proposition?
   - What ICP and positioning work has been done?
   - What JTBD research or customer feedback is available?
   - What existing value propositions exist (if any)?

2. **Research the core job-to-be-done**:

   Interview data, support tickets, reviews, or founder knowledge should inform:
   - **Functional job**: What task is the customer trying to accomplish?
   - **Emotional job**: How do they want to feel during and after?
   - **Social job**: How do they want to be perceived by others?
   - **Trigger**: What event causes them to start looking for a solution?
   - **Hiring criteria**: What factors determine which solution they "hire"?
   - **Firing criteria**: What would cause them to "fire" your product?

3. **Build the 6-part value proposition using the JTBD template**:

   **Part 1 — WHO** (Target Customer):
   - Define the specific customer, not a demographic but a situation
   - "When a [role] at a [company type] is facing [situation]..."
   - The more specific the situation, the more the right customer feels seen

   **Part 2 — WHY** (The Job They're Hiring For):
   - State the job in the customer's language
   - Include the functional, emotional, and social dimensions
   - "They need to [functional job] so they can [emotional/social outcome]..."

   **Part 3 — WHAT BEFORE** (Current Alternatives):
   - Describe how they currently solve this job
   - Name the specific alternatives (competitors, manual processes, workarounds)
   - Articulate the pain: "Today they [alternative], which means [specific pain]..."
   - Quantify the pain where possible (time, money, risk, frustration)

   **Part 4 — HOW** (Our Approach):
   - Describe how the product solves the job differently
   - Focus on the approach, not features
   - "Our product [approach] by [mechanism]..."
   - This should make the differentiation from alternatives obvious

   **Part 5 — WHAT AFTER** (Transformed Experience):
   - Paint the picture of life after adoption
   - "Now they can [new capability] which means [outcome]..."
   - Include quantified outcomes where possible
   - This is the promise — make it specific and believable

   **Part 6 — ALTERNATIVES** (Why Not Them):
   - For each major alternative, explain why the customer would choose you
   - "Unlike [alternative] which [limitation], we [advantage]..."
   - Be specific about what you do better, not vague claims of superiority

4. **Produce context-specific value proposition statements**:

   ### Marketing / Website Statement
   - Audience: prospects who are problem-aware but may not be solution-aware
   - Tone: aspirational but credible
   - Length: 2-3 sentences maximum
   - Purpose: get them to explore further (click, scroll, sign up)
   - Emphasis: Parts 1, 2, and 5 (who, why, transformed experience)

   ### Sales Pitch Statement
   - Audience: prospects in active evaluation, often with a champion and decision maker
   - Tone: confident, evidence-based
   - Length: 30-60 second verbal pitch
   - Purpose: differentiate from alternatives and earn the next meeting
   - Emphasis: Parts 3, 4, and 6 (current pain, our approach, why not them)

   ### Onboarding Statement
   - Audience: new users who have already signed up but haven't experienced value
   - Tone: encouraging, action-oriented
   - Length: 1-2 sentences + a clear first action
   - Purpose: motivate them to complete activation and experience the "aha moment"
   - Emphasis: Parts 4 and 5 (how it works, what success looks like)

   ### Investor Pitch Statement
   - Audience: investors evaluating market opportunity and team
   - Tone: ambitious but grounded in evidence
   - Length: 2-4 sentences
   - Purpose: convey market size, differentiation, and traction
   - Emphasis: Parts 1, 2, and 5 with market sizing context

5. **Define validation criteria for each statement**:

   Each value proposition must pass these tests:

   | Test | Question | Pass Criteria |
   |------|----------|--------------|
   | **Clarity test** | Can someone understand it in under 10 seconds? | No jargon, no ambiguity |
   | **Specificity test** | Is it specific to your product, or could a competitor say it? | Unique to your offering |
   | **Believability test** | Is there evidence to support the claim? | At least one proof point |
   | **Relevance test** | Does the target customer recognize their situation? | Tested with 3+ target customers |
   | **Action test** | Does it motivate the next step? | Clear CTA implied or stated |
   | **Differentiation test** | Is it clear why this is better than alternatives? | Named alternatives are weaker |

   For each statement, mark each test as: Pass, Conditional (needs evidence), or Fail (needs revision).

6. **Create A/B variations**:
   - For the marketing statement: 2-3 variations emphasizing different value themes
   - For the sales pitch: a version for technical buyers vs. business buyers
   - Recommend which variation to test first and how (landing page, email, sales call)

7. **Synthesize the core value proposition**:
   - Write a single "master" value proposition that captures all 6 parts
   - This is the internal reference document — every context-specific version should be traceable back to it
   - Include a one-sentence "elevator pitch" distillation

## Output

Write deliverable to `.deliberate/reports/{slug}/value-proposition.md` including:
- JTBD research summary (functional, emotional, social jobs)
- 6-part value proposition (master version)
- Marketing / website statement with validation
- Sales pitch statement with validation
- Onboarding statement with validation
- Investor pitch statement with validation
- Validation criteria results (pass/conditional/fail per test per statement)
- A/B test variations with test recommendations
- One-sentence elevator pitch

## Constraints

- Value propositions must use customer language, not internal product language
- Every claim must have evidence or be flagged as "needs validation"
- The JTBD must come from customer research, not product team assumptions — if no research exists, flag this
- Do not write generic value props that any product in the category could claim
- Context-specific statements must serve their specific audience and purpose — an investor statement is not a marketing statement
- Keep statements concise — verbosity kills value propositions

## Transition

Value proposition statements feed into `/gtm-messaging` (messaging built on the value prop), `/competitive-battlecard` (value prop vs. competitors), and are used directly by Content Writer and SDR agents.
