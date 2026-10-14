#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
cat > src/checkout.js <<'JS'
const { cartTotal } = require('./cart');

function checkout(items) {
  if (items.length === 0) return { ok: false, reason: 'empty cart' };
  const total = cartTotal(items);
  return { ok: true, total, currency: 'EUR' };
}

module.exports = { checkout };
JS
