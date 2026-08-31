#!/usr/bin/env bash
# Martin's Odyssey — skills installer
#
# Recommended (download, inspect if you like, then run):
#   t="$(mktemp -d)" && curl -fsSLo "$t/i.sh" \
#     https://raw.githubusercontent.com/nikshostudios/uni-claude-skills/v1.0.0/install.sh \
#     && bash "$t/i.sh" && rm -rf "$t"
#
# Flags:
#   --force   replace existing same-name skills (old copies are backed up first)
#   --local   install from the repo checkout this script sits in (skips download)
#
# Compatible with macOS's stock Bash 3.2.
set -euo pipefail

TAG="v1.0.0"
REPO="https://github.com/nikshostudios/uni-claude-skills"
DEST="$HOME/.claude/skills"
CRITICAL="guide-me"
RECEIPT="$HOME/.claude/uni-claude-skills-receipt.txt"
BACKUP_ROOT="$HOME/.claude/uni-claude-skills-backups"
MARKER=".uni-claude-skills-owned"
TMP="$(mktemp -d)"
[[ -n "$TMP" && -d "$TMP" ]] || { echo "!!  mktemp failed"; exit 1; }
STAGE=""
trap 'rm -rf "$TMP"; [[ -n "$STAGE" ]] && rm -rf "$STAGE"' EXIT

FORCE=0 LOCAL=0
for a in "$@"; do
  case "$a" in
    --force) FORCE=1 ;;
    --local) LOCAL=1 ;;
    *) echo "unknown flag: $a (valid: --force --local)"; exit 2 ;;
  esac
done

echo "==> Martin's Odyssey — skills installer ($TAG)"
mkdir -p "$DEST"

# Resolve the payload. --local uses the checkout containing this script (validated
# by the repo marker); everything else fetches the pinned tag.
if [[ $LOCAL -eq 1 ]]; then
  SELF="${BASH_SOURCE[0]:-}"
  if [[ -z "$SELF" || ! -f "$SELF" ]]; then
    echo "!!  --local needs to run from a real file inside the repo checkout."; exit 1
  fi
  SRCROOT="$(cd "$(dirname "$SELF")" && pwd)"
  if [[ ! -f "$SRCROOT/.uni-claude-skills" ]]; then
    echo "!!  $SRCROOT is not a uni-claude-skills checkout (marker missing)."; exit 1
  fi
else
  echo "==> Downloading $TAG ..."
  # try git first, but NEVER trust it: stock macOS ships an Xcode shim that fails.
  # any git failure cleans up and falls through to curl/tar.
  if ! { command -v git >/dev/null 2>&1 && git clone --depth 1 --branch "$TAG" "$REPO" "$TMP/repo" >/dev/null 2>&1; }; then
    rm -rf "$TMP/repo"
    curl -fsSL "$REPO/archive/refs/tags/$TAG.tar.gz" | tar -xz -C "$TMP"
    mv "$TMP"/uni-claude-skills-* "$TMP/repo"
  fi
  SRCROOT="$TMP/repo"
  [[ -f "$SRCROOT/.uni-claude-skills" ]] || { echo "!!  Download looks wrong (marker missing) — aborting."; exit 1; }
fi
SRC="$SRCROOT/skills"
[[ -d "$SRC/$CRITICAL" ]] || { echo "!!  Payload is missing $CRITICAL — aborting."; exit 1; }

# Preflight the critical slot BEFORE any mutation: the router must end up
# kit-owned, or nothing should be installed at all.
critical_blocked=0
if [[ -e "$DEST/$CRITICAL" || -L "$DEST/$CRITICAL" ]]; then
  if [[ $FORCE -eq 0 && ! -f "$DEST/$CRITICAL/$MARKER" ]]; then
    critical_blocked=1
  fi
fi
if [[ $critical_blocked -eq 1 ]]; then
  echo
  echo "!!  Something else already owns $DEST/$CRITICAL, and the kit does not"
  echo "!!  work without its router. Nothing was installed."
  echo "!!  Re-run with --force (your existing copy is backed up first)."
  exit 1
fi

BACKUP_DIR=""   # created lazily via mktemp for uniqueness under concurrency
installed=0 skipped=0 replaced=0 failed=0
receipt_lines=()

