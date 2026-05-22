# /deliberate — Launch the Two-Window Architecture

Boot the Integrator + Orchestrator two-window setup. This is the primary way to start a Deliberate Agents session with full coordination.

---

## Step 1: Resolve Framework and Project

1. Set `DA_HOME` from `$DELIBERATE_AGENTS_HOME` (default: `$HOME/Development/Deliberate_Agents`).
2. Use Glob to find `$DA_HOME/config.*.yaml` files. Exclude `config.example.yaml`.
3. If exactly one config: use it. If multiple: use `AskUserQuestion` to ask which project.
4. If no config found: tell the user to run `$DA_HOME/scripts/init.sh` first and stop.
5. Read the chosen config. Extract: `name`, `worktrees`, `tmux_session` (default: `deliberate`), `slack_enabled`.

Set these variables for use in subsequent steps:
- `CONFIG_PATH` — full path to the config file
- `PROJECT_NAME` — from the `name:` field
- `WORKTREES` — from the `worktrees:` field
- `DELIBERATE_DIR` — `{WORKTREES}/.deliberate`
- `TMUX_SESSION` — from `tmux_session:` or default `deliberate`

## Step 2: Check Current State

Run these checks (use Bash where needed, Glob/Read where possible):

1. **Orchestrator running?** — Check if a tmux window matching `orchestrat` exists in the session:
   ```bash
   tmux list-windows -t "$TMUX_SESSION" 2>/dev/null | grep -qi "orchestrat"
   ```

2. **Any agents running?** — Use Glob to check `$DELIBERATE_DIR/pids/*.pid`. For each, `kill -0 <pid>` to verify alive.

3. **Pending escalations?** — Use Glob to check `$DELIBERATE_DIR/comms/_system/inbox/integrator/*.md`. Count and read subjects if any exist.

4. **Dashboard available?** — Check if `$DELIBERATE_DIR/status/dashboard.md` exists.

## Step 3: Present Status and Act

Present a brief status to the user:

```
Project: {PROJECT_NAME}
Orchestrator: {RUNNING | NOT RUNNING}
Active agents: {count}
Escalations: {count or "none"}
```

### If Orchestrator is NOT running:

Tell the user you're launching the Orchestrator, then run:

```bash
$DA_HOME/orchestration/launch-agent.sh \
  --session "$TMUX_SESSION" \
  --name orchestrator \
  --role orchestrator \
  --config "$CONFIG_PATH" \
  --framework-dir "$DA_HOME"
```

Confirm it launched:
```bash
sleep 2 && tmux list-windows -t "$TMUX_SESSION" 2>/dev/null | grep -i "orchestrat"
```

Report success: "Orchestrator is now running in tmux session '{TMUX_SESSION}'. You can see it with `tmux attach -t {TMUX_SESSION}`."

### If Orchestrator IS already running:

Report: "Orchestrator is already running in tmux session '{TMUX_SESSION}'."

## Step 4: Show Escalations (if any)

If there are pending escalation files in `$DELIBERATE_DIR/comms/_system/inbox/integrator/`:

1. Read each file
2. Present them to the user with urgency level and subject
3. Ask if the user wants to address any now

If no escalations, skip this step.

## Step 5: Show Dashboard (if available)

If `$DELIBERATE_DIR/status/dashboard.md` exists, read it and present a condensed summary:
- Active agents and what they're working on
- Pipeline overview (stages with counts)
- Items needing attention

If no dashboard exists yet, note that the Orchestrator will generate one on its first cycle.

## Step 6: Ready State

Tell the user:

> Two-window architecture is live. You're the Integrator — share ideas, ask for status, dispatch work. The Orchestrator is coordinating in tmux below.

Then present options via `AskUserQuestion`:

| Option | Label | Description |
|--------|-------|-------------|
| 1 | Share an idea | Capture a new idea for evaluation and potential queueing |
| 2 | Check full status | Read board state and show pipeline details |
| 3 | Send directive to Orchestrator | Write a directive message for the Orchestrator to act on |
| 4 | Open command center | Switch to the full `/orchestrate` dispatch interface |

### If "Share an idea":

Ask the user to describe their idea. Then:
1. Write it to `$DELIBERATE_DIR/intake/{timestamp}-{slug}.md` with a simple format:
   ```markdown
   # {title}
   **Captured**: {ISO timestamp}
   **Source**: Integrator session

   {user's description}
   ```
2. Confirm capture and suggest next steps (evaluate against board state, or queue directly if clear-cut).

### If "Check full status":

Read these state files and present a comprehensive view:
- `$DELIBERATE_DIR/priority-stack.yaml` — current priorities
- `$DELIBERATE_DIR/queue/*.yaml` — initiative statuses
- `$DELIBERATE_DIR/status/dashboard.md` — if available
- `$DELIBERATE_DIR/comms/_system/inbox/integrator/*.md` — pending messages

### If "Send directive to Orchestrator":

Ask what the user wants the Orchestrator to do. Then write a directive:
```bash
TIMESTAMP=$(date -u '+%Y%m%d-%H%M%S')
```

Write to `$DELIBERATE_DIR/comms/_system/inbox/orchestrator/${TIMESTAMP}-directive.md`:
```markdown
# directive: {subject}
- **From**: integrator
- **To**: orchestrator
- **At**: {ISO timestamp}
- **Type**: directive
- **Urgency**: info
- **Status**: unread

{user's instruction}
```

Confirm: "Directive sent. The Orchestrator will pick it up on its next cycle."

### If "Open command center":

Tell the user to type `/orchestrate` to enter the full dispatch interface.

---

## After any action in Step 6, return to Step 6's ready state.

This is a persistent session. Stay in the loop until the user says "done" or closes the session.
