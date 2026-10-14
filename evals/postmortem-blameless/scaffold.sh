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
- 14:21 — Support reports customer complaints; on-call paged.
- 14:30 — On-call finds the timeout change in the deploy log.
- 14:38 — Config change reverted and redeployed.
- 14:43 — Error rate back to normal. Status: Mitigated.
- 15:10 — Confirmed resolved.

## Actions
- [x] Revert timeout config — on-call
MD
