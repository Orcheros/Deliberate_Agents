---
name: incident-respond
description: Security incident triage — classify incidents, determine severity, filter false positives, plan forensic evidence collection, route escalation
allowed-tools: Read, Write, Glob, Grep, Bash
---

# Security Incident Response

## Objective

Classify, triage, and manage declared security incidents from detection through escalation and evidence collection.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What event or alert triggered this?
   - What systems/data are potentially affected?

2. **Classify the incident** using the taxonomy:

   | Incident Type | Default Severity | Response SLA |
   |--------------|-----------------|--------------|
   | Ransomware | SEV1 | 15 minutes |
   | Data exfiltration | SEV1 | 15 minutes |
   | APT intrusion | SEV1 | 15 minutes |
   | Supply chain compromise | SEV1 | 15 minutes |
   | Credential compromise | SEV2 | 1 hour |
   | Lateral movement | SEV2 | 1 hour |
   | Malware infection | SEV2 | 1 hour |
   | Cloud account compromise | SEV2 | 1 hour |
   | Unauthorized access | SEV3 | 4 hours |
   | Policy violation | SEV3 | 4 hours |
   | Phishing attempt | SEV4 | 24 hours |

3. **Filter false positives** before escalating:
   - CI/CD agent activity (jenkins, github-actions, circleci)
   - Test environment assets (test-, staging-, dev- prefixes)
   - Scheduled job patterns (cron, backup_)
   - Whitelisted service accounts (svc_monitoring, datadog-agent)
   - Security scanner activity (nessus, qualys, aws_inspector)

4. **Determine severity and escalation path**:

   | Severity | Criteria | Escalation | Communication |
   |----------|----------|-----------|---------------|
   | SEV1 | Confirmed ransomware, active exfiltration, domain breach | SOC Lead → CISO → CEO | Every 15 min |
   | SEV2 | Confirmed unauth access, credential compromise with escalation | SOC Lead → CISO | Every 30 min |
   | SEV3 | Suspected access (unconfirmed), contained malware | SOC Lead → Security Manager | At milestones |
   | SEV4 | Alert with no confirmed impact, policy violation | L3 Analyst queue | Standard cycle |

   **Auto-escalation triggers**: ransomware note found, active exfiltration confirmed, CloudTrail disabled, second system compromised → immediately re-declare SEV1.

5. **Initiate forensic evidence collection** (volatile-first):
   - Live memory (RAM dump) — lost on reboot, collect first
   - Running processes and open network connections
   - Logged-in users and active sessions
   - System uptime and current time (timeline anchoring)
   - Then: disk images, logs, configuration snapshots

   **Chain of custody**: every evidence item needs SHA-256 hash at acquisition, UTC timestamp, tool provenance, investigator identity.

6. **Check regulatory notification obligations**:

   | Framework | Deadline |
   |-----------|----------|
   | GDPR | 72 hours after discovery |
   | PCI-DSS | 24 hours to acquirer |
   | HIPAA (>500 individuals) | 60 days |
   | SEC | 4 business days after materiality determination |

   If scope is unclear at declaration, assume the most restrictive applicable deadline.

## Critical Anti-Patterns

- Starting notification clock at investigation completion — clocks start at discovery
- Containing before collecting volatile evidence — containment destroys RAM
- Skipping false positive verification before escalation — degrades SOC credibility
- Single-source classification — get at least two independent signals before SEV1
- Bypassing human approval for containment actions — can cause outages and destroy evidence

## Output

Write deliverable to `.deliberate/reports/{slug}/incident-response.md` including:
- Incident classification and severity
- False positive assessment
- Escalation path and notifications sent
- Evidence collection log with chain of custody
- Regulatory notification timeline (if applicable)
- Containment recommendations (pending human approval)
