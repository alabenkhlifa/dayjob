#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
commit() { git -c user.name="Dev Me" -c user.email="dev@example.com" commit -q -m "$1"; }

git switch -q -c feature/order-history
mkdir -p openspec/changes/order-history
cat > openspec/changes/order-history/tasks.md <<'MD'
# Tasks: order-history

## 1. Backend
- [ ] 1.1 Add `orderHistory()` that sorts orders newest first
- [ ] 1.2 Unit tests for the sort order
- [ ] 1.3 Paginate `orderHistory()` (20 orders per page)

## 2. UI
- [ ] 2.1 Show the order history on the account page
MD
git add openspec
commit "docs(openspec): add order-history change"

cat > src/history.js <<'JS'
function orderHistory(orders) {
  return orders.slice().sort((a, b) => b.date - a.date);
}

module.exports = { orderHistory };
JS
git add src/history.js
commit "feat: add orderHistory sorted newest first"

cat > test/history.test.js <<'JS'
const test = require('node:test');
const assert = require('node:assert');
const { orderHistory } = require('../src/history');

test('sorts newest first', () => {
  assert.deepStrictEqual(orderHistory([{ date: 1 }, { date: 2 }]), [{ date: 2 }, { date: 1 }]);
});
JS
git add test/history.test.js
sed -i.bak 's/- \[ \] 1\.1/- [x] 1.1/; s/- \[ \] 1\.2/- [x] 1.2/' openspec/changes/order-history/tasks.md && rm openspec/changes/order-history/tasks.md.bak
git add openspec
commit "test: cover orderHistory sort order"
