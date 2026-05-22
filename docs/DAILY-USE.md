# Daily Use

How to use Deliberate Agents day-to-day once your project is set up.

If you haven't set up a project yet, start with the [Getting Started](GETTING-STARTED.md) guide or the quickstart in the main [README](../README.md).

---

## Starting Your Day

1. **Open Claude Code** — you're immediately talking to the **Integrator**, your strategic right-hand agent. The session-start hook gives you a briefing: project status, Orchestrator state, and any pending escalations from overnight work.

2. **Check escalations first** — if the Orchestrator sent critical or warning messages (agent crash, stalled initiative, gate failure), they appear at the top of your briefing. Read and address them.

3. **Launch the Orchestrator** (if not running) — the briefing shows the launch command. It runs in a tmux window below your session, coordinating agents and tracking handoffs.

4. **Start working** — share ideas, ask for status, dispatch work. The Integrator captures everything to `.deliberate/` and routes directives to the Orchestrator.

You now have the **coordination window** with two panes, both visible:
- **Top pane** (Integrator) — where you think, decide, and direct
- **Bottom pane** (Orchestrator) — coordinating agents, writing the dashboard, escalating blockers

When initiative work starts, each initiative gets its own window with agent panes inside it.

> **Tip**: For ad-hoc dispatch without leaving your session, type `/orchestrate` for the interactive command center.

---

## Dispatching Work

### Through the menu

Type "menu" to get a guided workflow picker organized by function:

- **Product** — intake ideas, write PRDs, run discovery
- **Engineering** — start dev on a story, run tests, deploy
- **Growth** — content creation, SEO, outreach
- **Operations** — compliance, support triage, metrics

Pick a category, then pick a specific workflow. The command center launches the right agent and confirms.

### Direct dispatch (faster)

Skip the menu — tell the command center what you want in plain language:

- "intake a bug about login failing on Safari"
- "start dev on story 3a for the auth initiative"
- "run QA on the payments branch"
- "write a LinkedIn post about the new feature"

The command center figures out the right agent and dispatches it.

### What happens when you dispatch

1. An agent launches in a dedicated tmux window
2. A journal entry is recorded with timestamp, agent role, and status
3. You get a short confirmation
4. The command center waits for your next instruction

You can dispatch multiple things in sequence without leaving the command center.

---

## Checking Status

Ask the Integrator (your Claude Code session) at any time:

| Say this | What you get |
|----------|-------------|
| "what's running?" | Quick view of active agents and what they're working on |
| "is the PM done?" | Status of a specific agent |
| "status" | Full board state — pipeline, active agents, blockers |

The Orchestrator also writes a **dashboard** to `.deliberate/status/dashboard.md` after each cycle — a structured markdown view with tables for active agents, pipeline stages, items needing attention, and recent transitions.

You can also type directly to the Orchestrator in its tmux window — ask it "status" and it responds with the current state.

---

## Daily Summary

Ask "what did we do today?" to get a summary pulled from the dispatch journal:

- Count of dispatches — completed, running, and failed
- Outcomes and artifacts from completed work
- In-progress items still running

This works at any point during the day, not just at the end.

---

## The Dispatch Journal

Every dispatch is recorded in `.deliberate/logs/dispatch-journal-YYYYMMDD.md` — one file per day. Entries track status through: **dispatched → running → complete** (or **failed**).

The journal is plain markdown. You can read it directly, share it, or use it for standups.

Example entry:

```markdown
## 09:42 — PM Agent → intake "login failing on Safari"
- **Status:** complete
- **Outcome:** Created initiative `safari-login-fix` in queue
- **Artifacts:** .deliberate/queue/safari-login-fix.yaml
```

---

## Command Quick Reference

### In your Claude Code session (Integrator)

| Say this | What happens |
|----------|-------------|
| "I have an idea about X" | Integrator captures to `intake/`, evaluates against in-flight work |
| "prioritize X over Y" | Updates `priority-stack.yaml` and notifies Orchestrator |
| "what's the status?" | Reads board state from `.deliberate/` and the dashboard |
| "what did we do today?" | Produces a daily summary from the journal |
| "tell the Orchestrator to start dev on auth" | Writes a directive to `comms/_system/inbox/orchestrator/` |

### In the Orchestrator tmux window

| Say this | What happens |
|----------|-------------|
| "status" | Shows current dashboard — pipeline, active agents, blockers |
| "unblock X" | Reads the blocker, resolves it, updates state |
| "launch PM for auth" | Manually launches a specific agent for an initiative |
| "what's wrong?" | Diagnoses issues — crashed agents, stalled initiatives, gate failures |

### In the command center (`/orchestrate`)

| Say this | What happens |
|----------|-------------|
| "intake this bug about X" | Dispatches a PM agent to process the intake |
| "start dev on story 2e" | Dispatches a developer agent for that story |
| "run QA on the payments branch" | Dispatches QA agents to test the branch |
| "menu" | Returns to the workflow selection menu |

---

## Tips

- **Nothing is lost.** Every idea you share with the Integrator is captured — to `intake/`, `decisions/strategic/`, `priority-stack.yaml`, or `comms/`. Conversations become documentation.
- **Escalations surface automatically.** If the Orchestrator hits a problem overnight, you'll see it in your next session briefing — no need to check manually.
- **Both panes are interactive.** You can type to the Orchestrator directly in its pane to unblock it, ask for status, or give manual overrides — no switching needed.
- **The dashboard is always current.** Check `.deliberate/status/dashboard.md` for a structured view of everything in flight.
- **Three interfaces, one system.** The Integrator session, the Orchestrator tmux window, and the `/orchestrate` command center all share the same queue and state. Use whichever fits the moment.

---

## Related Docs

- [README](../README.md) — Overview and quickstart
- [ARCHITECTURE.md](ARCHITECTURE.md) — How the system is designed
- [GETTING-STARTED.md](GETTING-STARTED.md) — Extended setup walkthrough
- [CUSTOMIZATION.md](CUSTOMIZATION.md) — Making it work with your stack
