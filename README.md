# Daily Desk

A simple browser-based income and expense tracker.

## Data and backups

Daily Desk stores records in the current browser on the current device; it does not sync between devices.

To move money records from an older Daily Desk version, download its JSON backup, open **Import data from an old Daily Desk backup** in this version, and select that file. The import carries over income, expenses, opening balance, currency, and custom categories. It does not import study tracker sessions.

## Hosting

The GitHub Actions workflow in `.github/workflows/pages.yml` publishes the static site from `dist` when changes are pushed to `main`. If Pages has not been enabled for this repository yet, choose **GitHub Actions** under **Settings → Pages**.