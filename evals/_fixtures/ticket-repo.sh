#!/usr/bin/env bash
# Builds a repo where ticket keys appear the way real projects write them: lowercase in branch names,
# in trailing parentheses (sometimes two), or not at all. SHOP-123 is only in a branch name.
set -euo pipefail

ago() { echo "$(( $(date +%s) - $1 * 86400 )) +0000"; }

commit_as() { # <days ago> <name> <email> <subject>
  GIT_AUTHOR_DATE="$(ago "$1")" GIT_COMMITTER_DATE="$(ago "$1")" \
    git -c user.name="$2" -c user.email="$3" commit -q --allow-empty -m "$4"
}

me=("Dev Me" "dev@example.com")
mate=("Sam Other" "sam@example.com")

git init -q -b main
git config user.name "${me[0]}"
git config user.email "${me[1]}"
git config commit.gpgsign false
git config core.hooksPath /dev/null

mkdir -p src
echo "module.exports = {};" > src/auth.js
git add src/auth.js
commit_as 6 "${me[@]}" "SHOP-50: set up project skeleton"

git checkout -q -b feat/shop-123-token-refresh
echo "module.exports = { refresh: () => true };" > src/auth.js
git add src/auth.js
commit_as 1 "${me[@]}" "feat(auth): refresh expired login tokens before API calls"

git checkout -q main
echo "module.exports = { round: (n) => Math.round(n * 100) / 100 };" > src/tax.js
git add src/tax.js
commit_as 1 "${me[@]}" "fix(invoices): round tax to cents on invoices and receipts (SHOP-127, SHOP-128)"

echo "module.exports = { search: () => [] };" > src/search.js
git add src/search.js
commit_as 1 "${me[@]}" "perf(search): cache product search results"

echo '{ "lodash": "4.17.21" }' > deps.json
git add deps.json
commit_as 1 "${mate[@]}" "chore(deps): bump lodash (SHOP-999)"

git checkout -q -b fix/shop-130-payment-retry
echo "// retry failed payments up to 3 times" > src/payments.js
git add src/payments.js
commit_as 0 "${me[@]}" "fix(payments): add payment retry skeleton"
echo "module.exports = { retry: () => {} };" >> src/payments.js
