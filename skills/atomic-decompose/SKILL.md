---
name: atomic-decompose
description: Decompose a feature or page requirement into the atomic hierarchy. Determine which atoms/molecules/organisms exist vs. need creation. Enforce reuse-first thinking.
allowed-tools: Read, Glob, Grep, Bash
---

# Atomic Decompose

## Objective

Given a feature or page requirement, decompose it into the atomic design hierarchy (atoms → molecules → organisms → templates → pages). Enforce reuse-first: identify what already exists before proposing anything new. The output is a build plan that `/atomic-build` can execute.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What feature/page/interface is being built?
   - Any mockups, wireframes, or descriptions?
   - Specific user interactions required?

2. **Check the existing inventory** first:
   - Read `.deliberate/reports/{slug}/atomic-inventory.md` if it exists
   - If no inventory exists, run a quick scan of `app/views/components/` and `app/assets/tailwind/components/` to know what's available
   - **Rule: Never propose a new component without first confirming it doesn't already exist**

3. **Decompose top-down, then validate bottom-up:**

   **Step A — Page-level decomposition:**
   - What distinct sections does this page/feature have?
   - Map each section to an organism

   **Step B — Organism decomposition:**
   - What functional groups make up each organism?
   - Map each group to a molecule

   **Step C — Molecule decomposition:**
   - What indivisible elements make up each molecule?
   - Map each element to an atom

   **Step D — Bottom-up validation:**
   - For each atom identified: does it already exist? (Check `components/*.css` and `views/components/`)
   - For each molecule: does a partial already exist that does this?
   - For each organism: is there an existing shared partial?

4. **Classify each component in the decomposition:**

   | Status | Meaning |
   |--------|---------|
   | `EXISTS` | Already built, use as-is |
   | `EXTEND` | Exists but needs a new variant |
   | `CREATE` | Doesn't exist, must be built |

5. **Produce the decomposition document:**

   ```markdown
   ## Feature: {name}

   ### Page Structure
   - Template: {layout used}
   - Page: {view file path}

   ### Decomposition Tree

   Page: {feature name}
   ├── Organism: {name} [STATUS]
   │   ├── Molecule: {name} [STATUS]
   │   │   ├── Atom: {name} [STATUS]
   │   │   └── Atom: {name} [STATUS]
   │   └── Molecule: {name} [STATUS]
   │       ├── Atom: {name} [STATUS]
   │       └── Atom: {name} [STATUS]
   └── Organism: {name} [STATUS]
       └── ...

   ### Build Order (bottom-up)
   1. Atoms to create: [list with file paths]
   2. Atoms to extend: [list with variant details]
   3. Molecules to create: [list with atoms they compose]
   4. Organisms to create: [list with molecules they compose]
   5. Template/page assembly

   ### Reuse Summary
   - {N} components reused as-is
   - {N} components extended with new variants
   - {N} new components to create
   ```

6. **Plan data traversal at decomposition time:**

   For each organism, answer these questions before building:
   - What data does each atom need? Can it be satisfied by 1-3 plain locals?
   - If an organism passes 4+ values to a molecule → plan a presenter object
   - If a molecule doesn't care about its content → plan a `yield` slot
   - If siblings need to coordinate → plan a Stimulus controller wrapper
   - If atoms need page-level context (current user, permissions) → plan a view helper

   Add a **Data Flow** column to the decomposition tree:
   ```
   ├── Organism: UserCard [CREATE] → receives presenter
   │   ├── Molecule: CardHeader [CREATE] → title, subtitle from presenter
   │   │   ├── Atom: Avatar [EXISTS] → src, size (plain locals)
   │   │   └── Atom: Heading [EXISTS] → yield (content block)
   │   └── Molecule: CardActions [CREATE] → Stimulus coordinates buttons
   ```

7. **Reuse-first gates** — reject decompositions that violate these:
   - A new atom MUST NOT duplicate an existing atom's purpose
   - A new molecule MUST compose existing atoms (not redefine them inline)
   - If 70%+ of a molecule's atoms are new, question whether the molecule is at the right level
   - Prefer extending an existing component with a variant over creating a parallel component

## Hard Constraints

- **No ViewComponent.** Do not use or recommend the `view_component` gem. Use plain ERB partials + presenters + Stimulus.
- **No instance variables below organism level.** Atoms and molecules receive data via locals or presenters only.
- **No callback locals.** Never pass procs/lambdas. Use Stimulus for cross-component interactivity.

## Workflow Transitions

- **Prerequisite**: Run `/atomic-inventory` first if no inventory report exists
- **After decompose**: Run `/atomic-build` to implement the build plan bottom-up
- **Design decisions**: Reference `/tailwind-design-system` for token and component conventions
- **Visual design**: Reference `/frontend-design-rails` for aesthetic direction

## Output

Write the decomposition plan to `.deliberate/reports/{slug}/atomic-decomposition.md`.
