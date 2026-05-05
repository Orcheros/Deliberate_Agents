---
name: stripe-lifecycle
description: Implement and maintain Stripe subscription lifecycle — Pay gem integration, webhook handling, metered billing, and tier management
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Stripe Subscription Lifecycle

## Objective

Implement or extend Stripe subscription lifecycle features following the project's established Pay gem + Jumpstart Pro patterns. Covers subscription creation, tier changes, trial-to-paid conversion, metered billing, webhook handling, and entitlement enforcement.

## Instructions

1. **Read your assignment file** (`.deliberate/assignments/{worktree}.md`):
   - What subscription feature is being built or modified?
   - Which tier(s) or billing change is affected?

2. **Understand the existing architecture** before making changes:

   ```
   Subscription Stack:
   ├── Pay gem (~> 11.0)              # Subscription abstraction layer
   ├── Stripe gem (~> 18.0)           # Direct Stripe API (conditional on Jumpstart.config.stripe?)
   ├── Jumpstart Pro                   # SaaS billing scaffold
   └── Application layer:
       ├── app/models/ai_budget.rb                        # Tier definitions, budget tracking
       ├── app/models/concerns/premium_entitlement.rb     # Entitlement checks
       ├── app/services/subscription_sync_service.rb      # Stripe event → tier mapping
       ├── app/jobs/report_usage_to_stripe_job.rb         # Metered billing sync
       ├── config/initializers/pay.rb                     # Pay callbacks (subscribe, change)
       └── config/initializers/stripe.rb                  # Stripe client config
   ```

   **Tier definitions** (from `AiBudget`):
   - `discovery` — Free/trial tier
   - `startup` — Entry paid tier
   - `growth` — Mid-tier
   - `partner` — Enterprise tier

   **Key patterns to follow**:
   - Pay gem handles Stripe Customer/Subscription CRUD — never call `Stripe::Subscription.create` directly
   - `SubscriptionSyncService` maps Pay events to application tier changes
   - `AiBudget` is the single source of truth for what a team can do — subscriptions set the budget, budget gates the features
   - Entitlement checks go through `PremiumEntitlement` concern, never direct Stripe API calls
   - Metered usage is reported via background job (`ReportUsageToStripeJob`), not inline

3. **Subscription lifecycle events** — handle these through Pay callbacks:

   | Event | Handler | What Happens |
   |-------|---------|-------------|
   | New subscription | `sync_ai_budget_on_subscribe` | Create/update `AiBudget` for the team |
   | Plan change (upgrade/downgrade) | `sync_ai_budget_on_change` | Adjust tier and budget limits |
   | Trial expiry | Pay handles automatically | Subscription transitions or cancels |
   | Payment failure | Pay + Stripe dunning | Retry logic in Stripe, update status via webhook |
   | Cancellation | Pay callback | Downgrade to discovery tier, retain data |
   | Reactivation | Pay callback | Restore previous tier's budget |

4. **Webhook handling conventions**:
   - Pay gem processes most Stripe webhooks automatically — don't duplicate
   - Custom webhook handlers go in Pay callbacks (`config/initializers/pay.rb`), not separate controllers
   - Always verify webhook signatures (Pay handles this)
   - Return 200 for unknown event types
   - Log all subscription state transitions for audit trail
   - Webhook processing must be idempotent — replaying the same event produces the same state

5. **Metered billing pattern**:
   - Track usage in the application (e.g., API calls, AI token consumption)
   - Report to Stripe via `ReportUsageToStripeJob` on a schedule
   - Use Stripe's `create_usage_record` with `action: 'increment'` (not `set`)
   - Handle overage gracefully — don't block the user mid-request, bill retroactively
   - Budget checks happen in `AiBudget`, not at the Stripe level

6. **Entitlement enforcement**:
   - Gate features via `PremiumEntitlement` concern methods (`premium_entitled?`, `stripe_subscribed?`)
   - Check at the controller level (`before_action`) or in the view (conditional rendering)
   - Never check Stripe API directly in request path — use cached subscription state
   - Trial users get full access — entitlement checks should pass during trial

7. **Testing conventions**:
   - Unit test `SubscriptionSyncService` with mock Pay subscription objects
   - Test `AiBudget` tier transitions independently of Stripe
   - Integration test the full webhook → sync → budget pipeline
   - Use Pay's test helpers and fixtures (`test/fixtures/pay/subscriptions.yml`)
   - Test edge cases: expired trial, failed payment, downgrade with usage above new tier limit

## Stripe API Best Practices

**Deprecated APIs — never use these:**

| API | Status | Use Instead |
|-----|--------|-------------|
| Charges API | Never use | PaymentIntents (via Pay gem) |
| Sources API | Deprecated | PaymentMethods (via Pay gem) |
| Tokens API | Outdated | Confirmation Tokens / Setup Intents |
| Card Element | Legacy | Payment Element |
| Plan object | Deprecated | Price object |
| Legacy Accounts API (v1) | Deprecated for new | Accounts v2 API (if using Connect) |

**Integration rules:**
- Never store API keys in source code — use Rails encrypted credentials
- Prefer restricted API keys (`rk_`) over secret keys (`sk_`) for service-specific access
- Always verify webhook signatures (Pay gem handles this)
- Use test mode (`stripe_test_*`) for development and testing
- Pin to a specific API version in `config/initializers/stripe.rb`

**Security:**
- Roll compromised API keys immediately
- Never expose keys in client-side JavaScript
- Use Stripe.js for all PCI-sensitive operations (card collection)
- Verify webhook signatures on every request

## Quality Checks

- [ ] No direct `Stripe::` API calls outside of Pay callbacks and the usage reporting job
- [ ] All tier transitions go through `SubscriptionSyncService`
- [ ] Entitlement checks use `PremiumEntitlement`, not Stripe API
- [ ] Metered billing is async (background job), never inline
- [ ] Webhook processing is idempotent
- [ ] All subscription state changes are logged
- [ ] Tests cover upgrade, downgrade, cancellation, reactivation, and payment failure paths

## Output

Write deliverables to the appropriate application directories. Document changes in `.deliberate/reports/{slug}/stripe-lifecycle.md`.
