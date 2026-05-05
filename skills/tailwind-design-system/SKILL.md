---
name: tailwind-design-system
description: Build and extend the Tailwind CSS v4 design system in Deuterophos — CSS-first theme tokens, component CSS classes, ERB partials with symbol variants, Stimulus controllers, and accessible form patterns
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Tailwind v4 Design System (Rails + Stimulus)

## Objective

Build or extend the design system using Tailwind CSS v4's CSS-first configuration. The architecture is a **hybrid approach**: component CSS classes (`.btn`, `.card`, `.form-control`) defined in `components/*.css` files using CSS custom properties, with Tailwind utilities for layout in ERB templates. Interactivity is Stimulus controllers. No npm packages — Import Maps only.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What components or patterns are needed?
   - Is this a new component or extending an existing one?

2. **Understand the existing CSS architecture** before making changes:

   ```
   app/assets/tailwind/
   ├── application.css             # Entry point — imports, @theme, @plugin, @variant
   ├── themes/                     # Design tokens as CSS variables
   │   ├── henry.css               # Brand colors (@theme block)
   │   ├── light.css               # Light mode semantic vars (:root, .light)
   │   ├── dark.css                # Dark mode overrides (.dark)
   │   └── juicy.css               # Alternate theme
   └── components/                 # Component CSS classes (@layer components)
       ├── buttons.css             # .btn, .btn-primary, .btn-secondary, .btn-danger
       ├── cards.css               # .card variants
       ├── forms.css               # .form-control, .label, .form-hint, .form-group
       ├── modal.css               # Modal styles
       ├── nav.css                 # Navigation styles
       └── ... (29 total)
   ```

   **Entry point** (`application.css`):
   ```css
   @import "tailwindcss";
   @plugin "@tailwindcss/forms";
   @plugin "@tailwindcss/typography";

   @source "../../views/**/*.html.erb";

   /* Layer imports */
   @import "./themes/henry.css" layer(theme);
   @import "./themes/light.css" layer(theme);
   @import "./themes/dark.css" layer(theme);
   @import "./components/buttons.css" layer(components);
   @import "./components/forms.css" layer(components);
   /* ... etc */

   @variant dark (&:where(.dark, .dark *));
   ```

3. **Follow the design token hierarchy**:

   **Layer 1 — Brand tokens** (`themes/henry.css`):
   ```css
   @theme {
     --color-brand-void: #FAF8F5;
     --color-brand-core: #0B3D6B;
     --color-brand-accent: #B06A2B;
     --color-surface-void: #FAF8F5;
     --color-surface-surface: #FFFFFF;
     --color-text-ink: #1C1C1E;
     /* Domain-specific tokens */
     --color-agent: #0B3D6B;
     --color-plane-work: #0B3D6B;
     --color-plane-execution: #6D28D9;
     --color-plane-experience: #047857;
     --color-status-complete: #16A34A;
   }
   ```

   **Layer 2 — Semantic role vars** (`themes/light.css`):
   ```css
   :root, .light {
     --bg-primary: var(--color-blue-700);
     --bg-primary-hover: var(--color-blue-600);
     --text-on-primary: var(--color-white);
     --border-primary: var(--color-blue-600);
     --bg-secondary: var(--color-gray-100);
     --bg-secondary-hover: var(--color-gray-200);
     --text-on-secondary: var(--color-gray-900);
     --border-secondary: var(--color-gray-300);
     --bg-danger: var(--color-red-700);
     --text-on-danger: var(--color-white);
     --base-border-focus: var(--color-blue-500);
   }
   ```

   **Dark overrides** (`themes/dark.css`):
   ```css
   .dark {
     --bg-primary: var(--color-blue-500);
     --bg-primary-hover: var(--color-blue-400);
     /* ... dark equivalents */
   }
   ```

   **Layer 3 — Component CSS classes** (`components/buttons.css`):
   ```css
   .btn {
     display: inline-flex;
     align-items: center;
     justify-content: center;
     padding: 6px 12px;
     border-radius: 6px;
     font-weight: 600;
     box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
     transition: background-color 0.15s, border-color 0.15s;

     &:focus-visible {
       outline: 2px solid var(--base-border-focus);
       outline-offset: 2px;
     }

     &:disabled {
       opacity: 60%;
       cursor: not-allowed;
     }
   }

   .btn-primary {
     background: var(--bg-primary);
     color: var(--text-on-primary);
     &:hover, &:focus { background: var(--bg-primary-hover); }
   }

   .btn-secondary {
     background: var(--bg-secondary);
     color: var(--text-on-secondary);
     border: 1px solid var(--border-secondary);
     &:hover, &:focus { background: var(--bg-secondary-hover); }
   }

   .btn-danger {
     background: var(--bg-danger);
     color: var(--text-on-danger);
     &:hover, &:focus { background: var(--bg-danger-hover); }
   }
   ```

   **When adding new tokens**: brand tokens go in `henry.css`, semantic role vars go in `light.css` + `dark.css`, component classes go in `components/*.css`.

