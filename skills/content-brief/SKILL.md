---
name: content-brief
description: Understand the communication need, audience, and brand context
allowed-tools: Read, Glob, Grep
---

# Step 1: Understand the Brief

## Objective

Before writing anything, fully understand what needs to be written, for whom, and in what voice.

## Instructions

1. **Read your assignment** — understand what communications are needed:
   - What type? (lifecycle email, in-app copy, notification, marketing page, etc.)
   - What trigger? (event-based, time-based, manual)
   - What audience? (persona, ICP segment, lifecycle stage)
   - What goal? (activate, retain, convert, inform, win back)

2. **Read the PRD's communication map** (if one exists):
   - Map of all communications with triggers, channels, and templates
   - Channel strategy (which channel for what purpose)
   - Brand voice constraints

3. **Read existing copy in the codebase**:
   - Email templates (ActionMailer views, external template references)
   - Flash messages and in-app notifications
   - Onboarding text and empty states
   - Error messages and validation text
   - Marketing page copy

4. **Read the brand/style guide** (if one exists):
   - Voice and tone guidelines
   - Word choice preferences and restrictions
   - Formatting conventions
   - Personalization rules

5. **Identify the emotional state** of the reader at each touchpoint:
   - What just happened? (signed up, hit a limit, churned, achieved something)
   - What do they need to feel? (welcome, urgency, empathy, confidence)
   - What action should they take next?

6. **Update assignment status**:
   ```yaml
   status: "in_progress"
   started_at: "timestamp"
   ```

## Transition

Once you understand the brief -> proceed to `/content-draft`
