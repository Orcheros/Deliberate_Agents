---
name: integrations-verify
description: Verify integrations work end-to-end and document the results
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Step 3: Verify Integrations

## Objective

Verify every integration works end-to-end, document results, and signal completion.

## Instructions

1. **Run all tests**:
   ```bash
   bin/rails test test/services/{service}/
   bin/rails test test/jobs/sync/
   bin/rails test test/controllers/webhooks/
   ```

2. **For each integration, verify**:
   - Client wrapper connects successfully (or stubs return expected shapes)
   - Sync job creates/updates records correctly
   - Webhook handler processes test payloads correctly
   - Error handling works (stub failures, verify non-blocking behavior)
   - Credential loading works from encrypted storage

3. **Verify cross-integration behavior**:
   - Event dispatcher routes to correct destinations
   - Identity resolution works across services (same user in all systems)
   - Unsubscribe/opt-out propagates correctly
   - Feature flags/kill switches disable individual integrations

4. **Document results**:
   - Create or update integration runbook with verification results
   - Note any vendor-side configuration that needs manual verification
   - Document the 48-hour watch list (what to monitor after deploy)

5. **Update assignment status**:
   ```yaml
   status: "complete"
   completed_at: "timestamp"
   test_result: "pass"
   notes: "Integration verification results summary"
   ```

## Done

Your integration work is complete. The session can end.
