---
name: docs-assess
description: Identify what documentation the initiative requires
allowed-tools: Read, Glob, Grep
---

# Step 1: Assess Documentation Needs

## Objective

Identify every piece of documentation this initiative requires — runbooks, API docs, internal reference, updated existing docs.

## Instructions

1. **Read the PRD** — identify documentation touchpoints:
   - Cross-functional impact section (often calls out docs needs)
   - New services, APIs, or workflows that need runbooks
   - Existing documentation that becomes stale with this change
   - Agent contracts that need updating

2. **Read the code changes** (if development is complete):
   - New services, jobs, or controllers that need operational docs
   - New configuration options that need reference docs
   - New failure modes that need runbook entries
   - New API endpoints that need documentation

3. **Audit existing documentation**:
   - What docs exist? Where do they live?
   - Which existing docs are affected by this initiative?
   - What naming and structural conventions are used?
   - Is there a docs directory structure to follow?

4. **Create a documentation plan**:
   - List of docs to create (type, audience, location)
   - List of docs to update (what changed, what to add/modify)
   - Priority order (operational docs first, nice-to-haves later)

5. **Update assignment status**:
   ```yaml
   status: "in_progress"
   started_at: "timestamp"
   ```

## Transition

Once assessment is complete -> proceed to `/docs-write`
