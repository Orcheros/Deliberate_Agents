---
name: launch-strategy
description: Plan product launches and feature announcements — phased rollout, channel strategy, launch day execution, and post-launch momentum
allowed-tools: Read, Write, Glob, Grep
---

# Launch Strategy

## Objective

Plan a launch that builds momentum, captures attention, and converts interest into users.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What's being launched? (New product, major feature, minor update)
   - Timeline and owned channels (email list, blog, community)
   - Any previous launch learnings

2. **Classify the launch tier**:

   | Tier | What | Effort | Example |
   |------|------|--------|---------|
   | Tier 1 | New product or major pivot | Full campaign, 4-6 weeks prep | Product launch, rebrand |
   | Tier 2 | Major feature or integration | Targeted campaign, 2-3 weeks | Key feature, marketplace launch |
   | Tier 3 | Minor feature or improvement | Lightweight, 1 week | UI update, quality-of-life fix |

3. **Map channels using ORB framework**:
   - **Owned**: Email list, blog, in-app announcements, social accounts, documentation
   - **Rented**: Paid ads, sponsored newsletters, influencer partnerships
   - **Borrowed**: Product Hunt, Hacker News, press coverage, community cross-posts

   Every launch needs at least one channel from each category for Tier 1-2.

4. **Build the phased launch plan**:

   **Pre-launch (2-4 weeks before):**
   - Build anticipation: teaser content, waitlist, early access invites
   - Prepare assets: landing page, demo, screenshots, social content, email drafts
   - Seed with advocates: give early access to power users, collect testimonials

   **Launch day:**
   - Coordinated publishing across all channels within a 2-hour window
   - Email blast to full list
   - Social posts (thread format for depth)
   - In-app announcement for existing users
   - Product Hunt submission (if applicable — requires separate prep)
   - Monitor and engage with responses in real-time

   **Post-launch (1-4 weeks after):**
   - Day 2-3: Share initial results, user quotes, early wins
   - Week 1: Comparison content, detailed walkthrough, use-case posts
   - Week 2: Case study from early adopter
   - Week 3-4: Roundup email, interactive demo, retarget engaged non-converters

5. **Product Hunt strategy** (if applicable):
   - Build relationships with hunters 4-6 weeks before
   - Launch Tuesday-Thursday, 12:01 AM PT
   - Prepare: tagline (60 chars), description (260 chars), 4-6 images, maker comment
   - Day-of: personal outreach to supporters, respond to every comment
   - Don't ask for upvotes directly — ask people to "check it out"

6. **Define success metrics**:
   - Traffic to launch page
   - Signups or trial starts from launch
   - Activation rate of launch cohort vs. baseline
   - Social engagement and shares
   - Press/blog mentions

## Output

Write deliverable to `.deliberate/reports/{slug}/launch-plan.md` including:
- Launch tier classification
- ORB channel map with specific tactics per channel
- Phase-by-phase plan with dates and owners
- Launch day checklist with time-boxed actions
- Post-launch momentum plan (30 days)
- Success metrics and targets
