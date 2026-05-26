---
name: community-strategy
description: Design community growth strategy — platform selection, seeding plan, engagement cadence, moderation, and measurement
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "flywheel:engagement"
---

# Community Strategy

## Objective

Design a strategic community growth plan that selects the right platforms, defines a phased seeding approach, establishes engagement cadence, and measures community-driven business outcomes. This is the strategic layer above tactical community execution (`/community-engage`) and platform-specific writers.

## Instructions

1. **Read context**:
   - Read assignment file for community goals and constraints
   - Read GTM context (injected automatically) for ICP, positioning, voice/brand
   - Read existing community-engage outputs if any
   - Check which platform-specific writers are available (reddit-writer, hackernews-writer, producthunt-writer, etc.)

2. **Audit current community presence**:
   - Which platforms are we active on today?
   - What engagement metrics exist? (followers, post frequency, engagement rate)
   - What has `/community-engage` been doing? What's working?
   - What owned communities exist (Discord, Slack, forum)?

3. **Select target communities** (aim for 5-10 candidates, launch in max 3):
   
   Score each community on these criteria (1-5 scale):
   
   | Criteria | What to evaluate |
   |----------|-----------------|
   | Audience overlap | How closely does this community match our ICP? |
   | Activity level | Is the community active? Daily posts? Regular engagement? |
   | Receptiveness | Is the community open to newcomers and product discussion? |
   | Competitor presence | Are competitors active here? (Moderate presence = good signal; dominance = harder) |
   | Content format fit | Does our expertise translate well to this platform's format? |
   | Compounding potential | Does effort here build over time (SEO, reputation, followers)? |

   **Platform types to evaluate:**
   - Reddit subreddits (specific to industry/problem)
   - Hacker News
   - Discord servers (industry-specific)
   - Slack communities (professional/industry)
   - Indie Hacker / bootstrapper communities
   - Industry-specific forums
   - LinkedIn Groups
   - Stack Overflow / technical Q&A (if applicable)
   - Product Hunt (for launches, not ongoing)

   **Output:** Ranked list with scores, top 3 selected for activation.

4. **Design seeding strategy per community** (4-phase approach):

   ### Phase 1: Lurk & Learn (Weeks 1-4)
   - Join and observe. Read the last 30 days of top posts.
   - Identify community norms (what gets upvoted, what gets removed, what tone works)
   - Map key members and moderators
   - Build your profile (bio, history, credibility signals)
   - **Zero product mentions. Zero self-promotion.**

   ### Phase 2: Value-First Contributions (Weeks 5-8)
   - Answer questions in your domain of expertise
   - Share insights, data, or frameworks (not your product)
   - Engage thoughtfully with other members' posts
   - Build reputation through consistent, helpful presence
   - **Still no product mentions. Earn the right to be heard.**

   ### Phase 3: Soft Introduction (Weeks 9-12)
   - Share your product only when organically relevant to a discussion
   - Frame as "here's how we solved this" not "check out our product"
   - Respond to direct questions about tools/solutions in your space
   - Share case studies or results, not feature lists
   - **Only mention product when it genuinely helps the conversation.**

   ### Phase 4: Established Member (Ongoing)
   - Regular, valuable contributions (not just product-related)
   - Relationships with moderators and key community members
   - Thought leadership through original insights and data
   - AMA or "show and tell" when community norms allow
   - Become a resource, not a vendor

5. **Define engagement cadence per platform**:

   | Platform | Posting Frequency | Content Types | Response Time |
   |----------|------------------|---------------|---------------|
   | {platform} | {daily / 3x week / weekly} | {comments, posts, AMAs, tutorials} | {target hours} |

   **Escalation triggers** (route to human or growth strategist):
   - Negative sentiment spike about brand/product
   - Direct product criticism from influential member
   - Partnership or integration opportunity surfaced
   - Competitor making claims about us
   - Community moderator reaching out directly

6. **Design moderation guidelines**:

   **For owned communities (Discord, Slack, forum):**
   - Community rules (be respectful, no spam, stay on topic, etc.)
   - Moderation playbook (warning → temp mute → ban)
   - Content categories and channels
   - Welcome flow for new members
   - Event cadence (weekly discussion, monthly AMA, etc.)

   **For third-party communities:**
   - Respect existing community rules — read and follow them
   - Never mass-post or cross-post without adaptation
   - Disclose affiliation when discussing your product
   - Accept feedback gracefully, even when critical

   **Crisis response plan:**
   - Negative viral moment: acknowledge, don't argue, take offline if possible `[HUMAN GATE]`
   - Ban or removal: review what went wrong, adjust approach, do NOT create alt accounts
   - Competitor attack: respond with facts and grace, never mud-sling `[HUMAN GATE]`

7. **Measurement framework**:

   **Community health metrics:**
   - Community size (members, followers, subscribers)
   - Active member percentage (posted/commented in last 30 days)
   - Engagement rate (interactions per post)
   - Sentiment (positive/neutral/negative ratio)
   - Growth rate (new members per week/month)

   **Business metrics:**
   - Community-sourced leads (signups attributed to community activity)
   - Community-influenced signups (touched community before converting)
   - Support deflection (questions answered in community vs. support tickets)
   - Content amplification (community shares of our content)
   - Feature request signal (product insights from community discussions)

   **Review cadence:** Monthly for the first quarter, then quarterly.

## Constraints

- **Max 3 communities simultaneously** — focus beats breadth. Add more only after establishing presence in first 3.
- **Seeding phases are sequential** per community — never skip Phase 1 (Lurk & Learn). Trust the process.
- **Reference existing platform rules** — check the relevant platform-specific writer's `platform-rules.md` companion doc for platform-specific norms and constraints.
- **Community building is slow** — set expectations for a 6-12 month horizon before meaningful business metrics. Early wins are reputation and learning, not leads.
- **Include `[HUMAN GATE]`** for: account creation, actual posting (until confidence is established), crisis response, and moderator outreach.

## Output

Write the community strategy to `.deliberate/reports/{slug}/community-strategy.md`.

## Transition

Feeds into:
- `/community-engage` — Tactical execution of the strategy
- Platform-specific writers (`/reddit-writer`, `/hackernews-writer`, `/producthunt-writer`) — Content creation for selected platforms
- `/growth-loops` — Community-driven growth loops (referral, content, engagement)
- `/content-brief` — Community-informed content topics
