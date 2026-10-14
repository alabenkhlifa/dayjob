#!/usr/bin/env bash
# Tests scripts/lint-skills.sh against throwaway skill folders.
set -uo pipefail

lint="$(cd "$(dirname "$0")/.." && pwd)/scripts/lint-skills.sh"
failures=0

make_skill() { # <root> <folder> <name> <description> [extra body line]
  mkdir -p "$1/skills/$2"
  printf -- '---\nname: %s\ndescription: %s\n---\n%s\n' "$3" "$4" "${5:-body}" > "$1/skills/$2/SKILL.md"
}

expect() { # <label> <expected exit> <expected output fragment> <root>
  out=$(bash "$lint" "$4" 2>&1); code=$?
  if [ "$code" -ne "$2" ] || [[ "$out" != *"$3"* ]]; then
    echo "not ok - $1 (exit $code): $out"; failures=$((failures+1))
  else
    echo "ok - $1"
  fi
}

t=$(mktemp -d); make_skill "$t" good good "Use when testing"
expect "valid skill passes" 0 "ok: 1 skills" "$t"

t=$(mktemp -d); make_skill "$t" good good '"Use when quoted"'
expect "quoted description passes" 0 "ok: 1 skills" "$t"

t=$(mktemp -d); make_skill "$t" folder other "Use when testing"
expect "name must match folder" 1 "frontmatter name must equal folder name" "$t"

t=$(mktemp -d); make_skill "$t" good good "Does things"
expect "description must start with Use when" 1 "description must start with 'Use when'" "$t"

t=$(mktemp -d); make_skill "$t" good good "Use when testing" "see ../other/SKILL.md"
expect "no references outside the folder" 1 "references a file outside its own folder" "$t"

t=$(mktemp -d); make_skill "$t" good good "Use when testing" "$(printf 'line\n%.0s' $(seq 1 160))"
expect "max 150 lines" 1 "(max 150)" "$t"

t=$(mktemp -d); mkdir -p "$t/skills/empty"
expect "missing SKILL.md fails" 1 "missing SKILL.md" "$t"

t=$(mktemp -d); mkdir -p "$t/skills"
expect "no skills is fine" 0 "no skills found" "$t"

t=$(mktemp -d); mkdir -p "$t/skills/open"
printf -- '---\nname: open\ndescription: Use when testing\nbody without closing\n' > "$t/skills/open/SKILL.md"
expect "frontmatter must be closed" 1 "frontmatter is not closed" "$t"

[ "$failures" -eq 0 ] && echo "all lint tests passed"
exit "$failures"
