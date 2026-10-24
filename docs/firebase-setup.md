# Firebase setup

The app runs without Firebase: with no config files every Firebase-backed service is a silent no-op, which is how
the mock environment works. Follow these steps once per environment before the first real build.

## 1. Projects

Create one Firebase project per flavor so test traffic never pollutes production numbers and a broken flag change in
staging cannot reach users:

| Flavor | Project id (edit `.firebaserc` if different) | Google Analytics |
| --- | --- | --- |
| dev | `p2p-dev` | Optional |
| staging | `p2p-staging` | On, separate property |
| prod | `p2p-prod` | On |

When creating the Analytics property: data retention 14 months, Google signals off, ads personalization off. The app
shows no ads.

## 2. Register the apps

| Platform | Flavor | Identifier |
| --- | --- | --- |
| Android | dev | `com.hairextensions.hairextensions.hairextensions.dev` |
| Android | staging | `com.hairextensions.hairextensions.hairextensions.staging` |
| Android | prod | `com.hairextensions.hairextensions.hairextensions` |
| iOS | prod | `com.hairextensions.hairextensions.hairextensions` |

SHA certificate fingerprints are not needed; the app uses no Firebase Auth or Dynamic Links. Register the iOS dev and
staging apps after the Xcode schemes from [ios-flavors.md](ios-flavors.md) exist.

## 3. Config files

- Android: put each `google-services.json` in `android/app/src/<flavor>/`. The Google Services Gradle plugin turns on
  automatically once any of these files exists, and from then on every flavor you build needs its file.
- iOS: drag the prod `GoogleService-Info.plist` into `ios/Runner` in Xcode and tick the Runner target. Copying the
  file in Finder is not enough; it must be in the target. Per-flavor plists are covered in ios-flavors.md.

These files identify the project but are not secrets. Commit them so CI can build.

## 4. Consent and collection

Collection is off at the native level (`AndroidManifest.xml` meta-data and `Info.plist` keys) and stays off until the
user opts in through `ConsentManager.update`. `MonitoringInitializer` then enables Crashlytics, Analytics and
Performance individually. Debug builds never send analytics or crashes; use a profile build
(`flutter run --profile`) to verify events end to end.

There is no consent prompt or Settings toggle yet. Until one calls `ConsentManager.update`, production sends nothing,
so build that screen before relying on any dashboard below.

## 5. Crashlytics

1. Open Crashlytics in each project and finish the setup screen.
2. iOS native symbols: in Xcode add a Run Script build phase after "Embed Frameworks" to the Runner target:

   ```bash
   "${PODS_ROOT}/FirebaseCrashlytics/run"
   ```

   Input files: `${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}` and
   `${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${PRODUCT_NAME}`. The release lane
   also uploads dSYMs.
3. Dart symbols: release builds are obfuscated, so traces are unreadable without `build/symbols`. The release
   workflow uploads them when `FIREBASE_*_APP_ID` secrets are set. Manually:

   ```bash
   firebase crashlytics:symbols:upload --app=<FIREBASE_APP_ID> build/symbols/android
   ```

4. Alerts: enable new fatal issue, regressed issue and velocity alerts, routed to email or Slack.
5. Verify once with a profile build after opting in: trigger a test error through a temporary button that calls
   `NonFatal.record`, then remove it.

## 6. Performance Monitoring

Enable it in each project. What the app reports:

| Name | Kind | Meaning |
| --- | --- | --- |
| `app_startup` | Trace, metric `first_frame_ms` | `main()` to first frame (engine start before `main` is not included; Firebase also records its own `_app_start`) |
| `screen_<feature>_<screen>` | Trace, attributes `feature`, `outcome` (`loaded` or `left`) | First build until the screen's data is shown |
| HTTP requests | Network metrics | Recorded by `PerformanceInterceptor` for every API call |

Alerts to set in prod: `app_startup` p90 above 1.5 s, any screen trace p90 above 1 s, API response p90 above 2 s.

## 7. Analytics

Register custom definitions (Admin, Custom definitions) so parameters appear in reports:

- Event-scoped dimensions: `feature`, `action`, `source`, `currency`.
- Event-scoped metrics: `duration_ms` (milliseconds), `value`, `item_count`.
- User-scoped dimensions: `plan`, `beta_cohort`, `app_version`, `business_currency`.

Mark as key events: `setup_completed`, `quote_saved`, `trial_started`, `invoice_paid`.

Event names live in `lib/core/analytics/analytics_event_names.dart`. Screen views are logged automatically per named
route and tab.

DebugView with a profile build:

```bash
adb shell setprop debug.firebase.analytics.app com.hairextensions.hairextensions.hairextensions.dev
```

On iOS add `-FIRDebugEnabled` to the scheme's launch arguments.

## 8. Remote Config

The template `firebase/remote_config_template.json` holds every parameter with the same defaults compiled into the
app; a test fails if they drift. Publish it with the Firebase CLI:

```bash
npm install -g firebase-tools && firebase login
firebase deploy --only remoteconfig -P dev     # then staging and prod
```

Deploying replaces the whole template, including conditions. After you add conditions in the console, pull the
template back before the next deploy: `firebase remoteconfig:get -P prod -o firebase/remote_config_template.json`.

Useful conditions:

- **Staged feature rollout:** condition "User in random percentile" up to 10%, set the feature parameter to `true`
  for it, then widen.
- **Beta testers:** a custom signal condition on `beta_cohort` equal to the cohort name passed to
  `BetaTargeting.joinCohort`. That method is meant to be called from a beta invite deep link, which is not wired yet.
- **By version:** a custom signal condition on `app_version`, for example to enable a feature only on builds that
  contain it.

Timing: the app fetches after the first frame and on resume, at most once every 12 hours per device in release. A
change, including maintenance mode and kill switches, therefore reaches everyone within about 12 hours, and active
users sooner. If faster kill switches matter more than the extra fetches, lower `_releaseFetchInterval` in
`FirebaseRemoteConfigSource`.

## 9. Cloud Messaging (later)

`firebase_messaging` is a dependency and the `pushNotifications` flag exists (off), but no token registration or
message handling is implemented. When building it: upload an APNs authentication
key under Project settings, Cloud Messaging; enable the Push Notifications capability and the Remote notifications
background mode in Xcode; and declare `POST_NOTIFICATIONS` for Android 13+. Notification taps route through
`NotificationRouteResolver`, which accepts only allow-listed route names.

## 10. CI secrets

Add to the `production` GitHub environment:

| Secret | Value |
| --- | --- |
| `FIREBASE_ANDROID_APP_ID` | Prod Android app id (`1:...:android:...`), Project settings |
| `FIREBASE_IOS_APP_ID` | Prod iOS app id |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Service account key with the Firebase Crashlytics Admin role |

## 11. Privacy and deletion

- Withdrawing consent (`ConsentManager.update` with `false`) disables collection for the rest of the session and
  future launches.
- Analytics user deletion: Admin, Data deletion requests, or the User Deletion API with the app instance id.
- Crashlytics data is kept 90 days and can be deleted per project on request.
