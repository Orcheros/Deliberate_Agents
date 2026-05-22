# Handoff: Scrum Master → Developer

## Trigger

Stories decomposed, dependencies mapped, initiative status is `PRD_COMPLETE`. Project Manager creates assignments.

## Sender's Obligations ("Done for us")

- [ ] Assignment file exists at `.deliberate/assignments/{worktree}.md`
- [ ] Assignment contains: task description, acceptance criteria, boundary, pattern reference
- [ ] `read_before_starting` file list is ordered by importance
- [ ] `anti_patterns` list reflects real codebase pitfalls
- [ ] Test strategy defined: test file path, model-after file, fixtures
- [ ] Dependencies between tasks are tracked and respected
- [ ] Worktree created and checked out to correct branch

## Receiver's Expectations ("Ready for them")

- [ ] Pattern reference file actually exists at the specified path
- [ ] All `read_before_starting` files exist
- [ ] Model-after test file exists
- [ ] Worktree is clean and on the correct branch
- [ ] No unresolved blockers from upstream tasks

## Timebox

Development per task: 1 agent session. Multiple tasks may run in parallel across worktrees (up to `max_concurrent_developers`).

## Mechanics

1. Project Manager creates assignment YAML with `agent_type` and task details
2. Orchestrator detects assignment, launches developer agent in worktree
3. Developer runs: `/dev-understand` → `/dev-implement` → `/dev-test` → `/dev-complete`
4. On completion: assignment status set to `complete`, agent status set to `idle`
5. Orchestrator detects completion, checks for next assignment or advances initiative
