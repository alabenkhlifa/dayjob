---
name: whats-next
description: Use when the user asks what to work on, what's next, where to start, or opens a session without a clear task (e.g. "good morning", "what now?", "I'm back"). Points them to the dayjob skill that fits this moment.
---

# What's next

Look at where the engineer is in their day and suggest the 1–3 skills that fit right now. Suggest only; never run them yourself.

## Gather context

Run these; skip any that fail and never mention the failure.

```bash
date '+%A %H:%M'
git rev-parse --is-inside-work-tree 2>/dev/null
git status --short --branch
git log -1 --format='%cr'
base=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
[ -n "$base" ] || base=$(git branch --list main master | head -1 | tr -d ' *')
git log --oneline "$base"..HEAD
# task lists this branch changed that still have open items:
git diff --name-only --diff-filter=d "$(git merge-base "$base" HEAD 2>/dev/null)" -- '*.md' ':!incident-*' ':!postmortem-*' 2>/dev/null | xargs grep -l '^ *[-*] \[ \]' 2>/dev/null
# only with a GitHub remote (git remote -v), as the gh account picked below:
gh pr list --search 'review-requested:@me' --limit 5 2>/dev/null
gh pr checks 2>/dev/null
grep -l '^Status: \(Open\|Mitigated\)' incident-*.md 2>/dev/null
grep -l '^Status: Resolved' incident-*.md 2>/dev/null
ls postmortem-*.md 2>/dev/null || true
```

**`gh` account:** the user may have several `gh` accounts, and the active one may not see this repo. Before the first `gh` call, list each account's access:
```bash
for u in $(gh auth status 2>&1 | sed -n 's/.*account \([^ ]*\).*/\1/p'); do echo "$u $(GH_TOKEN=$(gh auth token --user "$u") gh repo view --json viewerPermission -q .viewerPermission 2>/dev/null)"; done; true
```
Pick the first account with ADMIN, MAINTAIN or WRITE, else one with READ or TRIAGE. If none shows a permission, skip every `gh` call. Run every `gh` call as that account, `GH_TOKEN=$(gh auth token --user <account>) gh ...`, with `2>/dev/null`. Never run `gh auth switch`.

If `git rev-parse` prints nothing, this is not a git repo: skip the git and `gh` lines and the rows that need them, and find task lists with these instead:

```bash
grep -l '^ *[-*] \[ \]' tasks.md TODO.md 2>/dev/null
grep -rl --include=tasks.md '^ *[-*] \[ \]' openspec/changes 2>/dev/null || true
```

If MCP tools are available, also check: tickets assigned to me and not started (Jira, Linear, ClickUp, Trello, Asana); 1:1 meetings today (calendar). Otherwise skip.

## Pick

Go down the table; take the first matches, max 3, each skill once.

| Signal | Suggest |
|---|---|
| An `incident-*.md` with `Status: Open` or `Status: Mitigated` | `incident` |
| An `incident-*.md` with `Status: Resolved` and no `postmortem-<same date>-<same slug>.md` | `postmortem` |
| Failing checks on the current branch | `fix-bug` |
| Uncommitted changes (ignore `incident-*.md` and `postmortem-*.md`) | `ship-pr` |
| An open item (`- [ ]`) in a task list found above | `start-ticket`, naming the first open item (number and title) |
| Commits not yet on `<base>`, and no open item in a task list | `ship-pr` |
| Review requests waiting | `review-pr` |
| Start of the day or a greeting | `standup` |
| Friday afternoon | `weekly-update` |
| A 1:1 on the calendar today | `one-on-one` |
| A ticket assigned and not started | `start-ticket` |
| Nothing above | `start-ticket`, reason "no open work found on <branch>"; or ask what they're working on |

Only suggest skills that are installed (they appear in your available skills); skip any row whose skill isn't installed.

If another installed skill or command does the same job as a row's skill (a project `/commit` for `ship-pr`, a task runner like `/opsx:apply` for `start-ticket`), suggest that one in its place.

`<base>` is the remote's default branch (snippet above), falling back to `main` or `master`.

If `<base>` comes back empty, skip the "commits not yet on `<base>`" check.

## Output

```
**Right now:** `<skill>` — <reason with evidence: branch, file count, PR number>
**Also:** `<skill>` — <reason>

Say "go" to start `<first skill>`.
```

The reply is exactly this template: the "Right now" line, 0–2 "Also" lines, and the "Say go" line.

## Rules

- Every reason cites something concrete you saw. No generic advice.
- Never start the suggested skill, and never commit, push, or edit anything, until the user says so.
- A failed command is not a finding; don't mention tool errors.
