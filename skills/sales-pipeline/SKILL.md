---
name: sales-pipeline
description: Maintain pipeline hygiene — stage accuracy, stale deal detection, data completeness
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Pipeline Management

## Objective

Review and maintain pipeline health — ensure deal stages are accurate, identify stale opportunities, and flag data gaps.

## Instructions

1. **Review all active deals**:
   - Is the stage accurate based on last activity?
   - Are required properties populated (company, contact, ICP segment, value)?
   - When was the last meaningful activity?
   - Is there a clear next step documented?

2. **Identify stale deals**:
   - No activity in 14+ days for early-stage deals
   - No activity in 30+ days for mid-stage deals
   - Recommended action: re-engage, downgrade stage, or close as lost

3. **Data completeness audit**:
   - Contacts missing key properties (ICP segment, company, role)
   - Deals missing value estimates
   - Missing stakeholder mapping for multi-stakeholder deals

4. **Pipeline metrics summary**:
   - Total pipeline value by stage
   - Deals added/moved/closed this period
   - Average deal age by stage
   - Conversion rates between stages

5. **Recommendations**:
   - Deals that need immediate attention
   - Deals ready to advance
   - Deals to consider closing
   - Data cleanup tasks

## Output

Write pipeline health report and recommendations. Update assignment status.
