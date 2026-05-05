---
name: gdpr-compliance
description: GDPR compliance assessment — scan for privacy risks, generate DPIA documentation, track data subject rights requests, map legal bases
allowed-tools: Read, Write, Glob, Grep, Bash
---

# GDPR Compliance

## Objective

Assess and improve GDPR compliance through codebase scanning, documentation, and process design.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What's the scope? (New processing activity, audit, DPIA, DSR handling)
   - Does the product process EU personal data?

2. **Scan codebase for privacy risks**:
   - Search for personal data patterns: email, phone, IP addresses, names
   - Check for special category data: health, biometric, religious, political
   - Identify risky code patterns:
     - Logging personal data (grep for log statements near PII fields)
     - Missing consent mechanisms
     - Indefinite data retention (no TTL or deletion)
     - Unencrypted sensitive data at rest
     - Disabled deletion functionality

3. **Map legal bases for each processing activity** (Art. 6):
   - **Consent**: Marketing, newsletters, analytics — must be freely given, specific, informed
   - **Contract**: Order fulfillment, service delivery
   - **Legal obligation**: Tax records, employment law
   - **Legitimate interests**: Fraud prevention, security — requires balancing test

4. **Determine if DPIA is required** (Art. 35):
   Triggers:
   - Systematic monitoring of public areas
   - Large-scale special category data processing
   - Automated decision-making with legal/significant effects
   - Two or more WP29 high-risk criteria met

   If required, generate DPIA documenting:
   - Processing description and purpose
   - Necessity and proportionality assessment
   - Risks to data subjects
   - Mitigation measures
   - DPO consultation outcome

5. **Design data subject rights handling** (Art. 15-22):

   | Right | Article | Deadline | Implementation |
   |-------|---------|----------|---------------|
   | Access | Art. 15 | 30 days | Export user data in machine-readable format |
   | Rectification | Art. 16 | 30 days | Allow data correction via settings or support |
   | Erasure | Art. 17 | 30 days | Delete all PII, anonymize analytics |
   | Restriction | Art. 18 | 30 days | Flag account, limit processing |
   | Portability | Art. 20 | 30 days | JSON/CSV export of user-provided data |
   | Objection | Art. 21 | 30 days | Stop processing based on legitimate interests |

   Design a tracking workflow: log request → verify identity → gather data → generate response → complete within deadline.

6. **Check breach notification readiness**:
   - GDPR: 72 hours after discovery to supervisory authority
   - Must notify data subjects "without undue delay" if high risk
   - Document: what happened, data affected, consequences, measures taken

## Key Requirements Checklist

- [ ] Privacy policy reflects actual data processing
- [ ] Consent collected before non-essential processing
- [ ] Data retention periods defined and enforced
- [ ] Encryption at rest and in transit for PII
- [ ] Data subject rights request process documented
- [ ] Breach notification process documented
- [ ] Records of processing activities maintained (Art. 30)
- [ ] Sub-processor agreements (DPAs) in place

## Output

Write deliverable to `.deliberate/reports/{slug}/gdpr-assessment.md` including:
- Compliance score (0-100) with risk categorization
- Processing activity inventory with legal bases
- DPIA (if required)
- Data subject rights implementation plan
- Prioritized remediation actions with GDPR article references
