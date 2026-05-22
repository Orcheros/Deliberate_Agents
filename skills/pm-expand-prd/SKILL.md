---
name: pm-expand-prd
description: Write a complete PRD at production depth — all sections from overview through test scenarios
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
intent: "Produce an exhaustive PRD that autonomous agents can execute against without clarification"
execution-mode: 4
responsible: product-manager
accountable: integrator
risk-level: medium
inputs:
  information: ["one-pager", "codebase context", "AAAERRR positioning"]
  artifacts: ["one-pager document"]
  access: ["codebase read access", "initiative directory"]
  conditions: ["one-pager approved", "initiative selected for grooming"]
  people: ["architect for technical feasibility questions"]
outputs:
  updated-information: ["detailed requirements", "acceptance criteria"]
  produced-artifacts: ["PRD document"]
  system-state-change: ["prd_path set in queue YAML"]
  commitments-made: ["requirements locked for this iteration"]
  ready-output: ["PRD ready for architecture review"]
---

# Step 2: Write the PRD

## Objective

Write a complete Product Requirements Document that is thorough enough for autonomous agents to execute against without further clarification. The PRD must cover functional requirements, non-functional requirements, cross-functional impact, failure modes, rollout strategy, and acceptance criteria.

## PRD Sections

Write every section below. Skip none. If a section is genuinely not applicable, include it with a brief explanation of why.

### 1. Overview
- **1.1 Summary**: What this initiative does in 2-3 paragraphs. State the problem, the solution, and the architectural approach.
- **1.2 Strategic Position**: Why this matters to the business. How it fits in the product's lifecycle (AAAERRR or equivalent).
- **1.3 Position in Product Lifecycle**: Table mapping AAAERRR stages (or equivalent) to how this initiative contributes.

### 2. Problem Statement
- **2.1 Core Problem**: What doesn't work today. Include user impact.
- **2.2 Specific Gaps**: Named gaps the initiative addresses.
- **2.3 Current State Table**: What exists today, where it lives, and its status.

### 3. Functional Requirements
Group by domain area (e.g., "Event Dispatch", "Identity Resolution", "CRM Integration"). For each requirement:
- **FR-XX: Title**
- **Description**: What the behavior is
- **Acceptance Criteria**: Checkboxes with testable criteria (Given/When/Then or equivalent)
- **Notes**: Implementation hints or constraints

Number requirements sequentially (FR-01, FR-02, ...) for cross-referencing.

### 4. Non-Functional Requirements
- **4.1 Performance**: Latency targets, throughput, load expectations (table format with metric, target, rationale)
- **4.2 Security & Privacy**: PII handling, credential management, data flow boundaries, multi-tenancy
- **4.3 Reliability**: Failure modes, retry strategies, idempotency requirements

### 5. User Experience
- **5.1 User Flow**: Step-by-step flow diagram (ASCII or text-based)
- **5.2 UI Requirements**: Table of UI elements with specifications
- **5.3 Copy & Messaging**: Table of contexts with copy text

### 6. Communications
- **6.1 Communication Map**: Table with columns: #, Communication, AAAERRR Stage, Trigger, Channel, Template/File, Status
- **6.2 Channel Strategy**: Which channels are used and why
- **6.3 Brand Voice Constraints**: Voice, tone, and copy constraints

### 7. Agent & AI Requirements (if applicable)
- **7.1 Agent Impact**: Table of affected agents and changes
- **7.2 Prompt & Step File Changes**: Table of files, change types, and purposes
- **7.3 AI Budget Impact**: Cost analysis of new AI operations

### 8. Data Model
- **8.1 New/Modified Models**: Table with model, change, and purpose
- **8.2 Migration Details**: Column definitions, types, defaults, indexes

### 9. Scope Boundaries
- **9.1 In Scope**: Bullet list of what this initiative covers
- **9.2 Out of Scope**: Bullet list with brief explanation of why each is excluded
- **9.3 Future Considerations**: What might come later, what triggers it

