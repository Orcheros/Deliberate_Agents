# Language

Canonical vocabulary for the Deliberate Agents framework. All agents, skills, and documentation should use these terms consistently. When you encounter an "Avoid" synonym in conversation, translate it to the canonical term.

---

### Initiative

A scoped unit of work that moves through the pipeline from intake to deployment. Each initiative has a slug (e.g., `15a-template-growth-engine`), a lifecycle bucket, and a queue YAML.

Avoid: "project" (too broad), "task" (too granular), "feature" (implies code only), "ticket" (implies issue tracker).

### One-pager

The structured brief produced during intake (`/pm-intake`) that captures problem, solution, target user, scope, and feasibility. Lives at `{initiatives_path}/{bucket}/{slug}/{slug}-one-pager.md`.

Avoid: "spec" (implies detail level of a PRD), "brief" (ambiguous with design brief), "proposal" (implies optional).

### PRD

The detailed product requirements document produced during grooming (`/pm-expand-prd`). Expands the one-pager into functional requirements, acceptance criteria, and cross-functional concerns.

Avoid: "spec" (too generic), "requirements doc" (implies waterfall).

### Design study

The UX/UI specification produced by the product-designer agent. Covers user flows, component specs, copy, states, accessibility, and responsive behavior.

Avoid: "design brief" (implies brevity), "design doc" (ambiguous with architecture doc), "mockup" (implies visual artifacts).

### Lifecycle bucket

The directory stage an initiative occupies: `backlog/`, `needs-prd/`, `in-dev/`, `shipped/`, etc. The bucket determines which agent workflow applies.

Avoid: "phase" (overloaded), "status" (refers to the queue YAML field, not the directory), "stage" (vague).

### Queue YAML

The state file at `.deliberate/queue/{slug}.yaml` tracking an initiative's status, source artifacts, agent instructions, and sequencing. The orchestrator reads this to decide what to dispatch.

Avoid: "state file" (too generic), "config" (implies settings, not state), "manifest" (implies a list of contents).

### Dispatch

Launching an agent via `launch-agent.sh` into a tmux pane to perform a specific task. The orchestrator dispatches; the integrator directs what to dispatch.

Avoid: "spawn" (implies forking), "start" (too vague), "kick off" (informal).

### Escalation

A message from an agent to the Integrator or Visionary requesting a decision that the agent cannot make autonomously. Written to `.deliberate/comms/_system/inbox/{recipient}/`.

Avoid: "alert" (implies urgency only), "notification" (implies informational), "flag" (too vague).

### Artifact

A file produced by an agent as the primary output of its work: a PRD, architecture doc, design study, code commit, test plan, etc. The artifact verification system checks that artifact-producing roles actually create or modify files.

Avoid: "output" (too generic), "deliverable" (implies handoff), "document" (not all artifacts are docs).

### Coordination window

The tmux window holding Integrator (top pane) + Orchestrator (bottom pane). Created by `/deliberate`. The user attaches to this window to interact with the Integrator directly.

Avoid: "main window" (ambiguous), "control window" (implies a dashboard).

### Visionary

The human founder/operator who decides what gets built. The Visionary's Claude Code session is the entry point; it launches the coordination window but is not the Integrator.

Avoid: "user" (too generic in AI contexts), "founder" (not always a founder), "operator" (too operational).

### Integrator

The AI agent (top pane of coordination window) that validates ideas, prioritizes the pipeline, and tracks initiatives to completion. The Visionary's primary conversation partner.

Avoid: "facilitator" (implies meetings), "coordinator" (too close to Orchestrator).

### Orchestrator

The AI agent (bottom pane of coordination window) that dispatches specialist agents, manages handoffs between pipeline stages, and escalates blockers. Operates more autonomously than the Integrator.

Avoid: "scheduler" (implies time-based), "dispatcher" (only one aspect of the role), "project manager" (implies human role).

### Worktree

A git worktree where agent work happens, isolated from the main branch. Configured in the project config as `worktrees:`. The `.deliberate/` directory lives at the worktree root.

Avoid: "branch" (a worktree contains branches), "workspace" (too vague), "sandbox" (implies throwaway).

### Persona

The `.md` file in `agents/{team}/{role}.md` defining an agent's identity, responsibilities, workflow, and constraints. Passed to Claude via `--agent {role}`.

Avoid: "role file" (too generic), "agent config" (implies YAML), "profile" (implies user-facing).

### Skill

A reusable workflow definition in `skills/{name}/SKILL.md`, invoked as `/{name}`. Skills are the building blocks agents execute. A skill directory may also contain companion docs (templates, checklists, pattern references).

Avoid: "command" (implies CLI), "script" (implies bash), "recipe" (informal).
