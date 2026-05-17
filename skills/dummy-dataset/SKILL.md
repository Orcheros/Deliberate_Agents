---
name: dummy-dataset
description: Generate realistic test datasets — CSV, JSON, SQL INSERT, or pandas DataFrame with referential integrity, realistic distributions, and edge cases
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Dummy Dataset Generation

## Objective

Generate realistic test datasets for development, testing, and demonstration purposes. Produce data in multiple output formats (CSV, JSON, SQL INSERT statements, Python pandas DataFrames) with referential integrity across tables, realistic distribution patterns, and deliberate edge cases.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What data schema is needed (tables, columns, types)?
   - How many rows per table?
   - What output format(s) are required (CSV, JSON, SQL, Python)?
   - What database dialect for SQL output (PostgreSQL, MySQL, BigQuery)?
   - Are there specific scenarios or edge cases to include?

2. **Understand the data schema**:
   - If a schema exists (SQL DDL, ORM models, documentation), read and follow it exactly
   - If no schema exists, design one based on the use case:
     - Identify entities and their relationships (one-to-many, many-to-many)
     - Define column names, data types, and constraints (NOT NULL, UNIQUE, FK)
     - Document primary keys and foreign key relationships
   - Note any enum values, valid ranges, or business rules that constrain the data

3. **Generate realistic values** (not random noise):

   **Personal data**:
   - Names: mix of common and less-common names, diverse cultural backgrounds
   - Emails: follow realistic patterns (`firstname.lastname@domain.com`, common providers)
   - Dates: realistic ranges (birthdates 18-80 years ago, registration dates within product lifetime)
   - Addresses: realistic city/state/country combinations (not random strings)

   **Business data**:
   - Company names: realistic SaaS/tech company patterns
   - Revenue: log-normal distribution (many small, few large), not uniform
   - Plan tiers: weighted distribution matching typical SaaS (e.g., 60% free, 25% starter, 12% pro, 3% enterprise)
   - Dates: business-hours bias for activity data, realistic timezone distribution

   **Product usage data**:
   - Session counts: power-law distribution (few heavy users, many light users)
   - Feature adoption: correlated with tenure and plan tier
   - Event timestamps: realistic patterns (weekday/weekend, business hours, timezone-adjusted)
   - Retention patterns: exponential decay matching typical SaaS curves

4. **Ensure referential integrity across tables**:
   - Foreign keys must reference existing primary keys
   - One-to-many relationships have realistic cardinality (not every user has exactly 5 orders)
   - Many-to-many junction tables are consistent
   - Cascading constraints are respected (no orphan records)
   - Timestamps are chronologically consistent (created_at < updated_at, signup before first activity)

5. **Apply realistic distribution patterns** (not uniform random):
   - Use appropriate distributions per data type:
     - Revenue/prices: log-normal
     - Counts/frequency: Poisson or negative binomial
     - Ratings: beta distribution (skewed toward positive)
     - Time intervals: exponential
     - Categories: weighted categorical (Zipf-like for some)
   - Add correlations between related fields (higher plan tier correlates with more usage)
   - Include seasonal patterns where appropriate (higher signups in Q1, lower in summer)

6. **Include deliberate edge cases**:
   - **Nulls**: nullable columns should have some NULL values (5-15% depending on field)
   - **Unicode**: include names/text with accented characters, CJK characters, emoji, RTL text
   - **Long strings**: include some values at or near VARCHAR limits
   - **Boundary values**: zero amounts, negative values where valid, MAX_INT adjacent
   - **Duplicate-adjacent**: similar but not identical values (testing dedup logic)
   - **Temporal edge cases**: midnight crossings, timezone boundaries, leap year dates, DST transitions
   - **Empty strings vs. NULLs**: include both where the column allows it
   - Document which rows contain edge cases and why

7. **Produce output in requested format(s)**:

   **CSV**:
   - UTF-8 encoding with BOM for Excel compatibility
   - Properly escaped commas, quotes, and newlines within values
   - Header row with column names
   - One file per table

   **JSON**:
   - Array of objects, one per row
   - Proper data types (numbers as numbers, dates as ISO 8601 strings)
   - Pretty-printed for readability
   - One file per table

   **SQL INSERT statements**:
   - Match target dialect (PostgreSQL, MySQL, BigQuery)
   - Batch inserts for efficiency (multi-row VALUES)
   - Include CREATE TABLE DDL before INSERTs
   - Respect insertion order for foreign key constraints
   - Escape special characters properly

   **Python (pandas)**:
   - Generate a Python script that creates DataFrames
   - Include proper dtypes (datetime64, category, Int64 for nullable ints)
   - Add comments explaining the data generation logic
   - Optionally include Faker-based generation for reproducibility

8. **Document the dataset**:
   - Schema description: tables, columns, types, constraints
   - Row counts per table
   - Distribution descriptions: what patterns were used and why
   - Edge case inventory: which rows have special values
   - Known limitations: what the dataset does NOT represent
   - Seed value or reproducibility instructions if applicable

## Output

Write deliverable to `.deliberate/reports/{slug}/dummy-dataset/` including:
- Data files in the requested format(s) (CSV, JSON, SQL, or Python script)
- `README.md` documenting: schema, row counts, distributions, edge cases, and generation methodology
- Schema diagram or description showing table relationships

## Constraints

- Never include real PII — all personal data must be synthetic
- Ensure foreign key integrity — no orphan references
- Document all assumptions about data distributions
- Edge cases should be realistic, not adversarial (this is test data, not fuzzing)
- Large datasets (>10K rows) should be generated via script, not inline

## Transition

Dummy datasets support `/sql-query-generation` for testing queries, `/data-report` for building report templates, and development/testing workflows. They can also be used for demo environments and onboarding.
