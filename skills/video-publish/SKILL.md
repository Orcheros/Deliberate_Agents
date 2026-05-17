---
name: video-publish
description: Upload rendered videos to YouTube, TikTok, and Instagram with platform-specific metadata
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Video Publish

Upload rendered videos to target platforms with optimized metadata.

## Process

### Step 1: Pre-Flight Checks

1. Video file exists and is valid
2. Render Status = "Complete"
3. Status = "Scheduled" or "Approved"
4. Publish Date ≤ today
5. Target platform(s) identified from Channel field

### Step 2: Prepare Metadata

For each target platform, assemble metadata:

**YouTube:**
- Title (≤100 chars): Clear, keyword-rich, no clickbait
- Description (≤5000 chars): Summary, timestamps, links, CTAs
- Tags: 5-15 relevant keywords
- Category: Select from YouTube categories
- Thumbnail: Extract frame or use custom
- Visibility: public / unlisted / private
- Is Short: true if ≤60s vertical

**TikTok:**
- Description (≤2200 chars): Brief, with hashtags
- Hashtags: 3-5 relevant
- Sounds: Original sound (default)
- Privacy: public / friends / private
- Allow duet/stitch: true (default)

**Instagram Reels:**
- Caption (≤2200 chars): Brief, personal
- Cover image: Frame selection or custom
- Audio: Original
- Share to Feed: true

### Step 3: Upload

Route to appropriate provider:
```bash
./integrations/social/start.sh --platform {platform} --publish --video {file_path}
```

### Step 4: Update State

Write back to Notion:
- Platform-specific Video ID (YouTube Video ID, TikTok Video ID, Instagram Post ID)
- Status → "Published"
- Published Date → now

### Step 5: Notify

Post to Slack:
```
📹 Video published to {platform}
Title: {title}
URL: {url}
Duration: {duration}
```

## Platform-Specific Rules

### YouTube
- Shorts: ≤60s, vertical (9:16), no end screen
- Long-form: Add end screen in last 20 seconds
- First 48 hours critical for algorithm
- Publish at peak audience hours

### TikTok
- Maximum 10 minutes (but <60s performs best)
- First 3 seconds = everything
- Vertical only (9:16)
- Trending sounds boost discovery

### Instagram Reels
- 15-90 seconds optimal
- Cover image matters for profile grid
- Vertical (9:16)
- Cross-post to Stories for reach

## Constraints

- Never upload without verifying video passes platform specs
- Rate limits: YouTube 6/day, TikTok 25/day, Instagram 25/day
- Human must have approved the video before publish
- Keep originals — never delete source after upload
