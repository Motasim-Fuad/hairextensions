## What and why

## How it was tested

## Checklist

- [ ] `make check` passes (format, analyze, tests)
- [ ] One class or widget per file; no emojis; comments only for non-obvious constraints
- [ ] No hardcoded strings (ARB) and no magic numbers (tokens)
- [ ] Errors render inline under the related field or button; success and navigation are silent
- [ ] New remote datasource has both a mock and an API implementation
- [ ] Writes go to sqflite first and are queued for sync
- [ ] Loading state uses a page-shaped skeleton
- [ ] Rebuilds are scoped (BlocSelector, buildWhen, listenWhen)
- [ ] New feature is behind a FeatureKey if it should be remotely switchable
- [ ] Tests cover the bloc, repository and any pure logic
- [ ] An ADR is added if this changes an architectural decision
