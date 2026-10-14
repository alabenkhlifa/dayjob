#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
cat > src/checkout.js <<'JS'
const { cartTotal } = require('./cart');
const PAYMENT_TIMEOUT_MS = 0;

function checkout(items) {
  if (items.length === 0) return { ok: false, reason: 'empty cart' };
  if (PAYMENT_TIMEOUT_MS <= 0) throw new Error('payment client timed out');
  return { ok: true, total: cartTotal(items) };
}

module.exports = { checkout };
JS
git add src/checkout.js
git -c user.name="Sam Other" -c user.email="sam@example.com" commit -q -m "chore: tune payment client timeout"
