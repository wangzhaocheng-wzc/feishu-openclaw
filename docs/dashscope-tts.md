# DashScope TTS (Qwen3) - OpenClaw Working Notes

Goal: add a reliable "text -> audio" pipeline for Chinese narration/voiceover.

This doc is a practical runbook for this workspace (scripts + env).

## What This Is (and What It Isn't)

- This is TTS (Text-to-Speech): generate `mp3`/`wav` audio from text.
- This is *not* a full "digital human" video pipeline (lip-sync, avatar render, etc.).

## Prereqs

- A DashScope API key in env var `DASHSCOPE_API_KEY`.
- Python 3 (the system has Python 3.6; using 3.11 is preferred if available).

Install SDK:

```bash
python3 -m pip install --user dashscope
```

If you have `python3.11`:

```bash
python3.11 -m pip install --user dashscope
```

## Generate Audio

Basic:

```bash
export DASHSCOPE_API_KEY='...'
python3 scripts/dashscope-tts.py --text '你好，我是你的 AI 助手' --out /tmp/tts.mp3
```

Voice + style (instruction mode):

```bash
python3 scripts/dashscope-tts.py \
  --text '恭喜你今天完成了任务！' \
  --out /tmp/happy.mp3 \
  --voice Cherry \
  --style 开心
```

Notes:
- `--style` switches model default to `qwen3-tts-instruct-flash`.
- Without `--style`, model default is `qwen3-tts-flash`.

## Suggested Conventions

- Short-form narration: keep a single call < 60s audio; split long scripts.
- Store generated artifacts under `tmp/` or `/tmp/`; do not commit audio outputs.

## Next Step (Optional)

If this is useful long-term, we can wrap it as a first-class OpenClaw skill:
- `~/.openclaw/skills/dashscope-tts/SKILL.md`
- a small `scripts/` folder + documented inputs/outputs
