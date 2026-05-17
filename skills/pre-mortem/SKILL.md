---
name: pre-mortem
description: Risk analysis using Gary Klein's pre-mortem technique with Tigers, Paper Tigers, and Elephants categorization
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Pre-Mortem

## Objective

Conduct a pre-mortem risk analysis using Gary Klein's technique. Imagine the project has already failed, then work backward to identify all possible causes. Categorize risks as Tigers (high probability, high impact), Paper Tigers (seem scary but manageable), and Elephants (known issues everyone ignores).

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What initiative or project is being analyzed?
   - What is the timeline and scope?

2. **Read project context**:
   - Read the PRD, one-pager, or initiative description
   - Understand the technical architecture and dependencies
   - Review any existing risk notes or open questions

3. **Imagine the project has failed**:
   - Fast-forward to the deadline — the project shipped late, shipped broken, or didn't ship at all
   - Brainstorm every possible reason for failure
   - Don't filter or judge — generate volume first
   - Consider: technical, organizational, market, resource, dependency, and adoption risks

4. **Categorize each risk**:
   - **Tigers** (high probability, high impact): Must address immediately. These will kill the project if ignored.
   - **Paper Tigers** (seem scary but manageable): Plan mitigation but don't panic. Often overestimated risks.
   - **Elephants** (known issues everyone ignores): Surface and confront. These are the most dangerous because no one talks about them.

5. **Assess probability and impact**:
   - Probability: Low (< 20%), Medium (20-60%), High (> 60%)
   - Impact: Low (delays < 1 week), Medium (delays 1-4 weeks or partial scope cut), High (project failure or major pivot)
   - Use the combination to validate categorization

6. **Create mitigation plan per risk**:
   - Tigers: specific action plan with owner and deadline
   - Paper Tigers: contingency plan — what to do if it materializes
   - Elephants: escalation plan — who needs to hear this and what decision is needed

7. **Produce the pre-mortem document**:
   - Risk register with all identified risks
   - Categorized and prioritized
   - Mitigation/contingency/escalation plans per risk
   - Top 3 risks highlighted for leadership attention

## Output

Write deliverable to `.deliberate/reports/{slug}/pre-mortem.md` including:
- Project context and assumptions
- Complete risk register (all identified risks)
- Categorization: Tigers, Paper Tigers, Elephants
- Probability and impact assessment per risk
- Mitigation plan per risk with owners
- Top 3 risks summary for leadership

## Constraints

- Do not skip the Elephants — surfacing ignored risks is the primary value of this exercise
- Every Tiger must have a concrete mitigation action, not just "monitor"
- Do not rate all risks as "Medium" — force differentiation
- Include at least one risk from each category (technical, organizational, external)

## Transition

Pre-mortem findings feed into `/stakeholder-map` for communication planning and `/brainstorm-okrs` for risk-adjusted confidence scoring.
