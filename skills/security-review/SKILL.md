---
name: security-review
description: Review code and configuration for vulnerabilities — produce findings report
allowed-tools: Bash, Read, Glob, Grep
---

# Step 2: Security Code Review

## Objective

Review the actual code changes for security vulnerabilities and produce an actionable findings report.

## Instructions

1. **Review code for OWASP Top 10**:
   - **Injection** (SQL, command, LDAP): Are user inputs sanitized? Parameterized queries used?
   - **Broken Authentication**: Session management sound? Token handling secure?
   - **Sensitive Data Exposure**: PII logged? Secrets in error messages? Insecure transmission?
   - **XXE**: XML parsing secure?
   - **Broken Access Control**: Authorization checks on every action? IDOR possible?
   - **Security Misconfiguration**: Default passwords? Unnecessary features enabled?
   - **XSS**: User input rendered unescaped? Content security policy adequate?
   - **Insecure Deserialization**: Untrusted data deserialized?
   - **Known Vulnerabilities**: Dependencies up to date? `bundle audit` clean?
   - **Insufficient Logging**: Security events logged? Audit trail adequate?

2. **Rails-specific checks**:
   - Strong parameters used for all user input?
   - `html_safe` or `raw` used on untrusted content?
   - Mass assignment protection in place?
   - CSRF protection enabled for state-changing actions?
   - `protect_from_forgery` exceptions justified?
   - Secure headers configured (X-Frame-Options, CSP, HSTS)?

3. **Webhook endpoint review**:
   - Signature verification implemented and tested?
   - Replay protection (timestamp validation)?
   - Error responses don't leak internal state?

4. **Dependency audit**:
   ```bash
   bundle audit check --update
   ```

5. **Write the findings report**:
   For each finding:
   - **Severity**: Critical / High / Medium / Low / Informational
   - **Title**: One-line description
   - **Location**: File and line number
   - **Description**: What the vulnerability is
   - **Impact**: What an attacker could achieve
   - **Remediation**: Specific fix with code snippet
   - **Reference**: CWE ID or OWASP category

6. **Critical/High findings**: Write immediately to `.deliberate/decisions/`

7. **Update assignment status**:
   ```yaml
   status: "complete"
   completed_at: "timestamp"
   notes: "Security review findings: X critical, Y high, Z medium"
   ```

## Done

Your security review is complete. The session can end.
