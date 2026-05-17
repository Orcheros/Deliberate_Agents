---
name: video-produce
description: Orchestrate video production from script to rendered output using AI video providers
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Video Produce

Orchestrate the video production pipeline: script → render provider → review → export.

## Process

### Step 1: Read Script

Read the video script from the Notion page body. Extract:
- Segments (timestamp, visual cue, spoken text, on-screen text)
- Target format (Short/Standard/Long)
- Target platform (YouTube/TikTok/Instagram)
- Recommended render style (avatar/generative/manual)

### Step 2: Select Render Provider

Based on video style from config + script requirements:
- **Avatar** (talking head, thought leadership) → HeyGen provider
- **Generative** (creative visuals, b-roll) → Runway provider
- **Manual** (screen recording, live footage) → Flag for human, create checklist

Read `config.henry.yaml` for provider preferences:
```yaml
video:
  avatar_provider: "heygen"
  generative_provider: "runway"
  default_style: "avatar"
```

### Step 3: Prepare Render Job

Transform the script into the provider's format:
- **HeyGen**: Extract spoken text, select avatar/voice, set background
- **Runway**: Extract visual cues as prompts, set duration/style
- **Manual**: Generate shot list and recording checklist

### Step 4: Submit Render

Call the video provider integration:
```bash
./integrations/video/start.sh --provider {provider} --render {script.json}
```

Record the job_id in Notion (Render Job ID field).
Set Render Status → "Rendering"

### Step 5: Monitor Progress

Poll for completion:
```bash
./integrations/video/start.sh --provider {provider} --status {job_id}
```

If status = "complete":
- Download the rendered video
- Set Render Status → "Complete"

If status = "failed":
- Set Render Status → "Failed"
- Log error details
- Notify via Slack

### Step 6: Review Output

Verify:
- Duration matches target (±10%)
- Aspect ratio correct (9:16 or 16:9)
- Audio is clear (for avatar videos)
- No visual artifacts

### Step 7: Export

Prepare platform-specific exports:
- YouTube: 1080p or 4K, H.264, .mp4
- TikTok: 1080x1920, H.264, .mp4, ≤60s
- Instagram Reels: 1080x1920, H.264, .mp4, ≤90s

Update Notion page with:
- Video file path
- Duration
- Resolution
- Ready for publish flag

## Constraints

- Never publish without human review of the rendered video
- If render fails twice, escalate to manual production
- Maximum spend per video: check provider rate limits
- Video must match script — no creative drift from providers
