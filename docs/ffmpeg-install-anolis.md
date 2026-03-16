# Install ffmpeg on Anolis OS (static build)

Anolis 8.x may not ship `ffmpeg` in default repos. For our "comic video" pipeline we only need:

- `ffmpeg`
- `ffprobe`

This repo includes a resumable installer:

- `scripts/install-ffmpeg-static.sh`

## Install

As root:

```bash
bash /root/.openclaw/workspace/scripts/install-ffmpeg-static.sh
```

If you want to overwrite an existing ffmpeg:

```bash
bash /root/.openclaw/workspace/scripts/install-ffmpeg-static.sh --force
```

Custom install location:

```bash
bash /root/.openclaw/workspace/scripts/install-ffmpeg-static.sh --prefix /usr/local/bin
```

## Verify

```bash
ffmpeg -version | head -n 2
ffprobe -version | head -n 2
```

## Notes

- The script uses HTTP resume (`curl -C -`) to survive interrupted downloads.
- The default URL is the John Van Sickle static build.
