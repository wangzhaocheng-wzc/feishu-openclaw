# shared/

This directory holds reusable assets shared across agents/workspaces.

Principles:

- Put "generic + reusable" things here: scripts, templates, docs, small configs.
- Do NOT put secrets here.
- Keep changes small and versioned (commit with clear Chinese messages).

Recommended layout:

- shared/scripts/   reusable scripts
- shared/templates/ reusable templates
- shared/docs/      reusable docs/specs

How to consume:

- Prefer referencing via relative paths from the repo root.
- If you run multiple agents with separate workspaces, use symlinks to mount this folder into each workspace.