### 10. Cross-Functional Impact
Tables for each function area:
- **10.1 Marketing & Positioning**: Impact and action required
- **10.2 Knowledge Base & Documentation**: What docs need creating/updating
- **10.3 Legal & Compliance**: Privacy, terms, data ownership, regulatory
- **10.4 Revenue & Commercial**: Pricing, tier, cost impact
- **10.5 Support & Operations**: New failure modes, monitoring, admin tooling
- **10.6 Future Business Functions**: Customer Success, Sales, Partnerships, i18n, Analytics

### 11. Rollout & Migration
- **11.1 Migration Strategy**: Ordered table of migrations with dependencies
- **11.2 Feature Flags**: Table of flags with defaults and purposes

### 12. Testing Strategy
Tables organized by test type:
- **12.1 Unit Tests**: File, coverage
- **12.2 Controller Tests**: File, coverage
- **12.3 Job Tests**: File, coverage
- **12.4 System Tests**: File, AC coverage, scenarios

### 13. Success Metrics
- **13.1 Primary Metrics**: Table with metric, definition, target, measurement point
- **13.2 Secondary Metrics**: Table with metric, definition, baseline, target, AAAERRR stage
- **13.3 Leading Indicators**: 24-hour, 7-day, and 30-day checkpoints

### 14. Guardrails
Table with guardrail, threshold, enforcement, and breach behavior.

### 15. Failure Modes
Table with #, failure mode, severity, detection, response, and recovery. Include "Undetectable Risks" section.

### 16. Dependencies
- **16.1 Internal Dependencies**: Table with dependency, type, status, impact if unavailable
- **16.2 External Dependencies**: Table with dependency, provider, purpose, fallback
- **16.3 Upstream Initiatives**: Table with initiative, what it provides, hard/soft

### 17. Assumptions
Table with #, assumption, confidence level, and "if wrong" fallback.

### 18. Rollout and Monitoring
- **18.1 Rollout Plan**: Phased table with audience, duration, gate criteria
- **18.2 First 48-Hour Watch List**: Signals, where to monitor, normal range, action triggers
- **18.3 Rollback Plan**: Full, destination-specific, and migration rollback procedures

### 19. Acceptance Criteria
Grouped tables (by domain area) with columns: #, criterion, precondition, expected outcome. Number them AC-01, AC-02, etc.

### 20. Test Scenarios
- **20.1 Happy Path**: Table with scenario, validates (AC refs), steps, assertions
- **20.2 Edge Cases**: Same format
- **20.3 Failure States**: Same format, with failure condition column

### 21. Open Questions
Table with #, question, context, recommendation.

### 22. Appendices (if needed)
Cross-references to external documents, event taxonomies, configuration guides.

## Quality Checks Before Moving On

- [ ] Every functional requirement has numbered acceptance criteria
- [ ] The task breakdown in the PRD is ordered with dependencies
- [ ] All file paths referenced in the PRD actually exist in the codebase
- [ ] No TODO or placeholder sections remain
- [ ] Cross-functional impact sections are complete (not just engineering)
- [ ] Failure modes cover both technical and business failures
- [ ] Success metrics are measurable, not aspirational
- [ ] Test scenarios cover happy path, edge cases, AND failure states

## Output

### Artifact Co-Location Rule

**All initiative artifacts live inside the initiative's own directory.** Never write a PRD to a separate location, a shared folder, or a cross-cutting spec directory unless the initiative is explicitly documented as cross-cutting.

Before writing, read the project's initiative guide (typically `.documentation/initiatives/CLAUDE.md` or equivalent) to learn:
- The initiative directory path (e.g., `backlog/0z2-diagnosis-card-refactor/`)
- The file naming convention (typically `{slug}-{document-type}.md`, e.g., `diagnosis-card-refactor-prd.md`)
- Any project-specific PRD conventions or metadata fields

### Write the PRD

1. Locate the initiative's directory (where the one-pager already lives)
2. Name the file using the project's naming convention: `{slug}-prd.md`
3. Write the PRD into that directory alongside the one-pager
4. Update the initiative state file (`.deliberate/queue/{initiative}.yaml`) with `prd_path` pointing to the PRD's location relative to the project root

## Transition

Proceed to `/pm-architecture`
