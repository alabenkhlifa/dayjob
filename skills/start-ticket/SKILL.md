---
name: start-ticket
description: Use when the user starts work on a ticket, issue, story, or feature request (a ticket id like PROJ-123, a GitHub issue, or pasted requirements) and wants it understood, planned, and implemented.
---

# Start ticket

Turn a ticket into the smallest correct change that follows the codebase's patterns: understand → plan → confirm → build → verify.

## 1. Get the ticket

- A ticket id like `PROJ-123` and a Jira or Linear MCP tool is available → fetch summary, description, acceptance criteria.
- A GitHub issue number or URL → `gh issue view <n>`.
- Otherwise use the text the user gave. If there is none, ask for it.

## 2. Find the gaps — stop here first

List what is unclear: expected behavior, inputs and validation, edge cases, error handling, UI, environments. Ask only the questions whose answers change the implementation, most important first, max 5. Then state your understanding in 3–5 lines and wait.

**Do not edit or create any file until the user confirms.** Exception: the user already said the requirements are final and to go ahead. Then state your understanding in one line and continue.

## 3. Read the codebase

Find similar features to copy, helpers and constants to reuse, tests covering this area, and per-environment config. Cite `path:line` for each.

## 4. Plan — confirm before code

```
Change: <path> — <what>
Create: <path> — <why> (prefer none)
Reuse:  <path:line> — <what>
Tests:  <what you will add and run>
Risks:  <what could break>
```

Wait for a yes, unless the user pre-approved in step 2.

## 5. Build

- Match the surrounding code's style and patterns exactly.
- Only what the ticket asks: no extra features, no drive-by refactors.
- Reuse existing helpers; use named constants, not magic values.
- No dead code, no unused imports.
- Add or update tests for the new behavior when the project has tests.

## 6. Verify

Find the build and test commands (package.json, Makefile, README, CI config) and run them. Fix failures you caused. Report:

```
Done:    <one line>
Changed: <files>
Tests:   <command> — <passed/failed counts>
Open:    <assumptions or follow-ups>
```

## Rules

- No file edits before the user confirms your understanding, unless they pre-approved.
- Never claim tests pass without running them.
- When a requirement is ambiguous, ask; don't guess.
