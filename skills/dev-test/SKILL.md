---
name: dev-test
description: Verify implementation with tests and fix failures
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Step 3: Test

## Objective

Verify your implementation works correctly and doesn't break existing functionality.

## Instructions

1. **Write tests using your assignment's test strategy**:
   - Write tests in the file specified by `test_strategy.test_file` in your assignment
   - Read and mirror the structure of the `test_strategy.model_after` file — match its setup patterns, assertion style, and naming conventions
   - Use the fixtures listed in `test_strategy.fixtures`
   - Test happy path for each acceptance criterion
   - Test edge cases explicitly mentioned in the task
   - Test validation errors and error states
   - For controllers: test each action's response, redirects, and flash messages
   - For models: test validations, associations, and scopes
   - For Stimulus: if the project has system tests, add coverage for JS behavior

2. **Run the relevant test suite**:
   ```bash
   # Run tests for the specific files you changed
   bin/rails test test/models/your_model_test.rb
   bin/rails test test/controllers/your_controller_test.rb

   # Run the full test suite
   bin/rails test

   # If system tests are relevant
   bin/rails test:system
   ```

3. **If tests fail**:
   - Read the failure message carefully
   - If the failure is in YOUR code: fix it and re-run
   - If the failure is in code you didn't touch: investigate
     - Is it a pre-existing failure? Check if the test passes on the base branch
     - Did your change break an unrelated test? Fix the regression
     - Is it a flaky test? Note it but don't mark yourself blocked for flaky tests
   - Re-run until all tests pass

4. **If tests can't pass**:
   - If the issue is outside your task scope -> mark as `blocked`
   - If the test framework itself has issues -> mark as `blocked`
   - Document exactly what fails and why in the assignment file

## Lint / Style (if applicable)

If the project uses linting tools (RuboCop, ESLint, etc.), run them:
```bash
bundle exec rubocop --autocorrect
```

## Transition

Once all tests pass -> proceed to `/dev-complete`
