---
name: seo-audit
description: Audit current site content and structure across SEO, AEO, AIO, and GEO dimensions
allowed-tools: Read, Glob, Grep, Bash
---

# SEO Audit

## Objective

Analyze existing site content, metadata, schema markup, and structure to identify gaps and opportunities across all four search visibility dimensions: traditional SEO, Answer Engine Optimization, AI Optimization, and Generative Engine Optimization.

## Instructions

### 1. Inventory Existing Content

- Catalog all pages, blog posts, and landing pages with their URLs
- Map the current information architecture (navigation, categories, URL structure)
- Identify the content hierarchy and topical clusters (or lack thereof)
- Note any orphaned pages (no internal links pointing to them)

### 2. Technical SEO Assessment

Evaluate for each page/template:

- **Title tags**: Present? Under 60 chars? Include primary keyword?
- **Meta descriptions**: Present? Under 160 chars? Compelling CTA?
- **Header hierarchy**: Proper H1 → H2 → H3 nesting? One H1 per page?
- **Canonical URLs**: Set correctly? Self-referencing?
- **Image alt text**: Present? Descriptive?
- **Internal linking**: Does every key page have inbound internal links?
- **Schema markup**: What JSON-LD exists? What's missing?
- **Open Graph / Twitter Cards**: Present? Correct?
- **Robots.txt and sitemap**: Properly configured?

Rate each area: **Good** / **Needs Improvement** / **Missing**

### 3. AEO Assessment

For key topic areas:

- Does content directly answer common questions in the first paragraph?
- Are there FAQ sections with clear Q&A formatting?
- Is content structured for featured snippet capture (lists, tables, definitions)?
- Are PAA (People Also Ask) opportunities being addressed?
- Does schema markup support FAQ, HowTo, or Q&A rich results?

### 4. AIO Assessment (AI Overviews / SGE)

- **E-E-A-T signals**: Are author bios, credentials, and organization authority visible?
- **Content depth**: Is content comprehensive enough to be selected for AI summaries?
- **Claim structure**: Are key claims stated clearly with supporting evidence?
- **Source citation**: Does content cite authoritative sources that AI can verify?
- **Freshness**: Is content dated and regularly updated?

### 5. GEO Assessment

- **Quotability**: Can key value propositions be extracted as clean, citable statements?
- **Unique data**: Does the site publish original research, statistics, or data?
- **Brand entity clarity**: Is the brand/product clearly defined in a way LLMs can parse?
- **Structured facts**: Are product features, pricing, and differentiators stated unambiguously?
- **Comparison readiness**: Can an LLM accurately compare this product to competitors from the content?

### 6. Competitive Context

If competitor information is available in the PRD or initiative docs:
- How does competitor content structure compare?
- What search features do competitors own (featured snippets, knowledge panels)?
- Where are the content gaps competitors haven't filled?

### 7. Compile Audit Report

Produce a structured audit report with:

- **Executive Summary**: Top 3-5 findings, overall readiness score per dimension
- **Dimension Scores**: SEO / AEO / AIO / GEO each rated 1-5 with justification
- **Issue Log**: Every issue found, categorized by dimension and severity (Critical / High / Medium / Low)
- **Quick Wins**: Issues that can be fixed with minimal effort for high impact
- **Strategic Gaps**: Larger opportunities that require content creation or structural changes

## Output

Write the audit report to the initiative's documentation directory. Update assignment status with `current_step: "seo-audit"`. Transition to `/seo-strategy`.
