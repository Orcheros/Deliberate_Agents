---
name: dep-audit
description: Audit project dependencies for vulnerabilities, license compliance, outdated packages, and supply chain risks
allowed-tools: Read, Write, Glob, Grep, Bash
---

# Dependency Audit

## Objective

Analyze project dependencies for security vulnerabilities, license compliance, outdated packages, and supply chain risks.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What's the scope? (Security scan, license audit, upgrade planning, full audit)
   - Which package ecosystems? (Ruby/Gemfile, JS/package.json, Python/requirements.txt, etc.)

2. **Scan for vulnerabilities**:
   - Run `bundle audit` for Ruby/Gemfile
   - Run `npm audit` or `yarn audit` for JavaScript
   - Run `pip-audit` for Python
   - Check for known CVEs against current dependency versions
   - Classify findings: Critical, High, Medium, Low (using CVSS scores)
   - Map vulnerabilities to dependency paths (direct vs. transitive)

3. **Check license compliance**:

   | License Type | Risk Level | Action |
   |-------------|-----------|--------|
   | MIT, Apache 2.0, BSD, ISC | Permissive — low risk | OK for any use |
   | LGPL v2.1/v3, MPL v2.0 | Weak copyleft — medium risk | OK if not modifying the library |
   | GPL v2/v3, AGPL v3 | Strong copyleft — high risk | May require open-sourcing your code |
   | Proprietary, Unknown | High risk | Requires legal review |

   Flag any GPL/AGPL dependencies in a commercial product. Identify license conflicts in the dependency tree.

4. **Identify outdated dependencies**:
   - Run `bundle outdated` (Ruby), `npm outdated` (JS), `pip list --outdated` (Python)
   - Categorize by severity: patch (safe), minor (likely safe), major (breaking changes possible)
   - Flag abandoned packages: no commits in 12+ months, no security patches
   - Identify pinned versions that are significantly behind

5. **Assess supply chain risks**:
   - Check for typosquatting (similarly-named malicious packages)
   - Review packages with recent maintainer changes
   - Flag packages with very few downloads or contributors
   - Verify lockfile is up-to-date and deterministic

6. **Plan upgrades** (prioritized):

   | Priority | Category | Action |
   |----------|----------|--------|
   | Immediate | Critical/High CVEs | Patch or upgrade now |
   | High | Deprecated dependencies | Plan replacement |
   | Medium | Major version updates | Schedule with testing |
   | Low | Minor/patch updates | Include in next maintenance cycle |

   For major version upgrades: review changelogs for breaking changes, assess migration effort, plan testing strategy.

7. **Check for unused dependencies**:
   - Grep for actual imports/requires of each dependency
   - Flag dependencies in manifest but not imported anywhere
   - Identify redundant packages (multiple packages doing the same thing)

## Output

Write deliverable to `.deliberate/reports/{slug}/dependency-audit.md` including:
- Vulnerability summary (count by severity, affected packages, remediation)
- License compliance report (any conflicts or risks)
- Outdated dependency inventory with upgrade priority
- Supply chain risk findings
- Unused dependency list
- Recommended upgrade plan with timeline
