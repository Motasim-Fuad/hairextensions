# 0007. Inline errors, silent success

- Status: Accepted
- Date: 2026-10-14

## Context

Snackbars disappear before they are read, stack up, cover the bottom actions this design relies on, and separate the
error from the control that caused it.

## Decision

Success and navigation give no extra feedback; the next screen or the changed state is the confirmation. Errors render
as inline text directly below the related field or button, with Retry where retrying makes sense. Buttons accept
`errorText` and `onRetry` for this. A manual toast exists for rare, explicitly designed cases and is never shown
automatically.

## Consequences

- Errors stay visible until resolved and point at their cause.
- Each state needs an error field next to what it describes, so states carry a little more structure.
- The Figma "saved" toast and PDF error dialog were replaced by this pattern.
