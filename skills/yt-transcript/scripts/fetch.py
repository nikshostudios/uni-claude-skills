#!/usr/bin/env python3
"""Fetch a YouTube transcript via yt-dlp and file it into the vault's Raw/transcripts/.

For each URL: pull metadata, build a `<ingest-date>-<title-slug>` folder, skip if it
already exists, grab the best English caption track (manual preferred over auto-generated),
clean the VTT into `[MM:SS] text` lines, and write `transcript.md` with a frontmatter
header (title, url, channel, upload date, ingest date, duration) so the downstream
ingest-source skill has everything it needs to build digests + backlinks.

Captions come from YouTube's own track — the same source youtubetotranscript.com scrapes.
No Whisper fallback: a video with no English captions is reported and skipped.

Output: a JSON summary on stdout describing what happened per URL, so the calling skill
knows which folders to hand to ingest-source.

Usage:
    python3 fetch.py --raw-dir /path/to/Raw/transcripts --date YYYY-MM-DD <url> [<url> ...]
"""

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile


def run(cmd):
    """Run a command, return (returncode, stdout, stderr)."""
    p = subprocess.run(cmd, capture_output=True, text=True)
    return p.returncode, p.stdout, p.stderr


def slugify(title):
    """Lowercase, ASCII, dash-separated slug — matches the existing Raw/transcripts naming."""
    s = title.lower()
    s = re.sub(r"[^\w\s-]", "", s)          # drop punctuation/emoji
    s = re.sub(r"[\s_]+", "-", s).strip("-")  # spaces -> dashes
    s = re.sub(r"-{2,}", "-", s)
    # keep folder names sane; the date prefix already disambiguates
    return s[:80].strip("-") or "video"


def get_metadata(url):
    """Return dict with title, channel, upload_date, duration, id — or None on failure."""
    sep = "\x1f"  # unit separator, safe against titles containing | or commas
    fmt = sep.join(["%(title)s", "%(channel)s", "%(upload_date)s",
                    "%(duration)s", "%(id)s"])
    code, out, err = run([
        "yt-dlp", "--no-warnings", "--skip-download", "--print", fmt, url,
    ])
    if code != 0 or not out.strip():
        return None
    parts = out.strip().split(sep)
    if len(parts) < 5:
        return None
    title, channel, upload_date, duration, vid = parts[:5]
    return {
        "title": title or vid,
        "channel": channel or "",
        "upload_date": upload_date or "",
        "duration": duration or "",
        "id": vid,
    }


def fmt_upload_date(raw):
    """yt-dlp gives YYYYMMDD; turn into YYYY-MM-DD for readable frontmatter."""
    if raw and len(raw) == 8 and raw.isdigit():
        return f"{raw[0:4]}-{raw[4:6]}-{raw[6:8]}"
    return raw


def fmt_duration(raw):
    """Seconds -> H:MM:SS or M:SS."""
    try:
        s = int(float(raw))
    except (ValueError, TypeError):
        return raw
    h, rem = divmod(s, 3600)
    m, sec = divmod(rem, 60)
    if h:
        return f"{h}:{m:02d}:{sec:02d}"
    return f"{m}:{sec:02d}"


def download_vtt(url, tmpdir):
    """Download the best English caption track as VTT. Manual subs win over auto.

    Returns the path to the .vtt file, or None if no English captions exist.
    """
    out_tmpl = os.path.join(tmpdir, "%(id)s.%(ext)s")
    # Prefer manual English subtitles; fall back to auto-generated.
    # en-orig is YouTube's "English (Original)" auto track. Order matters: yt-dlp
    # picks the first language pattern that matches an available track.
    sub_langs = "en,en-US,en-GB,en-orig"
    code, out, err = run([
        "yt-dlp", "--no-warnings", "--skip-download",
        "--write-subs", "--write-auto-subs",
        "--sub-langs", sub_langs,
        "--sub-format", "vtt",
        "-o", out_tmpl, url,
    ])
    vtts = [f for f in os.listdir(tmpdir) if f.endswith(".vtt")]
    if not vtts:
        return None
    # Prefer a manual track if both manual and auto were written. yt-dlp names
    # auto tracks the same way, so just take the first; manual is written when present.
    vtts.sort()
    return os.path.join(tmpdir, vtts[0])


