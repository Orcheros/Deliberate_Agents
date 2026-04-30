---
name: compliance-assess
description: Identify privacy, legal, and regulatory implications of the initiative
allowed-tools: Read, Glob, Grep
---

# Step 1: Assess Compliance Implications

## Objective

Identify every privacy, legal, and regulatory concern the initiative introduces before any work ships.

## Instructions

1. **Read the PRD** — focus on:
   - Data model changes (new PII columns, new data flows)
   - External service integrations (what data leaves the system, to where)
   - User-facing changes (consent mechanisms, recording, tracking)
   - Communication changes (new email types, notification channels)

2. **Map data flows**:
   - What PII is collected? (name, email, IP, behavior, financial)
   - Where does it go? (database, HubSpot, PostHog, Loops, GTM, etc.)
   - Who processes it? (internal, third-party sub-processors)
   - How long is it retained? (per service, per policy)
   - Can it be deleted on request? (deletion flow coverage)

3. **Assess regulatory implications**:
   - **GDPR**: Is consent needed? Legitimate interest basis? Right to deletion covered?
   - **CCPA/CPRA**: Disclosure requirements? Opt-out mechanisms? Sale of data?
   - **CAN-SPAM**: Marketing vs. transactional distinction? Unsubscribe mechanism?
   - **ePrivacy**: Cookie consent needed? Tracking pixel consent?
   - **Industry-specific**: Any sector-specific regulations (HIPAA, SOX, PCI)?

4. **Review existing compliance posture**:
   - Current privacy policy — does it cover the new data flows?
   - Current terms of service — any needed updates?
   - Existing DPAs with sub-processors — are new processors covered?
   - Cookie/consent notice — does it need updating?

5. **Categorize findings**:
   - **Must-fix before launch**: Blocks deployment
   - **Should-fix soon**: Ship but remediate within 30 days
   - **Track for future**: Not urgent, document for when it becomes relevant
   - **Needs legal review**: Flag for human/counsel decision

6. **Update assignment status**:
   ```yaml
   status: "in_progress"
   started_at: "timestamp"
   ```

## Transition

Once assessment is complete -> proceed to `/compliance-document`
