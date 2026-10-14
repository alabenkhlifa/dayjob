#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
cat > brag-doc.md <<'MD'
# Brag doc

## 2026-05-04
- Shipped the cart module — first step of the new checkout; unblocked the payments team.

## 2026-06-18
- Cut checkout p95 latency from 900 ms to 300 ms by caching price lookups.

## 2026-07-22
- Mentored Sam through their first on-call week; they handled two pages alone.

## 2026-08-30
- Wrote the ADR for integer-cent totals; adopted by two other teams.

## 2026-09-15
- Fixed the empty-cart checkout bug, which stopped failed orders.
MD
