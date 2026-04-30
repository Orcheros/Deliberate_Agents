---
name: integrations-assess
description: Map out the integration landscape and create a configuration plan
allowed-tools: Read, Glob, Grep, Bash
---

# Step 1: Assess Integration Needs

## Objective

Map every external service this initiative touches and create a configuration plan before doing any setup work.

## Instructions

1. **Read the PRD and architecture doc** — identify every external service mentioned:
   - SaaS platforms (CRM, analytics, email, etc.)
   - APIs that need client wrappers
   - Webhook endpoints to receive
   - Browser-side tags or scripts
   - DNS/email authentication needs

2. **Read the existing codebase** for integration patterns:
   - Existing service wrappers in `app/services/`
   - Existing webhook controllers in `app/controllers/webhooks/`
   - Existing sync jobs in `app/jobs/sync/`
   - Credential storage pattern (Rails credentials, env vars)
   - Existing `.mcp.json` or vendor SDK usage

3. **For each service, document**:
   - What needs to be configured on the vendor side (account, properties, pipelines, audiences)
   - What needs to be built on the Rails side (client wrapper, sync job, webhook handler)
   - What credentials are needed and where they'll be stored
   - Rate limits and cost implications
   - Dependencies on other integrations or initiatives

4. **Create a configuration plan** with:
   - Ordered list of services to configure (dependencies first)
   - For each: vendor-side steps, Rails-side steps, verification criteria
   - Credential requirements (what keys are needed, where to store them)

5. **Update your assignment status**:
   ```yaml
   status: "in_progress"
   started_at: "timestamp"
   ```

## Blockers

- Missing API documentation for a required service -> mark as `blocked`
- Credentials not available -> mark as `blocked`, list what's needed
- Service requires a paid tier the task doesn't mention -> mark as `blocked`

## Transition

Once assessment is complete -> proceed to `/integrations-configure`
