# Common Bug Patterns

Reference for Phase 1 (Root Cause Investigation). When symptoms match a pattern, start with that pattern's investigation strategy — it saves the binary-search step.

---

## Race Condition

**Symptoms**: Intermittent failures. Works most of the time. Fails under load or in CI but not locally. Different results on consecutive runs with identical input.

**Typical root cause**: Two operations assume sequential execution but run concurrently. Shared mutable state accessed without synchronization.

**Investigation strategy**:
1. Check for shared state: database rows, files, in-memory caches, global variables
2. Look for time-dependent ordering: `sleep`, `after_commit`, background jobs, Turbo Streams
3. Add timestamps to log each operation's start/end — look for overlapping windows
4. Try to increase concurrency to make the failure more frequent

---

## State Management Bug

**Symptoms**: Works on first try, fails on second. "Stale" data appears after updates. UI shows old values after a form submission. Works after a page refresh.

**Typical root cause**: Cached state not invalidated. Optimistic update diverged from server state. Event listener registered multiple times.

**Investigation strategy**:
1. Identify all places the affected state is read AND written
2. Check cache invalidation: is every write path covered?
3. For frontend: check Stimulus controller `connect`/`disconnect` lifecycle
4. For backend: check `after_commit` vs `after_save` timing

---

## Nil/Null Reference Chain

**Symptoms**: `NoMethodError: undefined method for nil:NilClass` (Ruby), `TypeError: Cannot read properties of undefined` (JS). Consistent failure but only on certain records.

**Typical root cause**: An association or lookup returns nil for a subset of records. Code assumes the association always exists.

**Investigation strategy**:
1. Trace the nil back: which variable is nil? What was supposed to populate it?
2. Check the database: does the expected association/record exist for the failing case?
3. Look for optional associations treated as required (`belongs_to` without validation)
4. Check for N+1 queries where eager loading missed a path

---

## Off-by-One / Boundary Condition

**Symptoms**: Pagination shows wrong count. Last item in a list behaves differently. Edge values (0, 1, max) produce unexpected results. Fencepost errors in loops.

**Typical root cause**: Inclusive vs. exclusive range confusion. Zero-based vs. one-based indexing mismatch. Boundary not tested.

**Investigation strategy**:
1. Identify the boundary: what are the minimum, maximum, and edge values?
2. Test each boundary explicitly: 0, 1, N-1, N, N+1
3. Check `<` vs `<=`, `.first(n)` vs `.limit(n)`, `..` vs `...` (Ruby ranges)
4. Look for `count` vs `length` vs `size` semantics differences

---

## Environment Divergence

**Symptoms**: Works locally, fails in CI. Works in development, fails in staging/production. Works on one developer's machine, fails on another's.

**Typical root cause**: Missing environment variable. Different dependency version. Database schema drift. File path assumption (macOS case-insensitive, Linux case-sensitive).

**Investigation strategy**:
1. Compare environments: `ruby -v`, `node -v`, `bundle list`, env vars
2. Check for hardcoded paths, hostnames, or ports
3. Look for seed data or fixture assumptions
4. Check `Gemfile.lock` / `package-lock.json` — is it committed and up to date?
5. For case-sensitivity: `git config core.ignorecase` differs across platforms

---

## Silent Failure / Swallowed Exception

**Symptoms**: Operation appears to succeed but has no effect. No error in logs. Data not saved. Callback not triggered.

**Typical root cause**: Empty `rescue` block. `save` instead of `save!`. Conditional logic skips the operation silently. Transaction rolled back without error.

**Investigation strategy**:
1. Search for `rescue` blocks near the failure — are they swallowing exceptions?
2. Check `save` vs `save!`, `update` vs `update!` — non-bang versions return false silently
3. Add logging at every branch in the operation's code path
4. Check `ActiveRecord::Base.transaction` — a rollback inside doesn't raise by default
