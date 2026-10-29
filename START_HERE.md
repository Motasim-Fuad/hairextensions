# Run the updated project

This ZIP contains the complete `hairextensions` project. Keep a backup of your current folder, then replace it with this folder. Preserve your own signing keys and platform-specific local files if they were not in the supplied ZIP.

The API is already set to `http://56.228.53.36:8000` in the default app config and in `config/dev.json`, `staging.json` and `prod.json`.

Use the Flutter SDK required by the project: Flutter 3.44.1 / Dart 3.12.1 or a compatible newer version. Then run from this folder:

```bash
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
```

Android:

```bash
flutter run --flavor dev --dart-define-from-file=config/dev.json
```

iOS (the supplied project has no native flavor schemes):

```bash
flutter run --dart-define-from-file=config/dev.json
```

Before releasing:

```bash
flutter analyze
flutter test --exclude-tags golden
flutter build apk --flavor dev --dart-define-from-file=config/dev.json
```

Use your own Xcode signing team for iOS and your existing Android signing setup. Device SDKs/signing cannot be supplied in a source ZIP.

Read `docs/API_INTEGRATION_AUDIT.md` for all 61 endpoints, the original missing integrations, verification evidence, and remaining backend/release requirements. `docs/APP_FLOW.md` contains the flow diagrams and screen tree. `verification/live_api_results.json` records 38 successful live requests; `verification/dart_core_tests.txt` records eight passing core tests.

Full Flutter/native build and device testing were not completed in this environment. Backend subscription billing, legal URLs, OTP email delivery and password reset require backend work; the source does not fabricate success for those features.
