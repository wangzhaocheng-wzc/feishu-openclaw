# Errors Log

Command failures, exceptions, and unexpected behaviors.

---
## [ERR-20260316-001] ffmpeg static download interrupted (SIGTERM)

**Logged**: 2026-03-16T10:23:00+08:00
**Priority**: medium
**Status**: pending
**Area**: infra

### Summary
Downloading `ffmpeg-release-amd64-static.tar.xz` from johnvansickle.com was terminated (SIGTERM) near completion (~99%).

### Error
```
Exec failed (signal SIGTERM)
... 99 39.9M 99 39.8M ...
```

### Context
- Goal: Install ffmpeg to unlock Agent Reach channels (e.g., podcast transcription).
- Environment: Anolis OS 8.9; `dnf` repo lacks `ffmpeg` package, so attempted static tarball download.
- Download source: `https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz`

### Suggested Fix
- Re-download with resume support: `curl -L -C - -o ffmpeg-release-amd64-static.tar.xz <url>`
- Or switch to a faster mirror/proxy; verify checksum if available.

### Metadata
- Reproducible: unknown
- Related Files: none

---
