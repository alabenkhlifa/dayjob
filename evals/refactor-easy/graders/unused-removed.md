---
type: regex
pattern: "require\\('fs'\\)"
match: not_contains
target:
  source: file
  path: src/pricing.js
---
