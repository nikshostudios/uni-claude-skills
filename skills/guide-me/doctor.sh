#!/usr/bin/env bash
# uni-claude-skills dependency doctor
# Usage: doctor.sh            → full report
#        doctor.sh --skill X  → just skill X's needs
set -uo pipefail

FILTER=""
[[ "${1:-}" == "--skill" && -n "${2:-}" ]] && FILTER="$2"

have() { command -v "$1" >/dev/null 2>&1; }
py()   { python3 -c "import $1" >/dev/null 2>&1; }

report() { # name, needed-by, present(0/1), fix
  local mark="MISSING"; [[ "$3" == "0" ]] && mark="ok     "
  if [[ -n "$FILTER" && "$2" != *"$FILTER"* ]]; then return; fi
  printf "  %s  %-12s needed by: %s\n" "$mark" "$1" "$2"
  [[ "$3" != "0" ]] && printf "           fix: %s\n" "$4"
}

echo "uni-claude-skills doctor"
echo
echo "core:"
if have claude; then echo "  ok       claude"; else
  echo "  MISSING  claude — install Claude Code first: https://claude.com/claude-code"; fi
if [[ -w "$HOME/.claude/skills" ]]; then echo "  ok       ~/.claude/skills writable"; else
  echo "  MISSING  write access to ~/.claude/skills"; fi
echo
echo "per-skill tools (install only what you actually use):"

have yt-dlp;      report yt-dlp      "yt-search, yt-transcript, watch" $? "brew install yt-dlp   (or: pipx install yt-dlp)"
have ffmpeg;      report ffmpeg      "watch" $? "brew install ffmpeg"
have python3;     report python3     "yt-search, yt-transcript, watch, assignment-creator" $? "install from python.org or via brew"
have node;        report node        "assignment-creator (PDF), playwright-cli, impeccable" $? "install from nodejs.org or via brew"
py fitz;          report pymupdf     "assignment-creator (DOCX/verify)" $? "pip install --user pymupdf"
py docx;          report python-docx "assignment-creator (editable DOCX)" $? "pip install --user python-docx"
node -e "require('playwright')" >/dev/null 2>&1; report playwright "assignment-creator (PDF render)" $? "npm i playwright && npx playwright install chromium"
node -e "require('playwright')" >/dev/null 2>&1 && npx --no-install playwright --version >/dev/null 2>&1; report pw-cli "playwright-cli skill (browser automation)" $? "npm i playwright && npx playwright install chromium (the skill drives npx playwright)"
have git;         report git         "installer updates (--force re-run)" $? "xcode-select --install (macOS) / apt install git"

echo
echo "Nothing here blocks the basics: /guide-me, /teach, writing and planning skills run with zero extras."
