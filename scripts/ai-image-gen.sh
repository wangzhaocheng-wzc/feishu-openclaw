#!/usr/bin/env sh
set -eu

# Thin wrapper around OpenClaw's built-in openai-image-gen skill.
# This adds a friendlier CLI and a simple "negative prompt" convention.

BASE_DIR="/usr/lib/node_modules/openclaw/skills/openai-image-gen"
PY="$BASE_DIR/scripts/gen.py"

if [ ! -f "$PY" ]; then
  echo "Missing openai-image-gen script at: $PY" >&2
  exit 2
fi

PROMPT=""
NEG=""
COUNT=4
MODEL="gpt-image-1"
SIZE="1536x1024"
QUALITY="high"
OUT_DIR=""

usage() {
  cat >&2 <<USAGE
Usage:
  OPENAI_API_KEY=... $0 --prompt '...' [--negative '...'] [--count N] [--model ID] [--size WxH] [--quality Q] [--out-dir DIR]

Notes:
  - Uses OpenAI Images API via openclaw's openai-image-gen script.
  - "Negative prompt" is implemented by appending an instruction to avoid listed items.
  - Seed control is not supported by the underlying script/API wrapper.
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    --prompt) PROMPT=$2; shift 2 ;;
    --negative) NEG=$2; shift 2 ;;
    --count) COUNT=$2; shift 2 ;;
    --model) MODEL=$2; shift 2 ;;
    --size) SIZE=$2; shift 2 ;;
    --quality) QUALITY=$2; shift 2 ;;
    --out-dir) OUT_DIR=$2; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

if [ -z "$PROMPT" ]; then
  echo "Missing --prompt" >&2
  usage
  exit 2
fi

FINAL_PROMPT="$PROMPT"
if [ -n "$NEG" ]; then
  FINAL_PROMPT="$FINAL_PROMPT\n\nAvoid: $NEG"
fi

# Build args and exec.
set -- "$PY" --prompt "$FINAL_PROMPT" --count "$COUNT" --model "$MODEL" --size "$SIZE" --quality "$QUALITY"
if [ -n "$OUT_DIR" ]; then
  set -- "$@" --out-dir "$OUT_DIR"
fi

exec python3 "$@"
