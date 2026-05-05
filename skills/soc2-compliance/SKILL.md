---
name: soc2-compliance
description: SOC 2 audit preparation — Trust Service Criteria mapping, control matrix generation, gap analysis, evidence collection, and readiness assessment
allowed-tools: Read, Write, Glob, Grep, Bash
---

# SOC 2 Compliance

## Objective

Prepare for SOC 2 Type I or Type II audits through structured control mapping, gap analysis, and evidence collection.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Type I (point-in-time design) or Type II (operating effectiveness over period)?
   - Which TSC categories are in scope?
   - Current state of compliance program

2. **Select applicable Trust Service Criteria**:

   **Security (CC1-CC9) — always required.** Covers:
   - CC1: Control environment (integrity, oversight, accountability)
   - CC2: Communication and information
   - CC3: Risk assessment
   - CC4: Monitoring activities
   - CC5: Control activities (policies, technology controls)
   - CC6: Logical and physical access (provisioning, auth, encryption)
   - CC7: System operations (vulnerability mgmt, incident response)
   - CC8: Change management (authorization, testing, approval)
   - CC9: Risk mitigation (vendor management)

   **Optional categories** — select based on business need:
   - **Availability (A1)**: Select when customers depend on uptime, you have SLAs
   - **Confidentiality (C1)**: Select when handling trade secrets or contractually confidential data
   - **Processing Integrity (PI1)**: Select when data accuracy is critical (financial, healthcare)
   - **Privacy (P1-P8)**: Select when processing PII and customers expect privacy assurance

3. **Build control matrix** for selected categories:

   For each control, document:
   | Field | Description |
   |-------|-------------|
   | Control ID | SEC-001, AVL-001, etc. |
   | TSC Mapping | Which criteria it addresses |
   | Control Description | What the control does |
   | Control Type | Preventive, Detective, or Corrective |
   | Owner | Responsible person/team |
   | Frequency | Continuous, Daily, Weekly, Monthly, Quarterly, Annual |
   | Evidence Type | Screenshot, Log, Policy, Config, Ticket |
   | Testing Procedure | How auditor verifies the control |

4. **Run gap analysis**:
   - **Missing controls**: TSC criteria with no corresponding control
   - **Partially implemented**: Control exists but lacks evidence or consistency
   - **Design gaps**: Control doesn't adequately address the criteria
   - **Operating gaps** (Type II): Control designed correctly but not operating effectively

   For each gap, define: remediation action, owner, priority (Critical 2-4wk / High 4-8wk / Medium 8-12wk / Low 12-16wk), target date.

5. **Plan evidence collection**:

   | Control Area | Primary Evidence | Secondary Evidence |
   |-------------|-----------------|-------------------|
   | Access Management | User access reviews, provisioning tickets | Role matrix, access logs |
   | Change Management | Change tickets, approval records | Deployment logs, test results |
   | Incident Response | Incident tickets, postmortems | Runbooks, escalation records |
   | Vulnerability Mgmt | Scan reports, patch records | Remediation timelines |
   | Encryption | Config screenshots, cert inventory | Key rotation logs |
   | Backup & Recovery | Backup logs, DR test results | Recovery time measurements |

   Automate where possible: IaC snapshots, git audit trail, scheduled scans.

6. **Assess readiness** (score 0-100%):
   - 90-100%: Audit ready — proceed
   - 75-89%: Minor gaps — address before scheduling
   - 50-74%: Significant gaps — remediation required
   - <50%: Not ready — major program build-out needed

## Common Audit Findings to Prevent

- Incomplete access reviews → automate quarterly review triggers
- Missing change approvals → define emergency change procedure with post-hoc approval
- Stale vulnerability scans → automated weekly scans with alerting
- Policy not acknowledged → annual e-signature workflow
- Missing vendor assessments → maintain vendor register with review schedule

## Output

Write deliverable to `.deliberate/reports/{slug}/soc2-assessment.md` including:
- Selected TSC categories with rationale
- Control matrix (full)
- Gap analysis with remediation plan
- Evidence collection plan
- Readiness score and timeline to audit-ready
