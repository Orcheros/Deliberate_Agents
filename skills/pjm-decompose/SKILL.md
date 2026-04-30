---
name: pjm-decompose
description: Break a PRD into multi-agent work streams with correct agent routing
allowed-tools: Read, Glob, Grep
---

# Step 1: Decompose PRD into Work Streams

## Objective

Read the PRD and cross-functional impact assessment. Break the initiative into work streams, each routed to the correct agent type. This is the critical step where a complex initiative gets turned into an executable plan across the full agent roster.

## Instructions

### 1. Read the PRD Thoroughly
- Functional requirements -> Developer tasks
- Integration requirements -> Integrations Engineer tasks
- Communication map -> Content Writer tasks
- Legal/compliance sections -> Compliance Analyst tasks
- Documentation needs -> Technical Writer tasks
- Infrastructure/deployment -> DevOps Engineer tasks
- Security considerations -> Security Analyst tasks
- Sales/GTM impact -> Sales agent tasks
- Customer success impact -> CS agent tasks
- Onboarding changes -> Onboarding Specialist tasks

### 2. Read the Cross-Functional Impact Assessment
The PM's `/pm-cross-functional` output identifies work by agent type. Use this as your starting point.

### 3. Create Work Streams

For each agent type that has work:

#### Work Stream: {Agent Type}
- **Tasks**: Ordered list of atomic tasks
- **Dependencies**: What must complete before this work stream starts
- **Dependencies within**: Ordering of tasks within the stream
- **Cross-stream dependencies**: What other streams depend on or feed into this one
- **Estimated task count**: Number of assignments
- **Priority**: Launch-blocking / should-do-before-launch / can-follow-up

### 4. Dependency Graph

Map the dependency order across streams:
```
Phase 1: Developer (data model, migrations) + DevOps (env vars, credentials)
Phase 2: Developer (services, controllers) + Integrations (SaaS config)
Phase 3: Content (email copy) + Security (review) [parallel]
Phase 4: Technical Writer (runbooks) + Compliance (policy updates)
Phase 5: Review (full validation)
```

### 5. Task Sizing

Each task must be:
- **Atomic**: One agent, one worktree (for dev), one concern
- **Completable in one session**: Don't create tasks that require context from a previous session
- **Testable**: Has clear acceptance criteria that the agent can verify
- **Bounded**: Touches at most ~10 files (for dev tasks)

Large tasks should be split. Adjacent tasks should be grouped if they're too small.

### 6. Phasing

Group tasks into phases that can be deployed independently:
- Phase A (launch-blocking) -> Phase B (full functionality) -> Phase C (optimization)
- Each phase should be independently deployable

## Output

A decomposition plan documented in the initiative state file. This feeds `/pjm-assign`.

## Transition

Once decomposition is complete -> proceed to `/pjm-assign`
