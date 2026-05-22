---
name: seo-strategy
description: Develop prioritized search optimization strategy based on audit findings
allowed-tools: Read, Write, Edit, Glob, Grep
aaaerrr-zone: "funnel:awareness"
---

# SEO Strategy

## Objective

Translate audit findings into a prioritized optimization strategy with clear recommendations, keyword targeting, and a roadmap that addresses all four search dimensions.

## Instructions

### 1. Review Audit Findings

- Read the SEO audit report produced by `/seo-audit`
- Identify the highest-impact issues across all dimensions
- Note any patterns (e.g., schema markup missing sitewide, no FAQ structures anywhere)

### 2. Keyword & Intent Mapping

For each key page or content area:

- **Primary keyword**: The main search query this page should rank for
- **Secondary keywords**: Related terms and long-tail variations
- **Search intent**: Informational, navigational, commercial, transactional
- **Target search feature**: Organic listing, featured snippet, PAA, AI Overview, knowledge panel
- **GEO angle**: What question would someone ask an AI assistant that this content should answer?

Organize as a keyword map table:

| Page | Primary Keyword | Intent | Target Feature | GEO Question | Priority |
|------|----------------|--------|---------------|--------------|----------|

### 3. Schema Markup Strategy

Define which schema types to implement:

- **Organization**: Company details, logo, social profiles
- **Product**: Features, pricing, offers (for product pages)
- **Article / BlogPosting**: Author, datePublished, dateModified
- **FAQ**: For pages with question-answer content
- **HowTo**: For tutorial or guide content
- **BreadcrumbList**: For navigation hierarchy
- **WebSite**: For sitelinks search box eligibility

For each, specify which pages get which schema type.

### 4. Content Optimization Priorities

Rank all recommendations by impact vs. effort:

**Tier 1 — Quick Wins** (high impact, low effort):
- Meta tag fixes, schema additions, header restructuring
- Adding FAQ sections to existing high-traffic pages
- Reformatting content for featured snippet capture

**Tier 2 — Strategic Improvements** (high impact, moderate effort):
- Content depth expansion for AI Overview inclusion
- Topical cluster creation with pillar pages
- Internal linking architecture improvements
- GEO-optimized content reformatting (clear claims, citable statements)

**Tier 3 — New Content** (high impact, high effort):
- Net-new content for keyword gaps
- Original research or data publications for GEO authority
- Comparison and alternative pages for competitive queries

### 5. GEO-Specific Recommendations

For each key product/service area:

- **Brand definition statement**: A clear, factual description an LLM can use verbatim
- **Feature-fact pairs**: Unambiguous statements linking features to outcomes
- **Competitive positioning**: Factual differentiation that LLMs can surface in comparisons
- **Citation-worthy claims**: Statistics, data points, or unique insights worth citing

### 6. Measurement Framework

Define how to track success across dimensions:

- **SEO**: Organic traffic, keyword rankings, crawl health (Google Search Console)
- **AEO**: Featured snippet ownership, PAA appearances, rich result impressions
- **AIO**: AI Overview citations (manual monitoring or third-party tools)
- **GEO**: Brand mentions in LLM responses (periodic testing across ChatGPT, Perplexity, Claude)

Specify PostHog events or analytics tracking needed if applicable.

### 7. Cross-Functional Handoffs

Identify what other agents need:

- **Content Writer**: Content briefs with keyword targets and structural requirements
- **Developer**: Technical SEO fixes, schema markup implementation, page speed improvements
- **Integrations Engineer**: Analytics/Search Console configuration
- **DevOps**: Caching, CDN, Core Web Vitals infrastructure

## Output

Write the strategy document with keyword map, schema plan, prioritized recommendations, and measurement framework. Update assignment status. Transition to `/seo-implement`.
