# Errors -> Assets (Reusable Loop)

Goal: when something breaks (downloads, deps, API changes), we don't just "fix once"; we turn it into a reusable asset.

This workspace already uses `.learnings/ERRORS.md`. This doc standardizes what to write and where.

## The Rule

- Every non-trivial failure gets captured once.
- If it might happen again: capture root cause + reliable workaround.
- If it might happen to other tasks: extract it into a generic pattern.

## Where To Write

- Technical failure patterns: `.learnings/ERRORS.md`
- Tooling/env specifics: `TOOLS.md` (read-only unless explicitly asked)
- Behavior/policy decisions: `MEMORY.md` (read-only unless explicitly asked)
- Execution mistakes (missed steps, ordering): `memory/YYYY-MM-DD.md`

## Error Entry Template

Use this format in `.learnings/ERRORS.md`:

```md
### [ERR-YYYYMMDD-XXX] <short title>

- Symptom:
- Context:
- Root cause:
- Fix/workaround:
- Prevent:
- Verification:
```

## Quick Checklist (What Makes It Useful)

- The *symptom* is copy/pastable (actual error line).
- The *root cause* is one sentence, falsifiable.
- The *fix* is a sequence of commands/steps.
- The *verification* is a command that proves it's resolved.

## Optional Automation

If we keep doing this, we can add:
- `scripts/learnings/new-error.sh` to scaffold a new entry id + section.
- a small "doctor" script to re-run checks and link back to ERR ids.
