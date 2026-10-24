# 0001. Feature-first clean architecture

- Status: Accepted
- Date: 2026-10-14

## Context

The app will grow to quotes, invoices, a product library, subscriptions and later more modules, built by several
people. Layer-first folders (all blocs together, all repositories together) scatter one feature across the tree and
make ownership and deletion hard.

## Decision

Group code by feature under `lib/features/<name>`, each with `data`, `domain` and `presentation`. Domain is pure Dart
and depends on nothing outside core. Repositories return `Either<Failure, T>`; exceptions never cross into
presentation. Features never import each other: shared entities live in `core/shared_entities` and cross-feature
reads go through interfaces in `core/contracts` (for example `BusinessProfileReader`). `lib/app` composes features
(router, startup, background isolate) and is the only place that knows all of them.

One class or widget per file. Bloc events and state are part files of the bloc library so sealed hierarchies still
work.

## Consequences

- A feature can be built, tested or removed as one folder.
- More files and some boilerplate per feature; `business_setup` is the reference to copy.
- Cross-feature needs require a contract in core first, which is deliberate friction.
