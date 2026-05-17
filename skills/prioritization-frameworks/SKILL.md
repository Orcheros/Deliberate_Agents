---
name: prioritization-frameworks
description: Reference guide to 9 prioritization frameworks — assess context, recommend a framework, and apply it to the backlog
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Prioritization Frameworks

## Objective

Serve as a reference and execution guide for 9 prioritization frameworks. Assess the team's context, recommend the most appropriate framework(s), and apply the selected framework to the provided backlog.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What backlog or item list needs prioritization?
   - What is the team's current context (stage, constraints, goals)?

2. **Assess context to select framework**:
   - Team size and maturity
   - Data availability (do we have metrics, or are we estimating?)
   - Decision urgency (quick triage vs. rigorous analysis)
   - Stakeholder alignment (high agreement vs. competing priorities)
   - Recommend 1-2 frameworks best suited to the context

3. **Framework Reference**:

   **1. RICE** (Reach x Impact x Confidence / Effort):
   - When to use: data-rich environments, comparing disparate features
   - Formula: Score = (Reach x Impact x Confidence%) / Effort
   - Pros: quantitative, reduces bias, accounts for uncertainty
   - Cons: requires data for Reach/Effort, can feel mechanical

   **2. ICE** (Impact x Confidence x Ease):
   - When to use: fast triage, early-stage products, small teams
   - Formula: Score = Impact x Confidence x Ease (each 1-10)
   - Pros: fast, simple, good for quick ranking
   - Cons: subjective, no reach component, scores cluster

   **3. MoSCoW** (Must / Should / Could / Won't):
   - When to use: fixed-scope releases, stakeholder negotiation, MVP definition
   - Method: classify each item into Must/Should/Could/Won't
   - Pros: simple, forces trade-offs, good for communication
   - Cons: no relative priority within categories, political gaming

   **4. Kano Model** (Must-be / One-dimensional / Attractive / Indifferent / Reverse):
   - When to use: understanding customer satisfaction drivers, feature differentiation
   - Method: survey users with functional/dysfunctional question pairs
   - Pros: reveals non-obvious priorities, separates hygiene from delight
   - Cons: requires user research, categories shift over time

   **5. Opportunity Score** (Importance + Max(Importance - Satisfaction, 0)):
   - When to use: identifying underserved needs, JTBD-aligned prioritization
   - Formula: Opportunity = Importance + Max(Importance - Satisfaction, 0)
   - Pros: finds gaps between importance and current satisfaction
   - Cons: requires survey data, ignores implementation cost

   **6. Value vs. Effort** (2x2 matrix):
   - When to use: quick visual prioritization, team workshops, backlog grooming
   - Method: plot items on High/Low Value x High/Low Effort grid
   - Pros: visual, intuitive, drives conversation
   - Cons: imprecise, effort estimates are unreliable, binary axes

   **7. WSJF** (Weighted Shortest Job First — SAFe):
   - When to use: SAFe environments, flow-based teams, capacity planning
   - Formula: WSJF = Cost of Delay / Job Duration
   - Cost of Delay = User Value + Time Criticality + Risk Reduction
   - Pros: accounts for time value, optimizes flow
   - Cons: complex, requires trained facilitators, SAFe-specific

   **8. Story Mapping** (horizontal = user journey, vertical = priority):
   - When to use: MVP slicing, release planning, understanding user flow
   - Method: lay out user journey horizontally, stack features vertically by priority
   - Pros: maintains user context, visual, reveals gaps in the journey
   - Cons: not a scoring method, requires facilitation, large wall/board needed

   **9. North Star Alignment** (how much does this move the NSM?):
   - When to use: teams with a defined North Star Metric, strategic alignment
   - Method: score each item on direct contribution to the NSM (1-10)
   - Pros: maintains strategic focus, simple, reduces scope creep
   - Cons: ignores infrastructure/tech debt, NSM must be well-defined

4. **Apply the selected framework**:
   - Read the backlog items
   - Score or classify each item using the chosen framework
   - Produce a ranked or categorized list
   - Note items where the framework produced surprising results — these warrant discussion

5. **Document the recommendation**:
   - Why this framework was selected over alternatives
   - Assumptions made during scoring
   - Items flagged for discussion or re-evaluation

## Output

Write deliverable to `.deliberate/reports/{slug}/prioritization.md` including:
- Context assessment and framework recommendation
- Framework applied with scoring/classification for each backlog item
- Ranked or categorized priority list
- Assumptions and caveats
- Items flagged for discussion

## Constraints

- Always state which framework was chosen and why
- Show the scoring or classification for each item, not just the final ranking
- Do not mix frameworks in a single pass — apply one consistently
- Flag items where scores are close and ordering is debatable

## Transition

Prioritization output feeds into `/outcome-roadmap` for roadmap placement and sprint planning for execution sequencing.