def vtt_to_lines(vtt_path):
    """Parse a VTT caption file into clean `[MM:SS] text` lines.

    YouTube auto-caption VTT is noisy: rolling cues that repeat the previous line,
    inline word-timing tags (<00:00:01.234><c>word</c>), and HTML entities. We strip
    all of that and dedupe consecutive repeats so the transcript reads cleanly.
    """
    with open(vtt_path, encoding="utf-8", errors="replace") as f:
        raw = f.read()

    ts_re = re.compile(r"(\d{2}):(\d{2}):(\d{2})\.\d{3}\s+-->")
    tag_re = re.compile(r"<[^>]+>")  # inline timing + <c> tags

    lines = []
    cur_ts = None
    last_text = None

    for line in raw.splitlines():
        line = line.rstrip()
        m = ts_re.match(line.strip())
        if m:
            hh, mm, ss = int(m.group(1)), int(m.group(2)), int(m.group(3))
            total_min = hh * 60 + mm
            cur_ts = f"[{total_min:02d}:{ss:02d}]"
            continue
        if not line.strip():
            continue
        if line.startswith(("WEBVTT", "Kind:", "Language:", "NOTE")):
            continue
        # strip inline tags + decode the few entities YouTube emits
        text = tag_re.sub("", line)
        text = (text.replace("&nbsp;", " ").replace("&amp;", "&")
                    .replace("&lt;", "<").replace("&gt;", ">")
                    .replace("&#39;", "'").replace("&quot;", '"'))
        text = text.strip()
        if not text or cur_ts is None:
            continue
        # rolling auto-captions repeat the prior line as they scroll; skip exact repeats
        if text == last_text:
            continue
        last_text = text
        lines.append(f"{cur_ts} {text}")

    return lines


def write_transcript(folder, meta, lines):
    os.makedirs(folder, exist_ok=True)
    fm = [
        "---",
        "type: raw-transcript",
        "source: youtube",
        f'title: "{meta["title"].replace(chr(34), chr(39))}"',
        f'url: "https://www.youtube.com/watch?v={meta["id"]}"',
        f'channel: "{meta["channel"].replace(chr(34), chr(39))}"',
        f"upload_date: {meta['upload_date_fmt']}",
        f"ingest_date: {meta['ingest_date']}",
        f"duration: {meta['duration_fmt']}",
        "---",
        "",
        "# Transcript",
        "",
    ]
    body = "\n".join(fm) + "\n".join(lines) + "\n"
    path = os.path.join(folder, "transcript.md")
    with open(path, "w", encoding="utf-8") as f:
        f.write(body)
    return path


def process(url, raw_dir, ingest_date):
    meta = get_metadata(url)
    if meta is None:
        return {"url": url, "status": "error",
                "message": "could not fetch metadata (private/age-gated/invalid URL?)"}

    slug = slugify(meta["title"])
    folder = os.path.join(raw_dir, f"{ingest_date}-{slug}")

    if os.path.isdir(folder):
        return {"url": url, "status": "skipped-duplicate",
                "folder": folder, "title": meta["title"]}

    with tempfile.TemporaryDirectory() as tmp:
        vtt = download_vtt(url, tmp)
        if vtt is None:
            return {"url": url, "status": "no-captions",
                    "title": meta["title"],
                    "message": "no English caption track available"}
        lines = vtt_to_lines(vtt)

    if not lines:
        return {"url": url, "status": "no-captions",
                "title": meta["title"],
                "message": "caption track found but produced no usable text"}

    meta["upload_date_fmt"] = fmt_upload_date(meta["upload_date"])
    meta["duration_fmt"] = fmt_duration(meta["duration"])
    meta["ingest_date"] = ingest_date
    path = write_transcript(folder, meta, lines)
    return {"url": url, "status": "filed", "folder": folder,
            "transcript": path, "title": meta["title"], "lines": len(lines)}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("urls", nargs="+")
    ap.add_argument("--raw-dir", required=True,
                    help="path to Raw/transcripts directory")
    ap.add_argument("--date", required=True,
                    help="ingest date, YYYY-MM-DD, used as folder prefix")
    args = ap.parse_args()

    results = [process(u, args.raw_dir, args.date) for u in args.urls]
    print(json.dumps({"results": results}, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
