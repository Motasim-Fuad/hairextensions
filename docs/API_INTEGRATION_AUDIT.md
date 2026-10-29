# API integration audit — 29 October 2026

The live OpenAPI document at `http://56.228.53.36:8000/openapi.json` matched the attached Swagger JSON exactly when retrieved. The full contract is included as `docs/openapi.json`.

## Coverage

- 61 operations in Swagger: 37 mobile, 22 owner/admin, 2 hosting health probes.
- 14 mobile operations had no effective integration in the original ZIP. Seven other existing operations had incomplete screen/action coverage.
- All 37 mobile operations now have a source integration and reachable flow. Admin operations belong to the separate owner's dashboard and are listed below rather than exposed to stylist accounts.
- 38 live HTTP calls succeeded, covering 37 unique operations (35 mobile plus both health probes). The live run did not execute resend-OTP or invoice deletion. Their existing integrations remain in the source.
- The live test used a disposable QA account, verified logo signature, all three PDF signatures, and equality of preview and saved totals; the QA account was deleted successfully.
- Eight standalone Dart core tests passed: six refresh/session tests and two pricing/invoice mapping tests. The selected core files passed static analysis. Full Flutter analysis, widget/golden tests and native builds were not run.

## Missing integrations found and addressed

| Area | Original gap | Updated behavior |
|---|---|---|
| Session | Refresh token ignored; authenticated 401 immediately deleted session | Persist access + refresh tokens, coalesce concurrent refresh requests, rotate tokens and retry once. Network/5xx failures retain credentials; rejected refresh ends session. Late refresh cannot restore a logged-out account. |
| Auth | No account read, server logout or account deletion UI | Read `/auth/me` after login, revoke session on logout, and confirmation before account deletion. |
| Images | Logo was local only | Multipart server upload; authenticated logo download; deletion; local picker preview and broken-image fallback. |
| Pricing | Builder and review relied on local totals | Debounced server preview plus a required server-price check before review; quote responses retain server totals. |
| PDF | Locally generated PDF | Backend quote PDF, invoice PDF and cost-sheet PDF used for preview and share. Invoice cost sheets use the source quote ID. |
| Quotes | Duplicate copied a local draft; edit PATCH not reachable from detail | Server duplicate; existing quote edit retains ID and uses PATCH. |
| Status | Only sent / paid actions surfaced | Allowed quote lifecycle actions and all three invoice payment states. Detail updates immediately after conversion/payment. |
| Library | Only hair products editable; detail GET unused | Full library item manager supports hair, labour, service, material and fee create/read/update/delete. |
| Dashboard | Totals derived from incomplete summary rows | `/dashboard` metrics for the current calendar month, with retry after failure. The server's collected metric is labelled Collected. |
| Profile | Edits reported local success and were queued | Final setup and settings edits await backend acknowledgement. Intermediate signup steps remain local until final submission. Additional backend pricing and invoice settings have a Settings editor. |

## Flow changes

Registration → OTP verification → business/profile setup → Login → Home.

The backend requires authentication for business creation. After OTP verification the app obtains a temporary signup session using the registration credentials to save the profile, then explicitly revokes that session when setup finishes. No paywall is inserted into registration/login/setup. A returning account restores its server business after login and opens Home.

Settings contains exactly one Subscription entry. The paywall is never an automatic redirect. Since this backend has no subscription billing/receipt/entitlement API, live builds show billing as unavailable rather than unlocking a fake paid plan. Mock mode remains available for UI development.

## Backend / release items still required

1. `/v1/app-config` currently returns null `terms_url`, `privacy_url`, `support_email` and `support_whatsapp`. Publish the owner's approved legal documents and configure their URLs in the backend. The app uses these URLs when supplied, and shows an unavailable message while they are absent. The About screen is present. No invented legal policy is presented as the owner's policy.
2. Swagger explicitly says subscription handling is not in this API version. Real store billing requires purchase/restore integrations and backend receipt verification/entitlement APIs. Admin plan configuration is not a mobile purchase API.
3. Swagger says OTP email delivery is not wired and local responses include the OTP. Configure an email provider and production OTP behavior on the backend before release.
4. No password-reset API is present. The app cannot send a genuine password-reset email without that backend endpoint.
5. The supplied API is HTTP. Android cleartext is scoped to the supplied IP; iOS ATS permits the supplied HTTP deployment. Replace the endpoint with HTTPS and restore strict ATS before store/production release.
6. The mobile workflow is for one current studio. The API mentions `X-Business-Id` for multiple studios; no authenticated mobile studio-list/selection contract is provided in this Swagger. Multi-studio account selection needs a confirmed backend contract and UI.
7. Full Flutter setup/build verification was blocked by automatic approval review because the setup command attempted to access cloud metadata at `169.254.169.254`. The standalone Dart core test/analysis path did not use Flutter setup. No claim of native-build, widget or device verification is made. Updated UI goldens need recording on the intended test platform after a verified Flutter setup.

## Complete endpoint inventory

