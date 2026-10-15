#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../whats-next-mid-task/scaffold.sh"
sed -i.bak 's/- \[ \]/- [x]/' openspec/changes/order-history/tasks.md && rm openspec/changes/order-history/tasks.md.bak
git add openspec
git -c user.name="Dev Me" -c user.email="dev@example.com" commit -q -m "feat: paginate order history and show it on the account page"
