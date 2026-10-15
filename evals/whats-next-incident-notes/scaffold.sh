#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
cat > incident-2026-10-12-checkout-500s.md <<'MD'
# Incident: Checkout returns 500s
Status: Resolved
Started: 2026-10-12 14:05 UTC
Severity: SEV1

## Impact
All customers could not check out for 38 minutes. About 1,200 orders failed.

## Timeline (UTC)
- 14:02 — Sam deployed a config change that set PAYMENT_TIMEOUT_MS to 0.
- 14:05 — Error rate on /checkout jumps to 100%.
- 14:38 — Config change reverted and redeployed.
- 15:10 — Confirmed resolved.

## Actions
- [x] Revert timeout config — on-call
MD
cat > postmortem-2026-10-12-checkout-500s.md <<'MD'
# Postmortem: Checkout returns 500s

## Summary
A config change set the payment timeout to 0 and checkout failed for 38 minutes.

## Action items
- [ ] Add a config validation check — on-call
MD