| Method | Path | Scope | Original ZIP | Updated integration / screen | Live test |
|---|---|---|---|---|---|
| GET | /health/live | Hosting health probe | Outside mobile scope | Verified by diagnostic script; not called on every screen | Passed |
| GET | /health/ready | Hosting health probe | Outside mobile scope | Verified by diagnostic script; not called on every screen | Passed |
| GET | /v1/app-config | Mobile app | Existing | Launch gates; Terms, Privacy and support URLs | Passed |
| POST | /v1/auth/register | Mobile app | Existing | Auth / session / Settings account actions | Passed |
| POST | /v1/auth/verify-otp | Mobile app | Existing | Auth / session / Settings account actions | Passed |
| POST | /v1/auth/resend-otp | Mobile app | Existing | Auth / session / Settings account actions | Not executed |
| POST | /v1/auth/login | Mobile app | Existing | Auth / session / Settings account actions | Passed |
| POST | /v1/auth/refresh | Mobile app | Missing | Auth / session / Settings account actions | Passed |
| GET | /v1/auth/me | Mobile app | Missing | Auth / session / Settings account actions | Passed |
| DELETE | /v1/auth/me | Mobile app | Missing | Auth / session / Settings account actions | Passed |
| POST | /v1/auth/logout | Mobile app | Missing | Auth / session / Settings account actions | Passed |
| POST | /v1/businesses | Mobile app | Existing | Setup, profile/defaults and pricing/invoice settings | Passed |
| GET | /v1/business | Mobile app | Existing | Setup, profile/defaults and pricing/invoice settings | Passed |
| PATCH | /v1/business | Mobile app | Partial UI/action coverage | Setup, profile/defaults and pricing/invoice settings | Passed |
| PUT | /v1/business/logo | Mobile app | Missing | Business setup/settings logo; authenticated image display | Passed |
| GET | /v1/business/logo | Mobile app | Missing | Business setup/settings logo; authenticated image display | Passed |
| DELETE | /v1/business/logo | Mobile app | Missing | Business setup/settings logo; authenticated image display | Passed |
| GET | /v1/library | Mobile app | Existing | Library; all-item manager supports hair/labour/service/material/fee | Passed |
| POST | /v1/library | Mobile app | Partial UI/action coverage | Library; all-item manager supports hair/labour/service/material/fee | Passed |
| GET | /v1/library/{item_id} | Mobile app | Missing | Library; all-item manager supports hair/labour/service/material/fee | Passed |
| PATCH | /v1/library/{item_id} | Mobile app | Partial UI/action coverage | Library; all-item manager supports hair/labour/service/material/fee | Passed |
| DELETE | /v1/library/{item_id} | Mobile app | Partial UI/action coverage | Library; all-item manager supports hair/labour/service/material/fee | Passed |
| POST | /v1/quotes/preview | Mobile app | Missing | Debounced builder pricing and mandatory price check before review | Passed |
| GET | /v1/quotes | Mobile app | Existing | Quote builder/review/history/detail actions | Passed |
| POST | /v1/quotes | Mobile app | Existing | Quote builder/review/history/detail actions | Passed |
| GET | /v1/quotes/{quote_id} | Mobile app | Existing | Quote builder/review/history/detail actions | Passed |
| PATCH | /v1/quotes/{quote_id} | Mobile app | Partial UI/action coverage | Quote builder/review/history/detail actions | Passed |
| DELETE | /v1/quotes/{quote_id} | Mobile app | Existing | Quote builder/review/history/detail actions | Passed |
| PATCH | /v1/quotes/{quote_id}/status | Mobile app | Partial UI/action coverage | Quote detail lifecycle actions; share status | Passed |
| POST | /v1/quotes/{quote_id}/duplicate | Mobile app | Missing | Quote detail → Duplicate | Passed |
| POST | /v1/quotes/{quote_id}/invoice | Mobile app | Existing | Quote detail → Convert to invoice | Passed |
| GET | /v1/invoices | Mobile app | Existing | History/detail; delete; unpaid/deposit-paid/paid actions | Passed |
| GET | /v1/invoices/{invoice_id} | Mobile app | Existing | History/detail; delete; unpaid/deposit-paid/paid actions | Passed |
| DELETE | /v1/invoices/{invoice_id} | Mobile app | Existing | History/detail; delete; unpaid/deposit-paid/paid actions | Not executed |
| PATCH | /v1/invoices/{invoice_id}/status | Mobile app | Partial UI/action coverage | History/detail; delete; unpaid/deposit-paid/paid actions | Passed |
| GET | /v1/quotes/{quote_id}/pdf | Mobile app | Missing | Server PDF preview/share | Passed |
| GET | /v1/quotes/{quote_id}/cost-sheet/pdf | Mobile app | Missing | Internal cost sheet preview/share (source quote ID) | Passed |
| GET | /v1/invoices/{invoice_id}/pdf | Mobile app | Missing | Server PDF preview/share | Passed |
| GET | /v1/dashboard | Mobile app | Missing | Home calendar-month totals with retry | Passed |
| GET | /v1/admin/overview | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| GET | /v1/admin/business | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| GET | /v1/admin/businesses | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| GET | /v1/admin/defaults | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| PUT | /v1/admin/defaults | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| POST | /v1/admin/defaults/apply | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| GET | /v1/admin/settings | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| PATCH | /v1/admin/settings | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| GET | /v1/admin/activity | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| GET | /v1/admin/platform/overview | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| GET | /v1/admin/platform/subscribers | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| GET | /v1/admin/platform/subscribers/{subscriber_id} | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| POST | /v1/admin/platform/subscribers/{subscriber_id}/grant-free | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| POST | /v1/admin/platform/subscribers/{subscriber_id}/toggle-status | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| POST | /v1/admin/platform/subscribers/{subscriber_id}/note | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| GET | /v1/admin/platform/activity | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| GET | /v1/admin/platform/plans | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| PUT | /v1/admin/platform/plans | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| GET | /v1/admin/platform/defaults | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| PUT | /v1/admin/platform/defaults | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| GET | /v1/admin/platform/settings | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
| PATCH | /v1/admin/platform/settings | Admin dashboard (separate) | Outside mobile scope | Separate owner/admin dashboard; intentionally not called by stylist app | Not executed |
