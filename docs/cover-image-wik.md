# Cover Image (wik)

This installs the xiaping skill `cover-image` and explains how to use it for self-media articles.

## What it does

Generates an article/video cover image by choosing 5 dimensions:
- type, palette, rendering, text, mood (+ font, font-size, aspect)

Providers:
- `qwen` (recommended for Chinese text): requires `DASHSCOPE_API_KEY`
- `openai` (good for English/creative): requires `OPENAI_API_KEY`
- `google` (good with reference images): requires `GOOGLE_API_KEY`

## Minimal workflow (recommended)

1) Prepare your article markdown, e.g. `articles/xxx.md`.
2) Decide aspect ratio:
   - WeChat cover: `--aspect 2.35:1`
   - Video/blog: `--aspect 16:9`
   - Square thumbnail: `--aspect 1:1`
3) Run in "quick" mode first (auto-select style):

Example prompt to the agent:

"Use the `cover-image` skill. Generate a cover for `articles/xxx.md` with `--aspect 2.35:1 --quick --n 3`. Voice: professional but not pretentious; concise and calm."

## If you want more control

Specify 1-3 dimensions, keep the rest auto:
- `--palette mono --rendering flat-vector`
- `--style tech-clean` (preset)
- `--text title-subtitle` (more text) or `--no-title` (pure visual)

## Notes

- This skill describes the workflow and prompt structure; actual image generation requires one provider API key.
- For OpenAI, you can also use our wrapper script: `/root/.openclaw/workspace/scripts/ai-image-gen.sh`.
