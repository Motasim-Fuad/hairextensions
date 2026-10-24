# Security

## Data on the device

| Data | Where | Protection |
| --- | --- | --- |
| Access and refresh tokens | `flutter_secure_storage` | iOS Keychain (this device only, after first unlock); Android Keystore-backed encryption. Excluded from backups. |
| Business profile, quotes, settings, sync queue | sqflite in the app sandbox | OS sandbox and full-disk encryption. Included in OS backups so data survives a new phone until cloud sync exists. |
| Logos | Application support directory | OS sandbox. Backed up with the database. |
| Device id | Settings table | Not secret. A restored backup keeps it, and the app opens a fresh device session because tokens are not restored. |

The database is not encrypted at rest beyond the OS. It holds business and client contact details but no payment
data. If client data later becomes sensitive enough, add SQLCipher (`sqflite_sqlcipher`) with the key in secure
storage; the database layer is isolated in `lib/core/database`, so the change stays contained.

## Network

- HTTPS only. Android blocks cleartext through `network_security_config.xml`; iOS App Transport Security is left at
  its secure default.
- User-installed certificate authorities are trusted only in Android debug builds, for debugging proxies.
- **Certificate pinning** (`lib/core/network/security/certificate_pinning.dart`) pins the SHA-256 of the API's leaf
  certificate when `ENABLE_CERT_PINNING` is true and `CERT_SHA256` lists fingerprints (comma-separated, colons
  allowed). Get a fingerprint with:

  ```bash
  openssl s_client -connect api.example.com:443 -servername api.example.com </dev/null 2>/dev/null \
    | openssl x509 -outform der | openssl dgst -sha256
  ```

  Always ship the current and the next certificate's fingerprints before rotating. A missed rotation cuts every
  installed app off the API until users update; force update and maintenance mode still work because they come
  from Remote Config, not the API.
- Token refresh runs once for concurrent requests. A rejected refresh token ends the session; a server that cannot be
  reached never logs the device out.

## Code and builds

- Release builds are obfuscated (`--obfuscate --split-debug-info`) and Android release builds are shrunk by R8.
- `AppLogger` and the HTTP logging interceptor are silent outside debug mode. Never log tokens, request bodies or
  personal data even in debug.
- Crash reports and analytics are off until the user consents, and crash reporting is disabled in debug builds.
- No secrets in the app: `config/*.json` and Remote Config values ship to every user. Keys that must stay secret
  belong on the backend.
- Remote Config is not trusted for security decisions. It can hide features or require updates, but entitlement is
  verified by the store, and the cached subscription status is only an offline convenience.

## Permissions

| Permission | Used for | Requested |
| --- | --- | --- |
| Photos | Choosing a logo | iOS shows the system picker, which needs no permission on iOS 14+. The purpose string is still required. |
| Camera | Taking a logo photo | Only if that option is offered. |
| Location | Declared because `geolocator` is linked | Never requested by current screens. Remove `geolocator` if location stays unused, so the purpose string can go too. |
| Notifications | Push, when `pushNotifications` is on | Only after the user opts in. |

On iOS, `permission_handler` only compiles in the permissions listed in the `Podfile` `post_install` block. Keep that
list in sync with `AppPermission`, or new permissions always report denied.

## Repository and CI

- Signing keys, store credentials and `android/key.properties` are git-ignored; CI writes them from secrets and
  deletes them after the build.
- Release secrets live in a `production` GitHub environment with required reviewers.
- Every PR runs a gitleaks secret scan. Dependabot opens weekly dependency updates.

## Reporting

Report vulnerabilities privately to the support address in `config/prod.json`, not in public issues.
