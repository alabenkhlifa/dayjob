---
name: fix-bug
description: Use when the user reports a bug, error, exception, stack trace, failing test, or broken behavior and wants it fixed.
---

# Fix bug

Find the root cause, fix it there, and prove nothing else broke. No workarounds.

## 1. Understand

Restate expected vs actual behavior, how to reproduce, and the exact error. Ask only if you cannot reproduce or the expected behavior is unclear.

## 2. Reproduce

Run the failing test or the reproduction steps and capture the exact failure. If it does not reproduce, say so and ask for more detail. Never fix blind.

## 3. Find the root cause

Trace from the symptom to its origin: read the code path, check `git log -L` or `git blame` on suspect lines and recent changes (`git log --since=<date> -- <path>`). Write it down before changing anything:

```
Root cause:    <what is wrong, at path:line>
Evidence:      <the line, log, or test output that proves it>
Introduced by: <commit, if found>
```

Do not move on until you can point to the line.

## 4. Design the fix

Fix the cause, not the symptom. Before editing, `grep` for other callers so the fix does not break them. If the fix changes behavior other code relies on, tell the user first.

Never: catch-and-ignore, special-case the failing input, weaken or delete a test, disable a check.

## 5. Implement

Make the smallest change at the root cause, in the surrounding code's style. Add a regression test if nothing covers the bug.

## 6. Verify

Re-run the failing test, then the full test suite, and the build if there is one. Report:

```
Root cause: <one line, path:line>
Fix:        <one line>
Tests:      <command> — <result>
```

## Rules

- The test is the spec. Change a test only if the user confirms the test itself is wrong.
- Never say it is fixed without a passing run.
