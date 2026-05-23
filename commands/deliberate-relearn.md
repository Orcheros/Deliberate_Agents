# /deliberate-relearn — Refresh the Project Learning Brief

Re-run the learning pass to update the structured brief with the current state of the codebase. Use this after major refactors, new services, or significant changes to the project.

---

## Step 1: Resolve Framework and Project

1. Set `DA_HOME` from `$DELIBERATE_AGENTS_HOME` (default: `$HOME/Development/Deliberate_Agents`).
2. Use Glob to find `$DA_HOME/config.*.yaml` files. Exclude `config.example.yaml`.
3. **Also check the current working directory**: if `$(pwd)/.deliberate.yaml` or `$(pwd)/.deliberate/config.yaml` exists, that's the active project's config (or its symlink in `$DA_HOME`). Match by the `repo:` field in found configs against `$(pwd)`.
4. If exactly one config matches (either by CWD match or only one exists): use it. If multiple and no CWD match: use `AskUserQuestion` to ask which project.
5. If no config found: tell the user to run `$DA_HOME/scripts/init.sh` first and stop.
6. Read the chosen config. Extract: `name`, `repo`, `worktrees`.

Set these variables for use in subsequent steps:
- `CONFIG_PATH` — full path to the config file
- `PROJECT_NAME` — from the `name:` field
- `REPO_DIR` — from the `repo:` field
- `WORKTREES` — from the `worktrees:` field
- `DELIBERATE_DIR` — `{WORKTREES}/.deliberate`

## Step 2: Check Existing Brief

1. Check if `$DELIBERATE_DIR/onboarding.md` exists.
2. If it does NOT exist:
   - Tell the user: "No existing brief found for **{PROJECT_NAME}**. Running a fresh learning pass instead."
3. If it does exist:
   - Read the first 5 lines to extract the generation date (the `> Generated:` line).
   - Tell the user: "Refreshing the learning brief for **{PROJECT_NAME}** (last generated: {date})."

## Step 3: Run the Learning Pass

```bash
$DA_HOME/scripts/onboard.sh "$CONFIG_PATH" --refresh --skip-prompt
```

Wait for completion.

## Step 4: Verify and Report

```bash
test -f "$DELIBERATE_DIR/onboarding.md" && wc -l "$DELIBERATE_DIR/onboarding.md"
```

If the file exists:
> Learning brief refreshed — **{line count}** lines written to `{DELIBERATE_DIR}/onboarding.md`. Any agents launched after this will pick up the updated brief. Already-running agents won't see the update until re-launched.

If the file does not exist:
> Re-learning failed. Check the output above for errors. You can retry with `/deliberate-relearn` or run manually: `$DA_HOME/scripts/onboard.sh $CONFIG_PATH --refresh`
