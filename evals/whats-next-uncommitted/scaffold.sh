#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
git switch -q -c feature/order-history
cat > src/history.js <<'JS'
function orderHistory(orders) {
  return orders.slice().sort((a, b) => b.date - a.date);
}

module.exports = { orderHistory };
JS
