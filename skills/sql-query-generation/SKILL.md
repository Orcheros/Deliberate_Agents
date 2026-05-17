---
name: sql-query-generation
description: Generate SQL queries from natural language — BigQuery, PostgreSQL, MySQL dialect support with optimization, comments, and common analytical patterns
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# SQL Query Generation

## Objective

Generate correct, optimized, and well-documented SQL queries from natural language descriptions. Support dialect differences across BigQuery, PostgreSQL, and MySQL. Include explanatory comments, performance guidance, and common analytical query patterns.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What data question needs to be answered?
   - What database dialect is in use (BigQuery, PostgreSQL, MySQL)?
   - What schema information is available (table names, column names, relationships)?
   - What is the expected output format and granularity?

2. **Understand the data question**:
   - Restate the natural language question as a precise analytical question
   - Identify: what entity is being measured, what metric, what time range, what filters, what grouping
   - Clarify ambiguity: "active users" needs a definition, "last month" needs a date range
   - Determine if the question requires: simple aggregation, joins, subqueries, window functions, CTEs
   - Ask clarifying questions if the request is ambiguous (write them in the output if unable to ask)

3. **Identify relevant tables and columns**:
   - Map the question to specific tables and columns in the schema
   - Identify join paths between tables (foreign keys, shared identifiers)
   - Note any derived or computed fields needed
   - Check for data availability: does the schema actually contain what's needed?
   - If schema is unknown, document assumed table structure clearly

4. **Write the query with proper structure**:
   - Use CTEs (WITH clauses) for readability when queries have multiple logical steps
   - Write explicit JOINs (never implicit comma joins)
   - Use meaningful aliases (not single letters: `users AS u` is fine, but prefer `users` when clear)
   - Add comments explaining the logic of each section
   - Include WHERE clauses for time ranges and relevant filters
   - Use appropriate aggregations (SUM, COUNT, AVG, COUNT(DISTINCT))
   - Apply GROUP BY for all non-aggregated columns
   - Add ORDER BY for deterministic output
   - Use LIMIT for exploratory queries

5. **Handle dialect differences**:

   **Date functions**:
   - PostgreSQL: `DATE_TRUNC('month', created_at)`, `created_at::date`, `INTERVAL '30 days'`
   - BigQuery: `DATE_TRUNC(created_at, MONTH)`, `DATE(created_at)`, `DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)`
   - MySQL: `DATE_FORMAT(created_at, '%Y-%m-01')`, `DATE(created_at)`, `DATE_SUB(CURDATE(), INTERVAL 30 DAY)`

   **String functions**:
   - PostgreSQL: `||` for concat, `ILIKE` for case-insensitive
   - BigQuery: `CONCAT()`, `LOWER() = LOWER()` for case-insensitive
   - MySQL: `CONCAT()`, `LIKE` (case-insensitive by default with utf8)

   **Window functions**:
   - PostgreSQL and BigQuery: full support
   - MySQL: supported in 8.0+, flag if targeting older versions

   **Other differences**:
   - BigQuery: backtick table names, no `DELETE` without `WHERE`, `SAFE_DIVIDE()`
   - PostgreSQL: `DISTINCT ON`, `FILTER` clause, array types
   - MySQL: `IFNULL` vs. `COALESCE`, `LIMIT` syntax, no full outer join

6. **Optimize for performance**:
   - Filter early (WHERE before JOIN when possible, or let the optimizer handle it with clear predicates)
   - Use indexed columns in WHERE and JOIN conditions
   - Avoid `SELECT *` — specify only needed columns
   - Use `EXISTS` instead of `IN` for subqueries on large tables
   - Avoid functions on indexed columns in WHERE clauses (`WHERE DATE(created_at) = ...` prevents index use; prefer range: `WHERE created_at >= ... AND created_at < ...`)
   - For large result sets, consider `EXPLAIN` plan guidance
   - Note any full table scans and suggest mitigation

