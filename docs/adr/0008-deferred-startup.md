# 0008. Deferred startup

- Status: Accepted
- Date: 2026-10-14

## Context

Cold start time shapes first impressions and store vitals. Firebase, Remote Config, network sessions and background
scheduling together cost hundreds of milliseconds if awaited before the first frame.

## Decision

Before `runApp` the app only configures DI registrations (no instances), installs error handlers and loads the
settings table, which the router needs synchronously. The native splash covers that time; there is no Flutter splash
screen. Everything else runs in `DeferredInitializer` after the first frame: feature modules, connectivity, Firebase,
consent, flags, the device session and lifecycle hooks. Each step is isolated so one failure cannot stop the others.

`StartupTimer` measures process start to first frame and reports it on the `app_startup` trace once Firebase is up.

## Consequences

- The first screen paints from local data regardless of network or Firebase state.
- Services must tolerate being used before they finish initializing (Firebase-backed services buffer or no-op).
- New startup work goes into `DeferredInitializer`, not `bootstrap()`, unless the first frame truly needs it.
