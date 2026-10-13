#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh"
git config user.name "New Hire"
git config user.email "new.hire@example.com"
