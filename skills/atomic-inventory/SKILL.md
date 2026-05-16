---
name: atomic-inventory
description: Scan existing UI and produce a classified component map (atoms → molecules → organisms → templates → pages). Identifies duplication and extraction opportunities.
allowed-tools: Read, Glob, Grep, Bash
---

# Atomic Inventory

## Objective

Produce a complete inventory of existing UI components classified by atomic design level. Identify duplication, extraction opportunities, and gaps where single-source-of-truth components should exist but don't.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Scope: full app inventory or specific feature/section?
   - Are there known problem areas (duplicated markup, inconsistent patterns)?

2. **Scan the component layers** in order:

   **Sub-atomic (design tokens):**
   ```
   app/assets/tailwind/themes/*.css     → CSS custom properties
   ```

   **Atoms (indivisible UI elements):**
   ```
   app/assets/tailwind/components/*.css  → CSS component classes (.btn, .label, .form-control)
   app/views/components/_*.html.erb      → Simple single-element partials
   ```

   **Molecules (small groups of atoms):**
   ```
   app/views/components/_*.html.erb      → Partials composing 2-3 atoms (form group = label + input + hint)
   app/views/shared/_*.html.erb          → Reusable grouped elements
   ```

   **Organisms (distinct UI sections):**
   ```
   app/views/shared/_*.html.erb          → Navigation bars, card lists, form sections
   app/views/layouts/_*.html.erb         → Layout-level organisms (sidebar, header, footer)
   ```

   **Templates (page-level structure):**
   ```
   app/views/layouts/*.html.erb          → Page shells with content slots
   ```

   **Pages (specific instances):**
   ```
   app/views/{resource}/*.html.erb       → Concrete pages filling templates
   ```

3. **Classify each component** using this decision tree:
   - Can it be broken down further? → It's NOT an atom
   - Does it combine 2-3 atoms into a functional group? → Molecule
   - Is it a distinct section of a page with its own purpose? → Organism
   - Does it define page-level structure with content slots? → Template
   - Is it a concrete instance with real data? → Page

4. **Identify duplication and extraction opportunities:**
   - Grep for repeated markup patterns across views (same class combinations, same structure)
   - Find inline styles or utility combinations used 3+ times → candidate for atom extraction
   - Find repeated groups of elements → candidate for molecule/organism extraction
   - Note components at the wrong abstraction level (atoms doing organism work, etc.)

5. **Produce the inventory report** with these sections:

   ```markdown
   ## Component Inventory

   ### Sub-Atomic (Design Tokens)
   | Token File | Purpose | Token Count |
   |---|---|---|

   ### Atoms
   | Component | File | Type (CSS/Partial) | Variants | Used By |
   |---|---|---|---|---|

   ### Molecules
   | Component | File | Atoms Used | Used By |
   |---|---|---|---|

   ### Organisms
   | Component | File | Molecules/Atoms Used | Used By |
   |---|---|---|---|

   ### Templates
   | Layout | File | Organisms/Slots |
   |---|---|---|

   ## Duplication Report
   | Pattern | Occurrences | Files | Recommended Extraction |
   |---|---|---|---|

   ## Gaps & Recommendations
   - Missing atoms that should exist
   - Components at wrong abstraction level
   - Opportunities for single-source-of-truth consolidation
   ```

## Workflow Transitions

- **After inventory**: Run `/atomic-decompose` for new feature work informed by what exists
- **After inventory**: Run `/atomic-audit` to validate current components against atomic principles
- **Before building**: Always run inventory first to prevent creating duplicates

## Output

Write the inventory report to `.deliberate/reports/{slug}/atomic-inventory.md`.
