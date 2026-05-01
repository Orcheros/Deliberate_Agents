---
name: seo-implement
description: Produce implementation artifacts — schema markup, content briefs, and technical specifications
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# SEO Implementation

## Objective

Produce concrete, ready-to-use implementation artifacts from the strategy: JSON-LD schema markup, page-level content optimization briefs, and technical specifications for the Developer agent.

## Instructions

### 1. Generate Schema Markup (JSON-LD)

For each page/template identified in the strategy, produce valid JSON-LD:

```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "...",
  "url": "...",
  ...
}
```

Produce separate JSON-LD blocks for:
- **Site-wide**: Organization, WebSite, BreadcrumbList
- **Per-page type**: Product, Article, FAQ, HowTo as specified in strategy
- **Aggregate**: If multiple schema types apply to a single page, show the combined markup

Validate that all required properties per schema type are present. Note any properties that need dynamic values (price, date, author) and specify where they come from in the codebase.

### 2. Write Content Optimization Briefs

For each page flagged for optimization, produce a brief for the Content Writer agent:

**Brief format:**
- **Page**: URL or path
- **Primary keyword**: Target search query
- **Current state**: What exists now (summary)
- **Title tag**: Recommended title (under 60 chars)
- **Meta description**: Recommended description (under 160 chars)
- **H1**: Recommended heading
- **Content structure**: Recommended header hierarchy with H2/H3 outline
- **Featured snippet target**: Format (paragraph/list/table) and the question to answer
- **FAQ section**: 3-5 questions to add with guidance on answer structure
- **GEO optimization**: Key citable statements to include
- **Internal links**: Pages to link to/from
- **Word count guidance**: Target length based on competitive analysis

### 3. Technical SEO Specification

Produce a developer-actionable specification covering:

- **Schema injection points**: Where in templates/layouts to add JSON-LD blocks
- **Meta tag template**: Pattern for dynamic title/description generation
- **Canonical URL rules**: Logic for setting canonical URLs
- **Sitemap generation**: What to include/exclude, update frequency hints
- **Robots.txt updates**: Any needed changes
- **Image optimization**: Alt text patterns, lazy loading, format recommendations
- **Page speed items**: Specific assets to optimize, render-blocking resources
- **Structured data testing**: URLs for Google Rich Results Test validation

### 4. GEO Content Blocks

For key product/service pages, write ready-to-use content blocks optimized for LLM citation:

- **Brand definition paragraph**: 2-3 sentences an LLM can quote verbatim when describing the product
- **Feature summary table**: Clean, structured feature-benefit mapping
- **Comparison data**: Factual differentiators in a format LLMs can extract
- **Statistics block**: Key numbers and data points with clear attribution

These blocks should be standalone — the Content Writer can integrate them into full page content.

### 5. Implementation Checklist

Produce a prioritized checklist with:

| # | Item | Type | Agent | Page(s) | Priority | Status |
|---|------|------|-------|---------|----------|--------|
| 1 | Add Organization schema | Technical | Developer | site-wide | P0 | TODO |
| 2 | Rewrite homepage title tag | Content | Content Writer | / | P0 | TODO |
| ... |

Group by priority tier (P0 = this sprint, P1 = next sprint, P2 = backlog).

### 6. Monitoring Setup

Specify what to track post-implementation:

- Google Search Console verification steps
- Rich result monitoring queries
- GEO brand mention test prompts (specific queries to periodically run against ChatGPT, Perplexity, Claude)
- PostHog custom events for search-driven conversions if applicable

## Output

Write all implementation artifacts to the initiative's documentation directory:
- `schema-markup/` — JSON-LD files per page type
- `content-briefs/` — Per-page optimization briefs
- `technical-spec.md` — Developer specification
- `geo-content-blocks.md` — LLM-optimized content blocks
- `implementation-checklist.md` — Prioritized action items

Update assignment status to `complete`. Mark deliverables in the assignment file.
