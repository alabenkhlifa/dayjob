---
name: standup
description: Use when the user wants to prepare a daily standup, scrum update, or "what did I do yesterday" summary, or asks what they worked on recently.
---

# Standup

Draft a paste-ready standup from real activity: Yesterday / Today / Blockers.

## Gather context

Run these; skip any command that fails and keep going. If `git` itself will not run, say so and ask the user what they worked on.

1. Who am I: `git config user.name` and `git config user.email`.
2. Window: since the last working day. `date +%u` gives 1 on Monday → window starts Friday 00:00; otherwise yesterday 00:00. A range the user gives wins.
3. My commits on all branches:
   `git log --all --no-merges --author="<email>" --since="<window start>" --format='%h %ad %s' --date=short`
   If that is empty, retry with `--author="<name>"`.
4. My PRs, only if `git remote -v` shows a GitHub remote: `gh pr list --author @me --state all --search "updated:>=<YYYY-MM-DD>" --limit 20 2>/dev/null`. Always append `2>/dev/null` to `gh` calls.
5. Work in progress: `git status --short --branch`.
6. If a Jira or Linear MCP tool is available: my in-progress tickets. Otherwise skip.

If steps 3, 4 and 6 (commits, PRs, tickets) find nothing for this identity, reply: "No activity found for <email> since <date>." Then ask what to include. Uncommitted work from step 5 may inform Today but does not count as Yesterday activity. Never fill the gap with other people's work, and never name or describe their commits, even to say you left them out. You may offer to check another identity.

## Write

- Group commits by theme; one bullet can cover several commits. Drop noise (typos, merges, wip) unless it is all there is.
- Plain language a teammate outside the code understands. No `feat:`/`fix:` prefixes, no hashes.
- **Today:** name the specific unfinished file or branch when you found one. Infer from the current branch (name it), uncommitted work, what your latest commits leave unfinished (e.g. a test added but no fix yet), open PRs, in-progress tickets. Do not run tests or other project code. Mark guesses with "(confirm)".
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

Max 3 bullets per section. In the normal case, add nothing before or after the template except the closing line (a one-line caveat is fine when it changes how to read the standup). End with one line: "Want me to post it?" Post to Slack, Teams or a ticket only after an explicit yes, and only if a tool for it is available.

## Rules

- Every bullet is backed by a commit, PR, ticket, or the user's own words.
- Never include commits by other authors. Never run `git log` without `--author`, so other people's commits never appear in your own tool output either.
- Normal case: the reply is the standup and the closing line. No notes about sources, skipped commits, other authors, or how you gathered data. The no-activity reply is the exception: it follows the no-activity rule above instead.
- Never show tool errors (like `gh` not being logged in) in the standup; just leave that source out.
- Never post anywhere without an explicit yes.
