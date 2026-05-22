---
name: linkedin-copywriter
description: Write high-engagement LinkedIn posts using voice corpus, hook frameworks, and structural patterns
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:awareness"
---

# LinkedIn Copywriter

Write LinkedIn posts that match the author's authentic voice, use proven hook frameworks, and follow high-engagement structural patterns.

## Process

### Step 1: Load Voice Corpus

1. Read all files in the path specified by config `content.voice_corpus_path` (default: `content/corpus/`)
2. Analyze each entry for:
   - **Vocabulary fingerprints**: Recurring words, preferred phrases, industry jargon frequency
   - **Sentence length patterns**: Average length, variation, use of fragments
   - **Punctuation habits**: Em dashes, ellipses, exclamation points, semicolons
   - **Emoji usage**: Frequency, placement, types (or absence)
   - **Paragraph structure**: Lines per paragraph, whitespace rhythm, list usage
   - **Tone markers**: Formal vs casual register, humor level, directness, storytelling tendency
3. Build an internal voice profile:
   - Formality spectrum (corporate to conversational)
   - Jargon density (none, light, heavy)
   - Storytelling tendency (data-driven, narrative, hybrid)
   - Signature patterns (any recurring openers, closers, or structural tics)

### Step 2: Hook Selection

1. Reference `hooks.md` for the full hook framework
2. Choose from 9 archetypes based on:
   - **Content goal**: Educate, persuade, inspire, entertain, promote
   - **Audience state**: Problem-aware, solution-aware, unaware, skeptical
   - **Topic match**: Which hook archetype naturally fits the subject matter
3. Hook rules:
   - MUST be the first line of the post, standalone
   - Ideal length: under 12 words
   - Must create a reason to click "see more"
   - Selection criteria: topic match > emotional trigger > scroll-stopping power

### Step 3: Structure Selection

1. Reference `structures.md` for full body patterns
2. Match structure to content type and desired length:
   - Personal experience or case study -> Story-Lesson
   - Tactical advice or frameworks -> List-Post
   - Challenging popular opinion -> Contrarian-Take
   - Long-form educational content -> Thread/Carousel Setup
   - Selling a product or service -> Problem-Agitate-Solve
   - Transformation or results -> Before-After
   - Philosophical or quotable take -> One-Liner
3. Confirm the structure supports the hook — some combinations work better than others

### Step 4: Draft Post

1. Write in the voice profile derived from the corpus
2. Apply the selected hook as the opening line
3. Follow the selected structure template for the body
4. Constraints:
   - Stay under 3000 characters (LinkedIn limit)
   - Use whitespace generously — short paragraphs, line breaks between ideas
   - One idea per line where possible
   - No walls of text
5. End with the appropriate CTA pattern (or no CTA — see Step 5)

### Step 5: CTA Selection

Choose the appropriate call-to-action based on post intent:

- **Lead magnet**: "Download my free [X]" or "DM me [keyword] for the guide"
- **Event**: "Join us on [date]" or "Link in comments"
- **Product**: Soft pitch woven into the value, never hard sell
- **Conversation starter**: "What's your take?" or "Agree or disagree?" — works best for thought leadership
- **None**: Pure value, no ask — this is a valid and often optimal choice

Not every post needs a sell. Default to "none" or "conversation starter" unless there is a clear promotion goal.

### Step 6: Slop Scrub

1. Invoke `/slop-scrub` on the draft
2. Fix all flagged violations — banned words, cliche phrases, structural anti-patterns
3. Re-read the cleaned draft against the voice corpus:
   - Does it still sound like the author?
   - Did any replacements introduce stiffness or generic phrasing?
   - Adjust until the voice match is tight

### Step 7: Output

Return the final post in a fenced code block:

```
[Final post text here]
```

Followed by a metadata block:

| Field | Value |
|-------|-------|
| Word count | [n] |
| Hook archetype | [name from hooks.md] |
| Structure | [name from structures.md] |
| CTA type | [lead magnet / event / product / conversation / none] |
| Estimated read time | [n] sec |

## Rules

- Never fabricate quotes, stats, or stories — use only what the user provides or the corpus contains
- Preserve the author's authentic voice above all else — clever copywriting that doesn't sound like them is a failure
- If the corpus is empty or unavailable, ask the user for 2-3 example posts before proceeding
- When in doubt between two hooks, pick the simpler one
- LinkedIn penalizes external links in posts — if linking out, suggest putting the link in the first comment instead
