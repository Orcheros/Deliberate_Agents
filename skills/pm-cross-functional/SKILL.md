---
name: pm-cross-functional
description: Assess cross-functional impact and identify work streams for non-engineering agents
allowed-tools: Read, Glob, Grep
---

# Step 3.5: Cross-Functional Impact Assessment

## Objective

Review the PRD from the perspective of every function in a scaling startup. Identify work streams that non-engineering agents need to handle. This step ensures the PjM can route tasks to the right agent types.

## Instructions

### 1. Review the PRD's Cross-Functional Impact Section

If it exists, validate it. If it doesn't, create it. For each function area:

### 2. Engineering Assessment
- What code needs to be written? (Developer Agent tasks)
- What migrations, models, services, controllers, tests?
- Complexity and phasing?

### 3. Integrations Assessment
- What SaaS tools need configuration? (Integrations Engineer tasks)
- Account setup, custom properties, pipelines, audiences, workflows?
- Client wrappers, sync jobs, webhook handlers?
- DNS/email authentication?

### 4. Content Assessment
- What copy needs to be written? (Content Writer tasks)
- Lifecycle emails, in-app messaging, notification templates?
- Per-ICP variants? Brand voice alignment?
- Communication map completeness?

### 5. Compliance Assessment
- What privacy/legal/regulatory work is needed? (Compliance Analyst tasks)
- Privacy policy updates?
- New data flows to document?
- Consent mechanisms needed?
- DPA requirements for new processors?

### 6. Documentation Assessment
- What docs need to be written? (Technical Writer tasks)
- Runbooks for new operational procedures?
- API documentation for new endpoints?
- Agent contract updates?
- Internal reference updates?

### 7. Infrastructure Assessment
- What DevOps work is needed? (DevOps Engineer tasks)
- New environment variables or secrets?
- CI/CD pipeline changes?
- Monitoring and alerting setup?
- Deployment procedure changes?

### 8. Security Assessment
- What security review is needed? (Security Analyst tasks)
- New attack surfaces?
- New authentication/authorization boundaries?
- PII handling changes?
- Dependency audit needed?

### 9. Sales & GTM Assessment
- What sales enablement is needed?
- Pipeline changes? New templates? Playbook updates?
- Demo or trial changes?

### 10. Customer Success Assessment
- What onboarding or support changes are needed?
- New failure modes users might encounter?
- Help documentation updates?
- Admin tooling changes?

## Output

Update the PRD's Cross-Functional Impact section with your assessment. For each function area, note:
- **Impact**: What changes
- **Agent Type**: Which agent handles this
- **Priority**: Must-do before launch / should-do soon / track for later
- **Task Sketch**: Brief description of what the task assignment would say

This output is critical for the PjM's task decomposition in the next phase.

## Transition

Proceed to `/pm-ready-for-dev`
