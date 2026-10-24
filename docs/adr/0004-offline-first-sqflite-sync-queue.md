# 0004. Offline-first with sqflite and a sync queue

- Status: Accepted
- Date: 2026-10-14

## Context

Stylists quote in salons and at clients' homes with unreliable connectivity. A quote must never fail to save because
the network is down, and there is no backend yet.

## Decision

sqflite is the source of truth. Repositories write locally, then enqueue a sync operation in the same flow. The queue
coalesces repeated writes to the same entity into one pending row. `SyncEngine` drains it on reconnect, on new
enqueues and on a single retry timer with exponential backoff, never by polling. Feature `SyncHandler`s push their
entity and are registered by feature modules, so core stays feature-agnostic.

The engine and the periodic background task only start while the `cloudSync` flag is on. The background isolate
builds its own service locator and initializes feature modules so handlers exist there too.

Settings live in a key-value table loaded into memory once, so router guards read them synchronously.

## Consequences

- Every feature works offline and in mock mode with no extra code paths.
- Until cloud sync ships, OS backups are the only way data survives a device change (see 0011).
- Conflict resolution is last write wins per entity; revisit when multi-device editing becomes real.
- Schema changes need a migration file and a version bump in `DatabaseMigrator`.
