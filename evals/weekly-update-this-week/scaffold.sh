#!/usr/bin/env bash
# One commit just before this week's Monday 00:00 (inside "last 7 days", outside "this week"),
# one commit now, and a teammate's commit now.
set -euo pipefail

now=$(date +%s)
monday=$(( now - ($(date +%u) - 1) * 86400 - 10#$(date +%H) * 3600 - 10#$(date +%M) * 60 - 10#$(date +%S) ))

commit_at() { # <epoch> <name> <email> <subject>
  GIT_AUTHOR_DATE="$1 +0000" GIT_COMMITTER_DATE="$1 +0000" \
    git -c user.name="$2" -c user.email="$3" commit -q -m "$4"
}

me=("Dev Me" "dev@example.com")
mate=("Sam Other" "sam@example.com")

git init -q -b main
git config user.name "${me[0]}"
git config user.email "${me[1]}"
git config commit.gpgsign false
git config core.hooksPath /dev/null

mkdir -p src
echo "module.exports = {};" > src/search.js
git add src/search.js
commit_at $(( monday - 3600 )) "${me[@]}" "feat(search): move product search to Elasticsearch"

echo "module.exports = { apply: (code) => code };" > src/coupons.js
git add src/coupons.js
commit_at $(( now - 60 )) "${me[@]}" "feat(checkout): accept coupon codes at checkout"

echo '{ "lodash": "4.17.21" }' > deps.json
git add deps.json
commit_at $(( now - 60 )) "${mate[@]}" "chore(deps): bump lodash"
