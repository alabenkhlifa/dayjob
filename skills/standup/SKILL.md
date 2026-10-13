---
name: standup
description: Use when the user wants to prepare a daily standup, scrum update, or "what did I do yesterday" summary, or asks what they worked on recently.
---

# Standup

Draft a paste-ready standup from real activity: Yesterday / Today / Blockers.

## Gather context

Run these; skip any command that fails and keep going. If `git` itself will not run, read `.git/config` (identity, remote) and `.git/logs/HEAD` (commit history with author, time, subject) directly instead of giving up.

1. Who am I: `git config user.name` and `git config user.email`.
2. Window: since the last working day. `date +%u` gives 1 on Monday → window starts Friday 00:00; otherwise yesterday 00:00. A range the user gives wins.
3. My commits on all branches:
   `git log --all --no-merges --author="<email>" --since="<window start>" --format='%h %ad %s' --date=short`
   If that is empty, retry with `--author="<name>"`.
4. My PRs, only if `git remote -v` shows a GitHub remote: `gh pr list --author @me --state all --search "updated:>=<YYYY-MM-DD>" --limit 20 2>/dev/null`. Always append `2>/dev/null` to `gh` calls.
5. Work in progress: `git status --short --branch`. Then run the project's tests once (e.g. `npm test 2>&1 | tail -30`) to see what is failing; a failing test is the best hint for Today.
6. If a Jira or Linear MCP tool is available: my in-progress tickets. Otherwise skip.

If steps 3–6 find nothing for this identity, reply: "No activity found for <email> since <date>." Then ask what to include. Never fill the gap with other people's work, and never name or describe their commits, even to say you left them out. You may offer to check another identity.

## Write

- Group commits by theme; one bullet can cover several commits. Drop noise (typos, merges, wip) unless it is all there is.
- Plain language a teammate outside the code understands. No `feat:`/`fix:` prefixes, no hashes.
- **Today:** name the specific failing test or unfinished file when you found one. Infer from the current branch, uncommitted work, open PRs, failing tests, in-progress tickets. Mark guesses with "(confirm)".
- **Blockers:** only real ones: failing CI, a PR waiting on review for more than a day, something the user said. Otherwise "None".

## Output template

```
**Yesterday**
- <theme>: <what changed and why it matters>

**Today**
- <next step> (confirm)

**Blockers**
- None
```

Max 3 bullets per section, nothing before or after the template except the closing line. End with one line: "Want me to post it?" Post to Slack, Teams or a ticket only after an explicit yes, and only if a tool for it is available.

## Rules

- Every bullet is backed by a commit, PR, ticket, or the user's own words.
- Never include commits by other authors. Never run `git log` without `--author`, so other people's commits never appear in your own tool output either.
- The reply is the standup and the closing line only. No notes about sources, skipped commits, other authors, or how you gathered data.
- Never show tool errors (like `gh` not being logged in) in the standup; just leave that source out.
- Never post anywhere without an explicit yes.
