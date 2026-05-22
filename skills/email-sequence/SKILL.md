---
name: email-sequence
description: Create email sequences — welcome, nurture, re-engagement, post-purchase, and event-based drip campaigns with full copy and timing
allowed-tools: Read, Write, Glob, Grep
aaaerrr-zone: "funnel:activation"
---

# Email Sequence Design

## Objective

Create email sequences that nurture relationships, drive action, and move people toward conversion.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What type of sequence? (Welcome, nurture, re-engagement, post-purchase, event-based, sales)
   - Who is the audience and what triggered them into this sequence?
   - What's the primary conversion goal?

2. **Define sequence architecture**:
   - **Trigger**: What event starts the sequence (signup, trial start, cart abandon, etc.)
   - **Length**: Number of emails (typically 3-7)
   - **Cadence**: Delay between emails (matches urgency: daily for trial expiry, weekly for nurture)
   - **Exit conditions**: When they leave the sequence (converted, unsubscribed, entered another sequence)
   - **Branching**: Any conditional paths based on behavior (opened/didn't open, clicked/didn't click)

3. **Write each email** with all required elements:

   For each email provide:
   - **Email #**: Name/Purpose
   - **Send timing**: Delay from trigger or previous email
   - **Subject line**: Primary + 2 A/B test alternatives
   - **Preview text**: First 40-90 chars that appear in inbox
   - **Body**: Full copy — lead with value, single clear ask
   - **CTA**: Button text and link destination
   - **Segment/Conditions**: Any behavioral conditions for sending

4. **Apply sequence-type best practices**:

   **Welcome sequence** (3-5 emails):
   - Email 1 (immediate): Deliver promised value, set expectations
   - Email 2 (day 1-2): Quick win or tutorial
   - Email 3 (day 3-5): Social proof or case study
   - Email 4 (day 7): Feature discovery
   - Email 5 (day 10-14): Conversion push or next step

   **Re-engagement sequence** (3 emails):
   - Email 1 (after X days inactive): "We miss you" + what's new
   - Email 2 (+3 days): Specific value reminder + incentive
   - Email 3 (+5 days): Last chance before list cleanup

   **Trial expiry sequence** (4 emails):
   - Email 1 (7 days before): Value recap, what they'll lose
   - Email 2 (3 days before): Urgency + social proof
   - Email 3 (day of): Final call
   - Email 4 (1 day after): Grace period offer or downgrade option

5. **Set metrics benchmarks**:

   | Metric | Welcome | Nurture | Re-engagement |
   |--------|---------|---------|---------------|
   | Open rate | 50-60% | 20-30% | 15-25% |
   | Click rate | 10-15% | 3-5% | 2-4% |
   | Unsubscribe | <0.5% | <0.3% | <1% |

6. **Coordinate with in-app experience**:
   - Email should reinforce in-app actions, not duplicate them
   - Drive back to product with specific CTA (not just "log in")
   - Personalize based on actions already taken in-product

## Red Flags to Surface

- Low open rates but high clicks → subject lines are the bottleneck
- High opens but low clicks → body copy or CTA is weak
- Trial emails not sent before expiry → revenue leaking
- Same sequence for all segments → personalize by behavior

## Output

Write deliverable to `.deliberate/reports/{slug}/email-sequence.md` including:
- Sequence overview (trigger, goal, length, timing, exit conditions)
- Complete email drafts (subject, preview, body, CTA for every email)
- A/B test subject line alternatives
- Metrics plan with benchmarks
- Coordination notes with in-app experience
