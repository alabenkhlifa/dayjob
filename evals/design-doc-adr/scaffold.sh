#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
mkdir -p docs/adr
cat > docs/adr/0001-record-architecture-decisions.md <<'MD'
# ADR 0001: Record architecture decisions

Status: Accepted
Date: 2026-09-01

## Context
We need to record the architectural decisions made on this project.

## Decision
We will use Architecture Decision Records, as described by Michael Nygard.

## Consequences
See Michael Nygard's article.
MD
git add docs/adr
git -c user.name="Dev Me" -c user.email="dev@example.com" commit -q -m "docs: add ADR 0001"
