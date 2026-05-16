---
name: content-publish
description: Publish approved and scheduled content to LinkedIn via provider API with approval verification
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Content Publish

## Objective

Publish content that has been approved and scheduled for today. Verify approval gates, publish via LinkedIn provider, update Notion state, and notify the team.

## Pre-Flight Checks

Before publishing anything:

1. **Query Notion**: Status = Scheduled AND Publish Date = today
2. **Verify approval chain**: Page must have transitioned through "Approved" status (check page history or audit field)
3. **Check config**: `publish_requires_approval: true` — if set, refuse to publish anything that hasn't been explicitly approved
4. **Rate limit**: Maximum 2 posts per day (LinkedIn algorithm penalizes rapid-fire posting)

If no posts are scheduled for today, exit cleanly with a log message.

## Publish Sequence

For each post to publish (in chronological order if multiple scheduled):

### Step 1: Extract Content

1. Read the post content from the Notion page body
2. Verify content length ≤ 3000 characters (LinkedIn limit)
3. Check for any placeholder text or TODO markers — abort if found
4. Extract media URLs if any are attached

### Step 2: Final Slop Check

Run a quick scan against `content/slop-blacklist.yaml`:
- If violations found: **do not publish**
- Update Notion status to "Review" with a comment noting violations
- Notify via Slack that a scheduled post was bounced back

### Step 3: Publish

1. Call LinkedIn provider: `publish_post(content, media_urls)`
2. Capture returned `post_id` and `url`
3. Log the publish event

### Step 4: Update State

1. Update Notion page:
   - Status → "Published"
   - LinkedIn Post ID → returned post_id
2. Write publish record to `.deliberate/logs/content-publish.log`:
   ```
   [timestamp] PUBLISHED page_id=X post_id=Y title="Z"
   ```

### Step 5: Notify

Post to Slack:
```
📢 Published: "[Post title]"
LinkedIn: [post URL]
Scheduled metrics check: today 18:00
```

## Error Handling

| Error | Action |
|---|---|
| LinkedIn API failure | Retry once after 60s. If still failing, mark post as "Scheduled" (no change), notify Slack with error. |
| Content too long | Bounce back to "Review" status, comment with character count. |
| Missing approval | Skip post, log warning, notify Slack. |
| Rate limit hit | Queue remaining posts for tomorrow, notify. |

## Dry Run Mode

If environment variable `CONTENT_DRY_RUN=true`:
- Execute all steps except the actual API call
- Log what would have been published
- Update Notion status to "Scheduled" (no change)
- Useful for testing the full pipeline

## Constraints

- Never publish without verified approval gate
- Never publish more than 2 posts per day
- Never publish content with slop violations
- Never publish content containing placeholder text
- Always write post_id back to Notion immediately after publish
- Always notify Slack on both success and failure

## Transition

Published → engagement-tracker picks up at 18:00 → metrics written back to Notion.
