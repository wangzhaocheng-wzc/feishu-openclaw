#!/usr/bin/env bash
set -euo pipefail

# link-shared-into-agent.sh
# Create/refresh a symlink named "shared" inside an agent workspace.
#
# Usage:
#   shared/scripts/link-shared-into-agent.sh /path/to/agent/workspace

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /path/to/agent/workspace" >&2
  exit 2
fi

TARGET_WS="$1"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SHARED_SRC="$REPO_ROOT/shared"

mkdir -p "$TARGET_WS"
ln -sfn "$SHARED_SRC" "$TARGET_WS/shared"

echo "OK: linked $TARGET_WS/shared -> $SHARED_SRC"
