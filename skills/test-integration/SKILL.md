---
name: test-integration
description: Execute integration tests, write new tests for gaps, validate data flows
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Step 2: Execute Integration Tests

## Objective

Execute each assigned test case. Run existing test suites, identify coverage gaps, write new tests, and validate data integrity across systems.

## Instructions

### For Each Test Case

1. **Run existing tests first**:
   - Identify existing tests in `test/` that cover the area
   - Run them: `bin/rails test test/path/to/relevant_test.rb`
   - Note pass/fail and whether they actually test what the case requires

2. **Validate data integrity**:
   - For cases involving record creation: verify correct attributes, associations, constraints
   - For cases involving updates: verify only intended fields changed
   - For cases involving deletion: verify cascade behavior, no orphans
   - Use Rails console or test assertions to check database state

3. **Test API contracts**:
   - Verify request format (params, headers, auth)
   - Verify response format (status code, body shape, error format)
   - Test auth requirements (unauthenticated, wrong role, correct role)
   - Test validation errors (missing required fields, invalid values)

4. **Test background jobs**:
   - Verify jobs are enqueued at the right trigger point
   - Verify job execution produces correct results
   - Test job failure handling (retry, dead letter)
   - Verify idempotency (running the same job twice doesn't duplicate)

5. **Test external integrations**:
   - Verify service wrapper handles success responses correctly
   - Verify service wrapper handles error responses (4xx, 5xx, timeout)
   - Verify webhook handlers parse payloads correctly
   - Verify webhook handlers are idempotent

6. **Test data flows end-to-end**:
   - Trace multi-step operations from trigger to final state
   - Verify intermediate states are correct
   - Verify the final state matches expectations across all systems

### Writing New Tests

When coverage gaps are found:
- Create test files following project conventions (`test/integration/`, `test/controllers/`, etc.)
- Use existing fixtures and test helpers — don't reinvent setup
- Test both happy path and failure paths
- Assert on database state, not just HTTP responses
- Include meaningful test names that describe the behavior being verified

```ruby
# Follow project conventions
class FeatureNameIntegrationTest < ActionDispatch::IntegrationTest
  # Setup using existing fixtures
  setup do
    @user = users(:confirmed_user)
    sign_in @user
  end

  test "creates record with correct attributes when valid params" do
    assert_difference("Model.count", 1) do
      post path, params: { model: valid_params }
    end
    assert_response :redirect
    
    record = Model.last
    assert_equal expected_value, record.attribute
    assert_equal @user, record.user
  end

  test "returns validation errors when invalid params" do
    assert_no_difference("Model.count") do
      post path, params: { model: invalid_params }
    end
    assert_response :unprocessable_entity
  end
end
```

### Recording Results

For each test case, record:
```yaml
test_case_id: "TC-XXX"
status: "pass|fail|blocked"
evidence:
  type: "test_output|manual_verification|database_check"
  detail: "What was observed"
  command: "bin/rails test test/path/to/test.rb"
  output: "Relevant output (truncated if long)"
  new_test_written: true|false
  test_file: "test/path/to/new_test.rb (if written)"
notes: "Additional context"
executed_at: "ISO timestamp"
```

## Transition

When all assigned cases are executed -> proceed to `/test-report`
