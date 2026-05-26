# Exploring Design Alternatives

Guidance for Step 3 (Propose Approaches) of the design-before-code workflow. Inspired by John Ousterhout's "Design It Twice" principle: even if you think the first design is good, try a second radically different approach — it will either confirm the first or reveal something better.

---

## When to Explore Alternatives

**Always explore** for:
- New user-facing features (the UX shape has many valid options)
- Data model design (schema decisions are expensive to change)
- Cross-cutting concerns (auth, caching, event systems)
- Anything that will be called from many places (interface shape matters)

**Skip and document why** for:
- The codebase already has an established pattern for this exact case
- There's a framework convention that dictates the approach (e.g., Rails resource routes)
- Mechanical changes where only one approach makes sense

## How to Frame Alternatives

Present 2-3 approaches. Each must be genuinely defensible — don't include a strawman just to have three options.

### Comparison Template

| | Approach A: {name} | Approach B: {name} | Approach C: {name} |
|---|---|---|---|
| **What** | {1 sentence} | {1 sentence} | {1 sentence} |
| **Trade-off** | {main advantage + disadvantage} | {main advantage + disadvantage} | {main advantage + disadvantage} |
| **Complexity** | {small / medium / large} | {small / medium / large} | {small / medium / large} |
| **Files touched** | {count or list} | {count or list} | {count or list} |
| **Reversibility** | {easy / hard / permanent} | {easy / hard / permanent} | {easy / hard / permanent} |

### Trade-off Dimensions

Pick the 2-3 dimensions most relevant to the decision:

- **Simplicity vs. flexibility** — Does it handle only today's requirements, or is it extensible? (Prefer simplicity unless extensibility is a stated requirement.)
- **Performance vs. readability** — Is the optimization worth the cognitive cost? (Almost always prefer readability.)
- **Consistency vs. correctness** — Does it follow existing patterns even if a better pattern exists? (Prefer consistency in most cases — the codebase is the team's shared vocabulary.)
- **Scope vs. completeness** — Does it solve 80% now or 100% with more work? (Prefer 80% unless the remaining 20% is a known near-term need.)
- **Coupling vs. duplication** — Share code and create a dependency, or duplicate and stay independent? (Prefer duplication for 2 call sites, shared abstraction for 3+.)

## After Selection

Once an approach is selected, briefly note why the others were rejected. This becomes part of the design doc's implicit ADR — if someone asks "why didn't we do X?" later, the answer is already documented.

```markdown
### Why not {Approach B}?
{1 sentence: the decisive trade-off that ruled it out.}
```
