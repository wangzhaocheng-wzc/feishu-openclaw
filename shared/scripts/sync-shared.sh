#!/usr/bin/env bash
set -euo pipefail

# sync-shared.sh
# Sync root-level docs/templates into shared layer mirrors.
#
# Usage:
#   shared/scripts/sync-shared.sh
#
# Behavior:
# - Mirrors ./docs/*.md -> ./shared/docs/
# - Mirrors ./templates/*.md -> ./shared/templates/
# - Prints a small summary of changes.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

mkdir -p shared/docs shared/templates

# Copy (preserve timestamps when possible). We intentionally keep it simple.
cp -a docs/*.md shared/docs/ 2>/dev/null || true
cp -a templates/*.md shared/templates/ 2>/dev/null || true

if command -v git >/dev/null 2>&1; then
  echo "== git status (shared mirrors) =="
  git status --porcelain shared/docs shared/templates || true
fi

echo "OK: sync done"
