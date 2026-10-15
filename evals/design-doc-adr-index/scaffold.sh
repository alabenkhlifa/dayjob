#!/usr/bin/env bash
# ADR folder with 3-digit numbers and a README index table.
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
mkdir -p docs/adr
cat > docs/adr/001-record-architecture-decisions.md <<'MD'
# ADR 001: Record architecture decisions

Status: Accepted
Date: 2026-09-01

## Context
We need to record the architectural decisions made on this project.

## Decision
We will use Architecture Decision Records, as described by Michael Nygard.

## Consequences
See Michael Nygard's article.
MD
cat > docs/adr/README.md <<'MD'
# Architecture Decision Records

## Index of ADRs

| ADR | Title | Status | Date |
|-----|-------|--------|------|
| [001](001-record-architecture-decisions.md) | Record architecture decisions | Accepted | 2026-09-01 |
MD
git add docs/adr
git -c user.name="Dev Me" -c user.email="dev@example.com" commit -q -m "docs: add ADR 001"
