---
name: ux-review-design
description: Compare implementation against design brief, check all states and responsive behavior
allowed-tools: Bash, Read, Glob, Grep
---

# Step 1: Design Fidelity Review

## Objective

Compare the implemented UI against the design brief. Verify that every component, state, and responsive behavior matches the specification.

## Instructions

1. **Read your assignment file** (`.deliberate/qa/{slug}/assignments/ux-ui-reviewer.md`):
   - List of test cases assigned to you
   - Priority and preconditions for each

2. **Read the design brief**:
   - Component hierarchy and specs
   - All UI states (loading, empty, error, success, disabled)
   - Responsive behavior at each breakpoint
   - Copy and microcopy specifications
   - Existing pattern reuse directives

3. **Read the implemented views**:
   - ERB templates and partials in `app/views/`
   - Layouts affecting the feature
   - Stimulus controllers in `app/javascript/controllers/`
   - Any new or modified CSS/Tailwind classes

4. **For each component in the design brief, verify**:

   **Layout and Structure**:
   - HTML element hierarchy matches spec
   - Tailwind layout classes match (flex, grid, spacing, sizing)
   - Component nesting is correct
   - Correct partials are used (or created per spec)

   **Visual Styling**:
   - Typography: font, size, weight, color, line-height match design tokens
   - Colors: background, text, border colors match Tailwind config / design tokens
   - Spacing: margin, padding match specification
   - Borders, shadows, rounded corners match

   **UI States**:
   - Loading state: appropriate indicator present, content hidden/skeleton
   - Empty state: helpful message with guidance, not just blank
   - Error state: clear message, specific to the error, recovery path
   - Success state: confirms the action, appropriate feedback
   - Disabled state: visually distinct, `disabled` attribute present, non-interactive

   **Responsive Behavior**:
   - Mobile (< 640px): layout adapts correctly, no overflow
   - Tablet (640px - 1024px): intermediate layout works
   - Desktop (> 1024px): full layout renders correctly
   - Check Tailwind responsive prefixes (`sm:`, `md:`, `lg:`, `xl:`)

   **Copy and Microcopy**:
   - All text matches design brief specifications
   - Error messages match spec (not generic Rails defaults)
   - Empty states have the specified guidance text
   - Tooltips, labels, and placeholders are present and correct

5. **Check Stimulus controllers**:
   - Controllers initialize on the correct elements
   - `data-controller`, `data-action`, `data-target` attributes are correct
   - User interactions trigger expected behavior
   - State transitions work (show/hide, enable/disable, class toggling)

6. **Check for pattern reuse**:
   - Design brief's "Existing Pattern Reuse" section followed
   - No unnecessary new components where existing ones suffice
   - Consistent with the rest of the application's visual language

7. **Record findings** for each test case:
   - PASS: implementation matches spec
   - FAIL: deviation found (document what's different)
   - Note the file, line number, and what needs to change

## Output

- Per-case findings recorded for `/ux-review-report`
- Categorized as: design-fidelity, responsive, state, interaction, regression

## Transition

Proceed to `/ux-review-accessibility`
