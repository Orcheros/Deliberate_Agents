# CLAUDE.md

## Identity
- Repo: **Deliberate Agents** (`github.com/Orcheros/Deliberate_Agents`)
- Multi-agent orchestration system for the **Henry** product (`OkHenry.ai`)
- Target repo for all agent work: `~/Development/Deuterophos` (OkHenry) and its worktrees

## Branching Discipline

**Staging is protected in the target repo (Deuterophos).** Direct code changes to `staging` are forbidden.

- **Hotfixes:** Must be done on a `hotfix/*` branch off staging. Never commit code fixes directly to staging.
- **Product documentation/spec** (backlog one-pagers, STATUS.yaml, ROADMAP.md updates): Allowed directly on staging — these are short, low-risk, and don't affect runtime behavior.
- **Feature work:** Always on worktrees (`~/Development/Deuterophos-worktrees/{slug}/`).

If the current branch is `staging` and the task involves changing any `.rb`, `.erb`, `.js`, `.css`, or test file, **stop and create a `hotfix/<description>` branch first.** No exceptions.

This rule applies to both this repo and the target Deuterophos repo. Agents spawned by this system must follow it.
