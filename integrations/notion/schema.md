# Content Database Schema

## Required Notion Database Properties

| Property | Type | Values / Notes |
|---|---|---|
| Title | title | Content title or working headline |
| Status | select | Idea / Drafting / Review / Approved / Scheduled / Published / Tracking |
| Pillar | select | Thought Leadership / Product / Community / Behind-the-Scenes |
| Format | select | Text / Carousel / Video / Poll / Article |
| Channel | multi-select | LinkedIn / Twitter / Blog / Newsletter |
| Author | person | Notion workspace member |
| Publish Date | date | Scheduled publication date |
| Metrics | rich text | Engagement summary (updated by engagement-tracker) |
| LinkedIn Post ID | rich text | Post identifier for API tracking |
| Hook Type | select | Contrarian / Story / Data / Question / Authority / Vulnerability / Pattern Interrupt / Bold Claim / How-To |
| Source | relation | Links to research page that spawned this idea |

## Status Flow

Idea -> Drafting -> Review -> Approved -> Scheduled -> Published -> Tracking

## Setup Instructions

1. Create a new Notion database with the properties above
2. Set NOTION_TOKEN env var (create integration at https://www.notion.so/my-integrations)
3. Share the database with your integration
4. Set NOTION_CONTENT_DB env var to the database ID
5. Test: `./start.sh --test`
