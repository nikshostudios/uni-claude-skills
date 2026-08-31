#!/usr/bin/env bash
# uni-claude-skills vault installer
# Copies the starter Obsidian vault to a folder of your choice (default: ~/MyVault).
# Usage: bash install-vault.sh [target-folder]
set -euo pipefail

REPO="https://github.com/nikshostudios/uni-claude-skills"
TARGET="${1:-$HOME/MyVault}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "==> vault installer"

if [[ -e "$TARGET" && -n "$(ls -A "$TARGET" 2>/dev/null)" ]]; then
  echo "!!  $TARGET already exists and is not empty — refusing to touch it."
  echo "    Pick another folder: bash install-vault.sh ~/SomewhereElse"
  exit 1
fi

if [[ -d "$(dirname "$0")/vault-starter" ]]; then
  SRC="$(cd "$(dirname "$0")/vault-starter" && pwd)"
else
  echo "==> Downloading latest from $REPO ..."
  if command -v git >/dev/null 2>&1; then
    git clone --depth 1 "$REPO" "$TMP/repo" >/dev/null 2>&1
  else
    curl -fsSL "$REPO/archive/refs/heads/main.tar.gz" | tar -xz -C "$TMP"
    mv "$TMP"/uni-claude-skills-main "$TMP/repo"
  fi
  SRC="$TMP/repo/vault-starter"
fi

mkdir -p "$TARGET"
cp -R "$SRC/". "$TARGET/"

echo
echo "==> Vault installed at: $TARGET"
echo
echo "   Next three steps:"
echo "   1. Open Obsidian → 'Open folder as vault' → pick $TARGET"
echo "   2. In a terminal:  cd \"$TARGET\" && claude"
echo "   3. Say:  onboard me into my vault"
echo
echo "   Claude will interview you (~10 min) and build the vault around your life."
