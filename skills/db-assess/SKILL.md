---
name: db-assess
description: Review schema design, migration safety, and database performance
allowed-tools: Bash, Read, Glob, Grep
---

# Step 1: Database Assessment

## Objective

Review the current database state, proposed schema changes, or performance concerns to provide expert guidance.

## Instructions

1. **Read your assignment** (`.deliberate/assignments/{worktree}.md`):
   - Is this a new schema design, migration review, or performance investigation?
   - What initiative or feature does this support?

2. **Review current schema**:
   - Read `db/schema.rb` for current state
   - Read recent migrations in `db/migrate/` for evolution patterns
   - Read relevant model files for associations, validations, and scopes
   - Check for existing indexes and constraints

3. **For schema design reviews**:
   - Does the proposed model support the use cases in the PRD?
   - Are relationships properly normalized (or intentionally denormalized)?
   - Are foreign keys defined at the database level (not just ActiveRecord)?
   - Are NOT NULL constraints applied where data is required?
   - Are unique constraints defined where duplicates would be invalid?
   - Is there a sensible indexing strategy for expected query patterns?

4. **For migration safety reviews**:
   - Will any migration lock tables during writes?
   - Are column additions safe? (adding NOT NULL without default on existing table = danger)
   - Are column removals safe? (is the column still referenced in code?)
   - Are index operations concurrent? (`algorithm: :concurrently`)
   - Is there a backfill strategy for existing data?
   - Can each migration be rolled back?

5. **For performance reviews**:
   - Identify slow queries from logs or `pg_stat_statements`
   - Check for missing indexes (sequential scans on large tables)
   - Check for N+1 queries in the relevant controllers/models
   - Check for over-indexing (unused indexes waste write performance)
   - Evaluate connection pool configuration

## Output

- Assessment report with findings and recommendations
- Specific migration safety concerns (if any)
- Index recommendations with justifying query patterns

## Transition

Proceed to `/db-migrate` if migrations need to be written or revised.
