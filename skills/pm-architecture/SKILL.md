---
name: pm-architecture
description: Write an implementation-ready architecture document with code examples, build sequence, and file manifest
allowed-tools: Read, Glob, Grep, Bash, Write
---

# Step 3: Architecture Document

## Objective

Determine whether this initiative requires an architecture document. If it does, write one at implementation-ready depth — with actual code examples, migration definitions, service signatures, and a build sequence that developer agents can execute directly.

## Decision Criteria

An architecture document is needed when the initiative:
- Introduces 3+ new models or significantly modifies existing schema
- Adds new service layers or architectural patterns
- Introduces external service integrations requiring client wrappers
- Changes authentication, authorization, or multi-tenancy patterns
- Requires phased implementation (multiple deployable increments)
- Involves complex data flows between multiple services/jobs
- Has non-trivial decision gates (technology choices with trade-offs)

**If no architecture doc is needed**: Skip to `/pm-cross-functional`. Note in the state file that no architecture doc was necessary and why.

## Architecture Document Sections

### 1. Architecture Overview
- **1.1 Architectural Premise**: The core insight that drives the design. What's the key abstraction?
- **1.2 Current Infrastructure**: Table of existing mechanisms this builds on (file, behavior, status)
- **1.3 Key Architectural Decisions**: Table of decisions, choices, and rationale

### 2-N. Phase Sections (one per deployable increment)
For each phase:

#### Migration
- Full migration code (create_table, add_column, add_index)
- `strong_migrations` compliance notes
- Index strategy and rationale

#### Model Definitions
- Full model code with:
  - Associations (belongs_to, has_many, through)
  - Enums with integer mappings
  - Validations
  - Scopes
  - Instance methods
  - Concerns if applicable

#### Service Implementations
- Full service code with:
  - `initialize` signature and instance variables
  - Public method signatures
  - Key private methods (fully implemented, not stubbed)
  - Error handling pattern
  - LLM client usage pattern (if applicable)
  - Budget/cost tracking (if applicable)

#### Job Definitions
- Full job code with queue, retry strategy, perform method

#### Controller Changes
- Exact code to add/modify with surrounding context

#### Integration Points
- Which existing files are modified, how, and where (line-level if possible)

### Decision Gates
For any technology choice with trade-offs:
- **Evaluation table**: Criteria across options (use real criteria for this project)
- **Recommendation**: Which option and why
- **Migration path**: How to change later if the choice is wrong

### Integration Points with Current Codebase
- Table of files modified, phase, change description, and risk level
- Interaction with other initiatives (table with initiative, interaction, phase)

### Testing Strategy
- Test patterns with example test code
- What to test at each phase
- How to stub external dependencies

### Build Sequence
- Table with day/phase, tasks, and verification criteria
- Dependencies between phases
- Total estimated scope

### File Manifest
- **New Files**: Table with file path, phase, estimated lines
- **Modified Files**: Table with file path, phase, change description

## Code Quality Standards

Every code example in the architecture doc must be:
- **Runnable**: Not pseudocode. Real Ruby/JS/SQL that a developer agent can paste and adjust.
- **Grounded**: Reference real file paths, real method names, real column names from the codebase.
- **Pattern-consistent**: Follow the project's existing code patterns exactly.
- **Complete**: Include error handling, edge cases, and validation — not just the happy path.

## Output

Write the architecture doc alongside the PRD in the project's documentation directory. Update the initiative state file with the architecture path.

## Transition

Proceed to `/pm-cross-functional`
