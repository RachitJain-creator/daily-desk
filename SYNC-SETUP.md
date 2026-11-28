# Daily Desk cloud sync setup

Cloud sync is opt-in. The website keeps working locally if it is not configured. The browser uses Supabase Auth email links and stores one validated Daily Desk data snapshot per account. No existing local data is uploaded until the signed-in user accepts the notice and confirms the first upload.

## Supabase project setup

1. Project `hgpckldyfshtkfvbmkrz` is active in South Asia (Mumbai).
2. The project already has both sync tables and row-level security policies. Anonymous access is revoked; reads, inserts, and updates to the records snapshot require the matching `auth.uid()` and active consent. An owner can still delete their snapshot after withdrawing consent. [`supabase/schema.sql`](supabase/schema.sql) is the reproducible setup script.
3. In Authentication URL Configuration, set the Site URL and allow this redirect URL: `https://rachitjain-creator.github.io/daily-desk/`.
4. `dist/supabase-config.js` contains the project URL and **publishable key**. This config is public in the website. Never put a `service_role` or secret key in the repository or browser.
5. Email magic-link sign-in is used. Configure the Site URL and allowed redirect above. Supabase email sign-in is enabled by default; for reliable public use, configure SMTP and review its processing and retention terms. The default email service may have sending limits.
6. The cloud privacy notice in `dist/index.html` names Supabase, the data fields, the Mumbai region, and the privacy contact.
7. Verify an account can sign in, only see its own records, export its cloud snapshot, and delete the snapshot. Do not upload personal records during setup or verification.

## Data and controls

- `daily_desk_records` stores income/expense entries, opening balance, currency, and custom categories as a JSON snapshot.
- `daily_desk_sync_access` stores the account ID and consent / withdrawal timestamps. A withdrawn account cannot read or write the snapshot through the client policies.
- A user's cloud snapshot can be downloaded as JSON. “Delete cloud data & stop sync” removes the snapshot, marks consent withdrawn, and signs out the current device. Existing local data remain on that device.
- Full sign-in account deletion is a separate request to `jainrachit133@gmail.com`; the current static site cannot delete Supabase Auth users itself. Process these requests promptly and confirm completion.
- The design does not supply a breach response operation, a processor contract review, or a legal compliance certification. The site operator must maintain those operational processes and keep the privacy notice accurate.

## Current status

The app uses email magic links and per-account row-level security. Configure the Supabase Auth Site URL and redirect allow-list as shown above before first sign-in. Existing records remain local until the user opts in and confirms the first upload.

