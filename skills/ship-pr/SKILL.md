---
name: ship-pr
description: Use when the user wants to commit their work, write commit messages, ship a branch, push, or open or prepare a pull request (PR/MR) and its description.
---

# Ship PR

Turn the working tree into clean commits and a PR description a reviewer can read in a minute.

## 1. Look

```bash
base=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
[ -n "$base" ] || base=$(git branch --list main master | head -1 | tr -d ' *')
```

```bash
git status --short --branch
git diff --stat; git diff --cached --stat; git diff --cached --name-only
git log --oneline <base>..HEAD
git log -10 --format=%s <base>
```

`<base>` is the remote's default branch (snippet above), falling back to `main` or `master`. Also look for a PR template: `.github/pull_request_template.md` or `.github/PULL_REQUEST_TEMPLATE/`.

If `<base>` comes back empty (no `origin/HEAD` and no `main` or `master`), ask the user which branch is the base before going on.

## 2. Guard

- **On the base branch with changes:** create a branch first, `git switch -c <type>/<short-slug>`, named after the change. Never commit to the base branch unless the user explicitly asks to commit to it.
- **Never stage secrets or junk:** `.env*`, `*.pem`, `*.key`, credential files, `node_modules/`, build output, large binaries. If any are untracked, leave them out, tell the user, and suggest a `.gitignore` line. If one is already staged (check `git diff --cached --name-only`), unstage it with `git restore --staged <file>`, tell the user, and suggest `.gitignore`.
- **Incident notes stay out:** leave `incident-*.md` and `postmortem-*.md` unstaged unless the user asks to commit them.
- **Stage by explicit path.** Never `git add -A`, `git add .`, `git add --all`, or `git commit -a`.
- Run the project's tests or lint if it has them; report failures before committing.

## 3. Commit

One concern per commit. Follow the repo's message style from step 1; default to conventional commits: `type(scope): imperative summary`, max 72 characters, with a body explaining why when it is not obvious.

## 4. PR description

Use the repo's template if there is one. Otherwise:

```
## What
- <what changes for users or callers>

## Why
<the problem, or the ticket link>

## How to test
<steps or commands>

## Risk
<what could break: migrations, flags, config>
```

The title follows the commit style.

## 5. Hand off

Show the commits made and the PR draft, then ask: "Push and open the PR?" Only after a yes:

```bash
git push -u origin <branch>
gh pr create --title "<title>" --body-file <file>
```

If the remote is not GitHub (e.g. GitLab) or `gh` is missing, give the push command and the compare/MR URL or paste-ready text instead of `gh pr create`.

## Rules

- Never push or open a PR without an explicit yes.
- Never commit to the base branch unless the user explicitly asks to.
- Never stage secrets; never use `add -A`, `add .`, or `commit -a`.
