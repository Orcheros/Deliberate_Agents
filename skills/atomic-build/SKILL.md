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

7. **Data traversal between atomic layers:**

   The core challenge: how does data flow from pages through organisms and molecules down to atoms without painful prop drilling or invisible coupling?

   **Pattern A — Presenter objects (solves prop drilling):**

   Instead of drilling individual locals through every render layer, pass a single presenter that each level queries for what it needs:

   ```ruby
   # app/presenters/card_presenter.rb
   class CardPresenter
     attr_reader :resource

     def initialize(resource)
       @resource = resource
     end

     def title = resource.name
     def subtitle = resource.category&.name
     def status_variant = resource.active? ? :success : :muted
     def action_label = resource.draft? ? "Edit Draft" : "View"
     def action_path = resource.draft? ? edit_path : show_path
   end
   ```

   ```erb
   <%# Organism — passes presenter, not 10 separate locals %>
   <%= render "components/status_card", presenter: presenter %>

   <%# Molecule — pulls what it needs from presenter %>
   <%= render "components/card_header", title: presenter.title, subtitle: presenter.subtitle %>
   <%= render "components/badge", variant: presenter.status_variant %>
   ```

   **Rule**: If a partial needs 4+ locals, it should receive a presenter instead.

   **Pattern B — Content blocks + capture (solves context injection):**

   Higher levels inject rendered content into lower levels without intermediate layers knowing the data shape:

   ```erb
   <%# Page-level: knows the data, injects rendered content %>
   <%= render "components/data_table" do |table| %>
     <% @users.each do |user| %>
       <%= render "components/table_row" do %>
         <%= render "components/avatar", src: user.avatar_url, size: :sm %>
         <span class="font-medium"><%= user.name %></span>
       <% end %>
     <% end %>
   <% end %>
   ```

   ```erb
   <%# Molecule: doesn't know about users — just yields a slot %>
   <tr class="table-row">
     <td class="table-cell"><%= yield %></td>
   </tr>
   ```

   **Rule**: When a molecule doesn't need to know _what_ it contains, use `yield` instead of passing data through.

   **Pattern C — Stimulus outlets + dispatch (solves sibling coordination):**

   When atoms/molecules in the same organism need to react to each other, use Stimulus — not ERB data passing:

   ```erb
   <%# Organism with coordinating siblings %>
   <div data-controller="filter-list">
     <%= render "components/search_input", action: "input->filter-list#filter" %>
     <%= render "components/results_list", target: "filter-list.results" %>
     <%= render "components/empty_state", target: "filter-list.empty" %>
   </div>
   ```

   ```javascript
   // Stimulus controller owns the coordination logic
   export default class extends Controller {
     static targets = ["results", "empty"]

     filter(event) {
       const query = event.target.value.toLowerCase()
       // Toggle visibility of result items, show/hide empty state
     }
   }
   ```

   **Rule**: If two siblings need to know about each other's state, wrap them in a Stimulus controller. Never pass callbacks or state through ERB locals.

   **Pattern D — View helpers for page-level context:**

   When deeply nested atoms need page-level context (current user, feature flags, permissions), use helpers — not drilling through locals:

   ```ruby
   # app/helpers/context_helper.rb
   module ContextHelper
     def current_permissions
       @_permissions ||= PermissionSet.for(current_user, controller_name)
     end

     def feature_enabled?(flag)
       Flipper.enabled?(flag, current_user)
     end
   end
   ```

   ```erb
   <%# Atom can call helpers directly — no prop drilling %>
   <% if feature_enabled?(:new_badge_style) %>
     <span class="badge badge-v2"><%= label %></span>
   <% else %>
     <span class="badge"><%= label %></span>
   <% end %>
   ```

   **Rule**: Helpers are the view layer's "ambient context." Use them for cross-cutting concerns (auth, features, i18n). Do NOT use instance variables (`@`) in atoms/molecules — only organisms and above may reference `@`.

   **Data traversal decision tree:**
   ```
   Need to pass data down 2+ levels?
   └── YES → Use a presenter object (Pattern A)

   Parent doesn't care what child contains?
   └── YES → Use yield / content blocks (Pattern B)

   Siblings need to coordinate?
   └── YES → Stimulus controller wraps them (Pattern C)

   Deep component needs app-level context?
   └── YES → View helper (Pattern D)

   Simple 1-level pass of 1-3 values?
   └── YES → Plain locals are fine
   ```

8. **Single-source-of-truth enforcement:**
   - Every visual element has ONE canonical definition
   - Consumers `render` or apply the CSS class — they never copy markup
   - To change a button's appearance globally: edit `components/buttons.css` or `_button.html.erb` once
   - If you find yourself writing markup that looks like an existing component: stop and use `render`

9. **Follow `/tailwind-design-system` conventions:**
   - CSS tokens in `app/assets/tailwind/themes/`
   - Component CSS in `app/assets/tailwind/components/` with `@import` in `application.css`
   - ERB partials in `app/views/components/`
   - Stimulus controllers in `app/javascript/controllers/`
   - Symbol keys for variants, `local_assigns[:class]` for overrides

## Hard Constraints

- **No ViewComponent.** Do not use the `view_component` gem. It introduces indirection, complex slot APIs, and debugging pain that outweighs its benefits. Plain ERB partials + presenters + Stimulus cover all needs.
- **No instance variables below organism level.** Atoms and molecules receive data via locals or presenters only. `@` vars are reserved for organisms, templates, and pages.
- **No callback locals.** Never pass procs/lambdas as locals for interactivity. Use Stimulus for all dynamic behavior between components.

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
