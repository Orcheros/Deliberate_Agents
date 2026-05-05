---
name: api-design-review
description: Review API endpoints for REST conventions, consistency, security, and developer experience
allowed-tools: Bash, Read, Glob, Grep
---

# API Design Review

## Objective

Audit API endpoints (controllers, routes, serializers) for REST convention adherence, consistency across the codebase, security posture, and developer experience. Produce a findings report with severity-graded issues.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - Which controllers or API areas to review
   - Any specific concerns flagged by the PRD or architect

2. **Collect the API surface**:
   - Read `config/routes.rb` for all API routes (namespaced under `/api/` or versioned)
   - Identify all API controllers (`app/controllers/api/`)
   - Read serializers/jbuilder templates (`app/views/api/`, `app/serializers/`)
   - Check for API documentation (`app/views/api/**/*.json.jbuilder`, OpenAPI specs if present)

3. **Review REST conventions**:

   | Check | Convention | Anti-pattern |
   |-------|-----------|-------------|
   | Resource naming | Plural nouns (`/users`, `/projects`) | Verbs in URLs (`/getUsers`, `/createProject`) |
   | HTTP methods | GET=read, POST=create, PATCH=update, DELETE=destroy | POST for everything |
   | Nesting depth | Max 2 levels (`/users/:id/projects`) | 3+ levels (`/users/:id/projects/:id/tasks/:id/comments`) |
   | ID format | Consistent type (UUID or integer) across all endpoints | Mixed ID formats |
   | Collection endpoints | Return arrays with pagination metadata | Unbounded arrays |
   | Status codes | 200 OK, 201 Created, 204 No Content, 4xx client, 5xx server | 200 for everything |
   | Error format | Consistent error envelope (`{ error: { message:, code:, details: } }`) | Inconsistent error shapes |

4. **Review consistency across endpoints**:
   - Pagination: same parameters (`page`, `per_page` or cursor-based) everywhere
   - Filtering: consistent query param naming (`?status=active` vs `?filter[status]=active`)
   - Sorting: consistent parameter (`?sort=created_at` or `?sort=-created_at` for desc)
   - Response envelope: same top-level structure across all endpoints
   - Timestamps: consistent format (ISO 8601) and timezone (UTC)
   - Null handling: consistent presence/absence of null fields

5. **Review security posture**:
   - Authentication: all endpoints require auth (or explicitly document why not)
   - Authorization: proper `before_action` callbacks or policy checks on every action
   - Rate limiting: present on public or high-cost endpoints
   - Input validation: strong params enforced, no mass-assignment vulnerabilities
   - Sensitive data: no passwords, tokens, or secrets in responses
   - CORS: configured appropriately for the API's consumers

6. **Review developer experience**:
   - Versioning strategy: present and consistent (`/api/v1/` prefix or header-based)
   - Error messages: actionable (tell the caller what to fix, not just what's wrong)
   - Empty states: collections return `[]` not null or error
   - Partial updates: PATCH accepts partial payloads without requiring all fields
   - Idempotency: unsafe operations (POST, DELETE) are idempotent or have idempotency keys

7. **Grade each finding**:
   - **Critical**: Security vulnerability, data leak, or broken contract
   - **Major**: Convention violation that will cause integration bugs or confusion
   - **Minor**: Inconsistency that reduces developer experience
   - **Suggestion**: Improvement that would make the API more ergonomic

## Output

Write findings to `.deliberate/reports/{slug}/api-design-review.md`:

```markdown
# API Design Review: {Initiative or Area Name}

## Summary
- Endpoints reviewed: {count}
- Findings: {critical} critical, {major} major, {minor} minor, {suggestion} suggestions

## Findings

### [CRITICAL] {Title}
**Endpoint**: `{METHOD} {path}`
**File**: `{file_path}:{line}`
**Issue**: {description}
**Fix**: {what to change}

### [MAJOR] {Title}
...

## Consistency Matrix
| Pattern | Current State | Recommendation |
|---------|--------------|----------------|
| Pagination | {describe} | {recommend} |
| Error format | {describe} | {recommend} |
| Auth | {describe} | {recommend} |

## Recommendations
1. {Prioritized list of changes}
```
