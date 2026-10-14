#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
git switch -q -c feature/payments
cat > src/payments.js <<'JS'
function charge(amount) {
  return { charged: amount, provider: process.env.PAYMENT_PROVIDER };
}

module.exports = { charge };
JS
printf 'STRIPE_SECRET_KEY=sk_live_51Hx9fakefakefake\nPAYMENT_PROVIDER=stripe\n' > .env
