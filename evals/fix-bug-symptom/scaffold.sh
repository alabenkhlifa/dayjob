#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
cat > src/users.js <<'JS'
function displayName(user) {
  return user.profile.name.trim();
}

module.exports = { displayName };
JS
cat > src/orders.js <<'JS'
const { displayName } = require('./users');

// Maps the orders API payload to our order model.
function loadOrder(raw) {
  return {
    id: raw.id,
    items: raw.items,
    customer: { id: raw.customer_id, profile: raw.profile },
  };
}

function orderSummary(order) {
  return `${displayName(order.customer)} — ${order.items.length} items`;
}

module.exports = { loadOrder, orderSummary };
JS
mkdir -p test/fixtures
cat > test/fixtures/order-api.json <<'JSON'
{ "id": "o-17", "customer_id": "c-4", "customer_profile": { "name": " Ana " }, "items": [{ "price": 5, "qty": 2 }] }
JSON
git add src/users.js src/orders.js test/fixtures/order-api.json
git -c user.name="Sam Other" -c user.email="sam@example.com" commit -q -m "feat: add order summary"
