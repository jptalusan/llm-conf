---
name: markitdown
description: Read or convert documents and media that aren't plain text - PDF, Word (.docx), PowerPoint (.pptx), Excel (.xlsx/.xls), images, audio, video, EPUB, Outlook .msg, HTML, CSV, Jupyter notebooks, ZIP - into Markdown/text using a fully local, offline toolchain (markitdown, poppler, tesseract/Apple Vision, whisper, ffmpeg). Use whenever a task needs the contents of such a file. Everything runs on-device; never route file contents through a cloud API.
---

# Local document and media extraction

Get the *contents* of a non-plain-text file. Never try to read those bytes directly.

**Everything here runs locally.** Do not use cloud extraction paths, and do not send file contents to a third-party API to get text out of them. Specifically avoid these markitdown features:

- **Audio/video conversion.** `markitdown song.mp3` posts the audio to Google's Web Speech API. Use whisper instead (below). Never point markitdown at an audio or video file.
- **`-d` / `--use-docintel`.** Azure Document Intelligence. Use `ocrmypdf` or docling.
- **`llm_client=` with a hosted API.** Only acceptable pointed at a local server (below).

## Pick the tool by file type

| Input | Tool | Notes |
|---|---|---|
| PDF with a text layer | `pdftotext -layout f.pdf -` | Better than markitdown: markitdown's pdfminer glues words together on LaTeX PDFs (`YusenLiu1` vs `Yusen Liu1`). |
| Scanned/image-only PDF | `ocrmypdf` then `pdftotext` | See below. |
| `.docx` `.pptx` `.xlsx` `.csv` `.html` `.epub` `.ipynb` `.msg` `.zip` | `markitdown f.docx` | Offline and reliable. Tables become Markdown tables, slides get `<!-- Slide number: N -->`. |
| Image | Apple Vision or tesseract | OCR. markitdown returns only `ImageSize: WxH`, never the content. |
| Audio | whisper | |
| Video | ffmpeg + whisper (+ frames) | **Ask first**, see below. |

Run markitdown without installing anything: `uvx --from 'markitdown[all]' markitdown f.docx`.

## Local stack

None of this is installed by default. Install on demand, and say what you're installing before you do.

```bash
brew install tesseract ocrmypdf whisper-cpp    # OCR + speech (ffmpeg, poppler, exiftool assumed present)
uv add mlx-whisper                             # Apple Silicon: fastest whisper
uv add ocrmac                                  # macOS: Apple Vision OCR, on-device, no model download
```

On Apple Silicon prefer **Apple Vision** (`ocrmac`) over tesseract for OCR accuracy, and **mlx-whisper** over whisper.cpp for speed.

## PDFs

```bash
pdffonts f.pdf                      # empty output => no text layer => needs OCR
pdftotext -layout f.pdf out.txt     # has a text layer: done
ocrmypdf f.pdf ocr.pdf              # no text layer: adds an invisible one, stays a normal PDF
```

For multi-column papers, tables, or formulas where the above mangles the layout, use a local layout-aware model (**docling**, MIT, or **marker**) instead of raising OCR settings.

## Images

```bash
python -c "from ocrmac import ocrmac; print('\n'.join(a[0] for a in ocrmac.OCR('img.png').recognize()))"
tesseract img.png -                 # portable fallback
```

OCR gets text off the image. For *describing* what an image shows, run a local VLM (`ollama run qwen2.5vl`). markitdown's caption path is OpenAI-shaped, so a local server can drive it:

```python
from openai import OpenAI
from markitdown import MarkItDown
client = OpenAI(base_url="http://localhost:11434/v1", api_key="ollama")
MarkItDown(llm_client=client, llm_model="qwen2.5vl").convert("img.png")
```

If the goal is just to *see* the image, view it directly rather than converting it.

## Audio

```bash
ffmpeg -i in.m4a -vn -ac 1 -ar 16000 audio.wav     # whisper wants 16kHz mono
mlx_whisper audio.wav --model mlx-community/whisper-large-v3-turbo   # or: whisper-cli -f audio.wav
```

## Video

Video has two independent tracks of information, and the visual one costs far more to process. **Ask the user which they want before starting**, since it changes runtime from seconds to many minutes:

- **Audio only.** The spoken transcript. Right for talks, interviews, meetings, podcasts.
- **Audio + visual.** Adds slide text, code on screen, charts, and demo UI. Right for conference talks, screencasts, tutorials, anything where the screen carries content the speaker doesn't read aloud.

Audio track:

```bash
ffmpeg -i talk.mp4 -vn -ac 1 -ar 16000 audio.wav
mlx_whisper audio.wav --model mlx-community/whisper-large-v3-turbo --output-format srt
```

Visual track. Sample frames, then OCR each one. Scene detection avoids hundreds of duplicate frames of the same slide:

```bash
mkdir -p frames
# slides/screencasts: keep frames only when the picture changes
ffmpeg -i talk.mp4 -vf "select='gt(scene,0.3)',showinfo" -vsync vfr frames/f%04d.jpg 2>frames/log.txt
# steady-motion video instead: fixed sampling, frame N is at (N-1)*5 seconds
ffmpeg -i talk.mp4 -vf fps=1/5 frames/f%04d.jpg
```

Then OCR each frame (Apple Vision/tesseract) for on-screen text, or caption with a local VLM for what is happening. Timestamps for scene-detected frames come from the `pts_time` values in `frames/log.txt`; merge them with the whisper SRT timestamps to interleave speech and screen into one transcript.

Tune `scene` (0.3 is a reasonable default): lower catches more changes, higher keeps fewer frames. Always report how many frames were extracted before OCR'ing them, and drop near-duplicates first.

## Caveats

- Scanned PDFs and images return nothing useful without an OCR pass. Check for a text layer first rather than assuming extraction failed.
- Converting a large batch is slow and verbose. Write output to files and grep them instead of dumping whole documents into context.
- `exiftool` supplies image/audio metadata; without it that section is silently absent.
