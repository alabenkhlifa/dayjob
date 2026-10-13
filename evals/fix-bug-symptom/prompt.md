---
tags: [fix-bug]
max_turns: 25
allowed_tools: [Bash, Read, Glob, Grep, Edit, Write, Skill]
---
Order summaries crash in production:

    TypeError: Cannot read properties of undefined (reading 'name')
        at displayName (src/users.js:2:23)
        at orderSummary (src/orders.js:13:13)

A sample API payload is in test/fixtures. Please fix it.
