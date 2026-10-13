---
tags: [start-ticket]
max_turns: 25
allowed_tools: [Bash, Read, Glob, Grep, Edit, Write, Skill]
---
Start ticket SHOP-42. Requirements are final, no questions needed, and you don't need to wait for plan approval — go ahead and implement:
`checkout(items, code)` applies 10% off the total when `code` is "SAVE10" (case-insensitive). Any other code, or no code, leaves the total unchanged. Codes don't stack. Add tests.
