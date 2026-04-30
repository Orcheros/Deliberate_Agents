---
name: docs-write
description: Write all required documentation — runbooks, API docs, internal reference
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Step 2: Write Documentation

## Objective

Write all documentation identified in the assessment, verified against the actual codebase.

## Instructions

1. **For each document in the plan**:

   ### Runbooks
   - Title: action-oriented ("Handling Failed HubSpot Sync Jobs")
   - Format: numbered steps, each step is one action
   - Include: exact commands, expected output, decision points
   - Include: escalation path if the runbook doesn't resolve the issue
   - Test: mentally walk through the runbook — can someone follow it at 2 AM?

   ### API Documentation
   - Endpoint, method, authentication
   - Request parameters (required/optional, types, validation)
   - Response format (success and error examples)
   - Rate limits and pagination
   - Code examples in the project's primary language

   ### Internal Reference
   - Service interaction diagrams (text-based)
   - Data model relationships
   - Configuration options with defaults and valid values
   - Environment variable reference

   ### Agent Contracts
   - Role and responsibility description
   - Input/output specifications
   - Behavioral constraints and guardrails
   - Integration points with other agents

2. **Verify every claim against the codebase**:
   - File paths exist
   - Method signatures match
   - Configuration values are accurate
   - Commands produce the described output

3. **Place docs in the correct location**:
   - Follow existing directory structure
   - Match naming conventions
   - Add to any documentation index or table of contents

4. **Update existing docs** where this initiative changes documented behavior

5. **Update assignment status**:
   ```yaml
   status: "complete"
   completed_at: "timestamp"
   notes: "Documentation deliverables summary"
   ```

## Done

Your documentation work is complete. The session can end.
