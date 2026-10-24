# 0002. BLoC with scoped rebuilds

- Status: Accepted
- Date: 2026-10-14

## Context

Performance is the top priority. Forms like the quote builder change state on every keystroke, and a naive
`BlocBuilder` around a page rebuilds everything each time.

## Decision

Use `flutter_bloc`. Events are sealed classes, one part file each; state is one immutable class with a status enum
and `copyWith`. Widgets read state through `BlocSelector` for single values, `buildWhen` when a builder needs several,
and `listenWhen` for side effects. Navigation and other side effects happen only in listeners. Text fields own their
controllers and select only their own error, so typing never rebuilds the form.

Cubits are used for simple read-only screens (for example the setup summary).

## Consequences

- Rebuilds are proportional to what changed, which keeps frames under budget on low-end Android devices.
- Every selector is a small contract to maintain; reviews check that pages do not wrap whole trees in builders.
- `AppBlocObserver` logs transitions in debug and reports bloc errors as non-fatals in all builds.
