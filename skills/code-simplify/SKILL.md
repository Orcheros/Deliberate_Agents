---
name: code-simplify
description: Simplify and refine recently modified code for clarity, consistency, and maintainability while preserving functionality
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Code Simplification

## Objective

Review recently modified code and simplify it for clarity, consistency, and maintainability — without changing behavior. This is a refinement pass, not a rewrite.

## Instructions

1. **Identify scope** — Focus on recently modified files. Check `git diff --name-only HEAD~3` or read the assignment for specific files.

2. **Analyze each file** for simplification opportunities:

   **Complexity reduction:**
   - Extract deeply nested conditionals into early returns or guard clauses
   - Replace complex conditional chains with lookup hashes or case statements
   - Break long methods into focused helpers (only if the extraction clarifies intent)

   **Redundancy elimination:**
   - Remove dead code, unused variables, unreachable branches
   - Consolidate duplicate logic (but only if 3+ instances — two is not yet a pattern)
   - Remove unnecessary intermediate variables that don't add clarity

   **Naming improvement:**
   - Rename variables/methods whose names don't match their behavior
   - Replace generic names (`data`, `result`, `temp`, `item`) with domain-specific ones
   - Match project naming conventions (check surrounding code)

   **Rails-specific patterns:**
   - Replace manual loops with ActiveRecord scopes or query methods
   - Use `presence`, `blank?`, `present?` instead of nil/empty checks
   - Use `find_by` instead of `where(...).first`
   - Replace `if x.nil?` with `unless x` where clearer

3. **Preserve functionality** — Every simplification must be behavior-preserving:
   - Run tests before AND after each change
   - If you're not 100% certain a change preserves behavior, don't make it
   - Never change public API signatures

4. **Match project standards** — Read surrounding code to understand local conventions:
   - Indentation, string quoting style, method definition patterns
   - Test style (Minitest assertions, fixture usage, test naming)
   - Controller/model/service patterns already established

5. **Don't over-simplify** — Some complexity is essential:
   - Don't inline a well-named helper just because it's only called once
   - Don't remove error handling that protects against real edge cases
   - Don't abstract prematurely — concrete code that's clear beats a clever abstraction

## Quality Checks

- [ ] All tests pass after simplification
- [ ] No behavior changes (same inputs produce same outputs)
- [ ] Changes match existing project conventions
- [ ] Each simplification makes the code genuinely clearer (not just shorter)
- [ ] No new abstractions unless they eliminate 3+ instances of duplication

## Output

Commit simplified code with a message like:
```
[initiative-slug] Simplify {area} for clarity

- {specific change and why it's clearer}
```
