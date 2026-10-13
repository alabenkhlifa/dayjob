#!/usr/bin/env bash
# Builds a small Node shop repo in the current directory with dated commits from two authors.
# Usage: sample-repo.sh [--fixed]   (--fixed also commits a working cartTotal so tests pass)
set -euo pipefail

ago() { echo "$(( $(date +%s) - $1 * 86400 )) +0000"; }

commit_as() { # <days ago> <name> <email> <subject>
  GIT_AUTHOR_DATE="$(ago "$1")" GIT_COMMITTER_DATE="$(ago "$1")" \
    git -c user.name="$2" -c user.email="$3" commit -q -m "$4"
}

me=("Dev Me" "dev@example.com")
mate=("Sam Other" "sam@example.com")

git init -q -b main
git config user.name "${me[0]}"
git config user.email "${me[1]}"

cat > package.json <<'JSON'
{ "name": "sample-shop", "version": "1.0.0", "private": true, "scripts": { "test": "node --test" } }
JSON
echo "node_modules/" > .gitignore
git add package.json .gitignore
commit_as 6 "${me[@]}" "chore: set up eslint and project skeleton"

mkdir -p src test
cat > src/cart.js <<'JS'
function cartTotal(items) {
  return items.reduce((sum, item) => sum + item.price, 0);
}

module.exports = { cartTotal };
JS
git add src/cart.js
commit_as 6 "${me[@]}" "feat: add cart module"

cat > src/checkout.js <<'JS'
const { cartTotal } = require('./cart');

function checkout(items) {
  return { ok: true, total: cartTotal(items) };
}

module.exports = { checkout };
JS
git add src/checkout.js
commit_as 1 "${me[@]}" "feat: add checkout button to cart page"

cat > src/checkout.js <<'JS'
const { cartTotal } = require('./cart');

function checkout(items) {
  if (items.length === 0) return { ok: false, reason: 'empty cart' };
  return { ok: true, total: cartTotal(items) };
}

module.exports = { checkout };
JS
git add src/checkout.js
commit_as 1 "${me[@]}" "fix: handle empty cart in checkout"

echo '{ "lodash": "4.17.21" }' > deps.json
git add deps.json
commit_as 1 "${mate[@]}" "chore: bump lodash to 4.17.21"

echo "# sample-shop" > README.md
git add README.md
commit_as 1 "${mate[@]}" "docs: add README for onboarding"

cat > test/cart.test.js <<'JS'
const test = require('node:test');
const assert = require('node:assert');
const { cartTotal } = require('../src/cart');

test('empty cart totals zero', () => {
  assert.strictEqual(cartTotal([]), 0);
});

test('multiplies price by quantity', () => {
  assert.strictEqual(cartTotal([{ price: 2, qty: 3 }, { price: 5, qty: 1 }]), 11);
});
JS
git add test/cart.test.js
commit_as 0 "${me[@]}" "test: add cart quantity test"

if [ "${1:-}" = "--fixed" ]; then
  cat > src/cart.js <<'JS'
function cartTotal(items) {
  return items.reduce((sum, item) => sum + item.price * item.qty, 0);
}

module.exports = { cartTotal };
JS
  git add src/cart.js
  commit_as 0 "${me[@]}" "fix: multiply price by quantity"
fi
