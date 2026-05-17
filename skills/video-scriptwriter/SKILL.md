---
name: video-scriptwriter
description: Write video scripts with timing, hooks, visual cues, and platform-specific formatting
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Video Scriptwriter

Write scripts for video content across formats (Short ≤60s, Standard 3-5min, Long 10-15min) and platforms (YouTube, TikTok, Instagram Reels).

## Process

### Step 1: Load Voice Corpus

Read all files in `content/corpus/` to internalize voice. Video scripts should sound natural when spoken aloud — conversational, direct, zero filler.

### Step 2: Determine Format

Based on the content idea and target platform:
- **Short** (≤60s): Reels, TikTok, YouTube Shorts — vertical 9:16
- **Standard** (3-5min): YouTube mid-form — horizontal 16:9
- **Long** (10-15min): YouTube deep-dive — horizontal 16:9

### Step 3: Hook Design

Select from `skills/video-scriptwriter/hooks.md`. Video hooks are ruthless — you have 3 seconds for shorts, 10 seconds for long-form.

### Step 4: Script Writing

Write in this exact format:

```
[TIMESTAMP] [VISUAL CUE] [SPOKEN TEXT] [ON-SCREEN TEXT]
```

Example:
```
[0:00-0:03] [Close-up face, direct eye contact] "Most founders get this completely wrong." [TEXT: "The #1 mistake"]
[0:03-0:08] [Cut to screen recording] "They spend weeks building features nobody asked for." [TEXT: "❌ Feature factory"]
[0:08-0:15] [Back to face, lean in] "Here's what to do instead..." [None]
```

### Step 5: Platform Adaptation

- **Shorts/Reels/TikTok** (9:16 vertical):
  - Hook in 0-3 seconds
  - Pattern interrupt every 5-10 seconds
  - Payoff before 45 seconds
  - CTA in last 5 seconds
  - 30-60 seconds total

- **YouTube Standard** (16:9):
  - Hook in 0-10 seconds
  - Promise/preview in 10-30 seconds
  - Content delivery in chunks (2-3 min each)
  - CTA at 70% mark (not the end)
  - Recap in final 30 seconds

- **YouTube Long** (16:9):
  - Cold open/teaser (0-15 seconds)
  - Intro + context (15-60 seconds)
  - Chapters with visual variety (2-4 min each)
  - Mid-roll CTA opportunity at 50%
  - Conclusion with next-video hook

### Step 6: B-Roll Suggestions

For each visual cue, note:
- Can this be AI-generated (Runway/generative)?
- Does this need screen recording?
- Does this need avatar (HeyGen)?
- Does this need manual filming?

### Step 7: Slop Scrub

Run `/slop-scrub --platform video` against the spoken text portions.

### Step 8: Output

Write script to Notion page body in structured format with:
- Total duration estimate
- Platform target (Short/Standard/Long)
- Aspect ratio (9:16 or 16:9)
- Render style recommendation (avatar/generative/manual)
- B-roll requirements
- On-screen text list for graphic design

## Rules

- First 3 seconds must hook (for shorts) — no intros, no "hey guys"
- Every sentence must be speakable naturally (read aloud test)
- Zero filler words (um, basically, literally, actually, you know)
- Visual variety every 10-15 seconds minimum
- One idea per segment — don't stack concepts
- CTA must feel earned (deliver value FIRST)
- Script duration = word count / 150 (average speaking pace)
- Short scripts: 80-150 words | Standard: 500-750 words | Long: 1500-2250 words
