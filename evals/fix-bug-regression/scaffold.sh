#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
cat > src/checkout.js <<'JS'
const { cartTotal } = require('./cart');

function checkout(items) {
  if (!items) return { ok: false, reason: 'empty cart' };
  return { ok: true, total: cartTotal(items) };
}

module.exports = { checkout };
JS
git add src/checkout.js
git -c user.name="Sam Other" -c user.email="sam@example.com" commit -q -m "refactor: tidy checkout guard"
