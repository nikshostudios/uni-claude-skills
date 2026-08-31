---
name: yt-transcript
description: "Fetch a YouTube video's transcript from just a pasted link. Pulls the caption track via yt-dlp, files a clean timestamped transcript into ./transcripts/, then offers a study digest (summary + key concepts + quiz questions). Use whenever the user pastes a YouTube URL (youtube.com/watch, youtu.be, with or without surrounding text), says /yt-transcript, 'transcribe this YouTube link', 'get the transcript for this', or wants to study from a video. Trigger even if the user only drops a bare YouTube link with no instruction — a pasted YouTube link is the signal."
---

# Skill: yt-transcript

## Purpose

Automate the manual chore of: copy a video link → paste into a transcript-generator site →
copy the transcript → ask Claude to summarize it. The user pastes a YouTube link and this
skill does the whole thing — fetch, clean, file — then offers to turn it into study
material (summary, concept notes, quiz questions).

## Trigger

- `/yt-transcript <url> [<url> ...]`
- A bare YouTube link pasted in chat (`youtube.com/watch?v=...` or `youtu.be/...`), with or
  without surrounding text. A pasted link **is** the request — fetch it.

## The pipeline

```
paste link(s)
   │
   ▼
fetch.py  ──► yt-dlp pulls metadata + English captions
   │           cleans VTT → [MM:SS] lines, dedupes rolling captions
   │           writes ./transcripts/<today>-<slug>/transcript.md  (+ frontmatter)
   │           skips folders that already exist
   ▼
read JSON summary  ──► per-URL status: filed / skipped-duplicate / no-captions / error
   │
   ▼
for each FILED transcript → offer the study digest
```

## Step 1 — Run the fetch script

Transcripts live in `./transcripts/` under the current working directory (create it if
needed). Use **today's date** as the folder prefix (the fetch date, not the video's upload
date).

Run the bundled script with every YouTube URL the user gave (it handles one or many):

```bash
python3 ~/.claude/skills/yt-transcript/scripts/fetch.py \
  --raw-dir "$(pwd)/transcripts" \
  --date "$(date +%F)" \
  "<url1>" "<url2>" ...
```

The script prints a JSON summary. It does the deterministic work so you don't have to:
metadata fetch, slug, duplicate check, English caption selection (manual track preferred,
then auto-generated `en`/`en-orig`), VTT cleaning into `[MM:SS] text`, and writing
`transcript.md` with a frontmatter header (title, url, channel, upload date, fetch date,
duration).

## Step 2 — Act on each result

Parse the JSON `results` array. Each entry has a `status`:

- **`filed`** — transcript written. Note the `folder`.
- **`skipped-duplicate`** — a folder for this video already exists. Tell the user, do nothing
  else for it (never re-fetch or overwrite).
- **`no-captions`** — the video has no English caption track. Report the link and move on.
  **No audio-transcription fallback** — this is intentional.
- **`error`** — metadata fetch failed (private / age-gated / bad URL). Report the link + the
  `message`.

## Step 3 — Offer the study digest

For every `filed` transcript, ask the user (or just do it if they asked to "study" or
"learn" the video): produce a **study digest** next to the transcript as `digest.md`:

1. **TL;DR** — 3-5 sentences, what the video actually teaches.
2. **Key concepts** — each concept as a heading + 2-3 sentence explanation in plain
   language, with the `[MM:SS]` timestamp so the user can jump back to it.
3. **Quiz** — 5 short questions (no answers inline; answers at the bottom) so the user can
   test recall later.

If multiple videos were filed in one run, do one digest per video.

## Step 4 — Report

Short summary: which videos were filed (title + folder), which were skipped or failed and
why, and where the digests landed.

## Guardrails

- **Captions only, English-first.** Manual subtitles win over auto-generated; if neither
  English manual nor `en`/`en-orig` auto exists, report and skip. Never silently grab a
  different language, never fall back to audio transcription.
- **Today's date prefixes the folder**, not the video's upload date.
- **Duplicates are skipped**, never overwritten.
- **Transcript is raw material.** Never hand-edit transcript content after the script writes
  it — digests and notes are separate files.

## Dependencies

- `yt-dlp` (`brew install yt-dlp` on macOS, `pipx install yt-dlp` elsewhere) — caption +
  metadata fetch.
