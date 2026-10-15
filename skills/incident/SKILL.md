---
name: incident
description: Use when something is broken in production or users are affected right now — an outage, errors spiking, "we have an incident", "prod is down" — to triage, mitigate, and keep a running timeline.
---

# Incident

Stop the bleeding first, keep a timeline as you go, and never take a risky action without a yes.

## 1. Open the incident file — right away

Create `incident-<YYYY-MM-DD>-<slug>.md` in the current folder (UTC date; slug from the symptom, e.g. `checkout-500s`). If an incident file with `Status: Open` or `Status: Mitigated` already covers this problem, append to it instead. Keeping this file is part of the job; you don't need to ask before writing it.

```
# Incident: <short title>
Status: Open
Started: <YYYY-MM-DD HH:MM> UTC
Severity: <SEV1 | SEV2 | SEV3>

## Impact
<who or what is affected, since when>

## Timeline (UTC)
- <HH:MM> — <event>

## Actions
- [ ] <action> — <owner>
```

Get times with `date -u '+%H:%M'`. Severity: SEV1 = most users or money affected, SEV2 = a key feature degraded, SEV3 = minor. Mark a guess with "(confirm)".

## 2. Triage

Ask at most 3 quick questions, only for what you can't find: what is broken, who is affected, since when.

## 3. Look for what changed

```bash
git log --since="24 hours ago" --format='%h %an %ar %s'
gh run list --limit 5 2>/dev/null   # only with a GitHub remote
git tag --sort=-creatordate | head -5
```

Read the suspect diffs (`git show <hash>`). Match change times against when the symptom started.

## 4. Mitigate first

Propose the fastest safe mitigation — revert the suspect change, roll back the deploy, flip a feature flag, scale up — with the exact command. **Never run any mitigation or any command that changes a live system (revert, reset, rollback, deploy, push, restart, scale, feature flag, config change), and never edit project code, without an explicit yes.** Root cause can wait until users are OK.

## 5. Keep the timeline

Every finding, decision and action gets a timestamped line in the file. Facts, not blame: "config change deployed", not "X broke it".

## 6. Each reply during the incident

```
Status: <Open | Mitigated | Resolved> · Impact: <one line>
Next: <one step> — <command if any>
Need from you: <one thing, or "nothing">
```

## 7. Close

When the user confirms it's fixed: set `Status: Resolved`, add the resolution to the timeline, tick done actions, and suggest the `postmortem` skill.

## Rules

- Mitigation before root cause.
- No mitigation, no command that changes a live system (revert, reset, rollback, deploy, push, restart, scale, feature flag, config change), and no project code edit without an explicit yes.
- UTC times. Facts, not blame.
