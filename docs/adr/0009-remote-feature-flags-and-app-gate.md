# 0009. Remote feature flags and the app gate

- Status: Accepted
- Date: 2026-10-14

## Context

Store review makes fixes slow. The team needs to disable a broken feature, stage new ones, force updates and show
maintenance without shipping a build.

## Decision

`FeatureKey` lists every switchable feature with a default compiled into the app. `FeatureFlagService` serves
defaults overlaid with the last cached Remote Config values, synchronously from memory, and refreshes after the first
frame and on resume. Feature routes are blocked by `FeatureFlagGuard`, widgets use `FeatureGate`, and feature modules
initialize only while their flag is on. `AppGateService` turns version and maintenance parameters into a gate status
that the router enforces.

## Consequences

- Turning a flag off hides and blocks a feature on the next fetch, with no release.
- Defaults must be safe offline, because they apply on first launch and whenever fetches fail.
- Flags are not security. Anything that must be enforced is enforced by the backend or the store.
