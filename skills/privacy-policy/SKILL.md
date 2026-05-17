---
name: privacy-policy
description: Generate a privacy policy template covering GDPR, CCPA, and COPPA requirements with legal review disclaimer
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Privacy Policy

## Objective

Generate a privacy policy template that addresses applicable data protection regulations. Cover data collection, usage, sharing, retention, user rights, and security measures. This is a template — legal counsel must review for jurisdiction-specific compliance.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What product or service needs a privacy policy?
   - What jurisdictions are the users in?
   - What type of data is collected?

2. **Identify applicable regulations**:
   - **GDPR** (EU/EEA): applies if serving EU users — requires legal basis for processing, data minimization, right to erasure, DPO appointment for large-scale processing
   - **CCPA/CPRA** (California): applies if meeting revenue/data thresholds for California residents — right to know, delete, opt-out of sale, non-discrimination
   - **COPPA** (US, children under 13): applies if knowingly collecting data from children — verifiable parental consent, data minimization, no behavioral advertising
   - Note which regulations apply and which sections are required by each

3. **Define data collection practices**:
   - What personal data is collected (name, email, payment, usage data, device info, location)
   - How data is collected (forms, cookies, analytics, third-party integrations)
   - Distinguish between data actively provided vs. automatically collected
   - Legal basis for each type of collection (consent, contract, legitimate interest)

4. **Specify data usage purposes**:
   - Primary purposes: service delivery, account management, communication
   - Secondary purposes: analytics, improvement, personalization
   - Marketing purposes: promotional communications (opt-in/opt-out)
   - Each purpose must be specific and justified — no blanket "business purposes"

5. **Document data sharing and third parties**:
   - Categories of third parties who receive data (processors, analytics, advertising, payment)
   - What data is shared with each category and why
   - Whether data is sold (CCPA definition of "sale")
   - International data transfers and safeguards (Standard Contractual Clauses, adequacy decisions)

6. **Describe retention periods**:
   - How long each category of data is retained
   - Criteria for determining retention periods
   - What happens to data after the retention period (deletion, anonymization)

7. **List user rights**:
   - Right of access (copy of personal data)
   - Right to deletion/erasure
   - Right to data portability
   - Right to opt-out of sale (CCPA)
   - Right to rectification
   - Right to restrict processing
   - Right to withdraw consent
   - How to exercise these rights (contact method, response timeline)
   - Non-discrimination for exercising rights

8. **Cookie policy**:
   - Types of cookies used (essential, functional, analytics, advertising)
   - Cookie consent mechanism
   - How to manage or disable cookies

9. **Security measures**:
   - Technical measures (encryption, access controls, monitoring)
   - Organizational measures (training, policies, incident response)
   - Breach notification procedures and timelines

10. **Contact information**:
    - Data controller identity and contact details
    - Data Protection Officer (if applicable)
    - Supervisory authority contact (for GDPR)
    - How to submit complaints or requests

## Output

Write deliverable to `.deliberate/reports/{slug}/privacy-policy.md` including:
- Complete privacy policy document with all required sections
- Applicable regulations identified with section-level callouts
- Disclaimer about legal review requirement
- Last updated date placeholder

## Constraints

- Always include the legal review disclaimer: "This is a template — have legal counsel review for jurisdiction-specific compliance."
- Do not claim compliance — state what the policy covers and note that legal review is required
- Be specific about data types and purposes — vague policies fail regulatory scrutiny
- Include all user rights required by applicable regulations

## Transition

Privacy policy is a standalone deliverable. May reference `/draft-nda` for related confidentiality terms.
