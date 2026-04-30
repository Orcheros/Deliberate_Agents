---
name: devops-assess
description: Evaluate infrastructure and deployment needs for the initiative
allowed-tools: Read, Glob, Grep, Bash
---

# Step 1: Assess Infrastructure Needs

## Objective

Understand what infrastructure changes the initiative requires before making any modifications.

## Instructions

1. **Read the PRD and architecture doc** — identify infrastructure touchpoints:
   - New services or background workers needed
   - New environment variables or secrets
   - Database changes (migrations, indexes, connection pool impact)
   - New external service connections (API endpoints, webhook URLs)
   - Performance requirements (latency targets, throughput needs)
   - Monitoring and alerting requirements

2. **Read existing infrastructure configuration**:
   - Hosting config (Render blueprint, Procfile, docker-compose, etc.)
   - CI/CD pipeline (GitHub Actions, CircleCI, etc.)
   - Environment variable management
   - Background job configuration (queue names, worker counts)
   - Monitoring setup (Honeybadger, New Relic, etc.)

3. **Assess impact**:
   - Does this need a new service/process?
   - Does this change resource requirements (memory, CPU, workers)?
   - Does this introduce new failure modes that need monitoring?
   - Does the deployment need special handling (migrations, feature flags)?
   - What's the rollback plan?

4. **Create an infrastructure plan**:
   - Changes to make, in order
   - Environment variables to add
   - Monitoring/alerting to configure
   - Deployment procedure (if non-standard)
   - Rollback procedure

5. **Update assignment status**:
   ```yaml
   status: "in_progress"
   started_at: "timestamp"
   ```

## Transition

Once assessment is complete -> proceed to `/devops-implement`
