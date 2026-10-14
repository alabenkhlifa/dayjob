---
name: postmortem
description: Use when the user wants a postmortem, incident review, incident report, or RCA write-up after an outage or incident has been resolved.
---

# Postmortem

Turn an incident into a blameless write-up that makes the next one less likely.

## 1. Find the incident

Use the file the user names. Otherwise take the most recent `incident-*.md` in the current folder with `Status: Resolved`. Its format:

```
# Incident: <title>
Status: Resolved
Started: <YYYY-MM-DD HH:MM> UTC
Severity: <SEV1 | SEV2 | SEV3>
## Impact
## Timeline (UTC)
## Actions
```

No file → ask the user for the timeline or notes.

## 2. Fill gaps

Ask up to 3 questions, only for facts the write-up needs and the file lacks: impact numbers, how it was detected, the root cause if unknown.

## 3. Write it blameless

Describe systems, decisions and missing safeguards, never people. A person who acted becomes a role ("an engineer deployed a config change"). Ask "why did the system allow this?", not "who did this?". Never write that someone made a mistake or is at fault.

Always check detection: compute the gap between the symptom starting and the first alert or page. If people (customers, support) noticed first, say so.

## 4. Template

```
# Postmortem: <title> (<YYYY-MM-DD>)
**Status:** Draft · **Severity:** <SEVn> · **Duration:** <start> → <end> UTC

## Summary
<3 sentences: what broke, who was affected, how it was fixed>

## Impact
## Timeline (UTC)
## Root cause
## Detection
<how and when we found out; time from start to first alert>
## What went well
## What went wrong
## Action items
| Action | Type | Owner | Due |
|---|---|---|---|
| <specific action> | prevent / detect / mitigate | <role or TBD (confirm)> | <date or TBD> |
```

Every timeline line comes from the incident file or the user.

## 5. Hand off

Show the draft in chat. Offer to save it as `postmortem-<same date>-<same slug>.md` next to the incident file. Save only after an explicit yes.

## Rules

- Blameless: roles, not names; systems, not mistakes.
- Action items are specific, typed, and owned.
- Never save a file without an explicit yes.
