---
name: design-doc
description: Use when the user wants a design doc, technical proposal, RFC, or architecture decision record (ADR) — comparing options for a technical problem and recording the decision.
---

# Design doc

Turn a problem into options, a recommendation, and a written record a reviewer can decide on.

## 1. Frame the problem

Restate the problem in 2–3 lines. Ask up to 3 questions only if the answer would change the recommendation (scale, deadline, hard constraints). If the user said not to ask, list your assumptions instead.

## 2. Read the codebase

Find where the change would live, what already exists, and the constraints it imposes. Cite `path:line`. A doc that ignores the code is a wish list.

## 3. Options

At least two real options. "Do nothing" counts when it is viable. No strawmen. For each:

- How it works (2–4 lines)
- Pros, cons
- Effort and risk

## 4. Recommend

Pick one, say why, and say what would change your mind.

## 5. Format

- A format the user names wins ("design doc", "RFC", "ADR").
- Otherwise use an **ADR** when the repo has `docs/adr/` or `docs/decisions/` (number it after the highest existing one, e.g. `ls docs/adr docs/decisions`), and a **design doc** when it doesn't.

Design doc:
```
# <Title>
**Status:** Draft · **Author:** <git config user.name> · **Date:** <YYYY-MM-DD>

## Context
## Goals and non-goals
## Options
### Option A — <name>
### Option B — <name>
## Recommendation
## Open questions
```

ADR:
```
# ADR <NNNN>: <title>
Status: Proposed
Date: <YYYY-MM-DD>

## Context
## Decision
## Consequences
## Alternatives considered
```

## 6. Hand off

Show the draft in chat. Then offer to save it: an ADR to `docs/adr/<NNNN>-<slug>.md` (or the repo's decisions folder), a design doc to `docs/design/<slug>.md`. Save only after an explicit yes.

## Rules

- At least two real options, each with pros and cons.
- Cite the code the decision touches.
- Never save a file without an explicit yes.
