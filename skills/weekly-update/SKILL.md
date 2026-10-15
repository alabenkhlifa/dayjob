---
name: weekly-update
description: Use when the user wants a weekly status update, end-of-week report, or "what did I get done this week" summary for their manager or team.
---

# Weekly update

Draft a paste-ready weekly update from real activity: Shipped / In progress / Risks / Asks.

## Gather context

Run these; skip any command that fails and keep going.

1. Who am I: `git config user.name` and `git config user.email`.
2. Window: the last 7 days (`--since="7 days ago 00:00"`). A range the user gives wins.
3. Audience: the manager unless the user says the team. Ask only if it changes the content.
4. My commits on all branches:
   `git log --all --no-merges --author="<email>" --since="<window start>" --format='%h %ad %s' --date=short`
   If that is empty, retry with `--author="<name>"`. If `user.email` and `user.name` are both empty, ask the user which author to use; never run `git log` with an empty `--author`.
5. My PRs, only with a GitHub remote: `gh pr list --author @me --state all --search "updated:>=<YYYY-MM-DD>" --limit 30 2>/dev/null`.
6. Work in progress: `git status --short --branch` and branches with my recent commits that are not on the base branch (`<base>`, via `$base`):
   ```bash
   base=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
   [ -n "$base" ] || base=$(git branch --list main master | head -1 | tr -d ' *')
   ```
   If `<base>` comes back empty, skip the not-on-base check.
7. If a Jira or Linear MCP tool is available: my tickets moved this week. Otherwise skip.

If steps 4, 5 and 7 find nothing for this identity, reply: "No activity found for <email> in the last 7 days." Then ask what to include. Never fill the gap with other people's work, and never name or describe their commits, even to say you left them out.

## Write

- **Shipped:** outcomes, not activity. "Customers can check out from the cart page", not "added checkout.js". Group related commits and PRs into one bullet.
- **In progress:** each item with its next step, and an ETA only if you know one.
- **Risks:** only real ones: failing CI, a PR stuck in review, something the user said. Otherwise "None".
- **Asks:** decisions or help the user needs from the reader. Otherwise "None".
- Manager audience: lead with impact, keep it short. Team audience: a bit more technical detail is fine.
- Plain language. No commit hashes, no `feat:`/`fix:` prefixes.
- Do not run tests or other project code.

## Output template

```
**Weekly update — <Mon DD> to <Mon DD>**

**Shipped**
- <outcome>

**In progress**
- <item> — <next step>

**Risks**
- None

**Asks**
- None
```

Max 4 bullets per section. If a Slack, email or ticket tool is available, end with "Want me to send it?" and send only after an explicit yes. Otherwise end after the template.

## Rules

- Every bullet is backed by a commit, PR, ticket, or the user's own words.
- Never include work by other authors. Always pass `--author` to `git log`.
- Normal case: the reply is the update and the closing line. No notes about sources, skipped commits, other authors, or how you gathered data.
- Never show tool errors in the update; leave that source out.
- Never send anything without an explicit yes.
