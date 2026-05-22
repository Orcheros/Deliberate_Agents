# Handoff: Developer → Reviewer

## Trigger

All developer tasks for the initiative are complete. Initiative status is `DEV_COMPLETE`.

## Sender's Obligations ("Done for us")

- [ ] All assignment files show status `complete`
- [ ] All tests pass (verified by dev-complete's fresh test run)
- [ ] Atomic commits with descriptive messages
- [ ] No debug output, temp files, or `.env` changes committed
- [ ] Each task's acceptance criteria verified against actual code
- [ ] Completion notes written in assignment files

## Receiver's Expectations ("Ready for them")

- [ ] PRD is accessible (reviewer needs acceptance criteria to validate against)
- [ ] All commits are on the initiative branch (not scattered across branches)
- [ ] Test suite passes cleanly (no pre-existing failures mixed in)
- [ ] No blocked or partially-complete tasks remain

## Timebox

Review validation: 1 agent session (typically 10-15 minutes).

## Mechanics

1. Orchestrator detects all tasks complete, sets initiative to `DEV_COMPLETE`
2. Reviewer agent launched with initiative slug
3. Reviewer runs: `/review-validate` → `/review-summarize`
4. If validation fails: initiative set to `BLOCKED`, corrective tasks created
5. If validation passes: review summary written, initiative set to `REVIEW_READY`
