# 0005. Silent device session instead of login

- Status: Accepted
- Date: 2026-10-14

## Context

The product has no accounts. Asking a stylist to sign up before pricing a job loses users, but the backend still
needs to identify the installation for sync and entitlements later.

## Decision

On first launch the app generates a device id and registers it with `POST /auth/device`, receiving access and refresh
tokens that are stored in secure storage. This runs after the first frame and never blocks the UI. The token refresh
interceptor runs one refresh for concurrent 401s. A rejected refresh token (4xx) ends the session and a new one is
opened automatically; an unreachable server keeps the existing session.

## Consequences

- Zero-friction onboarding, and the app is fully usable before the session exists.
- Reinstalling or restoring to a new device creates a new session. Moving data between devices will need an account
  or a transfer code; that is a future decision.
- Adding real accounts later replaces `ensureSession` behind the same `AuthRepository` interface.
