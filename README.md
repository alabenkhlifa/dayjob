# dayjob

> Your agent writes the code. **dayjob** handles the rest of the job.

[![GitHub stars](https://img.shields.io/github/stars/alabenkhlifa/dayjob?style=social)](https://github.com/alabenkhlifa/dayjob)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Standups, tickets, PRs, reviews, incidents, status updates, 1:1s. dayjob is a set of agent skills for the whole software engineering job, organized around the rhythm of your week.

**Quick start (Claude Code):**

```
/plugin marketplace add alabenkhlifa/dayjob
/plugin install dayjob@dayjob
```

Then ask: *"what's next?"*

## The rest of the job

Coding agents got good at writing code. The job is more than that:

- The first ten minutes of the day go to digging through `git log` to remember what you did yesterday.
- Tickets arrive half-written, and the agent happily builds the wrong thing.
- PR descriptions say "fix stuff", and reviews miss the bug that matters.
- The Friday update, the postmortem, the 1:1 prep, the self-review: all from memory, all at the last minute.

dayjob gives your agent a skill for each of these, built on what is already in your repo (git, `gh`) and on your tools when they are connected (Jira, Linear, Slack, calendar).

## How it works

Ask `whats-next` anytime. It reads your branch, your open PRs and the time of day, and points you to the skill that fits.

| Rhythm | Skill | What it does |
|---|---|---|
| Anytime | `whats-next` | Reads your branch, PRs and time of day; tells you which skill fits now |
| Daily | `standup` | Yesterday / Today / Blockers from your commits, PRs and tickets |
| | `start-ticket` | Ticket → questions → plan → the smallest change that fits the codebase |
| | `fix-bug` | Root cause first, fix at the source, prove nothing else broke |
| | `ship-pr` | Clean commits and a PR description reviewers can read in a minute |
| | `review-pr` | Finds what would break in production; specific, kind comments |
| Weekly | `weekly-update` | Shipped / In progress / Risks / Asks from your week |
| | `refactor` | Quick cleanups or deep restructuring without changing behavior |
| | `design-doc` | Problem → options → decision, as a design doc or ADR |
| When it breaks | `incident` | Live triage: impact, mitigation, running timeline |
| | `postmortem` | Blameless write-up from the incident timeline |
| Career | `one-on-one` | Wins, blockers and asks for your next 1:1 |
| | `brag-doc` *(soon)* | Logs wins as they happen; drafts your self-review |

Every skill drafts first and asks before posting anything to Slack, Jira or GitHub.

## Installation

### Claude Code

```
/plugin marketplace add alabenkhlifa/dayjob
/plugin install dayjob@dayjob
```

### Any agent (Cursor, Codex, Copilot, Gemini CLI, OpenCode, ...)

```
npx skills add alabenkhlifa/dayjob                      # all skills
npx skills add alabenkhlifa/dayjob --skill standup      # just one
```

### Manual

```
git clone https://github.com/alabenkhlifa/dayjob.git
cp -r dayjob/skills/* ~/.claude/skills/
```

## Contributing

Each skill lives in `skills/<name>/SKILL.md` and ships with eval cases in `evals/<name>-*/`. Before opening a PR:

```
bash scripts/lint-skills.sh
claude plugin eval . --scaffold --trust-plugin --no-publish --allow-tools Bash Edit Write --threshold 0.8 --case '<name>-*'
```

A skill must score at least 0.8 on every case, never lower than a plain agent, and higher than a plain agent wherever there is room to improve.

## License

[MIT](LICENSE)
