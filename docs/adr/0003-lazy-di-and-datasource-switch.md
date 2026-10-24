# 0003. Lazy DI and the mock/API datasource switch

- Status: Accepted
- Date: 2026-10-14

## Context

The frontend ships before the backend. Connecting the backend later should not touch repositories, blocs or UI.
Startup must not pay for services the first screen does not use.

## Decision

Use `get_it` with `injectable`. Every singleton is lazy; blocs are factories. Each remote datasource has an interface
and two implementations: `_mock` registered with `env: DiEnv.mockOnly` and `_api` with `env: DiEnv.remote`. The
`ENV` value in the config file picks the environment at startup.

The generated `injection.config.dart` is committed. CI regenerates it and fails if it differs. A test resolves the
mock and prod graphs, because the analyzer does not check generated code and missing registrations or cycles only
fail at runtime.

## Consequences

- Switching to the real backend is a config change; mock mode keeps working for demos and UI work.
- Implementations registered under an interface must have their `@disposeMethod` declared on the interface.
- A dependency cycle overflows the generator; split the dependency, as `BareDioFactory` does for token refresh.
