---
name: review-pr
description: Use when the user asks to review a pull request, merge request, branch, or diff, e.g. "review PR 42", "review this branch before I merge", or wants a self-review before asking others.
---

# Review PR

Find what would hurt in production, explain it so the author can fix it fast, and say it kindly.

## 1. Get the diff

```bash
base=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
[ -n "$base" ] || base=$(git branch --list main master | head -1 | tr -d ' *')
```

`<base>` is the remote's default branch (snippet above), falling back to `main` or `master`.

- PR number or URL with `gh` → `gh pr view <n>` (title, body, linked issue) and `gh pr diff <n>`.
- PR number without `gh` → GitHub: `git fetch origin pull/<n>/head:pr-<n>`; GitLab: `git fetch origin merge-requests/<n>/head:mr-<n>`; otherwise ask for the branch name.
- Branch → `git log <base>..<branch>` and `git diff <base>...<branch>`.
- Nothing given → the current branch against its base.

Read the description first and judge the code against what it claims to do.

## 2. Read beyond the diff

For each changed function, read the whole file at the PR's version (`git show <branch>:<path>`) and cite line numbers from that version. Never check out or switch the user's branch. Find its callers with `grep`. Bugs hide in what the diff does not show: callers relying on old behavior, places that also needed a change, tests that no longer test anything.

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

Offer to post only when a PR/MR exists; otherwise the review stays in chat. To post: `gh pr review <n> --comment --body-file <file>`. Never approve or request changes on GitHub without an explicit yes.

## Rules

- Read-only: never edit, commit, or push the author's code during a review.
- Don't run, install, or test the PR's code unless the user says so — derive failing inputs by reading the code. You may offer to run it.
- About the code, not the person. Ask when unsure: "Could this be null when…?"
- No finding without evidence. Say "not sure" rather than guess.
