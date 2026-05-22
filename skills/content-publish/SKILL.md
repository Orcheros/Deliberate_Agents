---
name: content-publish
description: Multi-platform content publishing with provider routing, rate limiting, and state management
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
aaaerrr-zone: "funnel:awareness"
---

# Content Publish

## Objective

Publish approved content across all configured platforms, routing each post to the correct provider based on its Channel field. Manage platform-specific rate limits and stagger publishing for optimal reach.

## Pre-Flight Checks

Before publishing ANY content:

1. ✅ Status = "Scheduled"
2. ✅ Publish Date ≤ today
3. ✅ Content body is non-empty
4. ✅ Channel field is populated
5. ✅ Platform provider is configured and enabled in `config.henry.yaml`
6. ✅ For video: Render Status = "Complete" and video file exists
7. ✅ Final slop scrub passes for target platform(s)

If ANY check fails → skip this post, log reason, continue to next.

## Publish Sequence

### Step 1: Query Scheduled Posts

Query Notion for posts where:
- Status = "Scheduled"
- Publish Date ≤ today

Sort by Publish Date (oldest first).

### Step 2: Route by Channel

For each post, read the Channel multi-select field. A post may have multiple channels.

For each channel:
1. Check if platform is enabled in config
2. Check rate limit not exceeded for today
3. Route to provider: `integrations/social/start.sh --platform {channel} --publish "{content}"`

### Step 3: Platform-Specific Formatting

Before publishing, adapt content per platform:
- **LinkedIn**: Publish as-is (drafted by linkedin-copywriter)
- **Twitter**: Publish as-is (drafted by twitter-copywriter)
- **Threads**: Publish as-is (drafted by threads-copywriter)
- **Facebook**: Publish as-is (drafted by facebook-copywriter)
- **YouTube/TikTok/Instagram**: Use video-publish flow (video file + metadata)

### Step 4: Update State

After successful publish to each platform:
1. Write platform-specific Post ID to Notion (e.g., Twitter Post ID, YouTube Video ID)
2. When ALL channels for a post are published: Status → "Published"
3. Record published timestamp

### Step 5: Stagger Publishing

Publishing order and timing:
1. LinkedIn — immediately
2. Twitter — +30 minutes
3. Threads — +30 minutes
4. Facebook — +1 hour
5. Video platforms — +2 hours (allows engagement to build on text first)

### Step 6: Notify

Post to Slack for each published item:
```
✅ Published to {platform}: "{title}" ({url})
```

## Rate Limits

| Platform | Daily Maximum | Notes |
|---|---|---|
| LinkedIn | 2 | Quality > quantity |
| Twitter | 10 | Including thread tweets |
| Threads | 5 | Casual platform, don't over-post |
| Facebook | 2 | Per page |
| YouTube | 6 | Shorts + long combined |
| TikTok | 25 | Platform is high-volume |
| Instagram | 25 | Reels + posts combined |
| Reddit | 3 | Per subreddit rules |
| HackerNews | 1 | Quality submissions only |
| ProductHunt | 1 | Launches are rare events |

## Error Handling

- **API error (4xx)**: Log error, skip this platform, continue with others
- **Rate limit hit (429)**: Stop publishing to that platform for today
- **Network error**: Retry once after 30 seconds, then skip
- **Auth error (401/403)**: Alert via Slack immediately, stop all publishing to that platform

## Dry Run Mode

When `content.dry_run: true` in config OR `--dry-run` flag:
- Execute all steps EXCEPT the actual API call
- Log what would be published where
- Useful for testing the full pipeline without side effects

## Constraints

- Never publish without Status=Scheduled
- Never publish future-dated content
- Never exceed platform rate limits
- Always write back Post IDs (enables engagement tracking)
- If multi-channel post fails on one platform, still publish to others
- Video content requires separate human approval of rendered output

## Transition

After publishing: Status → Published. Engagement tracker will pick up from here.
