# App flow and screen tree

```mermaid
flowchart TD
  Launch["Launch: read local session"] --> Onboarding{"Onboarding completed?"}
  Onboarding -->|No| Intro["Onboarding"]
  Intro --> Login["Login"]
  Onboarding -->|Yes| Session{"Stored session?"}
  Session -->|No| Login
  Session -->|Yes| Home["Home"]
  Login --> Signup["Register + verify OTP"]
  Signup --> Setup["Profile + business setup"]
  Setup --> Save["Save to API; revoke signup session"]
  Save --> Login
  Login -->|Existing business restored| Home
  Login -->|No business| Setup
  Home --> Shell["Main tabs"]
  Shell --> Quotes["Quotes and invoices"]
  Shell --> Library["Library"]
  Shell --> Settings["Settings"]
  Settings --> Subscription["One Subscription entry → paywall"]
  Settings --> Legal["Terms, Privacy, About, support"]
```

```mermaid
flowchart TD
  Build["Quote builder"] --> Price["Debounced API preview"]
  Price --> Review["Server-priced review"]
  Review --> Save["Create / update quote"]
  Save --> Detail["Quote detail"]
  Detail --> PDF["Backend PDF preview / share"]
  Detail --> Status["Allowed lifecycle status"]
  Detail --> Duplicate["Server duplicate"]
  Detail --> Invoice["Create invoice"]
  Invoice --> Payment["Unpaid / deposit paid / paid"]
  Invoice --> InvoicePDF["Backend invoice PDF"]
  Detail --> Cost["Backend internal cost sheet"]
```

Screen tree:

- Launch and onboarding
- Auth: Login, Register, OTP, password-reset screen (backend endpoint required)
- Profile/business setup: identity, contact, quote defaults
- Home: API dashboard, recent documents, new-quote action
- Quotes/invoices: history, builder, review, detail, lifecycle/payment actions, edit, duplicate, delete, PDF/cost sheet
- Library: hair product forms; all-item manager for hair/labour/service/material/fee
- Settings: business profile/logo, quote defaults, numbering, pricing/invoice settings, one Subscription/paywall entry, Terms, Privacy, About, support, logout and delete account

Responsive work includes bounded trailing text, wrapping share/legal actions, scrollable forms and editors, error-image fallbacks, and constrained editor widths. Device widths and large-text accessibility still require the Flutter UI checks described in the audit.
