---
name: systematic-debugging
description: Root cause investigation discipline — no fixes without evidence, hypothesis testing, 3-fix limit before architectural review
allowed-tools: Bash, Read, Glob, Grep
---

# Systematic Debugging

## Objective

Investigate bugs, test failures, and unexpected behavior using a structured root-cause-first approach. No guessing, no shotgun fixes.

## Iron Law

**NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST.**

If you find yourself typing a fix before you can explain WHY the bug exists, stop. You are guessing.

## Instructions

### Phase 1: Root Cause Investigation

1. **Reproduce the failure** — Run the failing test or trigger the bug. Capture the exact error message, stack trace, and conditions.
2. **Gather evidence** — Read the relevant code paths. For multi-component issues, trace the data flow from entry point to failure point.
3. **Narrow the scope** — Use binary search: comment out half the suspect code, does it still fail? Which half? Repeat.
4. **State the root cause** — Write one sentence: "The bug occurs because X, which causes Y, which manifests as Z." If you can't write this sentence, you haven't found the root cause.

### Phase 2: Pattern Analysis

5. **Check for siblings** — Is the same pattern used elsewhere? Are those instances also broken?
6. **Check for history** — Was this code recently changed? (`git log -p -- path/to/file`). Did a dependency update introduce this?
7. **Check for assumptions** — What assumption does the code make that is no longer true?

### Phase 3: Hypothesis and Testing

8. **Form a hypothesis** — "If I change X, the bug will be fixed because Y."
9. **Write a failing test first** — Before fixing anything, write a test that reproduces the bug. This test MUST fail before your fix and pass after.
10. **Apply the minimal fix** — Change as little as possible. One fix for one root cause.
11. **Verify** — Run the failing test. Run the full test suite. Confirm no regressions.

### Phase 4: The 3-Fix Limit

If you have attempted 3 fixes for the same issue and none have resolved it:

**STOP. Do not attempt a 4th fix.**

This triggers an architectural review:
- Step back and re-examine your understanding of the system
- The root cause is likely different from what you think
- Consider: is this a symptom of a deeper structural problem?
- If still stuck after re-examination, mark as **blocked** with all evidence gathered

## Red Flags — You Are Guessing If:

| Sign | What It Means |
|------|--------------|
| "Let me just try..." | You don't have a hypothesis |
| "That's weird, let me add a log" | You haven't read the code yet |
| "Maybe if I change this..." | You're doing trial-and-error |
| "It works now but I'm not sure why" | The bug will come back |
| Fix is larger than the bug | You're compensating for missing understanding |
| You changed something unrelated "just in case" | You don't know the root cause |

## Output

When debugging is complete, document:
- **Root cause**: One sentence explaining why the bug occurred
- **Fix**: What was changed and why this addresses the root cause
- **Test**: The test that was added to prevent regression
- **Siblings**: Whether the same pattern exists elsewhere and if those were also fixed
