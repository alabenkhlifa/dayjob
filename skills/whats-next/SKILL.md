---
name: whats-next
description: Use when the user asks what to work on, what's next, where to start, or opens a session without a clear task (e.g. "good morning", "what now?", "I'm back"). Points them to the dayjob skill that fits this moment.
---

# What's next

Look at where the engineer is in their day and suggest the 1–3 dayjob skills that fit right now. Suggest only; never run them yourself.

## Gather context

Run these; skip any that fail and never mention the failure.

```bash
date '+%A %H:%M'
git status --short --branch
git log -1 --format='%cr'
base=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
[ -n "$base" ] || base=$(git branch --list main master | head -1 | tr -d ' *')
git log --oneline "$base"..HEAD
gh pr list --search 'review-requested:@me' --limit 5
gh pr checks
ls incident-*.md
```

If MCP tools are available, also check: tickets assigned to me and not started (Jira, Linear); 1:1 meetings today (calendar). Otherwise skip.

## Pick

Go down the table; take the first matches, max 3.

| Signal | Suggest |
|---|---|
| `incident-*.md` without a "Resolved" line | `incident` |
| `incident-*.md` resolved, no postmortem written | `postmortem` |
| Failing checks on the current branch | `fix-bug` |
| Uncommitted changes, or commits not yet on `<base>` | `ship-pr` |
| Review requests waiting | `review-pr` |
| Start of the day or a greeting | `standup` |
| Friday afternoon | `weekly-update` |
| A 1:1 on the calendar today | `one-on-one` |
| A ticket assigned and not started | `start-ticket` |
| Nothing above | `start-ticket`, reason "no open work found on <branch>"; or ask what they're working on |

Only suggest skills that are installed (they appear in your available skills); skip any row whose skill isn't installed.

`<base>` is the remote's default branch (snippet above), falling back to `main` or `master`.

If `<base>` comes back empty, skip the "commits not yet on `<base>`" check.

## Output

```
**Right now:** `<skill>` — <reason with evidence: branch, file count, PR number>
**Also:** `<skill>` — <reason>

Say "go" to start `<first skill>`.
```

0–2 "Also" lines. Whole reply under 8 lines.

## Rules

- Every reason cites something concrete you saw. No generic advice.
- Never start the suggested skill, and never commit, push, or edit anything, until the user says so.
- A failed command is not a finding; don't mention tool errors.
