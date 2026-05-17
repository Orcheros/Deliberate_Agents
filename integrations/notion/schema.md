# Content Database Schema

## Required Notion Database Properties

| Property | Type | Values / Notes |
|---|---|---|
| Title | title | Content title or working headline |
| Status | select | Idea / Drafting / Review / Approved / Scheduled / Published / Tracking |
| Pillar | select | Thought Leadership / Product / Community / Behind-the-Scenes |
| Format | select | Text / Carousel / Video-Short / Video-Long / Poll / Article / Thread / Show-HN / Launch |
| Channel | multi-select | LinkedIn / Twitter / Threads / Facebook / Instagram / YouTube / TikTok / Reddit / HackerNews / ProductHunt / Blog / Newsletter |
| Author | person | Notion workspace member |
| Publish Date | date | Scheduled publication date |
| Metrics | rich text | Engagement summary (updated by engagement-tracker) |
| LinkedIn Post ID | rich text | Post identifier for API tracking |
| Hook Type | select | Contrarian / Story / Data / Question / Authority / Vulnerability / Pattern Interrupt / Bold Claim / How-To |
| Source | relation | Links to research page that spawned this idea |
| Twitter Post ID | rich text | X post identifier for API tracking |
| Threads Post ID | rich text | Threads post identifier |
| Facebook Post ID | rich text | Facebook post identifier |
| Instagram Post ID | rich text | Instagram Reel identifier |
| YouTube Video ID | rich text | YouTube video identifier |
| TikTok Video ID | rich text | TikTok video identifier |
| Reddit Post ID | rich text | Reddit submission identifier |
| HN Item ID | rich text | HackerNews item identifier |
| PH Post ID | rich text | ProductHunt post identifier |
| Video Style | select | Avatar / Generative / Screen-record / Manual |
| Video Duration | select | Short (≤60s) / Standard (3-5min) / Long (10-15min) |
| Render Status | select | Pending / Rendering / Complete / Failed |
| Render Job ID | rich text | Video provider job identifier |

## Status Flow

Idea -> Drafting -> Review -> Approved -> Scheduled -> Published -> Tracking

## Setup Instructions

1. Create a new Notion database with the properties above
2. Set NOTION_TOKEN env var (create integration at https://www.notion.so/my-integrations)
3. Share the database with your integration
4. Set NOTION_CONTENT_DB env var to the database ID
5. Test: `./start.sh --test`
