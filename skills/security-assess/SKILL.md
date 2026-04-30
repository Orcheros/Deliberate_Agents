---
name: security-assess
description: Threat model the initiative — identify attack surfaces and security risks
allowed-tools: Read, Glob, Grep, Bash
---

# Step 1: Security Assessment

## Objective

Produce a threat model for the initiative — identify attack surfaces, threat actors, and security risks before code ships to production.

## Instructions

1. **Read the PRD and architecture doc** — identify security-relevant surfaces:
   - New user inputs (forms, API endpoints, file uploads)
   - New data flows (PII handling, external service communication)
   - New authentication/authorization boundaries
   - New webhook endpoints (external parties calling in)
   - New background jobs processing untrusted data
   - New browser-side scripts (XSS surface)

2. **Identify threat actors**:
   - Unauthenticated external users
   - Authenticated users attempting privilege escalation
   - Malicious webhook payloads from compromised third parties
   - Internal agents/jobs processing malformed data

3. **Map attack surfaces** (for each new endpoint/flow):
   - Input validation: what's accepted, what should be rejected
   - Authentication: who can access this
   - Authorization: what data/actions are permitted per role
   - Data exposure: what's returned in responses, error messages, logs
   - Rate limiting: is abuse possible

4. **Review existing security patterns** in the codebase:
   - How is authentication handled? (Devise, custom)
   - How is authorization handled? (Pundit, CanCanCan, custom)
   - How are CSRF tokens managed?
   - What's the content security policy?
   - How are credentials stored?

5. **Categorize risks** by severity (Critical/High/Medium/Low/Info)

6. **Update assignment status**:
   ```yaml
   status: "in_progress"
   started_at: "timestamp"
   ```

## Transition

Once the threat model is complete -> proceed to `/security-review`
