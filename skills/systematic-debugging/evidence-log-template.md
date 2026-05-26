# Bug Investigation: {title}

## Reproduction

**Error**: {exact error message or unexpected behavior}
**Steps**: {minimal steps to reproduce}
**Frequency**: {always | intermittent | only under specific conditions}
**Environment**: {local | CI | staging | production}

## Evidence Gathered

| # | What I checked | What I found |
|---|---------------|-------------|
| 1 | | |
| 2 | | |
| 3 | | |

## Root Cause

{One sentence: "The bug occurs because X, which causes Y, which manifests as Z."}

## Hypotheses (ranked by likelihood)

1. **{Hypothesis}** — {evidence for/against}
2. **{Hypothesis}** — {evidence for/against}

## Fix Applied

**File(s) changed**: {paths}
**What changed**: {one sentence}
**Why this fixes it**: {connects fix to root cause}

## Regression Test

**Test file**: {path}
**What it verifies**: {the specific condition that was broken}
**Confirmed**: {fails before fix, passes after}

## Siblings Checked

| Location | Same pattern? | Also broken? | Fixed? |
|----------|--------------|-------------|--------|
| | | | |
