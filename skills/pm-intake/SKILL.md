---
name: pm-intake
description: Receive scoped content from the founder, research the codebase for context, and produce a formal one-pager in a new initiative directory
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Step 0: Intake — Create the One-Pager

## Objective

Receive scoped initiative content from the founder (typically developed in a separate Claude Chat conversation), ground it in the actual codebase, and produce a formal one-pager in a new initiative directory under `backlog/`.

You are NOT ideating — the founder has already scoped the idea. Your job is to research the codebase for feasibility and context, then format the idea into a structured one-pager that the rest of the Product team can work from.

## Instructions

1. **Read the scoped content** provided by the founder:
   - This arrives as the initiative prompt, a pasted document, or a file path
   - Identify: the problem, proposed solution, target user, and desired outcome

2. **Research the codebase for context**:
   - Read `CLAUDE.md` or `README.md` for project overview
   - Explore existing features related to the initiative (models, controllers, views, services)
   - Check for overlapping or conflicting functionality
   - Identify existing patterns, data models, and infrastructure that the initiative would build on
   - Note any technical constraints or dependencies discovered

3. **Determine the initiative number and slug**:
   - Read the existing initiative directories to find the next available number
   - Create a slug from the initiative name: `{number}-{kebab-case-name}`
   - Example: `0z15-team-permissions`, `0z16-billing-dashboard`

4. **Create the initiative directory**:
   ```
   mkdir -p {initiatives_path}/backlog/{slug}/
   ```

5. **Write the one-pager** to `{initiatives_path}/backlog/{slug}/{slug}-one-pager.md`:

   ```markdown
   # {Initiative Title}

   ## Problem
   What doesn't work today. Who is affected and how.

   ## Proposed Solution
   What we're building. High-level approach grounded in what we found in the codebase.

   ## Target User
   Who benefits. Which ICP segment(s) or internal roles.

   ## Desired Outcome
   What "done" looks like. Observable changes in user behavior or system capability.

   ## Codebase Context
   What already exists that this builds on. Key models, services, and patterns discovered.
   Existing features that overlap or interact with this initiative.

   ## Technical Feasibility Notes
   Constraints, risks, or dependencies discovered during research.
   Whether this extends existing patterns or requires new architecture.

   ## Scope Boundaries
   What's included. What's explicitly excluded and why.

   ## Estimated Impact
   Size: S / M / L / XL
   Risk: Low / Medium / High
   Complexity: Low / Medium / High
   ```

6. **Create the queue file** (`.deliberate/queue/{slug}.yaml`):
   ```yaml
   initiative:
     slug: "{slug}"
     title: "{Initiative Title}"
     status: "QUEUED"
     one_pager: "{initiatives_path}/backlog/{slug}/{slug}-one-pager.md"
     prd: null
     architecture: null
     design_brief: null
     backlog: null
     created_at: "ISO timestamp"
     updated_at: "ISO timestamp"
   ```

7. **Commit**:
   - Do NOT create a product branch yet — that happens when the initiative is selected for grooming
   - Commit the one-pager and queue file to the current branch
   - Message: `"Intake: {Initiative Title} — one-pager created in backlog"`

## Output

- Initiative directory at `{initiatives_path}/backlog/{slug}/`
- One-pager at `{slug}-one-pager.md`
- Queue file at `.deliberate/queue/{slug}.yaml` with status `QUEUED`

## Transition

The initiative sits in `QUEUED` until the founder selects it for grooming.
When selected -> the PM creates the `product/{slug}` branch and proceeds to `/pm-assess`.
