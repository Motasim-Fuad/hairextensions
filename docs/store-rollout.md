# Store rollout

How a build goes from a tag to every user on Google Play and the App Store. Building and signing are in
[release.md](release.md); this guide covers the store consoles and the rollout decisions.

## Before the first submission

Shared requirements:

- Real `PRIVACY_POLICY_URL`, `TERMS_URL` and `SUPPORT_EMAIL` in `config/prod.json`. The release preflight rejects
  `example.com`.
- A consent prompt that calls `ConsentManager.update`. Without it no analytics or crash data is collected.
- Store listing assets: icon, feature graphic (Play), screenshots of the real flows (setup, quote builder, invoice,
  PDF), a short description and a full description. Screenshots must not show placeholder screens.
- `store_url_android` and `store_url_ios` in Remote Config once the listings exist, so the force update screen can
  open them.

## Google Play

### One-time setup

1. Create the app in Play Console: default language, app (not game), free or paid, declarations.
2. App integrity: keep Play App Signing (default). The keystore in `key.properties` is the upload key; if it is lost
   Google can reset it, which is not possible for an app signing key.
3. Create a service account with release permissions, download its key and store it as `PLAY_SERVICE_ACCOUNT_JSON`.
   The first upload must be manual: build `make build-android` and upload the `.aab` to Internal testing in the
   console, then fastlane can upload later builds.

### App content answers

| Section | Answer |
| --- | --- |
| Privacy policy | `PRIVACY_POLICY_URL` |
| App access | All functionality is available without login |
| Ads | No ads |
| Content rating | Utility or productivity, no user-generated content shared between users: rated Everyone |
| Target audience | 18 and over |
| News app | No |
| Financial features | None of the listed (the app creates quotes and invoices; it does not move money) |
| Health apps | No |
| Government apps | No |

### Data safety

Answer from what the app actually sends. With consent given:

| Data type | Collected | Shared | Purpose | Optional |
| --- | --- | --- | --- | --- |
| App interactions (Analytics events) | Yes | No | Analytics | Yes, consent |
| Crash logs | Yes | No | App functionality | Yes, consent |
| Diagnostics (performance traces) | Yes | No | Analytics | Yes, consent |
| Device or other IDs (Firebase installation id, device session id) | Yes | No | Analytics, app functionality | No |

- Data is encrypted in transit (HTTPS only; cleartext is disabled).
- Business data (products, quotes, invoices, customer names) stays on the device until cloud sync ships. When the
  backend and `cloudSync` go live, add "Personal info: name, email, phone" and "Financial info: purchase history"
  if customer details are synced, and add a deletion request URL.
- Users can request deletion: required once any account or synced data exists.

### Release tracks

| Stage | Audience | Minimum time | Go criteria |
| --- | --- | --- | --- |
| Internal testing | Team, up to 100 testers | Each build | Smoke test of setup, quote, invoice, PDF share on one low-end and one recent device |
| Closed testing | Beta testers (Google group) | 3 to 7 days | No new crash cluster; crash-free users at least 99.5% |
| Production 5% | Random users | 48 hours | Vitals below thresholds; no new top-5 crash |
| Production 20% | | 48 hours | Same |
| Production 50% | | 24 hours | Same |
| Production 100% | | | |

New personal developer accounts must run a closed test with at least 12 testers for 14 days before production
access; plan for it.

Promote from `android/` with `bundle exec fastlane promote to:production rollout:0.05`, or in the console. Widen
an existing staged rollout in the console (Release, Production, Manage rollout); the lane promotes from internal.

### Halt criteria

Halt the staged rollout (Release, Production, Halt rollout) when any of these holds for the new version:

- User-perceived crash rate at or above 1.09% or ANR rate at or above 0.47% (Play's bad behavior thresholds; the app
  loses visibility above them).
- Crash-free users in Crashlytics below 99.5%, or any new fatal issue affecting more than 0.5% of users.
- A data loss or wrong price calculation report, at any volume.

A halted release can be resumed or replaced. Users who already updated keep the build, so pair a halt with a kill
switch: turn the affected feature flag off in Remote Config, or raise `min_supported_version` once a fixed build
is live.

## App Store

### One-time setup

1. Register the bundle id `com.hairextensions.hairextensions.hairextensions` in the Apple Developer portal.
2. Create the app record in App Store Connect: name, primary language, SKU, bundle id.
3. Create the App Store Connect API key used by fastlane (`ASC_*` secrets) and the match certificates
   repository (`MATCH_*` secrets), then replace `YOUR_TEAM_ID` in `ios/ExportOptions.plist`.
4. The app targets iPhone and iPad (`TARGETED_DEVICE_FAMILY = 1,2`). iPad screenshots are then required and review
   checks the iPad layout. If iPad is not designed yet, set the family to iPhone only before the first submission;
   it is hard to drop iPad support later.

### App Privacy (nutrition labels)

With consent given, the app collects, none of it used for tracking and none linked to the user's identity:

- Usage data: product interaction (Analytics).
- Diagnostics: crash data, performance data.
- Identifiers: device id (Firebase installation and analytics instance ids).

No IDFA is read and there are no ads, so App Tracking Transparency is not needed. Revisit the labels when cloud sync
or accounts ship.

### Export compliance

`ITSAppUsesNonExemptEncryption` is `false` in `Info.plist`: the app only uses HTTPS and OS encryption, which is
exempt. No per-build question will be asked.

### Age rating and review notes

- Age rating questionnaire: all "None"; rated 4+.
- Review notes: "No login is required. Open the app, complete the business setup, then create a quote from the
  center button. All data is stored on the device." Provide a demo video link if review asks about any feature.
- The permission strings in `Info.plist` must describe a real use. Remove camera, photo or location keys if the
  shipped build never requests them; unused purpose strings are a common rejection reason.

### TestFlight and release

1. Every tag uploads to TestFlight through `fastlane beta`.
2. Internal testers (up to 100 App Store Connect users) get builds without review.
3. External testers need a one-time beta review per version; use them for the same window as Play closed testing.
4. Submit for review with "Manually release this version" so the release happens alongside Play.
5. Turn on phased release (7 days: 1%, 2%, 5%, 10%, 20%, 50%, 100%). Users can still update manually, and the
   phased release can be paused for up to 30 days in total.
6. Halt criteria are the same as Play's, using Crashlytics and the App Store Connect crash metrics. Pause the phased
   release and fix forward; an expedited review can be requested for critical fixes.

## Subscriptions (when the paywall ships)

The paywall is a placeholder and `SubscriptionService` is a local cache; purchases are mocked only in the mock
environment. Before enabling the `subscriptions` flag in production:

- Play: create the subscription product and base plans; add the billing permission through the purchase library;
  configure Real-time developer notifications to the backend.
- App Store: sign the Paid Apps agreement, create a subscription group and products, add App Store Server
  Notifications V2 to the backend.
- Validate receipts on the backend, not in the app.
- The paywall must show price, period, auto-renew terms, links to terms and privacy policy, and a Restore purchases
  button (App Store guideline 3.1.2).
- Update the data safety form and privacy labels with purchase history.

## Every release

1. Bump nothing by hand: the tag sets the version and CI sets the build number.
2. Write release notes for both stores (keep them under 500 characters for Play).
3. Check Remote Config: any flag the release depends on is off, ready to turn on after rollout.
4. Watch Crashlytics and vitals daily until 100%.
5. After 100%, consider raising `min_supported_version` only for builds that are broken or insecure. Forcing updates
   for cosmetic reasons costs users.
