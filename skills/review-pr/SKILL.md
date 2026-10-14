---
name: review-pr
description: Use when the user asks to review a pull request, merge request, branch, or diff, e.g. "review PR 42", "review this branch before I merge", or wants a self-review before asking others.
---

# Review PR

Find what would hurt in production, explain it so the author can fix it fast, and say it kindly.

## 1. Get the diff

- PR number or URL → `gh pr view <n>` (title, body, linked issue) and `gh pr diff <n>`.
- Branch → `git log <base>..<branch>` and `git diff <base>...<branch>`.
- Nothing given → the current branch against its base.

Read the description first and judge the code against what it claims to do.

## 2. Read beyond the diff

For each changed function, open the whole file and its callers (`grep`). Bugs hide in what the diff does not show: callers relying on old behavior, places that also needed a change, tests that no longer test anything.

## 3. Check, in this order

1. **Correctness:** logic errors, `=` vs `===`, off-by-one, null or empty input, units, async/await, error paths.
2. **Security:** injection, secrets in code, missing auth checks, unsafe input.
3. **Data:** migrations, backwards compatibility, breaking API changes.
4. **Tests:** is the new behavior covered, and do the tests assert something real?
5. **Readability:** names, dead code — only when it will cause real confusion.

Skip style nits a linter would catch.

## 4. Report

```
**Verdict:** Approve / Approve with comments / Request changes

**Must fix**
1. `path:line` — <problem>. <concrete input → wrong result>. Suggest: <fix>.

**Should fix**
1. `path:line` — ...

**Nice to have** (max 3)

**Good:** <one specific thing done well>
```

Leave out empty sections. Every finding has `path:line`, a concrete failure, and a suggestion.

## 5. Post — only after a yes

Offer to post the review: `gh pr review <n> --comment --body-file <file>`. Never approve or request changes on GitHub without an explicit yes.

## Rules

- Read-only: never edit, commit, or push the author's code during a review.
- About the code, not the person. Ask when unsure: "Could this be null when…?"
- No finding without evidence. Say "not sure" rather than guess.
