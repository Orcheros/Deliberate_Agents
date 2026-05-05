---
name: db-migrate
description: Write safe, reversible database migrations following zero-downtime patterns
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Step 2: Write Migrations

## Objective

Write database migrations that are safe, reversible, and production-ready.

## Instructions

1. **Plan the migration sequence**:
   - Complex schema changes should be split into multiple migrations
   - Order: add columns → backfill data → add constraints → remove old columns
   - Each migration should be independently deployable

2. **Write migrations following safety patterns**:
   - **Adding a column**: Always add with a default or allow NULL first, backfill, then add NOT NULL constraint
   - **Removing a column**: First deploy code that ignores the column, then remove in a separate migration
   - **Adding an index**: Always use `algorithm: :concurrently` and `disable_ddl_transaction!`
   - **Renaming**: Add new column → backfill → update code → remove old column (never rename directly)
   - **Adding a table**: Safe — just add it with proper indexes and constraints

3. **Write the migration files**:
   - Follow Rails naming conventions: `YYYYMMDDHHMMSS_description.rb`
   - Include both `up` and `down` methods (or `change` if safely reversible)
   - Add comments for non-obvious operations
   - Include `safety_assured` blocks only when you've verified the operation is safe

4. **Update models**:
   - Add associations, validations, and scopes for new columns/tables
   - Add database-level constraints that match model validations
   - Update fixtures to include new columns

5. **Verify the migration**:
   ```bash
   bin/rails db:migrate
   bin/rails db:rollback
   bin/rails db:migrate
   ```
   - Confirm migration runs clean in both directions
   - Run the test suite to verify no breakage

## Output

- Migration files in `db/migrate/`
- Updated model files with associations and validations
- Updated fixtures

## Transition

Proceed to `/db-seed` if seed data needs updating, or complete.
