---
name: release-changelog
description: Generate internal changelog from git history and initiative documentation
allowed-tools: Read, Write, Glob, Grep, Bash
---

# Step 1: Internal Changelog

## Objective

Create a detailed internal changelog that the team can reference for what's shipping and why.

## Instructions

1. **Read the release plan** for the list of initiatives included
2. **Read git history**:
   - Commits included in this release (from last release tag to current)
   - Parse conventional commit prefixes to auto-categorize:
     - `feat` → New Features (minor version bump)
     - `fix` → Bug Fixes (patch bump)
     - `perf` → Performance Improvements (patch bump)
     - `breaking` or `!` suffix → Breaking Changes (major bump)
     - `security` → Security section
     - `docs`, `test`, `chore`, `ci`, `build` → internal only, omit from user-facing notes
   - Group by initiative/feature area
   - Note breaking changes, migration requirements, configuration changes
3. **Read initiative documentation**:
   - PRD summaries for context on each initiative
   - QA reports for known issues or limitations
4. **Determine version bump** from commit analysis:
   - Any `BREAKING CHANGE` or `!` → major bump
   - Any `feat` without breaking → minor bump
   - Only `fix`, `perf`, `security` → patch bump
5. **Write the changelog** to `.deliberate/releases/{version}/changelog.md`:
   - **New Features**: What's new, which initiative, key details
   - **Improvements**: Enhancements to existing features
   - **Bug Fixes**: What was broken and how it was fixed
   - **Breaking Changes**: Anything that changes existing behavior — must include migration guidance
   - **Security**: Vulnerability fixes, isolated in own section
   - **Database Changes**: Migrations included (for ops awareness)
   - **Configuration Changes**: New env vars, feature flags, settings
   - **Known Issues**: Limitations or deferred fixes
   - **Contributors**: Who worked on what

## Quality Checks

- Each bullet must be user-meaningful, not implementation noise
- Breaking changes must include migration action steps
- Security fixes isolated in their own section
- Sections with no entries are omitted
- Duplicate bullets across sections are removed

## Output

- Internal changelog document with semver bump recommendation

## Transition

Proceed to `/release-notes`.
