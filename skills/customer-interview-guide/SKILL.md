---
name: customer-interview-guide
description: Prepare structured customer interview scripts with JTBD probing questions, warm-up flows, and logistics checklists
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Customer Interview Guide

## Objective

Prepare a complete customer interview script and logistics plan for conducting discovery interviews. Based on Teresa Torres' continuous discovery interview frameworks and Jobs-to-Be-Done methodology. The output enables a human interviewer to run consistent, insight-rich conversations.

## Instructions

1. **Define research objectives**:
   - Read the initiative context, opportunity area, or assignment file
   - Articulate 3-5 specific research questions the interviews should answer
   - Frame questions as "What do we need to learn?" not "What do we want to confirm?"
   - Distinguish between: exploring a new problem space, validating a known opportunity, or testing a specific solution concept
   - Document what is already known vs. what is genuinely unknown

2. **Define participant criteria**:
   - Specify the target user segment(s) to interview
   - Write screening criteria:
     - **Must-have attributes**: behaviors, demographics, or usage patterns that qualify someone
     - **Nice-to-have attributes**: diversity dimensions that improve the sample
     - **Disqualifiers**: attributes that would make someone unrepresentative
   - Recommend sample size: 5-8 participants per segment for pattern recognition (Teresa Torres guideline)
   - Suggest recruitment channels: existing users (in-app recruit, email), prospects, user research panels, social media

3. **Write the interview script**:

   **a) Warm-up (3-5 minutes):**
   - Introduction: who you are, why the conversation matters, how the information will be used
   - Consent and recording permission
   - Set expectations: no right/wrong answers, we want honest experience, it is okay to say "I don't know"
   - Rapport-building question: "Tell me a bit about your role / how you spend a typical day"

   **b) Context and behavior questions (10-15 minutes):**
   - "When did you last [relevant activity]? Walk me through what happened."
   - "What were you trying to accomplish?"
   - "What tools/methods did you use? Why those?"
   - "How often do you do this? Has that changed over time?"
   - "Who else is involved in this process?"

   **c) JTBD probing questions (15-20 minutes):**
   - **Trigger**: "What prompted you to start looking for a solution / to do [action]?"
   - **Push/Pull**: "What was frustrating about the old way?" / "What attracted you to [current approach]?"
   - **Anxiety**: "What concerns did you have about trying something new?"
   - **Habit**: "What would you have to give up or change?"
   - **Timeline**: "Walk me through the timeline — from first thinking about it to actually doing it"
   - **Workarounds**: "Have you built any workarounds? Show me how they work."
   - **Desired outcome**: "If this worked perfectly, what would be different for you?"

   **d) Pain point deep-dives (10-15 minutes):**
   - "You mentioned [pain point] — tell me more about that"
   - "How often does that happen? How severe is it when it does?"
   - "What have you tried to solve it? What happened?"
   - "How does it affect your work / your team / your customers?"
   - "If you could wave a magic wand, what would change?"
   - Use the "5 Whys" technique to dig beneath surface-level answers

   **e) Closing (3-5 minutes):**
   - "Is there anything I should have asked but didn't?"
   - "Who else should I talk to about this?"
   - "Can I follow up if I have additional questions?"
   - Thank them and explain next steps

4. **Add interviewer guidance notes**:
   - **Do**: Ask open-ended questions, follow the energy, ask for specific stories (not hypotheticals), use silence to let them think
   - **Don't**: Ask leading questions, pitch solutions, interrupt stories, ask "would you use X?" (hypothetical intent is unreliable)
   - **Probing techniques**: "Tell me more about that", "What do you mean by [term]?", "Can you give me an example?", "Why was that important?"
   - **Red flags to probe**: Vague answers, "usually" or "sometimes" (ask for last specific instance), emotional language, contradictions between stated preference and actual behavior

5. **Create the logistics checklist**:
   - [ ] Research objectives documented and shared with team
   - [ ] Screening criteria finalized
   - [ ] Recruitment message drafted
   - [ ] Participants recruited and scheduled (aim for 2-3 per week for continuous discovery)
   - [ ] Recording setup tested (video/audio, consent form)
   - [ ] Note-taker assigned or template prepared
   - [ ] Incentive/compensation arranged (if applicable)
   - [ ] Interview script printed/accessible
   - [ ] Debrief template ready for post-interview synthesis
   - [ ] Calendar blocks for synthesis within 24 hours of each interview

6. **Write the interview guide document**:
   - Include: research objectives, participant criteria, full script, interviewer guidance, logistics checklist
   - Write to the initiative directory or `.deliberate/reports/{slug}/customer-interview-guide.md`

## Output

- A complete interview guide document containing:
  - Research objectives (3-5 questions)
  - Participant screening criteria and recruitment plan
  - Full interview script with sections, timing, and question-by-question flow
  - Interviewer do/don't guidance and probing techniques
  - Logistics checklist

## Constraints

- Questions must be open-ended — never yes/no or leading
- Never ask hypothetical intent questions ("Would you use...?" or "Would you pay...?") — ask about past behavior instead
- The script is a guide, not a rigid sequence — note that the interviewer should follow interesting threads
- Interviews are discovery, not validation — the goal is to learn, not to confirm
- Do not modify application code — this produces documentation only

## Transition

After interviews are conducted (by humans), transcripts and notes feed into `/interview-synthesis` to extract structured insights and opportunity statements.
