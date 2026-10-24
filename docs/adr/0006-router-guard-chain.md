# 0006. One router with a guard chain

- Status: Accepted
- Date: 2026-10-14

## Context

Where a user may go depends on several independent rules: maintenance and forced updates, onboarding, setup,
remote feature flags and Pro entitlement. Rules spread across pages drift, and deep links bypass page-level checks.

## Decision

A single `GoRouter` composes route lists exposed by features. One top-level redirect runs `RouteGuardChain`, whose
guards run in priority order: app gate, onboarding, setup, feature flags, subscription. A guard returns `null` to
defer, another path to redirect, or the current path to stay and stop the chain. The stop rule exists because two
guards that each allow only their own screen otherwise bounce the user forever.

Gate, flag and subscription changes refresh the router. Onboarding and setup flags do not: they flip right before an
explicit navigation, and refreshing at that moment would bounce the page through the guards first.

Tabs use `StatefulShellRoute.indexedStack` so each tab keeps its stack. Transitions are defined once and drop to no
animation when the OS requests reduced motion.

## Consequences

- Every rule applies equally to taps, deep links and notification taps.
- Guards are pure and synchronous, which keeps them unit-testable; the chain test replays redirects to the final
  landing page.
- Anything a guard reads must be available synchronously at startup.
