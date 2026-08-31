#!/usr/bin/env bash
# uni-claude-skills installer
# Copies every skill in this repo's skills/ folder into ~/.claude/skills/
# Safe: never overwrites an existing skill unless you pass --force.
set -euo pipefail

FORCE=0
[[ "${1:-}" == "--force" ]] && FORCE=1

REPO="https://github.com/nikshostudios/uni-claude-skills"
DEST="$HOME/.claude/skills"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "==> uni-claude-skills installer"
mkdir -p "$DEST"

if [[ -d "$(dirname "$0")/skills" ]]; then
  SRC="$(cd "$(dirname "$0")/skills" && pwd)"   # running from a local clone
else
  echo "==> Downloading latest from $REPO ..."
  if command -v git >/dev/null 2>&1; then
    git clone --depth 1 "$REPO" "$TMP/repo" >/dev/null 2>&1
  else
    curl -fsSL "$REPO/archive/refs/heads/main.tar.gz" | tar -xz -C "$TMP"
    mv "$TMP"/uni-claude-skills-main "$TMP/repo"
  fi
  SRC="$TMP/repo/skills"
fi

installed=0 skipped=0
for dir in "$SRC"/*/; do
  name="$(basename "$dir")"
  if [[ -d "$DEST/$name" && $FORCE -eq 0 ]]; then
    echo "  skip   $name (already installed — use --force to overwrite)"
    ((skipped++)) || true
    continue
  fi
  rm -rf "$DEST/$name"
  cp -R "$dir" "$DEST/$name"
  echo "  install $name"
  ((installed++)) || true
done

echo
echo "==> Done. $installed installed, $skipped skipped."
echo "==> Open Claude Code and type /  to see your new skills."
echo "==> First move: ask Claude to read HANDOFF.md from this repo:"
echo "    https://github.com/nikshostudios/uni-claude-skills/blob/main/HANDOFF.md"
