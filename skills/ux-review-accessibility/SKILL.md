---
name: ux-review-accessibility
description: Audit WCAG 2.1 AA compliance — keyboard nav, ARIA, focus management, color contrast
allowed-tools: Bash, Read, Glob, Grep
---

# Step 2: Accessibility Audit

## Objective

Audit every new or modified view for WCAG 2.1 AA compliance. Accessibility failures are always severity: major or higher.

## Instructions

1. **Read all new/modified view files** identified in Step 1

2. **Keyboard Navigation**:
   - All interactive elements (`<a>`, `<button>`, `<input>`, `<select>`, `<textarea>`) must be reachable via Tab
   - Custom interactive elements (divs with click handlers) must have `tabindex="0"` and keyboard event handlers
   - Focus order must follow visual layout (no unexpected tab jumps)
   - No keyboard traps (user can always Tab away from any element)
   - Modal dialogs trap focus correctly (Tab cycles within modal, Escape closes)
   - Stimulus controllers with click actions must also handle keydown (Enter/Space)

3. **Focus Management**:
   - Focus indicator is visible (no `outline: none` without alternative)
   - After page actions (form submit, modal open, content update), focus moves to appropriate element
   - Turbo Frame updates preserve or redirect focus appropriately
   - Skip navigation link present if the page has repeated navigation

4. **ARIA Attributes**:
   - Images have `alt` text (empty `alt=""` for decorative images)
   - Icon-only buttons have `aria-label`
   - Form inputs have associated `<label>` elements (or `aria-label` / `aria-labelledby`)
   - Error messages are associated with inputs via `aria-describedby`
   - Required fields have `aria-required="true"` or HTML `required` attribute
   - Dynamic content updates use `aria-live` regions where appropriate
   - Custom widgets have appropriate `role` attributes
   - Expandable sections have `aria-expanded`
   - Current navigation items have `aria-current="page"`

5. **Color and Contrast**:
   - Check Tailwind text/background color combinations against WCAG contrast ratios
   - Normal text (< 18px): 4.5:1 minimum contrast ratio
   - Large text (>= 18px or >= 14px bold): 3:1 minimum contrast ratio
   - UI components and graphical objects: 3:1 minimum
   - No information conveyed by color alone (icons, text, or patterns must supplement)
   - Check common Tailwind pairs: `text-gray-500` on `bg-white` often fails
   - Verify focus indicators have sufficient contrast

6. **Content Structure**:
   - Heading hierarchy is logical: `h1` → `h2` → `h3` (no skipped levels)
   - Only one `h1` per page
   - Lists use `<ul>`, `<ol>`, `<dl>` appropriately (not styled divs)
   - Tables have `<th>` with `scope` attributes
   - `<main>`, `<nav>`, `<aside>`, `<header>`, `<footer>` landmarks are used correctly

7. **Forms**:
   - Every input has a visible label (not just placeholder text)
   - Error messages appear near the input, not just at the top of the form
   - Required fields are indicated visually AND programmatically
   - Submit buttons have clear, action-specific text (not just "Submit")
   - Form validation errors are announced to screen readers

8. **Motion and Timing**:
   - Animations respect `prefers-reduced-motion` media query
   - No content that flashes more than 3 times per second
   - Auto-playing content can be paused

9. **Record each finding**:
   ```yaml
   finding:
     id: "A11Y-XXX"
     severity: "critical|major"  # accessibility is always major+
     wcag_criterion: "X.X.X - Criterion Name"
     wcag_level: "A|AA"
     file: "app/views/path/to/file.html.erb"
     line: N
     element: "<button> or description"
     issue: "What's wrong"
     remediation: "How to fix it"
   ```

## Common Rails/Tailwind Accessibility Pitfalls

- `link_to` with icon-only content: needs `aria-label`
- `button_to` for destructive actions: needs confirmation AND aria description
- Tailwind `hidden` class: verify it's not hiding content needed by screen readers (use `sr-only` for visually hidden but accessible content)
- Turbo Frame lazy loading: ensure loading state is announced
- Flash messages: need `role="alert"` or `aria-live="polite"`

## Output

- Accessibility findings recorded for `/ux-review-report`
- Each finding includes WCAG criterion reference and remediation

## Transition

Proceed to `/ux-review-report`
