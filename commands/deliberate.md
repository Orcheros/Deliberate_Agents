# /deliberate — Launch the Two-Window Architecture

Boot the Integrator + Orchestrator two-window setup. This is the primary way to start a Deliberate Agents session with full coordination.

---

## Step 1: Resolve Framework and Project

1. Set `DA_HOME` from `$DELIBERATE_AGENTS_HOME` (default: `$HOME/Development/Deliberate_Agents`).
2. Use Glob to find `$DA_HOME/config.*.yaml` files. Exclude `config.example.yaml`.
3. **Also check the current working directory**: if `$(pwd)/.deliberate.yaml` or `$(pwd)/.deliberate/config.yaml` exists, that's the active project's config (or its symlink in `$DA_HOME`). Match by the `repo:` field in found configs against `$(pwd)`.
4. If exactly one config matches (either by CWD match or only one exists): use it. If multiple and no CWD match: use `AskUserQuestion` to ask which project.
5. If no config found: tell the user to run `$DA_HOME/scripts/init.sh` first and stop.
6. Read the chosen config. Extract: `name`, `repo`, `worktrees`, `tmux_session` (default: `deliberate`), `slack_enabled`.

Set these variables for use in subsequent steps:
- `CONFIG_PATH` — full path to the config file
- `PROJECT_NAME` — from the `name:` field
- `REPO_DIR` — from the `repo:` field
- `WORKTREES` — from the `worktrees:` field
- `DELIBERATE_DIR` — `{WORKTREES}/.deliberate`
- `TMUX_SESSION` — from `tmux_session:` or default `deliberate`

## Step 2: First-Run Learning Pass (gated)

Check if the project has been learned:

1. Check if `$DELIBERATE_DIR/onboarding.md` exists.
2. If it exists: skip to Step 3.
3. If it does NOT exist: check if the repo has meaningful code (more than just a README or scaffold):
   ```bash
   find "$REPO_DIR" -name "*.rb" -o -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.go" -o -name "*.rs" -o -name "*.java" -o -name "*.swift" | head -5
   ```
4. If the repo has code, tell the user:

   > This is the first run against this project. I recommend a learning pass before we start — it takes 2-5 minutes and produces a structured brief that all agents will reference. Without it, agents will make decisions without understanding the existing codebase.

   Use `AskUserQuestion`:
   | Option | Label | Description |
   |--------|-------|-------------|
   | 1 | Run learning pass (Recommended) | Launch onboard.sh to explore the codebase and produce a brief |
   | 2 | Skip for now | Proceed without learning — agents will work with less context |

5. If the user chooses "Run learning pass":
   ```bash
   $DA_HOME/scripts/onboard.sh "$CONFIG_PATH" --skip-prompt
   ```
   This launches a Claude Code session that explores the repo and writes `.deliberate/onboarding.md`. It takes 2-5 minutes. Wait for it to complete.

   After completion, verify the file was created:
   ```bash
   test -f "$DELIBERATE_DIR/onboarding.md" && echo "Learning pass complete" || echo "Learning pass failed"
   ```

   If it succeeded, confirm: "Learning pass complete. All agents launched from now on will have this project knowledge injected into their context."

   If it failed, note the failure and continue — the user can run `$DA_HOME/scripts/onboard.sh $CONFIG_PATH` manually later.

6. If the repo is empty/scaffold (no source files found in step 3): skip silently — nothing to learn yet.

## Step 3: Check Current State

Run these checks (use Bash where needed, Glob/Read where possible):

1. **Coordination window running?** — Check if the tmux session and coordination window exist:
   ```bash
   tmux list-windows -t "$TMUX_SESSION" 2>/dev/null | grep -qi "coordination"
   ```

2. **Integrator running?** — Check if `$DELIBERATE_DIR/pids/integrator.pid` exists and `kill -0 <pid>` succeeds.

3. **Orchestrator running?** — Check if `$DELIBERATE_DIR/pids/orchestrator.pid` exists and `kill -0 <pid>` succeeds.

4. **Any other agents running?** — Use Glob to check `$DELIBERATE_DIR/pids/*.pid`. For each, `kill -0 <pid>` to verify alive.

5. **Pending escalations?** — Use Glob to check `$DELIBERATE_DIR/comms/_system/inbox/integrator/*.md`. Count and read subjects if any exist.

6. **Dashboard available?** — Check if `$DELIBERATE_DIR/status/dashboard.md` exists.

## Step 4: Launch Coordination Window

Present a brief status to the user:

```
Project: {PROJECT_NAME}
Integrator: {RUNNING | NOT RUNNING}
Orchestrator: {RUNNING | NOT RUNNING}
Other agents: {count}
Escalations: {count or "none"}
```

### If Integrator is NOT running:

Tell the user you're launching the Integrator, then run:

