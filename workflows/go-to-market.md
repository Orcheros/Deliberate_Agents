# Go-to-Market

## Purpose

Coordinate GTM activities around shipped features — growth strategy, content creation, sales enablement, customer success, and onboarding optimization. Not every release triggers this workflow; it's for significant feature launches and GTM-specific initiatives.

## Trigger

- Major feature release completing the Release workflow
- GTM-specific initiative (pricing change, new market entry, competitive response)
- Founder directive for growth/marketing push

## Agent Sequence

```
Feature shipped (or GTM initiative)
  ↓
Growth Strategist
  /growth-assess → /growth-strategy → /growth-plan
  ↓
  ┌────────────────────────────────────────────────────┐
  │ Parallel execution by specialty                     │
  ├────────────┬────────────┬────────────┬─────────────┤
  │ Content    │ Sales      │ Customer   │ Onboarding  │
  │ Writer     │ Enablement │ Success    │ Specialist  │
  │            │            │            │             │
  │ /content-  │ /sales-    │ /cs-health-│ /onboarding-│
  │  brief     │  research  │  check     │  assess     │
  │ /content-  │ /sales-    │ /cs-       │ /onboarding-│
  │  draft     │  outreach- │  interven- │  design     │
  │ /content-  │  prep      │  tion      │ /onboarding-│
  │  review    │ /sales-    │            │  optimize   │
  │            │  pipeline  │            │             │
  └────────────┴────────────┴────────────┴─────────────┘
  ↓
  SEO Specialist (if content-heavy)
    /seo-audit → /seo-strategy → /seo-implement
  ↓
  Technical Writer (if docs needed)
    /docs-assess → /docs-write
```

## Detailed Steps

### Step 1: Growth Strategist — Strategy

**Skills:** `/growth-assess` → `/growth-strategy` → `/growth-plan`
1. Assess the opportunity (market size, competitive position, channel potential)
2. Develop positioning and messaging strategy
3. Create actionable growth plan with experiments
4. Can invoke specialist skills: `/pricing-strategy`, `/experiment-design`, `/referral-program`, `/competitive-teardown`

**Output:** Growth strategy doc with channel priorities, messaging framework, experiment backlog

### Step 2: Content Creation

**Content Writer** — `/content-brief` → `/content-draft` → `/content-review`:
- Blog posts, landing page copy, email sequences, social content
- Can invoke `/email-sequence` for multi-touch nurture sequences
- All content follows brand voice guidelines

**SEO Specialist** — `/seo-audit` → `/seo-strategy` → `/seo-implement`:
- Optimize content for search (traditional SEO, featured snippets, AI overviews, LLM citation)
- Schema markup, internal linking, keyword targeting

### Step 3: Sales Enablement

**Sales Development Rep** — `/sales-research` → `/sales-outreach-prep` → `/sales-pipeline`:
- Research prospects, prepare personalized outreach
- Update pipeline with new feature talking points

**Account Executive Assistant** — `/sales-research` → `/sales-pipeline`:
- Update deal materials with new feature capabilities
- Competitive battle cards, proposal updates

### Step 4: Customer Success

**Customer Success** — `/cs-health-check` → `/cs-intervention`:
- Identify accounts that benefit most from new feature
- Plan adoption campaigns for existing customers
- Can invoke `/churn-prevent` for at-risk accounts

### Step 5: Onboarding Optimization

**Onboarding Specialist** — `/onboarding-assess` → `/onboarding-design` → `/onboarding-optimize`:
- Update onboarding flows to include new feature
- Activation metrics for new capability
- Empty states and progressive disclosure

### Step 6: Documentation

**Technical Writer** — `/docs-assess` → `/docs-write`:
- User-facing docs (help articles, guides)
- Internal docs (runbooks, API reference)
- Architecture decision records if applicable

## Decision Gates

| Gate | Who Decides | Condition |
|------|------------|-----------|
| GTM needed? | Founder / Growth Strategist | Feature significance, market opportunity |
| Which channels? | Growth Strategist | Based on assessment and strategy |
| Content approval | Human | All published content requires human review |
| Pricing changes | Founder | Always requires explicit founder approval |

## Exit Condition

GTM activities complete. Content published, sales enabled, onboarding updated, success outreach planned. Growth Strategist documents measurement plan via `/release-measure`.

## Deliverables Convention

GTM artifacts for an initiative should be organized in `.deliberate/reports/{slug}/gtm/` using the numbered naming convention defined in `templates/gtm-deliverables-convention.md`. This creates a browsable playbook per initiative.
