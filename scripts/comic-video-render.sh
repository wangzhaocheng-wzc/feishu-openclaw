#!/usr/bin/env bash
set -euo pipefail

# Render a "comic video" from numbered images + optional voice + optional subtitles.
# Typical input layout:
#   images/001.png ... images/008.png
#   voice.mp3
#   subs.srt

usage() {
  cat <<'USAGE'
Usage:
  comic-video-render.sh \
    --images-dir DIR \
    --out OUT.mp4 \
    [--fps 1] \
    [--voice voice.mp3] \
    [--subs subs.srt] \
    [--size 1080:1920]

Notes:
  - Images must be zero-padded and sequential: 001.png, 002.png ...
  - --fps controls how many images per second. For 8 images over ~60s, use 0.133.
  - If --voice is provided, output duration follows audio unless images end earlier.
USAGE
}

IMAGES_DIR=""
OUT=""
FPS=""
VOICE=""
SUBS=""
SIZE="1080:1920"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --images-dir) IMAGES_DIR="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    --fps) FPS="$2"; shift 2 ;;
    --voice) VOICE="$2"; shift 2 ;;
    --subs) SUBS="$2"; shift 2 ;;
    --size) SIZE="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

if [[ -z "$IMAGES_DIR" || -z "$OUT" ]]; then
  usage
  exit 2
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg not found. Install it first (see scripts/install-ffmpeg-static.sh)." >&2
  exit 1
fi

pattern="$IMAGES_DIR/%03d.png"
# Validate at least 001.png exists.
if [[ ! -f "$IMAGES_DIR/001.png" ]]; then
  echo "Missing $IMAGES_DIR/001.png (expects %03d.png sequence)." >&2
  exit 1
fi

# Default FPS: if voice exists, compute fps = num_images / audio_seconds.
if [[ -z "$FPS" ]]; then
  if [[ -n "$VOICE" ]]; then
    if ! command -v ffprobe >/dev/null 2>&1; then
      echo "ffprobe not found (needed to auto-compute fps)." >&2
      exit 1
    fi
    n_images=$(ls -1 "$IMAGES_DIR"/*.png 2>/dev/null | wc -l | tr -d ' ')
    dur=$(ffprobe -v error -show_entries format=duration -of default=nk=1:nw=1 "$VOICE" | head -n 1)
    if [[ -z "$dur" ]]; then
      echo "Could not read voice duration via ffprobe." >&2
      exit 1
    fi
    # fps = n_images / dur
    FPS=$(python3 - <<PY
n=${n_images}
d=float('${dur}')
print(n/d)
PY
)
  else
    FPS="1"
  fi
fi

# Build video filter: scale + pad to target size.
vf="scale=${SIZE}:force_original_aspect_ratio=decrease,pad=${SIZE}:(ow-iw)/2:(oh-ih)/2"

# Add subtitles if provided.
if [[ -n "$SUBS" ]]; then
  if [[ ! -f "$SUBS" ]]; then
    echo "Subs not found: $SUBS" >&2
    exit 1
  fi
  # Keep subtitle styling readable for vertical video.
  # NOTE: ffmpeg subtitles filter uses libass; ensure ffmpeg build includes it.
  vf="$vf,subtitles=${SUBS}:force_style='FontName=Arial,FontSize=44,Outline=2,Shadow=1,MarginV=60'"
fi

args=(
  -y
  -hide_banner
  -loglevel warning
  -framerate "$FPS"
  -i "$pattern"
)

if [[ -n "$VOICE" ]]; then
  if [[ ! -f "$VOICE" ]]; then
    echo "Voice not found: $VOICE" >&2
    exit 1
  fi
  args+=( -i "$VOICE" )
  # Map audio; stop when shortest stream ends (usually voice).
  args+=( -shortest -map 0:v:0 -map 1:a:0 )
else
  args+=( -map 0:v:0 )
fi

# Encode settings: good enough defaults, mobile-friendly.
args+=(
  -vf "$vf"
  -r 30
  -c:v libx264 -pix_fmt yuv420p
  -crf 18 -preset veryfast
)

if [[ -n "$VOICE" ]]; then
  args+=( -c:a aac -b:a 192k )
fi

args+=("$OUT")

echo "Rendering..."
ffmpeg "${args[@]}"

echo "OK: $OUT"