```bash
$DA_HOME/orchestration/launch-agent.sh \
  --session "$TMUX_SESSION" \
  --name integrator \
  --role integrator \
  --config "$CONFIG_PATH" \
  --framework-dir "$DA_HOME"
```

This creates the "coordination" window with the Integrator as the first pane.

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

This splits the "coordination" window and adds the Orchestrator as a second pane below the Integrator.

### After launching both (or confirming both are running):

Verify the coordination window has both panes:
```bash
sleep 2 && tmux list-panes -t "${TMUX_SESSION}:coordination" 2>/dev/null | wc -l
```

Then **auto-open** the coordination window in a new iTerm2 window so the user sees both agents immediately:

```bash
osascript -e '
tell application "iTerm2"
  activate
  set newWindow to (create window with default profile command "tmux attach -t '"${TMUX_SESSION}"'")
end tell
'
```

Report:
> Coordination window opened — Integrator (top pane) + Orchestrator (bottom pane). Talk to the Integrator to share ideas, check status, or dispatch work.

### If both are already running:

Auto-open the coordination window (same osascript as above), then report:
> Coordination window is already live — opened it for you. Integrator + Orchestrator running in tmux session '{TMUX_SESSION}'.

## Step 5: Show Escalations (if any)

If there are pending escalation files in `$DELIBERATE_DIR/comms/_system/inbox/integrator/`:

1. Read each file
2. Present them to the user with urgency level and subject
3. Ask if the user wants to address any now

If no escalations, skip this step.

## Step 6: Show Dashboard (if available)

If `$DELIBERATE_DIR/status/dashboard.md` exists, read it and present a condensed summary:
- Active agents and what they're working on
- Pipeline overview (stages with counts)
- Items needing attention

If no dashboard exists yet, note that the Orchestrator will generate one on its first cycle.

## Step 7: Ready State

Tell the user:

> Coordination window is open. The Integrator and Orchestrator are ready. Use this session to send messages, check status, or re-learn the codebase. Initiative windows will appear as work begins.

Then present options via `AskUserQuestion`:

| Option | Label | Description |
|--------|-------|-------------|
| 1 | Send a message to the Integrator | Write a message to the Integrator's inbox for it to process |
| 2 | Send a directive to the Orchestrator | Write a directive message for the Orchestrator to act on |
| 3 | Check status | Read board state and show pipeline details |
| 4 | Re-learn codebase | Run (or re-run) the onboarding learning pass to refresh project knowledge |

### If "Send a message to the Integrator":

Ask the user what they want to tell the Integrator. Then write:
```bash
TIMESTAMP=$(date -u '+%Y%m%d-%H%M%S')
```

Write to `$DELIBERATE_DIR/comms/_system/inbox/integrator/${TIMESTAMP}-message.md`:
```markdown
# message: {subject}
- **From**: visionary
- **To**: integrator
- **At**: {ISO timestamp}
- **Type**: message
- **Urgency**: info
- **Status**: unread

{user's message}
```

Also write to `$DELIBERATE_DIR/intake/{timestamp}-{slug}.md` if the message contains a new idea:
```markdown
# {title}
**Captured**: {ISO timestamp}
**Source**: Visionary via /deliberate

{user's description}
```

Confirm: "Message sent to the Integrator's inbox. It will pick it up on its next cycle."

### If "Send a directive to the Orchestrator":

Ask what the user wants the Orchestrator to do. Then write a directive:
```bash
TIMESTAMP=$(date -u '+%Y%m%d-%H%M%S')
```

Write to `$DELIBERATE_DIR/comms/_system/inbox/orchestrator/${TIMESTAMP}-directive.md`:
```markdown
# directive: {subject}
- **From**: visionary
- **To**: orchestrator
- **At**: {ISO timestamp}
- **Type**: directive
- **Urgency**: info
- **Status**: unread

{user's instruction}
```

Confirm: "Directive sent. The Orchestrator will pick it up on its next cycle."

### If "Check status":

Read these state files and present a comprehensive view:
- `$DELIBERATE_DIR/priority-stack.yaml` — current priorities
- `$DELIBERATE_DIR/queue/*.yaml` — initiative statuses
- `$DELIBERATE_DIR/status/dashboard.md` — if available
- `$DELIBERATE_DIR/comms/_system/inbox/integrator/*.md` — pending messages

### If "Re-learn codebase":

Run the onboarding script to produce (or refresh) the project knowledge brief:

```bash
$DA_HOME/scripts/onboard.sh "$CONFIG_PATH" --refresh --skip-prompt
```

This takes 2-5 minutes. Wait for completion, then verify:

```bash
test -f "$DELIBERATE_DIR/onboarding.md" && wc -l "$DELIBERATE_DIR/onboarding.md"
```

Report the result. Note: any agents launched after this will automatically pick up the refreshed brief — already-running agents won't see the update until re-launched.

---

## After any action in Step 7, return to Step 7's ready state.

This is a persistent session. Stay in the loop until the user says "done" or closes the session.
