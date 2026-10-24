# 0010. Tokens, localization and a single brand color

- Status: Accepted
- Date: 2026-10-14

## Context

Hardcoded strings block localization, scattered numbers make the design drift, and rebranding by search and replace
always misses something.

## Decision

All user-facing text lives in ARB files and is read through `context.l10n`. All sizes, spacing, radii, durations,
shadows and colors come from tokens in `lib/core/theme/tokens`. `BrandPalette.primary` is the only brand color;
tints, the color scheme, shimmer and the dark theme derive from it. The native splash colors mirror the palette and
are regenerated with `make splash`.

## Consequences

- Adding a language is adding `app_<locale>.arb`. Rebranding is one constant plus the splash.
- New values need a token first, which reviews enforce.
- Remote content such as the maintenance message is shown as served, with a localized fallback.
