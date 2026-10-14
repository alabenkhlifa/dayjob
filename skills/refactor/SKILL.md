---
name: refactor
description: Use when the user wants to refactor, clean up, tidy, or simplify existing code without changing what it does — quick wins (unused imports, magic numbers, duplication) or a deeper restructure.
---

# Refactor

Make code easier to read and change without changing what it does. Prove it with the tests, before and after.

## 1. Scope and mode

Target: the file or folder the user named. If none, ask.

Modes:
- **easy** — unused imports and variables, magic values → named constants, duplicated blocks → one function, dead code.
- **hard** — split long functions, clearer names, extract modules or interfaces, reuse existing helpers, simplify conditionals and loops.
- **auto** (no mode given) — read the target, list 3–5 concrete opportunities with `path:line`, recommend easy or hard, and ask which to apply. **Do not change any file until the user picks.**

## 2. Baseline

Find the test and build commands (package.json, Makefile, README, CI config) and run them **before** changing anything. Record the result.

- No tests cover the target → say so and offer to add characterization tests first. Ask before going on.
- Tests already failing → stop and report; don't refactor on a red baseline.

## 3. Change in small steps

- One kind of change at a time; run the tests after each group.
- Match the surrounding style. Reuse helpers that already exist.
- Never change behavior or a public API (exports, function signatures, CLI flags) without the user's approval.
- Never edit, skip, or delete a test to make it pass. Adding tests is fine.

## 4. Verify and report

Run the full test suite (and build) once more, then report:

```
Mode:    <easy | hard>
Changes:
- <path:line> — <what changed> — <why it is better>
Tests:   <command> — <result before> → <result after>
Skipped: <ideas you did not do, and why (risky, changes behavior, out of scope)>
```

## Rules

- No file changes in auto mode until the user picks a mode.
- Tests before and after; never claim green without running them.
- Behavior and public API stay the same unless the user approves.
- Tests are never weakened to pass.
