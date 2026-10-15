---
name: one-on-one
description: Use when the user wants to prepare for a 1:1 (one-on-one) meeting with their manager, a report, or a peer — wins, blockers, asks, and topics to raise.
---

# One-on-one

Walk into the 1:1 with your wins, blockers and asks ready, instead of "uh, things are fine".

## Gather context

Run these; skip any command that fails and keep going.

1. Who it's with: manager (default), a report, or a peer. Take it from the user's words.
2. Window: since the last 1:1 if the user says when; otherwise the last 14 days (`--since="14 days ago 00:00"`).
3. Who am I: `git config user.name` and `git config user.email`. If `user.email` and `user.name` are both empty, ask the user which author to use; never run `git log` with an empty `--author`.
4. My commits: `git log --all --no-merges --author="<email>" --since="<window start>" --format='%h %ad %s' --date=short` (retry with `--author="<name>"` if empty).
5. My PRs, only with a GitHub remote: `gh pr list --author @me --state all --search "updated:>=<YYYY-MM-DD>" --limit 20 2>/dev/null`. Note PRs waiting on review.
6. Brag doc: read the path the user names, else `~/brag-doc.md` if it exists. Use entries in the window.
7. If calendar or ticket MCP tools exist: the meeting's agenda, my tickets. Otherwise skip.

## Write

- **Wins:** outcomes from the window, in plain language. Group related work.
- **Blockers:** what slows you down — reviews waiting, unclear requirements, things the user mentioned.
- **Asks:** what you need from this person (a decision, an intro, feedback, priorities). Mark each "(suggestion — confirm)".
- **Topics:** 1–3 things worth raising (growth, workload, feedback both ways). Mark each "(suggestion — confirm)".
- For a 1:1 with a report, flip it: their wins to recognize, their blockers to clear, questions to ask them. Their wins and blockers come only from what the user tells you or from tickets assigned to them (when ticket MCP tools exist); if neither gives anything, ask the user. Never pull the report's git history.
- Do not run tests or other project code.

## Output template

```
**1:1 with <who> — <date>**

**Wins**
- <outcome>

**Blockers**
- None

**Asks**
- <ask> (suggestion — confirm)

**Topics**
- <topic> (suggestion — confirm)
```

Max 4 bullets per section. End with one line: "Anything on your mind you want to add?"

## Rules

- Your wins come only from the user's own commits, PRs, brag doc entries, or words. Always pass `--author` to `git log`; never include other people's work.
- Never show tool errors; leave that source out.
- Never send or post the prep anywhere.
- Do not name or describe anyone else's commits, even to say you left them out. Nothing after the closing line.
