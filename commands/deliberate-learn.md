# /deliberate-learn — Run the First-Run Learning Pass

Explore the target project's codebase and produce a structured brief that all agents reference. Use this when onboarding a project for the first time, or when you want to manually trigger the learning pass outside of `/deliberate`.

If a brief already exists, this command will warn and offer to refresh instead.

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
2. If it exists:
   - Tell the user: "A learning brief already exists for **{PROJECT_NAME}**. Use `/deliberate-relearn` to refresh it, or proceed here to overwrite."
   - Use `AskUserQuestion`:

     | Option | Label | Description |
     |--------|-------|-------------|
     | 1 | Overwrite | Re-run the learning pass and replace the existing brief |
     | 2 | Cancel | Keep the existing brief |

   - If "Cancel": stop.

## Step 3: Check for Code

1. Check if the repo has meaningful code:
   ```bash
   find "$REPO_DIR" -name "*.rb" -o -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.go" -o -name "*.rs" -o -name "*.java" -o -name "*.swift" | head -5
   ```
2. If no source files found: tell the user "No source files found in the repo — nothing to learn yet." and stop.

## Step 4: Run the Learning Pass

Tell the user: "Running learning pass against **{PROJECT_NAME}**. This takes 2–5 minutes."

```bash
$DA_HOME/scripts/onboard.sh "$CONFIG_PATH" --skip-prompt
```

Wait for completion.

## Step 5: Verify and Report

```bash
test -f "$DELIBERATE_DIR/onboarding.md" && wc -l "$DELIBERATE_DIR/onboarding.md"
```

If the file exists:
> Learning pass complete — **{line count}** lines written to `{DELIBERATE_DIR}/onboarding.md`. All agents launched from now on will have this project knowledge injected into their context.

If the file does not exist:
> Learning pass failed. Check the output above for errors. You can retry with `/deliberate-learn` or run manually: `$DA_HOME/scripts/onboard.sh $CONFIG_PATH`
