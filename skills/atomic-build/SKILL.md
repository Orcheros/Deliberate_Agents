---
name: atomic-build
description: Implement components bottom-up following atomic design. Build atoms first, compose into molecules, then organisms. Each level is a single-source-of-truth partial/CSS class.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Atomic Build

## Objective

Implement UI components bottom-up following atomic design principles. Each component is a **single source of truth** — defined once, used everywhere. Changes propagate automatically because consumers reference the source, never duplicate it.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What components need to be built?
   - Is there a decomposition plan from `/atomic-decompose`?

2. **Read the decomposition plan** (`.deliberate/reports/{slug}/atomic-decomposition.md`):
   - Follow the build order exactly: atoms → molecules → organisms → template → page
   - Never skip levels — each layer must exist before the one above can compose it

3. **Build atoms first** — the indivisible elements:

   **CSS atom** (when the atom is purely visual):
   ```css
   /* app/assets/tailwind/components/{name}.css */
   .{name} {
     /* Use CSS custom properties from theme files */
     /* Define all visual states: hover, focus-visible, disabled, dark */
   }
   ```

   **Partial atom** (when the atom has variant logic):
   ```erb
   <%# app/views/components/_atom_name.html.erb %>
   <% variant ||= :default %>
   <%
     variant_classes = {
       default: "...",
       alt: "..."
     }
     classes = [variant_classes[variant], local_assigns[:class]].compact.join(" ")
   %>
   <element class="<%= classes %>">
     <%= yield if block_given? %>
   </element>
   ```

   **Atom rules:**
   - One responsibility only
   - Uses theme tokens (never hardcoded colors)
   - Supports `local_assigns[:class]` escape hatch
   - Dark mode via CSS custom properties or `dark:` utilities
   - Focus states use `focus-visible:`

4. **Compose molecules** from atoms:

   ```erb
   <%# app/views/components/_molecule_name.html.erb %>
   <%# Molecules render atoms — they NEVER redefine atom markup inline %>
   <div class="<%= ['molecule-wrapper-classes', local_assigns[:class]].compact.join(' ') %>">
     <%= render "components/atom_one", variant: :primary %>
     <%= render "components/atom_two" do %>
       <%= local_assigns[:label] %>
     <% end %>
   </div>
   ```

   **Molecule rules:**
   - Compose atoms via `render` — never inline atom markup
   - Own only the layout/spacing between atoms
   - Pass through variant options to child atoms when needed
   - A molecule that doesn't render at least 2 atoms is probably just an atom

5. **Compose organisms** from molecules and atoms:

   ```erb
   <%# app/views/shared/_organism_name.html.erb %>
   <section class="organism-classes">
     <%= render "components/molecule_one", label: @data.title %>
     <div class="organism-body">
       <% @items.each do |item| %>
         <%= render "components/molecule_two", item: item %>
       <% end %>
     </div>
     <%= render "components/atom_action", variant: :primary do %>Submit<% end %>
   </section>
   ```

   **Organism rules:**
   - Compose molecules and atoms — never redefine their internals
   - Can introduce layout structure (grids, flex containers)
   - May connect to application data (@variables)
   - Should be independently testable sections of a page

6. **Assemble templates and pages:**
   - Templates define content slots using `yield` and `content_for`
   - Pages fill templates with real organisms and data
   - Pages should contain minimal direct markup — mostly `render` calls

7. **Single-source-of-truth enforcement:**
   - Every visual element has ONE canonical definition
   - Consumers `render` or apply the CSS class — they never copy markup
   - To change a button's appearance globally: edit `components/buttons.css` or `_button.html.erb` once
   - If you find yourself writing markup that looks like an existing component: stop and use `render`

8. **Follow `/tailwind-design-system` conventions:**
   - CSS tokens in `app/assets/tailwind/themes/`
   - Component CSS in `app/assets/tailwind/components/` with `@import` in `application.css`
   - ERB partials in `app/views/components/`
   - Stimulus controllers in `app/javascript/controllers/`
   - Symbol keys for variants, `local_assigns[:class]` for overrides

## Build Checklist

For each component built:
- [ ] Defined at the correct atomic level (not too high, not too low)
- [ ] Uses theme tokens (no hardcoded colors)
- [ ] Composes lower-level components via `render` (not inline duplication)
- [ ] Supports dark mode
- [ ] Has focus-visible states where interactive
- [ ] `local_assigns[:class]` escape hatch present
- [ ] Responsive behavior specified
- [ ] Added to `application.css` imports (if CSS component)

## Workflow Transitions

- **Prerequisite**: Run `/atomic-decompose` to produce the build plan
- **Token/CSS questions**: Reference `/tailwind-design-system`
- **Visual design direction**: Reference `/frontend-design-rails`
- **After building**: Run `/atomic-audit` to verify no violations were introduced

## Output

Write components to the appropriate application directories per `/tailwind-design-system` conventions. Document what was built in `.deliberate/reports/{slug}/atomic-build-log.md`.
