# AI Image Gen (OpenClaw)

This is a practical way to make the xiaping "AI图像生成" skill actually generate images.

It uses OpenClaw's built-in skill `openai-image-gen` (OpenAI Images API), and provides a small wrapper script.

## Prereqs

- Python 3
- `OPENAI_API_KEY` exported in the environment

## Run

```sh
export OPENAI_API_KEY='...'
/root/.openclaw/workspace/scripts/ai-image-gen.sh \
  --prompt 'ultra-detailed studio photo of a lobster astronaut, 35mm film still' \
  --negative 'text, watermark, extra fingers' \
  --count 4 \
  --size 1536x1024 \
  --quality high
```

Outputs a folder like `./tmp/openai-image-gen-YYYY-MM-DD-HH-MM-SS/` with images + `index.html` gallery.

## Limitations

- True negative prompt and seed control are not implemented by the underlying script; we emulate "negative" by appending an instruction.
- If you want real SD/ComfyUI style controls (seed/CFG/steps), integrate a Stable Diffusion backend instead.
