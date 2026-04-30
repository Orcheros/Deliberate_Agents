---
name: compliance-document
description: Produce compliance artifacts — policy drafts, data flow docs, recommendations
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Step 2: Document Compliance Requirements

## Objective

Produce actionable compliance artifacts so the team knows exactly what needs to happen before and after launch.

## Instructions

1. **Write compliance assessment report**:
   - Summary of findings
   - Data flow diagram (text-based)
   - Regulatory analysis by framework
   - Risk ratings (Critical / High / Medium / Low)
   - Recommended actions with owners and timelines

2. **Draft policy updates** (if needed):
   - Privacy policy additions (new data processors, recording disclosure, marketing email)
   - Terms of service amendments
   - Cookie notice updates
   - Include exact text to add/modify, with location in existing documents

3. **Document DPA requirements**:
   - List new sub-processors and their DPA status
   - Note any DPAs that need to be executed
   - Document data residency for each processor

4. **Document deletion-on-request flow**:
   - For each external processor, document the deletion API/mechanism
   - Identify gaps (services that don't support API deletion)
   - Recommend automation or runbook for manual deletion

5. **Write decision files** for issues needing legal review:
   - Create `.deliberate/decisions/` entries for each "needs legal review" finding
   - Include context, the specific question, and your recommendation

6. **Update assignment status**:
   ```yaml
   status: "complete"
   completed_at: "timestamp"
   notes: "Compliance assessment and artifacts delivered"
   ```

## Done

Your compliance work is complete. The session can end.
