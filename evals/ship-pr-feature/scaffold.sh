#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
git switch -q -c feature/discount-codes
cat > src/discount.js <<'JS'
const DISCOUNT_CODE = 'SAVE10';
const DISCOUNT_RATE = 0.1;

function applyDiscount(total, code) {
  if (!code || code.toUpperCase() !== DISCOUNT_CODE) return total;
  return total * (1 - DISCOUNT_RATE);
}

module.exports = { applyDiscount };
JS
cat > src/checkout.js <<'JS'
const { cartTotal } = require('./cart');
const { applyDiscount } = require('./discount');

function checkout(items, code) {
  if (items.length === 0) return { ok: false, reason: 'empty cart' };
  return { ok: true, total: applyDiscount(cartTotal(items), code) };
}

module.exports = { checkout };
JS
