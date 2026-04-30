# Step 2: Write Review Summary

## Objective

Produce a clear, concise summary for the human reviewer so they can efficiently review the completed work in Cursor.

## Instructions

1. **Write the review summary** with these sections:

   ### Initiative
   Name and one-line description.

   ### What Was Built
   Bullet-point summary of what was implemented, organized by area (models, controllers, views, etc.).

   ### Files Changed
   Organized list of all files created or modified, grouped by type:
   - Migrations
   - Models
   - Controllers
   - Views/Partials
   - Stimulus Controllers
   - Tests
   - Routes/Config

   ### How to Test
   Step-by-step instructions for the human to manually verify the feature works:
   1. Start the server
   2. Navigate to X
   3. Do Y
   4. Expect Z

   ### Commits
   List of all commits across all worktrees, in dependency order.

   ### Worktrees to Merge
   Which branches need to be merged, in what order.

   ### Notes
   Anything the reviewer should know — design decisions made, trade-offs, things that could be improved later.

2. **Write the summary** to `.deliberate/queue/{initiative}/review-summary.md`

3. **Update initiative status**:
   ```yaml
   status: "REVIEW_READY"
   review_summary_path: ".deliberate/queue/{initiative}/review-summary.md"
   review_ready_at: "timestamp"
   ```

## Done

The initiative is now ready for human review. The orchestrator will surface this to the human. The session can end.
