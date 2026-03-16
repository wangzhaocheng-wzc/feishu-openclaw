#!/usr/bin/env bash
set -euo pipefail

# Installs a static ffmpeg build (ffmpeg + ffprobe) on Linux x86_64.
# Default source: johnvansickle.com (fast to get a fully-featured build).
# Uses HTTP resume (-C -) to survive flaky downloads.

FFMPEG_URL_DEFAULT="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz"

usage() {
  cat <<'USAGE'
Usage:
  install-ffmpeg-static.sh [--prefix DIR] [--url URL] [--force]

Options:
  --prefix DIR  Install directory for ffmpeg/ffprobe (default: /usr/local/bin)
  --url URL     Tarball URL (default: johnvansickle static build)
  --force       Overwrite existing ffmpeg/ffprobe in prefix

Notes:
  - Needs write permission to --prefix. Run as root or use sudo.
  - Only supports x86_64/amd64 static build by default.
USAGE
}

PREFIX="/usr/local/bin"
URL="$FFMPEG_URL_DEFAULT"
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prefix)
      PREFIX="$2"; shift 2 ;;
    --url)
      URL="$2"; shift 2 ;;
    --force)
      FORCE=1; shift 1 ;;
    -h|--help)
      usage; exit 0 ;;
    *)
      echo "Unknown arg: $1" >&2
      usage
      exit 2 ;;
  esac
done

arch="$(uname -m)"
if [[ "$arch" != "x86_64" && "$arch" != "amd64" ]]; then
  echo "Unsupported arch: $arch (this script expects x86_64 static build)" >&2
  exit 1
fi

need_write_test="$PREFIX/.openclaw_write_test.$$"
if ! (mkdir -p "$PREFIX" && ( : > "$need_write_test" ) 2>/dev/null); then
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
  else
    echo "No permission to write to $PREFIX and sudo not found." >&2
    exit 1
  fi
else
  rm -f "$need_write_test"
  SUDO=""
fi

if [[ -x "$PREFIX/ffmpeg" || -x "$PREFIX/ffprobe" ]]; then
  if [[ "$FORCE" -ne 1 ]]; then
    echo "ffmpeg/ffprobe already exists in $PREFIX. Re-run with --force to overwrite." >&2
    exit 1
  fi
fi

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

pkg="$workdir/ffmpeg-static.tar.xz"

# -C - enables resume; --retry helps with transient failures.
echo "Downloading: $URL"
curl -fL \
  --retry 5 --retry-delay 2 --retry-connrefused \
  -C - \
  -o "$pkg" \
  "$URL"

echo "Extracting..."
tar -xJf "$pkg" -C "$workdir"

dir="$(find "$workdir" -maxdepth 1 -type d -name 'ffmpeg-*-static' | head -n 1)"
if [[ -z "$dir" ]]; then
  echo "Could not find extracted ffmpeg directory." >&2
  exit 1
fi

if [[ ! -x "$dir/ffmpeg" || ! -x "$dir/ffprobe" ]]; then
  echo "Extracted package missing ffmpeg/ffprobe." >&2
  exit 1
fi

echo "Installing to $PREFIX ..."
$SUDO install -m 0755 "$dir/ffmpeg" "$PREFIX/ffmpeg"
$SUDO install -m 0755 "$dir/ffprobe" "$PREFIX/ffprobe"

# Print versions for verification.
echo
echo "OK:"
"$PREFIX/ffmpeg" -version | head -n 2
"$PREFIX/ffprobe" -version | head -n 2
