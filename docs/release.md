# Release

## Versioning

`pubspec.yaml` holds the marketing version. The release workflow overrides it from the git tag (`v1.4.0` becomes
build name `1.4.0`) and sets the build number to the workflow run number plus `BUILD_NUMBER_OFFSET`. Build numbers
must only grow on both stores; raise the offset if builds were ever uploaded by hand.

## Local release builds

```bash
make build-android   # build/app/outputs/bundle/prodRelease/app-prod-release.aab
make build-ios       # build/ios/ipa/*.ipa
```

Both use `--obfuscate --split-debug-info=build/symbols/<platform>`. Keep the symbols for every shipped build;
without them Crashlytics stack traces cannot be read. CI stores them as artifacts for 90 days.

Without `android/key.properties`, local Android release builds are signed with the debug key. That is fine for
testing on a device and is rejected by Play, which is intended.

## One-time setup

### Android signing

1. Create an upload key: `keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`.
2. Enroll in Play App Signing when creating the app in Play Console (Google keeps the app signing key).
3. For local signed builds create `android/key.properties` (git-ignored):

   ```properties
   storeFile=/absolute/path/upload-keystore.jks
   storePassword=...
   keyAlias=upload
   keyPassword=...
   ```

4. Store the keystore in a password manager. Losing the upload key needs a reset through Play support.

### Play API access

Create a service account in Google Cloud, grant it Release Manager in Play Console for this app only, and download
its JSON key.

### iOS signing

1. Create a private git repository for certificates and run `bundle exec fastlane match appstore` once from `ios/`.
2. Create an App Store Connect API key (App Manager role) and download the `.p8`.
3. Put your team ID in `ios/ExportOptions.plist`.
4. Commit `Gemfile.lock` after the first `bundle install`.

### GitHub secrets

Add these to a `production` environment with required reviewers, so a tag alone cannot publish:

| Secret | Value |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | `base64 -i upload-keystore.jks` |
| `ANDROID_STORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD` | From step 1 |
| `PLAY_SERVICE_ACCOUNT_JSON` | Full JSON key contents |
| `ASC_KEY_ID`, `ASC_ISSUER_ID` | From App Store Connect |
| `ASC_KEY_P8_BASE64` | `base64 -i AuthKey_XXXX.p8` |
| `MATCH_GIT_URL`, `MATCH_PASSWORD` | match repository and its passphrase |
| `MATCH_GIT_BASIC_AUTHORIZATION` | `base64` of `user:token` with read access to the match repository |
| `FIREBASE_ANDROID_APP_ID`, `FIREBASE_IOS_APP_ID` | Prod Firebase app ids; when empty, symbol upload is skipped |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Key with the Firebase Crashlytics Admin role, for symbol upload |

## Release checklist

1. `config/prod.json` has the real API, privacy, terms and support values (the workflow refuses `example.com`).
2. Certificate fingerprints are set if pinning is on (see [security.md](security.md)).
3. Remote Config defaults in `FeatureFlagDefaults` match what the console will serve on day one
   (`firebase/remote_config_template.json`, kept in sync by a test; see [firebase-setup.md](firebase-setup.md)).
4. `make check` and `make goldens` pass.
5. Tag and push: `git tag v1.4.0 && git push origin v1.4.0`.
6. Approve the `production` environment in GitHub Actions.
7. Smoke test the internal and TestFlight builds: first launch, setup, offline use, upgrade from the previous build.
8. Promote with a staged rollout: `cd android && bundle exec fastlane promote to:production rollout:0.1`, then
   widen while crash-free users stay above the agreed threshold. On iOS use phased release in App Store Connect.
   Stages and halt criteria are in [store-rollout.md](store-rollout.md).

## Emergency levers

- **Stop a bad feature:** switch its `FeatureKey` off in Remote Config. The route becomes unreachable and its tab
  hides on the next fetch, with no release.
- **Force an update:** raise `min_supported_version` in Remote Config.
- Remote Config changes reach devices within the 12 hour fetch interval, sooner for users who open the app.
- **Maintenance:** turn on `maintenance_mode` with an optional `maintenance_message`.
- **Halt a rollout:** pause the staged rollout in Play Console or the phased release in App Store Connect.
