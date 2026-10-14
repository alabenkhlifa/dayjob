#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "$0")/../_fixtures/sample-repo.sh" --fixed
git switch -q -c feature/apply-discount
cat > src/discount.js <<'JS'
function applyDiscount(total, code) {
  if (code = 'SAVE10') {
    return total * 0.9;
  }
  return total;
}

module.exports = { applyDiscount };
JS
git add src/discount.js
git -c user.name="Sam Other" -c user.email="sam@example.com" commit -q -m "feat: apply SAVE10 discount"
git switch -q main