7. **Include EXPLAIN plan guidance**:
   - For PostgreSQL: `EXPLAIN ANALYZE` to see actual execution
   - For BigQuery: use Query Execution Details in the console
   - For MySQL: `EXPLAIN` with format tree (8.0+)
   - Flag expected expensive operations: full scans, hash joins on large tables, sorts on non-indexed columns
   - Suggest index creation if a query will be run repeatedly

## Common Analytical Patterns

Include these patterns as templates when relevant:

**Funnel query**:
```sql
WITH steps AS (
  SELECT user_id,
    MAX(CASE WHEN event = 'signup' THEN 1 ELSE 0 END) AS step_1_signup,
    MAX(CASE WHEN event = 'onboarding_complete' THEN 1 ELSE 0 END) AS step_2_onboard,
    MAX(CASE WHEN event = 'first_action' THEN 1 ELSE 0 END) AS step_3_action
  FROM events
  WHERE created_at >= '2025-01-01'
  GROUP BY user_id
)
SELECT
  COUNT(*) AS total_users,
  SUM(step_1_signup) AS signups,
  SUM(step_2_onboard) AS onboarded,
  SUM(step_3_action) AS activated
FROM steps;
```

**Cohort retention query**:
```sql
WITH cohorts AS (
  SELECT user_id, DATE_TRUNC('month', created_at) AS cohort_month
  FROM users
),
activity AS (
  SELECT user_id, DATE_TRUNC('month', event_date) AS activity_month
  FROM events
)
SELECT
  c.cohort_month,
  COUNT(DISTINCT c.user_id) AS cohort_size,
  COUNT(DISTINCT CASE WHEN a.activity_month = c.cohort_month + INTERVAL '1 month' THEN a.user_id END) AS month_1,
  COUNT(DISTINCT CASE WHEN a.activity_month = c.cohort_month + INTERVAL '2 months' THEN a.user_id END) AS month_2
FROM cohorts c
LEFT JOIN activity a ON c.user_id = a.user_id
GROUP BY c.cohort_month
ORDER BY c.cohort_month;
```

**Time-series query**:
```sql
SELECT
  DATE_TRUNC('day', created_at) AS day,
  COUNT(*) AS events,
  COUNT(DISTINCT user_id) AS unique_users
FROM events
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE_TRUNC('day', created_at)
ORDER BY day;
```

**Top-N with ranking**:
```sql
SELECT *
FROM (
  SELECT
    user_id,
    COUNT(*) AS action_count,
    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rank
  FROM events
  WHERE created_at >= '2025-01-01'
  GROUP BY user_id
) ranked
WHERE rank <= 100;
```

**Pivot table** (PostgreSQL):
```sql
SELECT
  plan_tier,
  COUNT(*) FILTER (WHERE status = 'active') AS active,
  COUNT(*) FILTER (WHERE status = 'churned') AS churned,
  COUNT(*) FILTER (WHERE status = 'trial') AS trial
FROM users
GROUP BY plan_tier;
```

## Output

Write deliverable to `.deliberate/reports/{slug}/sql-queries.md` including:
- Restated data question (precise analytical version)
- Schema assumptions or confirmed table/column references
- The SQL query with inline comments explaining each section
- Dialect notes if the query differs across databases
- Performance notes: expected cost, index recommendations, EXPLAIN guidance
- Expected output format: column names, data types, row count estimate

## Constraints

- Always use parameterized queries for any user-supplied values — no string interpolation
- Never generate queries that modify data (INSERT, UPDATE, DELETE) unless explicitly requested
- Always include a WHERE clause for time-bounded queries — unbounded scans on large tables are dangerous
- Document all schema assumptions — if table structure is assumed, say so
- Prefer readability over cleverness — a clear CTE-based query beats a nested subquery one-liner

## Transition

Generated queries feed into `/data-report`, `/cohort-analysis`, `/ab-test-analysis`, and ad-hoc data investigations. Query patterns become reusable templates for the data team.
