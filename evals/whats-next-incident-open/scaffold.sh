#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
cat > incident-2026-10-14-search-timeouts.md <<'MD'
# Incident: Search requests time out
Status: Mitigated
Started: 2026-10-14 08:10 UTC
Severity: SEV2

## Impact
About 30% of search requests time out.

## Timeline (UTC)
- 08:10 — Timeouts start.
- 08:40 — Traffic shifted to the healthy region. Status: Mitigated.

## Actions
- [ ] Find why the primary region's search cache is cold — on-call
MD
