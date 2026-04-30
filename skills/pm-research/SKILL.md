---
name: pm-research
description: Deep-dive into the codebase and domain before writing the PRD
allowed-tools: Read, Glob, Grep, Bash
---

# Step 1.5: Deep Research

## Objective

Before writing the PRD, build comprehensive knowledge of the codebase, existing patterns, and domain context. This step sits between assessment and PRD writing — you've confirmed the one-pager is ready, now you need to understand enough to write a PRD at production depth.

## Instructions

### 1. Codebase Exploration

Read broadly, not just the files the one-pager mentions:

- **Data model**: Read every model in `app/models/` that this initiative touches or neighbors. Understand relationships, validations, enums, scopes, callbacks, and concerns.
- **Controllers**: Read controllers in the affected area. Understand the request flow, authorization pattern, parameter handling.
- **Views/Partials**: Understand the UI structure, component patterns, and existing Stimulus controllers.
- **Services**: Read `app/services/` for existing patterns — how are external APIs wrapped? How are complex operations structured?
- **Jobs**: Read `app/jobs/` to understand background processing patterns, queue names, retry strategies.
- **Tests**: Read test files to understand testing conventions (Minitest vs. RSpec, fixtures vs. factories, test naming).
- **Configuration**: Read `config/routes.rb`, `Gemfile`, `config/initializers/`, credential structure.
- **Schema**: Read `db/schema.rb` to understand the full data model.

### 2. Existing Pattern Inventory

Document the patterns you find so your PRD references them accurately:

- How are similar features structured? (Find the closest analog to this initiative)
- How are service objects organized? (Single-method `call`, `initialize` + instance methods, etc.)
- How are background jobs patterned? (Queue names, retry strategies, error handling)
- How are external APIs wrapped? (Client pattern, credential loading, error handling)
- How is authorization implemented? (Pundit, CanCanCan, custom)
- How is multi-tenancy handled? (acts_as_tenant, explicit scoping, etc.)
- What Tailwind component patterns exist?
- What Stimulus controller conventions are used?

### 3. Reference Document Reading

Read every document the one-pager references:
- Vision documents
- Strategy documents
- Related initiative one-pagers, PRDs, or architecture docs
- Stack decision documents
- Brand/style guides

### 4. Current State Analysis

For each capability the initiative introduces, document what exists today:

| Capability | Current State | File(s) | Notes |
|------------|--------------|---------|-------|
| Example: Lead CRM sync | `Lead#crm_synced_at` column exists, nothing writes to it | `app/models/lead.rb` | Ready for integration |

### 5. Dependency Mapping

Identify:
- Internal dependencies (models, services, jobs that must exist)
- External dependencies (APIs, services, credentials)
- Initiative dependencies (other initiatives that must ship first or in parallel)
- Soft vs. hard dependencies

## Output

You don't produce a deliverable from this step — you produce the knowledge that makes the PRD accurate. The next step (`/pm-expand-prd`) uses everything you learned here.

## Transition

Once research is complete -> proceed to `/pm-expand-prd`
