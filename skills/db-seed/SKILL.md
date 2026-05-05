---
name: db-seed
description: Manage seed data, test fixtures, and development data strategies
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Step 3: Seed and Fixture Management

## Objective

Ensure development, test, and staging environments have appropriate data for the current schema.

## Instructions

1. **Update seed data** (`db/seeds.rb` or `db/seeds/`):
   - Add seed records for new models
   - Ensure seeds are idempotent (safe to run multiple times)
   - Use `find_or_create_by` patterns
   - Include realistic sample data, not just "Test 1", "Test 2"
   - Cover all enum values and important states

2. **Update test fixtures** (`test/fixtures/`):
   - Add fixture files for new models
   - Update existing fixtures with new columns
   - Ensure fixture relationships are consistent (foreign keys match)
   - Provide enough fixture variety to cover test scenarios
   - Follow existing fixture naming conventions

3. **Development data considerations**:
   - Is there enough data to exercise all features?
   - Are edge cases represented (empty states, maximum values, special characters)?
   - Is the data volume sufficient to surface performance issues?

4. **Verify**:
   ```bash
   bin/rails db:seed
   bin/rails test
   ```
   - Seeds run without errors
   - All tests pass with updated fixtures

## Output

- Updated seed files
- Updated fixture files
- Verification that seeds and tests pass

## Transition

Database work complete. Update assignment status.