stage_copy() { # src-dir name → stages and activates; returns nonzero on failure
  local dir="$1" name="$2"
  STAGE="$(mktemp -d "$DEST/.staging-XXXXXX")" || return 1
  if ! cp -R "$dir" "$STAGE/$name"; then rm -rf "$STAGE"; STAGE=""; return 1; fi
  if ! : > "$STAGE/$name/$MARKER"; then rm -rf "$STAGE"; STAGE=""; return 1; fi
  if ! mv "$STAGE/$name" "$DEST/$name"; then rm -rf "$STAGE"; STAGE=""; return 1; fi
  rm -rf "$STAGE"; STAGE=""
  return 0
}

install_one() { # explicit error handling — never relies on set -e inside
  local dir="$1" name; name="$(basename "$dir")"
  if [[ -e "$DEST/$name" || -L "$DEST/$name" ]]; then
    if [[ $FORCE -eq 0 ]]; then
      echo "  skip    $name (already exists — --force replaces, with backup)"
      skipped=$((skipped+1)); return 0
    fi
    if [[ -z "$BACKUP_DIR" ]]; then
      mkdir -p "$BACKUP_ROOT"
      BACKUP_DIR="$(mktemp -d "$BACKUP_ROOT/$(date +%Y%m%dT%H%M%S)-XXXXXX")" || { echo "  FAILED  $name (backup dir)"; failed=$((failed+1)); return 1; }
    fi
    if ! mv "$DEST/$name" "$BACKUP_DIR/$name"; then
      echo "  FAILED  $name (could not back up existing copy)"; failed=$((failed+1)); return 1
    fi
    if stage_copy "$dir" "$name"; then
      echo "  replace $name (old copy → $BACKUP_DIR/$name)"
      replaced=$((replaced+1)); receipt_lines+=("$name")
    else
      mv "$BACKUP_DIR/$name" "$DEST/$name" 2>/dev/null || true
      echo "  FAILED  $name (restored previous copy)"; failed=$((failed+1)); return 1
    fi
  else
    if stage_copy "$dir" "$name"; then
      echo "  install $name"
      installed=$((installed+1)); receipt_lines+=("$name")
    else
      rm -rf "$DEST/$name" 2>/dev/null || true
      echo "  FAILED  $name (copy error)"; failed=$((failed+1)); return 1
    fi
  fi
  return 0
}

for dir in "$SRC"/*/; do install_one "$dir" || true; done

# Post-verify the critical slot really is kit-owned now
if [[ ! -f "$DEST/$CRITICAL/$MARKER" ]]; then
  echo
  echo "!!  '$CRITICAL' did not install correctly — the kit is incomplete."
  exit 1
fi

# receipt: successful kit actions only, merged with prior runs, atomic write
if [[ -f "$RECEIPT" ]]; then
  while IFS= read -r line; do
    case "$line" in \#*|date:*|tag:*|"") continue ;; esac
    receipt_lines+=("$line")
  done < "$RECEIPT"
fi
{
  echo "# uni-claude-skills receipt — kit-owned skills (preview before deleting!)"
  echo "date: $(date -u +%FT%TZ)"
  echo "tag: $TAG"
  if [[ ${#receipt_lines[@]} -gt 0 ]]; then
    printf '%s\n' "${receipt_lines[@]}" | sort -u
  fi
} > "$RECEIPT.tmp" && mv "$RECEIPT.tmp" "$RECEIPT"

echo
echo "==> Done. $installed installed, $replaced replaced, $skipped skipped, $failed failed."
echo "==> Receipt: $RECEIPT"
echo "    (to remove the kit later: review that list, then delete those folders from ~/.claude/skills)"

echo
echo "==> Core check:"
if command -v claude >/dev/null 2>&1; then echo "    ok      claude"; else
  echo "    MISSING claude — install Claude Code first: https://claude.com/claude-code"; fi
if [[ -w "$DEST" ]]; then echo "    ok      $DEST writable"; fi
echo "    (per-skill tools: bash ~/.claude/skills/guide-me/doctor.sh)"

echo
echo "==> Next: open Claude Code anywhere and type:  /guide-me"
[[ $failed -eq 0 ]]
