---
name: integrations-configure
description: Set up and wire integrations following the configuration plan
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Step 2: Configure Integrations

## Objective

Execute the configuration plan — build client wrappers, sync jobs, webhook handlers, and document vendor-side configuration steps.

## Instructions

1. **For each integration, in dependency order**:

   ### Rails-Side Implementation
   - Create client wrapper at `app/services/{service}/client.rb`
     - Wrap the vendor SDK (never call SDK directly from controllers/models)
     - Include error handling (rescue, retry with backoff, Honeybadger capture)
     - Include rate limit awareness
     - Make all operations idempotent
   - Create sync jobs at `app/jobs/sync/{service}_sync_job.rb`
     - Idempotent — re-running produces the same end state
     - Retry with exponential backoff on transient failures
     - Log failures, never raise to user request
   - Create webhook controller at `app/controllers/webhooks/{service}_controller.rb`
     - Verify webhook signatures (reject unsigned requests with 401)
     - Handle all event types the PRD specifies
     - Return 200 for unknown event types (don't break on new events)
   - Store credentials via Rails encrypted credentials per project conventions

   ### Vendor-Side Documentation
   - Write step-by-step configuration instructions as runbook entries
   - Document custom properties, pipelines, audiences, workflows
   - Note configuration that must be done manually in vendor UI
   - Include screenshots or exact field values where possible

2. **Follow existing patterns**:
   - Match naming conventions of existing service wrappers
   - Use the same job queue as existing sync jobs
   - Follow the project's test patterns for client/job testing

3. **Write tests**:
   - Unit tests for client wrapper (idempotency, retry, error handling)
   - Job tests (idempotency, failure behavior, skip conditions)
   - Controller tests (signature verification, event handling, unknown events)
   - Use VCR cassettes or stubs for external API calls

## Quality Checks

- [ ] No direct SDK calls outside client wrappers
- [ ] All sync jobs are idempotent
- [ ] All webhook endpoints verify signatures
- [ ] All credentials in encrypted storage
- [ ] All external failures are non-blocking to user requests
- [ ] Rate limits are respected

## Transition

Once all integrations are configured -> proceed to `/integrations-verify`
