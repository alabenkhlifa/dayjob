---
name: standup
description: Use when the user wants to prepare a daily standup, scrum update, or "what did I do yesterday" summary, or asks what they worked on recently.
---

# Standup

Draft a paste-ready standup from real activity: Yesterday / Today / Blockers.

## Gather context

Run these; skip any command that fails and keep going. If `git` itself will not run, say so and ask the user what they worked on.

1. Who am I: `git config user.name` and `git config user.email`.
2. Window: since the last working day. If `date +%u` prints 1 (Monday), use `--since="last friday 00:00"`; otherwise `--since="yesterday 00:00"`. A range the user gives wins. For `gh` dates use `d=$(date -v-1d +%F 2>/dev/null || date -d yesterday +%F)` (Monday: `-v-3d` / `"3 days ago"`).
3. My commits on all branches, with the branch each came from (`%S`):
   `git log --all --source --no-merges --author="<email>" --since="<window start>" --format='%h %S %ad %s' --date=short`
   If that is empty, retry with `--author="<name>"`. If `user.email` and `user.name` are both empty, ask the user which author to use; never run `git log` with an empty `--author`.
4. My PRs, only if `git remote -v` shows a GitHub remote: `gh pr list --author @me --state all --search "updated:>=<YYYY-MM-DD>" --limit 20 2>/dev/null`. Always append `2>/dev/null` to `gh` calls.
5. Work in progress: `git status --short --branch`.
6. If a board tool is available (Jira, Linear, ClickUp, Trello, Asana, GitHub or GitLab issues, as MCP tools): my in-progress tickets with their titles. Otherwise skip.
7. Ticket refs: for each commit, take its ref from the subject; if the subject has none, from its branch name (`%S`); then from its PR title. One commit can carry several. Learn the format from the repo's own branches and commits:
   - a key like `PROJ-279` (Jira, Linear, ClickUp custom IDs), often lowercase in branch names: `fix/proj-279-midnight` → `PROJ-279`
   - `CU-86c0abc` (ClickUp), `#45` (GitHub or GitLab issue), `AB#123` (Azure Boards), a Trello card link
   - A trailing `(#15)` from a squash merge is the PR number, not a ticket.

If steps 3, 4 and 6 (commits, PRs, tickets) find nothing for this identity, reply: "No activity found for <email> since <date>." Then ask what to include. Uncommitted work from step 5 may inform Today but does not count as Yesterday activity. Never fill the gap with other people's work, and never name or describe their commits, even to say you left them out. You may offer to check another identity.

## Write

- Group commits by ticket, then by theme; one bullet can cover several commits. Drop noise (typos, merges, wip) unless it is all there is.
- Start a bullet with its ticket refs as the board shows them (`PROJ-279:`, `PROJ-74, PROJ-111:`, `#45:`). Work with no ref in git, PRs or the board gets a bullet with no ref.
- Plain language a teammate outside the code understands. No `feat:`/`fix:` prefixes, no commit hashes.
- **Today:** name the specific unfinished file or branch when you found one. Infer from the current branch (name it), uncommitted work, what your latest commits leave unfinished (e.g. a test added but no fix yet), open PRs, in-progress tickets. Do not run tests or other project code. Mark guesses with "(confirm)".
- **Blockers:** only real ones: failing CI, a PR waiting on review for more than a day, something the user said. Otherwise "None".

## Output template

```
**Yesterday**
- <ticket refs, if any>: <what changed and why it matters>

**Today**
- <ticket refs, if any>: <next step> (confirm)

**Blockers**
- None
```

Max 3 bullets per section. In the normal case, add nothing before or after the template except the closing line (a one-line caveat is fine when it changes how to read the standup). If a Slack, Teams or ticket tool is available, end with one line: "Want me to post it?" and post only after an explicit yes. Otherwise end after the template.

## Rules

- Every bullet is backed by a commit, PR, ticket, or the user's own words.
- Every ticket ref is copied from a commit, branch name, PR, or board tool. Never guess one.
- Never include commits by other authors. Never run `git log` without `--author`, so other people's commits never appear in your own tool output either.
- Normal case: the reply is the standup and the closing line. No notes about sources, skipped commits, other authors, or how you gathered data. The no-activity reply is the exception: it follows the no-activity rule above instead.
- Never show tool errors (like `gh` not being logged in) in the standup; just leave that source out.
- Never post anywhere without an explicit yes.
