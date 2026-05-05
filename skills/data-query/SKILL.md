---
name: data-query
description: Explore data sources, understand schema, and write queries to answer specific questions
allowed-tools: Bash, Read, Glob, Grep
---

# Step 1: Query and Explore

## Objective

Understand the data landscape and write queries to extract the information needed for your task.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What question needs answering or what metric needs measuring
   - Time range and segmentation requirements
   - Who will consume this analysis and what decisions it informs

2. **Explore the schema**:
   - Read `db/schema.rb` for the current database structure
   - Read relevant model files to understand associations and scopes
   - Check for existing database views or materialized views
   - Identify relevant tables, columns, and relationships

3. **Understand existing patterns**:
   - Check for existing reporting queries in `app/models/` or `app/services/`
   - Look for counter caches, computed columns, or denormalized data
   - Check if there's an analytics or reporting module already
   - Note any soft-delete patterns (`discarded_at`, `deleted_at`)

4. **Write queries**:
   - Start with exploratory queries to understand data distribution
   - Use `EXPLAIN ANALYZE` on complex queries to check performance
   - Build incrementally — simple query first, then add joins and conditions
   - Use CTEs for readability on multi-step analysis
   - Always include date filters to bound the query

5. **Validate results**:
   - Cross-check totals against known values (e.g., user count matches admin dashboard)
   - Check for NULL handling — are NULLs excluded or included appropriately?
   - Verify joins aren't creating duplicates (compare COUNT vs COUNT DISTINCT)

## Output

- Validated queries with results
- Schema notes relevant to the analysis
- Any data quality issues discovered

## Transition

Proceed to `/data-report` or `/data-investigate` depending on task type.
