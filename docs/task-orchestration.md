# Task Orchestration Patterns (Runbook)

Goal: make agent execution reliable: clear dependencies, state checkpoints, retries, and graceful degradation.

This is a lightweight runbook for *how we run work* in this workspace.

## Four Patterns

1) Sequential (chain)
- Use when each step depends on outputs from the previous step.
- Must persist state between steps (notes file, json, or doc).

2) Parallel (fan-out)
- Use when tasks are independent.
- Cap concurrency; plan for partial failure.

3) Conditional (branch)
- Use when decisions depend on intermediate results.
- Explicitly encode decision rules ("if 403 then verify; if 429 then backoff").

4) Iterative (retry/loop)
- Use when success is probabilistic (network, rate-limit, unstable providers).
- Must have an exit condition + backoff.

## State Is a First-Class Output

Each run should leave one of:
- a doc in `docs/` (how-to, runbook)
- a script in `scripts/` (repeatable action)
- a `.learnings/` entry (failure -> fix)
- a `memory/YYYY-MM-DD.md` note (what happened today)

## Retry Policy (Default)

- 429 / rate limit: exponential backoff, respect `Retry-After` if provided.
- download interrupted: prefer resumable tooling, avoid "single long curl".
- provider changes: pin versions or add compatibility handling.

## Example: Install/Enable a Capability

- Precheck: deps present? OS constraints? python version?
- Execution: install in venv; minimal global changes.
- Validation: run `doctor` / smoke test.
- Write-down: doc + ERR if needed.
- Commit: stage only relevant files; avoid secrets.
