#!/usr/bin/env bash
set -euo pipefail
# The project has its own command for working through openspec tasks.
mkdir -p .claude/commands
cat > .claude/commands/apply-task.md <<'MD'
---
description: Implement the next open task from an openspec change's tasks.md, then tick it.
---
Read `openspec/changes/<change>/tasks.md`, implement the first open task, run the tests, and tick it.
MD
bash "$(dirname "$0")/../whats-next-mid-task/scaffold.sh"
git switch -q main
git add .claude
git -c user.name="Dev Me" -c user.email="dev@example.com" commit -q -m "chore: add apply-task command"
git switch -q feature/order-history
git -c user.name="Dev Me" -c user.email="dev@example.com" merge -q --no-edit main
