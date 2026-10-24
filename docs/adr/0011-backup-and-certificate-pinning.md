# 0011. Backup policy and certificate pinning

- Status: Accepted
- Date: 2026-10-14

## Context

Two security defaults pull against product needs. Disabling OS backups protects data but, with no cloud sync yet,
means a new phone loses every quote. Certificate pinning stops interception by rogue CAs but can lock every installed
app out of the API if a certificate rotates unexpectedly.

## Decision

OS backups stay on for the database and logos. Secure storage is excluded on Android through `backup_rules.xml` and
`data_extraction_rules.xml`; on iOS the Keychain item is device-only. Restored installs keep their data and open a new
device session.

Pinning is implemented for both HTTP clients and is controlled by `ENABLE_CERT_PINNING` and `CERT_SHA256` per
environment. It pins leaf certificate SHA-256 fingerprints and requires the current and next fingerprints before any
rotation. The release workflow refuses to build if pinning is enabled without fingerprints. Pinning ships off until
the production API and its certificate plan exist.

## Consequences

- Users keep their work across devices through OS backup, at the cost of business data existing in their backup.
- Pinning adds an operational duty to every certificate rotation. Force update and maintenance still reach users
  because they come from Remote Config, not the pinned API.
- Revisit the backup decision when cloud sync ships.
