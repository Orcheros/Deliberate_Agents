# Workflows — How Agents Coordinate

Workflows define the end-to-end sequences that move work through the system. Each file is a routing map — it defines the agent sequence, handoff conditions, decision gates, and exit criteria for a specific type of work.

Workflows do NOT duplicate skill content or agent identity. Those live in `skills/` and `agents/` respectively. Workflows are pure routing — the orchestrator and humans reference these to understand what happens when.

## Workflow Inventory

| Workflow | Trigger | Teams Involved |
|----------|---------|---------------|
| [Initiative Discovery](initiative-discovery.md) | Founder has a scoped idea | Product (PM only) |
| [Initiative Build](initiative-build.md) | One-pager selected for grooming | Product (PM → Architect → Designer → Scrum Master) |
| [Development Execution](development-execution.md) | Initiative status → `READY_FOR_DEV` | Engineering (PjM → Developers → Review) |
| [Quality Assurance](quality-assurance.md) | Initiative status → `DEV_COMPLETE` | QA (QA Lead → Security → Integration → UX) |
| [Release](release.md) | One or more initiatives at `QA_COMPLETE` | Release (Manager → Engineer → Comms → Marketer) |
| [Go-to-Market](go-to-market.md) | Major feature shipping or GTM initiative | GTM (Growth → Content → Sales → CS → Onboarding) |
| [Incident Response](incident-response.md) | Production issue detected | Engineering + Release (cross-cutting) |
| [Review Protocol](review-protocol.md) | Developer work complete, before QA | Support (Reviewer) |

## How Workflows Connect

```
Initiative Discovery ──→ Initiative Build ──→ Development Execution ──→ Review Protocol ──→ Quality Assurance ──→ Release
                                                                                                                    ↓
                                                                                                              Go-to-Market
```

Human approval gates sit between each major transition. The orchestrator enforces sequencing.