4. **Build component partials** following existing conventions:

   Components live in `app/views/components/` as ERB partials. Variants use **symbol keys** and inline hash lookups. Classes compose CSS component classes (`.btn .btn-primary`) with Tailwind utilities for layout.

   **Button partial** (existing pattern):
   ```erb
   <%# app/views/components/_button.html.erb %>
   <% variant ||= :primary %>
   <% size ||= :md %>
   <%
     variant_classes = {
       primary:   "btn btn-primary",
       secondary: "btn btn-secondary",
       danger:    "btn btn-danger",
       ghost:     "btn btn-ghost",
       icon_only: "btn btn-icon"
     }

     size_classes = {
       sm: "px-2.5 py-1.5 text-xs gap-1",
       md: "px-4 py-2 text-sm gap-1.5",
       lg: "px-6 py-3 text-base gap-2"
     }

     classes = [variant_classes[variant], size_classes[size], local_assigns[:class]].compact.join(" ")
   %>
   <button class="<%= classes %>" <%= "disabled" if local_assigns[:disabled] %>>
     <%= yield if block_given? %>
   </button>
   ```

   **Usage:**
   ```erb
   <%= render "components/button", variant: :primary do %>Save<% end %>
   <%= render "components/button", variant: :danger, size: :sm do %>Delete<% end %>
   ```

   **Card partial** (existing pattern):
   ```erb
   <%# app/views/components/_card.html.erb %>
   <% variant ||= :default %>
   <% padding ||= true %>
   <%
     variant_classes = {
       default:   "bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-lg",
       elevated:  "bg-white dark:bg-gray-900 rounded-lg shadow-md",
       interactive: "bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-lg hover:shadow-md transition-shadow cursor-pointer"
     }
   %>
   <div class="<%= variant_classes[variant] %> <%= 'p-6' if padding %> <%= local_assigns[:class] %>">
     <%= yield if block_given? %>
   </div>
   ```

   **Key conventions for new partials:**
   - Default variants via `<% variant ||= :primary %>`
   - Symbol keys for all variant hashes
   - Compose CSS component classes + Tailwind layout utilities
   - Append `local_assigns[:class]` for override escape hatch
   - `yield if block_given?` for content
   - No custom class-merge helper — use array `.compact.join(" ")`

5. **Follow the form pattern** — standard `form_with` with CSS classes:

   ```erb
   <%= form_with(model: @resource, class: "space-y-6") do |f| %>
     <% if @resource.errors.any? %>
       <div class="p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg">
         <ul class="list-disc list-inside text-sm text-red-700 dark:text-red-400">
           <% @resource.errors.full_messages.each do |message| %>
             <li><%= message %></li>
           <% end %>
         </ul>
       </div>
     <% end %>

     <div>
       <%= f.label :email, class: "label" %>
       <%= f.text_field :email, class: "form-control", required: true,
           placeholder: "you@example.com" %>
     </div>

     <div>
       <%= f.label :password, class: "label" %>
       <%= f.password_field :password, class: "form-control", required: true %>
     </div>

     <div class="flex items-center gap-3">
       <%= f.submit "Sign In", class: "btn btn-primary" %>
       <%= link_to "Cancel", root_path, class: "btn btn-secondary" %>
     </div>
   <% end %>
   ```

   **Form conventions:**
   - `class: "label"` on labels (styled in `components/forms.css`)
   - `class: "form-control"` on all inputs, selects, textareas
   - `required: true` for HTML5 validation
   - `f.submit` with `class: "btn btn-primary"` (not a custom form builder)
   - Cancel links use `class: "btn btn-secondary"`
   - Error display as a custom block above the form
   - Responsive grid: `class: "grid gap-4 sm:grid-cols-2"` for multi-column layouts
   - No custom FormBuilder — use the default Rails builder

