#!/usr/bin/env bash
# Checks every skills/<name>/SKILL.md against the dayjob skill anatomy.
set -uo pipefail
shopt -s nullglob

root="${1:-.}"
max_lines=150
fail=0

err() { echo "FAIL $1: $2"; fail=1; }

frontmatter_value() { # <file> <key>
  awk -v key="$2" '
    /^---$/ { n++; next }
    n == 1 && $0 ~ "^" key ":" { sub("^" key ":[ ]*", ""); gsub(/^["\x27]|["\x27]$/, ""); print; exit }
  ' "$1"
}

dirs=("$root"/skills/*/)
[ ${#dirs[@]} -gt 0 ] || { echo "no skills found"; exit 0; }

for dir in "${dirs[@]}"; do
  name=$(basename "$dir")
  file="${dir}SKILL.md"
  [ -f "$file" ] || { err "$name" "missing SKILL.md"; continue; }
  [ "$(head -n 1 "$file")" = "---" ] || err "$name" "SKILL.md must start with frontmatter"
  [ "$(grep -c '^---$' "$file")" -ge 2 ] || err "$name" "frontmatter is not closed"
  [ "$(frontmatter_value "$file" name)" = "$name" ] || err "$name" "frontmatter name must equal folder name"
  desc=$(frontmatter_value "$file" description)
  [[ "$desc" == "Use when"* ]] || err "$name" "description must start with 'Use when'"
  [ ${#desc} -le 1024 ] || err "$name" "description longer than 1024 characters"
  lines=$(wc -l < "$file" | tr -d ' ')
  [ "$lines" -le "$max_lines" ] || err "$name" "SKILL.md is $lines lines (max $max_lines)"
  grep -rqE '\.\./|skills/[a-z-]+/' "$dir" && err "$name" "references a file outside its own folder"
done

[ $fail -eq 0 ] && echo "ok: ${#dirs[@]} skills"
exit $fail
