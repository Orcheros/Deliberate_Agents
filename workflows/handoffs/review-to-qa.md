# Handoff: Reviewer → QA Lead

## Trigger

Review validation passed. Initiative status is `REVIEW_READY` or routed directly to QA after `DEV_COMPLETE`.

## Sender's Obligations ("Done for us")

- [ ] Review summary exists at `.deliberate/queue/{initiative}/review-summary.md`
- [ ] Validation checklist in queue YAML shows all criteria met
- [ ] Files changed list is complete and organized by type
- [ ] How-to-test instructions are actionable (not vague)
- [ ] Worktrees-to-merge list and merge order documented

## Receiver's Expectations ("Ready for them")

- [ ] All specification artifacts accessible (PRD, arch doc, design brief, stories)
- [ ] Initiative branch has all developer commits
- [ ] Code diff is available (`git diff staging...HEAD`)
- [ ] Test suite passes (confirmed by reviewer)
- [ ] No unresolved issues from review validation

## Timebox

QA planning: 1 agent session for test plan creation. QA execution: varies by test case count.

## Mechanics

1. QA Lead agent launched after review completion
2. QA Lead runs: `/qa-plan` → `/qa-assign` → `/qa-coordinate`
3. QA agents execute test cases across categories
4. Results aggregated in `.deliberate/qa/{slug}/`
5. QA report written via `/qa-report`
6. If all critical/high tests pass: initiative advances
7. If failures found: initiative set to `BLOCKED` with regression tasks
