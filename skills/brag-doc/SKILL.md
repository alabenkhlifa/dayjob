---
name: brag-doc
description: Use when the user wants to log a win, accomplishment, or piece of impact to their brag doc, or to draft a self-review, promotion case, or performance review from their brag doc.
---

# Brag doc

Write wins down when they happen, so review season is copy-paste, not archaeology.

## The file

Path: the one the user names; otherwise `~/brag-doc.md`.

```
# Brag doc

## <YYYY-MM-DD>
- <what you did> — <impact or result>
```

## Log a win

1. Take the win from the user's words. If the impact is missing, ask one question: "What changed because of it?" (a number if there is one).
2. Append under today's date heading (`date +%F`); add the heading if it isn't there. If the file doesn't exist, create it with `# Brag doc` first.
3. Write the entry as `- <what you did> — <impact>`, in the user's words, tightened.
4. Confirm in one line with the path. Logging is what the user asked for, so no extra confirmation is needed.

No file yet and the user wants to backfill? Draft entries from their own commits (`git log --author="<email>" --since=<date> --format='%ad %s' --date=short`), show them, and write only after a yes. If `user.email` and `user.name` are both empty, ask the user which author to use; never run `git log` with an empty `--author`.

## Draft a self-review

1. Read the entries for the period (the user's, or the last 6 months).
2. Group them into themes: **Impact**, **Technical work**, **Collaboration and leadership**, **Growth**. Skip empty themes.
3. For each theme, 2–4 sentences in first person, leading with results and numbers from the entries. Restate only what the entries say: no new numbers or ratios ("3× faster"), causes, timing ("on time"), or scope.
4. End with "Next period" — 2 goals marked "(suggestion — confirm)", each a direct continuation of an entry.
5. Show the draft in chat. Don't write it to a file unless asked.

## Rules

- Never invent achievements, numbers, titles, or scope. Every claim traces to an entry or the user's words.
- Only the user's own work; always pass `--author` when reading git history.
- The self-review is a draft in chat; save it only after an explicit yes.
