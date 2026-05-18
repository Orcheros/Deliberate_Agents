# Daily Use

How to use Deliberate Agents day-to-day once your project is set up.

If you haven't set up a project yet, start with the [Getting Started](GETTING-STARTED.md) guide or the quickstart in the main [README](../README.md).

---

## Starting Your Day

1. Open Claude Code in your project directory
2. Type `/orchestrate`
3. Read the briefing — it shows running agents, the initiative queue, and items needing your attention
4. Decide what to work on

The command center stays alive after the briefing. It's waiting for your next instruction.

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

Ask the command center at any time:

| Say this | What you get |
|----------|-------------|
| "what's running?" | Quick view of active agents and what they're working on |
| "is the PM done?" | Status of a specific agent |
| "status" | Full briefing — same as what you see when you first open the command center |

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

| Say this | What happens |
|----------|-------------|
| "intake this bug about X" | Dispatches a PM agent to process the intake |
| "start dev on story 2e" | Dispatches a developer agent for that story |
| "run QA on the payments branch" | Dispatches QA agents to test the branch |
| "what's running?" | Shows active agent status |
| "what did we do today?" | Produces a daily summary from the journal |
| "menu" | Returns to the workflow selection menu |
| "status" | Full project briefing |
| "done for today" | Final status refresh and closing summary |

---

## Tips

- **Batch intake.** Dispatch multiple items in sequence without leaving the command center. It remembers context between dispatches.
- **Stay in the loop.** The command center never exits until you say so. It's designed for long sessions.
- **Context carries over.** The command center knows your project context — which initiatives are active, which agents are running, what was dispatched earlier today.
- **Ad-hoc tasks count.** Even small, one-off tasks get journaled. Nothing is lost.
- **Two modes, one system.** The autonomous `orchestrate.sh` script and the interactive `/orchestrate` command center share the same queue and state. You can use both — the script handles routine pipeline work while you use the command center for ad-hoc dispatches and oversight.

---

## Related Docs

- [README](../README.md) — Overview and quickstart
- [ARCHITECTURE.md](ARCHITECTURE.md) — How the system is designed
- [GETTING-STARTED.md](GETTING-STARTED.md) — Extended setup walkthrough
- [CUSTOMIZATION.md](CUSTOMIZATION.md) — Making it work with your stack
