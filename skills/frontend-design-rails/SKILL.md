---
name: frontend-design-rails
description: Create distinctive, production-grade frontend interfaces in Rails — ERB, Tailwind CSS v4, Stimulus. Avoids generic AI aesthetics.
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Frontend Design (Rails)

## Objective

Create distinctive, production-grade frontend interfaces that avoid generic "AI slop" aesthetics. Implement real working code in ERB + Tailwind CSS v4 + Stimulus with exceptional attention to design quality.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What interface is being built?
   - Any design brief or mockups to reference?
   - Technical constraints (responsive requirements, accessibility, browser support)

2. **Design thinking — before writing any code:**
   - **Purpose**: What problem does this interface solve? Who uses it?
   - **Tone**: Commit to a bold aesthetic direction — brutally minimal, refined luxury, warm organic, editorial, retro-futuristic, playful, industrial. Don't default to "clean and modern."
   - **Differentiation**: What's the one thing someone will remember about this interface?

3. **Follow the project's design system** (see `/tailwind-design-system`):
   - Use existing design tokens from `themes/henry.css`
   - Use semantic role vars from `themes/light.css` and `themes/dark.css`
   - Build on existing component CSS classes in `components/*.css`
   - Extend with new tokens only when the existing palette doesn't serve the design intent

4. **Typography choices:**
   - Never default to system fonts, Inter, Roboto, or Arial
   - Choose distinctive fonts that match the aesthetic direction
   - Use Import Maps to load web fonts (no npm packages)
   - Pair a display font with a refined body font
   - Configure via CSS custom properties in the theme files

5. **Color and visual depth:**
   - Dominant colors with sharp accents — don't spread color evenly
   - Use CSS variables for consistency, define new tokens when needed
   - Create atmosphere: gradient meshes, noise textures, layered transparencies, subtle shadows
   - Both light and dark mode must feel intentional, not just inverted

6. **Motion and interaction:**
   - CSS-only animations for page transitions and micro-interactions
   - Stimulus controllers for interactive behavior (following project conventions)
   - Focus on high-impact moments: one well-orchestrated page load with staggered reveals creates more delight than scattered micro-interactions
   - Scroll-triggered effects and hover states that surprise

7. **Spatial composition:**
   - Break out of predictable layouts — asymmetry, overlap, diagonal flow, grid-breaking elements
   - Generous negative space OR controlled density — both work with commitment
   - Use Tailwind's responsive grid (`sm:`, `md:`, `lg:`) for breakpoint behavior

8. **Implementation in Rails:**
   - ERB partials in `app/views/components/` with symbol variant keys
   - CSS component classes in `app/assets/tailwind/components/`
   - Stimulus controllers in `app/javascript/controllers/`
   - Follow the hybrid approach: component CSS classes for styling, Tailwind utilities for layout
   - Standard `form_with` + CSS classes for forms

## Anti-Patterns — Never Do These

- Generic AI aesthetics: purple gradients on white, Inter font, predictable card grids
- Cookie-cutter design that lacks context-specific character
- Same design every time — vary themes, fonts, aesthetics between interfaces
- Overuse of rounded corners, soft shadows, and pastel gradients together
- Implementation complexity that doesn't match the aesthetic vision

## Quality Checks

- [ ] Design has a clear, intentional aesthetic point-of-view
- [ ] Typography is distinctive and contextually appropriate
- [ ] Both light and dark modes are fully designed (not just inverted)
- [ ] Responsive behavior is specified for mobile, tablet, desktop
- [ ] Accessibility: focus-visible states, color contrast WCAG 2.1 AA, keyboard navigation
- [ ] Animations enhance the experience without blocking interaction
- [ ] Implementation follows project's ERB partial + Tailwind + Stimulus conventions

## Output

Write deliverables to the appropriate application directories. Document design decisions in `.deliberate/reports/{slug}/frontend-design.md`.
