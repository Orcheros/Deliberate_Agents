---
name: slop-scrub
description: Scan and clean content against the slop blacklist for authentic voice
allowed-tools: Read, Glob, Grep
---

# Slop Scrub

Scan content for overused AI slop, cliche phrases, and structural anti-patterns. Flag violations and produce a clean version.

## Process

1. **Load blacklist** from `content/slop-blacklist.yaml`
2. **Scan input content** against all categories:
   - Banned words (exact match, case-insensitive)
   - Banned phrases (substring match, case-insensitive)
   - Structural rules (evaluate each rule against the full post)
   - Regex patterns (apply each pattern to the content)
3. **For each violation found:**
   - Flag the specific word, phrase, or structural issue
   - Explain why it weakens the content
   - Suggest a concrete replacement using `replacement_guidance` or contextual alternatives
4. **Output a clean version** with all violations resolved
5. **Return a summary:**
   - Total violation count
   - Breakdown by category (words, phrases, structural, regex)
   - Confidence that the cleaned version preserves original meaning

## Rules

- Never replace a flagged word with another banned word
- Preserve the author's intent and argument structure
- When multiple replacements are possible, choose the one that best matches the surrounding tone
- If a banned word is used in a genuinely technical or specific way (e.g., "navigate" referring to literal navigation), leave it alone
- Structural rules apply to the post as a whole, not individual sentences
