#!/usr/bin/env bash
# Martin's Odyssey — vault installer
#
# Recommended:
#   tmp="$(mktemp -d)" && curl -fsSLo "$tmp/install-vault.sh" \
#     https://raw.githubusercontent.com/nikshostudios/uni-claude-skills/v1.0.0/install-vault.sh \
#     && bash "$tmp/install-vault.sh" ~/MyVault; rm -rf "$tmp"
#
# Usage: install-vault.sh [target-folder] [--local]
set -euo pipefail

TAG="v1.0.0"
REPO="https://github.com/nikshostudios/uni-claude-skills"
TARGET="$HOME/MyVault"
LOCAL=0
for a in "$@"; do
  case "$a" in
    --local) LOCAL=1 ;;
    -*) echo "unknown flag: $a"; exit 2 ;;
    *) TARGET="$a" ;;
  esac
done
TMP="$(mktemp -d)"
[[ -n "$TMP" && -d "$TMP" ]] || { echo "!!  mktemp failed"; exit 1; }
STAGE=""
trap 'rm -rf "$TMP"; [[ -n "$STAGE" ]] && rm -rf "$STAGE"' EXIT

echo "==> Martin's Odyssey — vault installer ($TAG)"

# Target matrix: symlink/file → reject; nonempty dir → adoption path;
# empty dir → install into it; absent → create.
if [[ -L "$TARGET" ]]; then
  echo "!!  $TARGET is a symlink — refusing. Pick a real folder."; exit 1
elif [[ -f "$TARGET" ]]; then
  echo "!!  $TARGET is a file — refusing. Pick a folder path."; exit 1
elif [[ -d "$TARGET" && -n "$(ls -A "$TARGET" 2>/dev/null)" ]]; then
  echo "!!  $TARGET already has content — not touching it."
  echo
  echo "    Already keep a vault? You don't need this installer:"
  echo "    open Claude Code inside YOUR vault and say:"
  echo "      \"adopt the starter structure from uni-claude-skills\""
  echo "    (/guide-me knows the adoption recipe — it previews, copies only"
  echo "    missing folders/templates, and never touches your notes.)"
  exit 1
fi

if [[ $LOCAL -eq 1 ]]; then
  SELF="${BASH_SOURCE[0]:-}"
  [[ -n "$SELF" && -f "$SELF" ]] || { echo "!!  --local needs a real script file."; exit 1; }
  SRCROOT="$(cd "$(dirname "$SELF")" && pwd)"
  [[ -f "$SRCROOT/.uni-claude-skills" ]] || { echo "!!  Not a uni-claude-skills checkout."; exit 1; }
else
  echo "==> Downloading $TAG ..."
  # git first, curl/tar on ANY git failure (macOS Xcode shim included)
  if ! { command -v git >/dev/null 2>&1 && git clone --depth 1 --branch "$TAG" "$REPO" "$TMP/repo" >/dev/null 2>&1; }; then
    rm -rf "$TMP/repo"
    curl -fsSL "$REPO/archive/refs/tags/$TAG.tar.gz" | tar -xz -C "$TMP"
    mv "$TMP"/uni-claude-skills-* "$TMP/repo"
  fi
  SRCROOT="$TMP/repo"
  [[ -f "$SRCROOT/.uni-claude-skills" ]] || { echo "!!  Download looks wrong — aborting."; exit 1; }
fi

# stage next to the destination, validate, then activate atomically;
# STAGE is registered in the EXIT trap the moment it exists
PARENT="$(dirname "$TARGET")"
mkdir -p "$PARENT"
STAGE="$(mktemp -d "$PARENT/.vault-stage-XXXXXX")"
[[ -n "$STAGE" && -d "$STAGE" ]] || { echo "!!  staging failed"; exit 1; }
cp -R "$SRCROOT/vault-starter/". "$STAGE/"
for must in Home.md CLAUDE.md Efforts/Efforts.md Templates/effort.md; do
  [[ -f "$STAGE/$must" ]] || { echo "!!  Staged vault is incomplete ($must missing) — aborting."; exit 1; }
done
if [[ -d "$TARGET" ]]; then rmdir "$TARGET"; fi   # known-empty from the matrix above
mv "$STAGE" "$TARGET"
STAGE=""   # activated — nothing left for the trap to clean

echo
echo "==> Vault installed at: $TARGET"
echo
echo "   Next three steps:"
echo "   1. Open Obsidian → 'Open folder as vault' → pick $TARGET"
echo "   2. In a terminal:  cd \"$TARGET\" && claude"
echo "   3. Type:  /guide-me   (or say: onboard me into my vault)"
