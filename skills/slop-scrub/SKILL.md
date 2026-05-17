---
name: slop-scrub
description: Scan and clean content against platform-specific slop blacklists
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Slop Scrub

Detects and removes AI-generated filler, corporate jargon, and platform-inappropriate language.

## Parameters

- `--platform` (optional): Load platform-specific rules. Values: `linkedin`, `twitter`, `threads`, `facebook`, `video`, `reddit`, `hackernews`, `producthunt`. Default: base rules only.

## Process

1. **Load rules:**
   - Always load `content/slop-rules/base.yaml` (universal rules)
   - If `--platform` specified, also load `content/slop-rules/{platform}.yaml`
   - Platform rules ADD to base (additional banned words/phrases + structural rules)
   - Platform rules can OVERRIDE base structural limits (e.g., emoji count)

2. **Scan input content** against all categories:
   - Banned words (exact match, case-insensitive) — base + platform
   - Banned phrases (substring match, case-insensitive) — base + platform
   - Structural rules (evaluate each rule against the full post) — base + platform overrides
   - Regex patterns (apply each pattern to the content) — base + platform

3. **For each violation found:**
   - Flag the specific word, phrase, or structural issue
   - Explain why it weakens the content (or violates platform norms)
   - Suggest a concrete replacement using `replacement_guidance` or contextual alternatives

4. **Output a clean version** with all violations resolved

5. **Return a summary:**
   - Total violation count
   - Breakdown by category (words, phrases, structural, regex)
   - Platform-specific violations highlighted separately
   - Confidence that the cleaned version preserves original meaning

## Rules

- Never replace a flagged word with another banned word
- Preserve the author's intent and argument structure
- When multiple replacements are possible, choose the one that best matches the surrounding tone
- If a banned word is used in a genuinely technical or specific way (e.g., "navigate" referring to literal navigation), leave it alone
- Structural rules apply to the post as a whole, not individual sentences
- Platform-specific rules take precedence over base rules when limits conflict
- HackerNews has the strictest rules — zero tolerance for marketing language
