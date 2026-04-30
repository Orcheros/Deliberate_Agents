---
name: devops-implement
description: Implement infrastructure changes — CI/CD, monitoring, deployment config
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Step 2: Implement Infrastructure Changes

## Objective

Execute the infrastructure plan — modify CI/CD, add monitoring, configure deployment.

## Instructions

1. **CI/CD Pipeline Changes**:
   - Add new test steps if needed
   - Configure deployment environment promotion
   - Add environment variables to CI/CD secrets
   - Ensure migration safety checks are in place

2. **Environment Configuration**:
   - Document all new environment variables with purpose and format
   - Add to `.env.example` or equivalent
   - Configure in hosting platform (staging first, then production)
   - Verify Rails credentials for API keys

3. **Monitoring & Alerting**:
   - Add error tracking for new services/jobs
   - Configure alerting thresholds per PRD guardrails
   - Add health check endpoints if needed
   - Set up dashboard for new metrics

4. **Background Job Configuration**:
   - Configure queue names and priorities
   - Set worker scaling if needed
   - Configure retry policies per PRD requirements
   - Add job monitoring to dashboard

5. **Deployment Documentation**:
   - Write deployment procedure for this initiative
   - Document any migration steps that need manual intervention
   - Write rollback procedure
   - Document the 48-hour watch list (what to monitor post-deploy)

6. **Verify**:
   - CI pipeline passes
   - Staging deployment works
   - Monitoring captures expected signals
   - Rollback procedure is tested (or documented)

7. **Update assignment status**:
   ```yaml
   status: "complete"
   completed_at: "timestamp"
   notes: "Infrastructure changes implemented and verified"
   ```

## Done

Your infrastructure work is complete. The session can end.
