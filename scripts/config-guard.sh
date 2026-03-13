#!/usr/bin/env bash
set -euo pipefail

# config-guard.sh
# A small guardrail script for OpenClaw config changes.
#
# Usage:
#   scripts/config-guard.sh backup
#   scripts/config-guard.sh audit
#   scripts/config-guard.sh verify
#   scripts/config-guard.sh backup-audit
#
# Notes:
# - Config path defaults to ~/.openclaw/openclaw.json
# - This script does NOT modify config content; it helps you do safe changes.

CFG_PATH="${OPENCLAW_CONFIG:-$HOME/.openclaw/openclaw.json}"
BACKUP_DIR="${OPENCLAW_CONFIG_BACKUP_DIR:-$HOME/.openclaw/openclaw.json.bak.d}"

cmd="${1:-}"
if [[ -z "$cmd" ]]; then
  echo "ERR: missing command (backup|audit|verify|backup-audit)" >&2
  exit 2
fi

require_bin() {
  local b="$1"
  command -v "$b" >/dev/null 2>&1 || {
    echo "ERR: missing dependency: $b" >&2
    exit 2
  }
}

backup() {
  mkdir -p "$BACKUP_DIR"
  local ts
  ts="$(date -u +%Y%m%dT%H%M%SZ)"
  local out="$BACKUP_DIR/openclaw.json.$ts"
  cp -a "$CFG_PATH" "$out"
  echo "OK: backup -> $out"
}

json_check() {
  require_bin python3
  python3 - <<PY
import json
p=r"$CFG_PATH"
with open(p,'r',encoding='utf-8') as f:
  json.load(f)
print('OK: json valid')
PY
}

audit() {
  require_bin openclaw
  echo "== openclaw security audit =="
  openclaw security audit
}

verify() {
  json_check
  audit
  echo "OK: verify done"
}

case "$cmd" in
  backup)
    backup
    ;;
  audit)
    audit
    ;;
  verify)
    verify
    ;;
  backup-audit)
    backup
    verify
    ;;
  *)
    echo "ERR: unknown command: $cmd" >&2
    exit 2
    ;;
esac
