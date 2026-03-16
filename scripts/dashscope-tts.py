#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DashScope/Qwen TTS helper.

Goal: turn text into an audio file (mp3) with optional style instructions.

This is intentionally a small, dependency-light wrapper. It uses the official
`dashscope` SDK if installed, otherwise exits with a clear error.

Env:
  - DASHSCOPE_API_KEY: required

Examples:
  python3 scripts/dashscope-tts.py --text '你好' --out out.mp3
  python3 scripts/dashscope-tts.py --text '恭喜你' --out happy.mp3 --style 开心
"""

import argparse
import os
import sys


def _die(msg: str, code: int = 2) -> None:
    print(f"error: {msg}", file=sys.stderr)
    raise SystemExit(code)


def main() -> int:
    ap = argparse.ArgumentParser(description="DashScope/Qwen TTS (text -> mp3)")
    ap.add_argument("--text", required=True, help="Text to synthesize")
    ap.add_argument("--out", required=True, help="Output audio path (mp3)")
    ap.add_argument("--voice", default="Cherry", help="Voice name (e.g. Cherry/Ethan)")
    ap.add_argument("--style", default=None, help="Optional style/instructions, e.g. 开心/温柔/严肃")
    ap.add_argument(
        "--model",
        default=None,
        help=(
            "Optional model override. If --style is set, defaults to qwen3-tts-instruct-flash; "
            "otherwise qwen3-tts-flash."
        ),
    )
    args = ap.parse_args()

    api_key = os.environ.get("DASHSCOPE_API_KEY")
    if not api_key:
        _die("DASHSCOPE_API_KEY is not set")

    try:
        import dashscope  # type: ignore
    except Exception as e:
        _die(f"dashscope SDK not available ({e}). Install: python3 -m pip install dashscope")

    # The SDK API is occasionally unstable across versions; keep calls conservative.
    model = args.model
    instructions = None
    if args.style:
        model = model or "qwen3-tts-instruct-flash"
        instructions = f"用{args.style}的语气说话"
    else:
        model = model or "qwen3-tts-flash"

    try:
        # Note: DashScope's return structure may differ by version.
        # We handle both object-style and dict-style results.
        resp = dashscope.MultiModalConversation.call(
            model=model,
            api_key=api_key,
            text=args.text,
            voice=args.voice,
            language_type="Chinese",
            stream=False,
            instructions=instructions,
            optimize_instructions=True if instructions else None,
        )
    except TypeError:
        # Back-compat: some SDK versions don't accept optimize_instructions.
        resp = dashscope.MultiModalConversation.call(
            model=model,
            api_key=api_key,
            text=args.text,
            voice=args.voice,
            language_type="Chinese",
            stream=False,
            instructions=instructions,
        )
    except Exception as e:
        _die(f"DashScope call failed: {e}")

    # Extract audio URL.
    status_code = getattr(resp, "status_code", None) or (resp.get("status_code") if isinstance(resp, dict) else None)
    if status_code != 200:
        _die(f"DashScope returned status_code={status_code}; raw={resp}")

    audio_url = None
    try:
        # object-style
        audio_url = resp.output.audio.get("url")  # type: ignore[attr-defined]
    except Exception:
        pass
    if not audio_url and isinstance(resp, dict):
        audio_url = (((resp.get("output") or {}).get("audio") or {}).get("url"))

    if not audio_url:
        _die(f"No audio url in response; raw={resp}")

    try:
        import urllib.request

        with urllib.request.urlopen(audio_url, timeout=60) as r:
            data = r.read()
        os.makedirs(os.path.dirname(os.path.abspath(args.out)) or ".", exist_ok=True)
        with open(args.out, "wb") as f:
            f.write(data)
    except Exception as e:
        _die(f"Failed to download/write audio: {e}")

    print(args.out)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
