---
name: beachhead-segment
description: Identify the first beachhead market segment for launch using Geoffrey Moore's criteria and structured segment evaluation
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Beachhead Segment Analysis

## Objective

Identify and validate the optimal beachhead market segment for initial product launch. The beachhead is the first segment you can dominate — small enough to win decisively, large enough to matter, and strategically positioned to enable expansion into adjacent segments.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What product or feature is being launched?
   - What segments have been hypothesized?
   - What existing data (usage, feedback, revenue) is available?

2. **List candidate segments** (aim for 5-8):
   - Draw from existing customer data, founder hypotheses, and market observation
   - Define each segment precisely: industry + company size + role + use case
   - Avoid segments that are too broad ("SMBs") or too narrow ("left-handed dentists in Vermont")
   - Each candidate must be a real group you could build a contact list for

3. **Evaluate each segment on Geoffrey Moore's criteria** (score 1-5):

   | # | Criterion | 1 (Poor) | 3 (Moderate) | 5 (Excellent) |
   |---|-----------|----------|-------------|---------------|
   | 1 | **Target Customer** — Do they have a compelling reason to buy? | Nice-to-have | Pain exists but workarounds suffice | Hair-on-fire problem, urgent need |
   | 2 | **Whole Product** — Can we deliver a complete solution? | Major gaps, need partners | Some gaps, manageable | We can deliver 100% of what they need |
   | 3 | **Competition** — Can we be #1 in this segment? | Entrenched incumbents | Competitors exist but beatable | No clear leader, greenfield |
   | 4 | **Partners & Allies** — Do we have channel access? | No connections | Some relationships | Strong existing channels |
   | 5 | **Segment Size** — Big enough to matter, small enough to dominate? | Too tiny or too massive | Reasonable but imprecise | Well-defined, $5M-50M addressable |
   | 6 | **Willingness to Pay** — Will they pay enough? | Price-sensitive, low budgets | Budget exists but tight | Active budget, proven spending |
   | 7 | **Word-of-Mouth** — Do they talk to each other? | Isolated buyers | Some community | Tight community, conferences, Slack groups |
   | 8 | **Strategic Value** — Does winning here unlock adjacent segments? | Dead-end niche | Some adjacency | Clear bowling pin path to larger markets |

4. **Score and rank segments**:
   - Calculate weighted total for each segment (all criteria equal weight unless assignment specifies otherwise)
   - Identify top 2-3 candidates
   - For the top candidates, write a paragraph defending the choice and a paragraph arguing against it

5. **Select the beachhead with rationale**:
   - Declare the recommended beachhead segment
   - Explain why it wins over the runner-up(s)
   - Identify the single biggest risk with this choice
   - Define the "bowling pin" adjacency — what segment do you expand to after dominating this one?

6. **Define the entry strategy for the beachhead**:
   - **Positioning**: How to position the product specifically for this segment (not generic)
   - **Messaging**: The core value proposition in their language
   - **Channel**: How to reach them (where they congregate, what they read, who influences them)
   - **Reference customers**: How many lighthouse customers are needed before expansion (typically 5-10)
   - **Success signals**: What metrics prove you've won this segment
   - **Timeline**: Milestones for beachhead dominance

7. **Produce go/no-go recommendation**:
   - GO: Clear beachhead identified, entry strategy is feasible
   - CONDITIONAL GO: Beachhead identified but key assumptions need validation first (list them)
   - NO-GO: No segment scores well enough — recommend further market research or pivot

## Output

Write deliverable to `.deliberate/reports/{slug}/beachhead-analysis.md` including:
- Candidate segment list with definitions
- Scoring matrix (all segments x all criteria)
- Top 2-3 segment deep dives with pro/con arguments
- Selected beachhead with rationale
- Entry strategy (positioning, messaging, channel, reference customer plan)
- Bowling pin adjacency map
- Go/no-go recommendation

## Constraints

- Every score must cite evidence or explicitly flag as assumption
- Segments must be specific enough to build a prospect list from
- Do not conflate "large market" with "good beachhead" — smaller is usually better
- Never recommend more than one beachhead — the whole point is focus
- If data is insufficient to score confidently, recommend specific research to close the gap

## Transition

Beachhead analysis feeds into `/ideal-customer-profile` (to define the ICP within the beachhead), `/gtm-motions` (to select the right go-to-market motion), and `/gtm-messaging` (to craft segment-specific messaging).
