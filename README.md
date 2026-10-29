# Price to Profit

Flutter pricing, quoting and invoicing app connected to the supplied Price to Profit API. Start with [START_HERE.md](START_HERE.md) for replacement and run instructions, [the API audit](docs/API_INTEGRATION_AUDIT.md) for endpoint coverage and verification limits, and [the app flow](docs/APP_FLOW.md) for navigation.

## Requirements

- Flutter 3.44.1 (Dart 3.12.1). CI pins this version.
- Xcode 26+ for iOS, Android SDK with the platform required by the plugins (currently API 37).
- Ruby 3.3 and Bundler, only for releasing with fastlane.

## First run

```bash
make setup      # pub get, localizations, DI code generation
make run-dev    # runs against the supplied live API
```

`make check` runs the same gate as CI: format, analyze (infos are fatal) and tests.

## Environments and flavors

Two independent switches, both set at build time:

| Config file           | `FLAVOR` (app id, name, Firebase project) | `ENV` (which datasources DI wires) |
| --------------------- | ----------------------------------------- | ---------------------------------- |
| `config/mock.json`    | dev                                       | mock                               |
| `config/dev.json`     | dev                                       | dev (real API)                     |
| `config/staging.json` | staging                                   | dev (real API)                     |
| `config/prod.json`    | prod                                      | prod (real API)                    |

```bash
flutter run --flavor dev --dart-define-from-file=config/mock.json
```

Android has native flavors (`.dev` and `.staging` app id suffixes) so all three install side by side. iOS has no
native flavors yet; run without `--flavor` until the schemes in [docs/ios-flavors.md](docs/ios-flavors.md) exist.

Config files hold no secrets. Anything in them ships inside the app binary.

## Architecture

```text
lib/
  main.dart            Calls bootstrap()
  app/                 Composition: bootstrap, router and guards, tab shell, gate screens, background isolate
  core/                Feature-agnostic infrastructure (network, database, sync, flags, monitoring, theme, l10n)
  shared/widgets/      Design-system widgets, one per file
  features/<name>/
    data/              Datasources (local sqflite, remote mock and API), models, mappers, repository impls
    domain/            Entities, enums, repository interfaces returning Either<Failure, T>, use cases
    presentation/      Blocs (sealed events and state as part files), pages, widgets, route list
```

Rules that keep it fast and consistent:

- **State:** BLoC. Widgets subscribe through `BlocSelector`, `buildWhen` and `listenWhen` so only the part that
  changed rebuilds. Side effects such as navigation happen in listeners.
- **Feedback:** success and navigation are silent. Errors are inline text under the related field or button; there
  are no error snackbars.
- **Loading:** skeletons shaped like the page, painted by one shared shimmer controller per page.
- **Offline-first:** sqflite is the source of truth. Repositories write locally, then enqueue a sync operation.
  The sync engine only runs while the `cloudSync` flag is on.
- **Backend switch:** every remote datasource has a mock and an API implementation. One `env:` list on the
  registration decides which is used, so connecting the backend is a config change.
- **Startup:** only the settings table loads before the first frame. Firebase, flags, the device session and sync
  start after it.
- **No hardcoded values:** strings live in `lib/l10n/arb/app_en.arb`; sizes, spacing, radii, motion and colors live
  in `lib/core/theme/tokens`. Rebrand by changing `BrandPalette.primary` in `lib/core/theme/brand_palette.dart`.
- **Style:** one class or widget per file, no emojis, comments only for constraints the code cannot show, and one
  debug-only logger (`AppLogger`) that prints `Source: message`.

Decisions and their reasons are recorded in [docs/adr](docs/adr/README.md).

### Navigation and guards

One `GoRouter` in `lib/app/router/app_router.dart`. Redirects run through a guard chain in priority order:
maintenance and force update, onboarding, setup, feature flags, subscription. A guard returns `null` to defer,
another path to redirect, or the current path to stay and stop the chain. Route names and paths live in
`lib/core/routing/app_routes.dart` so features can navigate without importing the app layer.

Deep links use `pricetoprofit://app/<path>`; guards still apply. Push payloads map through an allow-list in
`NotificationRouteResolver`.

### Branding

Brand colors and fonts follow the client brand guide.