6. **Write Stimulus controllers** following existing conventions:

   ```javascript
   // app/javascript/controllers/{name}_controller.js
   import { Controller } from "@hotwired/stimulus"

   export default class extends Controller {
     // Static declarations at top
     static targets = ["menu", "trigger"]
     static values = { open: { type: Boolean, default: false } }

     connect() {
       // Store bound handlers as instance vars for cleanup
       this.boundClose = this.close.bind(this)
       document.addEventListener("click", this.boundClose)
     }

     disconnect() {
       // Always clean up global listeners
       document.removeEventListener("click", this.boundClose)
     }

     toggle() {
       this.openValue = !this.openValue
       this.menuTarget.classList.toggle("hidden", !this.openValue)
     }

     close(event) {
       if (!this.element.contains(event.target)) {
         this.openValue = false
         this.menuTarget.classList.add("hidden")
       }
     }
   }
   ```

   **Stimulus conventions:**
   - `static targets`, `static values`, `static classes` declared at top
   - `connect()` / `disconnect()` lifecycle with proper listener cleanup
   - Bound listeners stored as `this.boundXxx` instance variables
   - camelCase method names
   - HTML: `data-controller="name"`, `data-action="event->name#method"`, `data-name-target="foo"`
   - No global state — server is source of truth (Turbo Streams push updates)
   - Auto-registered via `controllers/index.js`

   **Dark mode** (existing pattern — theme controller):
   ```javascript
   // app/javascript/controllers/theme_controller.js
   import { Controller } from "@hotwired/stimulus"

   export default class extends Controller {
     static values = { default: { type: String, default: "system" } }

     connect() {
       this.applyTheme(this.currentTheme)
     }

     toggle() {
       const next = this.currentTheme === "dark" ? "light" : "dark"
       localStorage.setItem("theme", next)
       this.applyTheme(next)
     }

     cycle() {
       const order = ["light", "dark", "system"]
       const current = localStorage.getItem("theme") || "system"
       const next = order[(order.indexOf(current) + 1) % order.length]
       localStorage.setItem("theme", next)
       this.applyTheme(next)
     }

     applyTheme(theme) {
       const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches
       const isDark = theme === "dark" || (theme === "system" && prefersDark)
       document.documentElement.classList.toggle("dark", isDark)
     }

     get currentTheme() {
       return localStorage.getItem("theme") || this.defaultValue
     }
   }
   ```

   **Dialog/modal** (use native `<dialog>` + Stimulus):
   ```javascript
   // app/javascript/controllers/dialog_controller.js
   import { Controller } from "@hotwired/stimulus"

   export default class extends Controller {
     static targets = ["dialog"]

     open() {
       this.dialogTarget.showModal()
     }

     close() {
       this.dialogTarget.close()
     }

     backdropClose(event) {
       if (event.target === this.dialogTarget) {
         this.close()
       }
     }
   }
   ```

   Note: Jumpstart already provides `ModalComponent` and `SlideoverComponent` in `lib/jumpstart/app/components/`. Check if those cover the need before creating new Stimulus controllers.

7. **When adding new components, follow this checklist**:
   - [ ] CSS class defined in `app/assets/tailwind/components/{name}.css`
   - [ ] Uses CSS custom properties from theme files (not hardcoded colors)
   - [ ] Both `.light` and `.dark` mode vars covered
   - [ ] ERB partial in `app/views/components/_name.html.erb`
   - [ ] Variant params use symbols (`:primary`, `:sm`)
   - [ ] `local_assigns[:class]` escape hatch for overrides
   - [ ] `dark:` variants included in any Tailwind utility classes
   - [ ] Focus states use `focus-visible:` (not `focus:`)
   - [ ] Stimulus controller (if interactive) follows static/connect/disconnect pattern
   - [ ] Responsive breakpoints: `sm:`, `md:`, `lg:`
   - [ ] Import added to `application.css` with correct layer

## v3 → v4 Reference

| v3 | v4 |
|----|-----|
| `tailwind.config.js` | `@theme` block in CSS |
| `@tailwind base/components/utilities` | `@import "tailwindcss"` |
| `darkMode: "class"` | `@variant dark (&:where(.dark, .dark *))` |
| `theme.extend.colors` | `@theme { --color-*: value }` |
| `bg-opacity-50` | `bg-black/50` |
| `theme('colors.blue.500')` | `var(--color-blue-500)` |
| `require("tailwindcss-animate")` | `@keyframes` inside `@theme` |

## Component Architecture

```
Layer 1: @theme tokens (henry.css)        → Brand values
Layer 2: Semantic CSS vars (light/dark)    → Role-based aliases
Layer 3: Component CSS (components/*.css)  → .btn, .card, .form-control
Layer 4: ERB partials (views/components/)  → Variant logic + layout utilities
Layer 5: Stimulus (controllers/)           → Interactivity
```

## Accessibility Checklist

- Focus rings via `focus-visible:` (2px solid `var(--base-border-focus)`, 2px offset)
- Color contrast WCAG 2.1 AA (4.5:1 text, 3:1 large text) in both light and dark
- Form errors: custom error block with `role="alert"`, semantic `required` attributes
- Modals: native `<dialog>` with `showModal()` for focus trapping
- Disabled: `opacity: 60%` + `cursor: not-allowed` (via `.btn:disabled`)
- All `dark:` variants maintain equivalent contrast ratios

## Output

Write deliverables to the appropriate application directories:
- Theme tokens → `app/assets/tailwind/themes/`
- Component CSS → `app/assets/tailwind/components/`
- Component partials → `app/views/components/`
- Stimulus controllers → `app/javascript/controllers/`
- Import updates → `app/assets/tailwind/application.css`
- Document changes in `.deliberate/reports/{slug}/design-system.md`
