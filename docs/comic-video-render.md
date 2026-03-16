# Comic Video Render (images + voice + subtitles -> mp4)

This repo provides a minimal pipeline to turn "comic shots" into a 1-minute vertical video:

- Input: `images/%03d.png` (e.g. `001.png..008.png`)
- Optional: `voice.mp3`
- Optional: `subs.srt`
- Output: `out.mp4`

Script:

- `scripts/comic-video-render.sh`

## Quick Start

1) Install ffmpeg (static)

```bash
bash /root/.openclaw/workspace/scripts/install-ffmpeg-static.sh
```

2) Prepare assets

```bash
mkdir -p /tmp/comic/images
# Put your frames here:
# /tmp/comic/images/001.png
# /tmp/comic/images/002.png
# ...
```

3) Render video

With voice + subtitles (recommended):

```bash
bash /root/.openclaw/workspace/scripts/comic-video-render.sh \
  --images-dir /tmp/comic/images \
  --voice /tmp/comic/voice.mp3 \
  --subs /tmp/comic/subs.srt \
  --out /tmp/comic/out.mp4 \
  --size 1080:1920
```

Without voice (uses `--fps` or default 1 image/sec):

```bash
bash /root/.openclaw/workspace/scripts/comic-video-render.sh \
  --images-dir /tmp/comic/images \
  --fps 1 \
  --out /tmp/comic/out.mp4
```

## FPS Tips

If you have 8 images and want ~60 seconds total, a rough starting point is:

- `fps = 8 / 60 = 0.133333...`

If you provide `--voice`, the script auto-computes fps from `voice.mp3` duration.

## Known Limitations

- Images must be sequential and zero-padded: `001.png`, `002.png` ...
- Subtitles are burned in using ffmpeg `subtitles=` (needs libass support in ffmpeg build).
