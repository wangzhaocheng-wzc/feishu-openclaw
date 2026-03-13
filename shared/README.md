# shared/

This folder contains reusable, portable assets intended to be shared across multiple agent workspaces.

- `shared/docs/` specs and how-tos
- `shared/templates/` reusable templates
- `shared/scripts/` reusable scripts

Versioning:

- `shared/VERSION.md` for the current version
- `shared/CHANGELOG.md` for changes over time

Guidelines:

- Keep it generic and reusable.
- Do not store secrets here.
- Prefer referencing `shared/...` paths from other docs/templates.
