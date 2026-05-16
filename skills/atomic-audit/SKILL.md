---
name: atomic-audit
description: Review code for atomic design violations — duplicated markup that should be extracted, components at the wrong abstraction level, missed reuse opportunities.
allowed-tools: Read, Glob, Grep, Bash
---

# Atomic Audit

## Objective

Review existing or new code for atomic design violations. Find duplicated markup, components at the wrong abstraction level, missed reuse opportunities, and single-source-of-truth breakdowns. Produce actionable fix recommendations.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Scope: full app audit or specific PR/feature?
   - Are there known concerns to focus on?

2. **Audit for these violation categories:**

### Violation 1: Duplicated Markup (Extraction Needed)

**What to look for:**
- Same HTML structure repeated in 3+ view files
- Same Tailwind utility combinations used identically in multiple places
- Inline markup that matches an existing component partial

**How to detect:**
- Grep for repeated class combinations across `.html.erb` files
- Look for `btn btn-primary` or similar patterns used directly instead of rendering `_button.html.erb`
- Find repeated `<div class="...">` structures with identical nesting

**Severity:**
- 3+ occurrences = HIGH (extract immediately)
- 2 occurrences = MEDIUM (extract if logic is identical)
- Similar but not identical = LOW (evaluate if variants cover it)

### Violation 2: Wrong Abstraction Level

**What to look for:**
- "Atoms" that contain multiple distinct elements (actually molecules)
- "Molecules" that render full page sections (actually organisms)
- Organisms with no sub-components (should be decomposed)
- Partials with 100+ lines (too much responsibility for one level)

**How to detect:**
- Count `render` calls in partials — atoms should have 0, molecules 2-3, organisms 3+
- Check line count — atoms < 20 lines, molecules < 40, organisms < 80
- Look for partials that mix layout structure with element definition

### Violation 3: Missed Reuse

**What to look for:**
- New partials that duplicate existing component capabilities
- Inline markup in page views that should use an existing partial
- CSS utility combinations that should be a component class

**How to detect:**
- Compare new partials against `app/views/components/_*.html.erb`
- Check if existing components could handle the use case with a new variant
- Look for repeated utility patterns that warrant a `components/*.css` class

### Violation 4: Source-of-Truth Breakdown

**What to look for:**
- The same component defined in multiple places
- Overriding component CSS with inline utilities instead of adding variants
- Copy-pasted markup instead of `render` calls
- Local style definitions that contradict the design system

**How to detect:**
- Find multiple files defining the same visual pattern
- Grep for `!important` or utility classes that fight component CSS
- Look for inline `style=""` attributes

3. **Produce the audit report:**

   ```markdown
   ## Atomic Design Audit Report

   **Scope**: {what was audited}
   **Date**: {date}
   **Health Score**: {percentage of components following atomic principles}

   ### Critical Violations (Fix Immediately)
   | # | Type | File(s) | Description | Recommended Fix |
   |---|------|---------|-------------|-----------------|

   ### Warnings (Fix Soon)
   | # | Type | File(s) | Description | Recommended Fix |
   |---|------|---------|-------------|-----------------|

   ### Suggestions (Improve When Touched)
   | # | Type | File(s) | Description | Recommended Fix |
   |---|------|---------|-------------|-----------------|

   ### Metrics
   - Total components audited: {N}
   - Atoms: {N} | Molecules: {N} | Organisms: {N}
   - Duplication instances found: {N}
   - Components at wrong level: {N}
   - Missed reuse opportunities: {N}
   - Source-of-truth breakdowns: {N}

   ### Extraction Candidates
   | Pattern | Occurrences | Suggested Name | Level | Priority |
   |---------|-------------|----------------|-------|----------|
   ```

4. **Score the health** of the audited code:
   - 90-100%: Excellent atomic hygiene
   - 70-89%: Good with minor violations
   - 50-69%: Significant duplication; refactoring needed
   - Below 50%: Atomic principles not followed; major restructuring recommended

## Workflow Transitions

- **Before audit**: Run `/atomic-inventory` to have baseline classification
- **After audit with extractions**: Run `/atomic-decompose` on extraction candidates
- **After audit with builds needed**: Run `/atomic-build` to implement fixes
- **Pair with**: Run after `/atomic-build` to verify the build introduced no violations

## Output

Write the audit report to `.deliberate/reports/{slug}/atomic-audit.md`.