| Token | Value | Where |
| --- | --- | --- |
| Baby Pink | `#FFCBDB` | `BrandPalette.babyPink`: soft fills, selected states, auth header wash |
| Vibrant Pink | `#ED77A8` | `BrandPalette.primary`: buttons, switches, focus, splash |
| Charcoal Grey | `#63635D` | `BrandPalette.ink`: main text and icons |
| White | `#FFFFFF` | `BrandPalette.white`: cards, sheets, text on pink |

Everything else in `brand_palette.dart` is a tint, shade or functional color derived from these. Vibrant Pink is
only 2.7:1 on white, so text-sized pink (links, text buttons) uses `primaryDeep`.

Fonts: main headings use Playfair Display, body text and smaller headings use Helvetica
(`lib/core/theme/tokens/app_typography.dart`). Helvetica is licensed and is not bundled: iOS and macOS use the system
Helvetica, and every other platform falls back to the bundled Arimo, which has the same metrics. PDFs use Arimo for
the same reason. The logo is the Amna Sheen signature wordmark (`BrandWordmark`); add the font file to
`assets/fonts/`, uncomment the `AmnaSheenSignature` block in `pubspec.yaml`, and it is picked up with no code change.
Until then the wordmark renders in italic Playfair Display.

After changing splash colors run `dart run flutter_native_splash:create`; after changing visuals run
`flutter test --update-goldens`.

### Account screens

Log in, register and forgot password live in `lib/features/auth/presentation`. First launch runs onboarding, then log
in, then the paywall. The screens are built against `AccountGateway`; `LocalAccountGateway` is a placeholder that
accepts every request. To connect the API, implement `AccountGateway` with the auth endpoints, register it in DI, and
resolve it in `LoginPage`, `RegisterPage` and `ForgotPasswordPage` (marked `TODO(auth)`). Nothing is stored and no
guard requires a login yet.

## Adding a feature

1. Copy the layout of `lib/features/business_setup` into `lib/features/<name>`.
2. Domain first: entities, a repository interface returning `Either<Failure, T>`, one use case per file.
3. Data: a sqflite table and migration in `lib/core/database`, a local datasource, a remote interface with
   `_mock` (`env: DiEnv.mockOnly`) and `_api` (`env: DiEnv.remote`) implementations, and a repository that writes
   locally and enqueues sync.
4. If it syncs, add a `SyncHandler` and a `FeatureModule`, then list the module in
   `lib/app/bootstrap/app_feature_modules.dart`.
5. Presentation: bloc with sealed events (one part file each), a status enum, a page, page-only widgets and a
   skeleton. Expose a route list and compose it in the app router.
6. Add a `FeatureKey` if it should be switchable remotely, and gate its route in
   `lib/app/router/guards/route_access.dart`.
7. Strings to the ARB file, values to tokens, then `make gen` and `make check`.

## Testing

```bash
make test       # unit, bloc, repository and widget tests with coverage
make goldens    # pixel tests; regenerate with: flutter test --update-goldens --tags golden
```

Repositories run against real migrations on in-memory sqlite (`test/helpers/test_database.dart`). The DI graph test
resolves the mock and prod graphs to catch missing registrations and cycles that the analyzer cannot see.

## Releasing

Push a tag such as `v1.2.0`. The release workflow builds an obfuscated, signed prod bundle and IPA, keeps the
debug symbols as artifacts, and uploads to the Play internal track and TestFlight. Setup, secrets and the staged
rollout process are in [docs/release.md](docs/release.md). Security measures are in
[docs/security.md](docs/security.md).

| Guide | Covers |
| --- | --- |
| [docs/firebase-setup.md](docs/firebase-setup.md) | Firebase projects, config files, Crashlytics, Performance, Analytics, Remote Config |
| [docs/store-rollout.md](docs/store-rollout.md) | Play Console and App Store Connect setup, privacy forms, staged rollout and halt criteria |
| [docs/performance.md](docs/performance.md) | Budgets, built-in optimizations, rules and the release checklist |
| [docs/release.md](docs/release.md) | Signing, secrets, the release workflow and emergency levers |
| [docs/security.md](docs/security.md) | Storage, network, pinning and backup rules |
| [docs/ios-flavors.md](docs/ios-flavors.md) | Creating the iOS dev and staging schemes |
