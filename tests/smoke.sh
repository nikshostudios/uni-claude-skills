#!/usr/bin/env bash
# uni-claude-skills smoke tests — run from repo root: bash tests/smoke.sh
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
T="$(mktemp -d)"
[[ -n "$T" && -d "$T" && -w "$T" ]] || { echo "ABORT: mktemp failed"; exit 1; }
trap 'rm -rf "$T"' EXIT
pass=0; fail=0
ok()  { echo "  ok   $1"; pass=$((pass+1)); }
bad() { echo "  FAIL $1"; fail=$((fail+1)); }

echo "== smoke: uni-claude-skills =="

# 1. fresh install (--local), exact count, guide-me present + kit-owned, receipt written
H1="$T/h1"; mkdir -p "$H1"
HOME="$H1" bash "$ROOT/install.sh" --local >/dev/null 2>&1
rc=$?
[[ $rc -eq 0 ]] && ok "fresh install exit 0" || bad "fresh install exit $rc"
n=$(ls "$H1/.claude/skills" 2>/dev/null | grep -vc '^\.' || true)
expected=$(ls "$ROOT/skills" | wc -l | tr -d ' ')
[[ "$n" -eq "$expected" ]] && ok "fresh install: exactly $n skills" || bad "fresh install count=$n want=$expected"
[[ -f "$H1/.claude/skills/guide-me/.uni-claude-skills-owned" ]] && ok "guide-me installed + kit-owned" || bad "guide-me ownership marker missing"
[[ -f "$H1/.claude/uni-claude-skills-receipt.txt" ]] && ok "receipt written" || bad "receipt missing"
grep -qx "guide-me" "$H1/.claude/uni-claude-skills-receipt.txt" && ok "receipt lists guide-me" || bad "receipt lacks guide-me"
find "$H1/.claude/skills" -maxdepth 1 -name ".staging-*" | grep -q . && bad "staging debris left" || ok "no staging debris"

# 2. rerun idempotence: everything skips, exit MUST be 0 (bash-3.2 empty-array trap)
HOME="$H1" bash "$ROOT/install.sh" --local >"$T/rerun.out" 2>&1
rc=$?
[[ $rc -eq 0 ]] && ok "rerun exit 0" || bad "rerun exit $rc"
grep -q "skip" "$T/rerun.out" && ok "rerun skips existing" || bad "rerun did not skip"

# 3. file collision honored (a FILE named like a skill is not deleted)
H2="$T/h2"; mkdir -p "$H2/.claude/skills"; echo keep > "$H2/.claude/skills/teach"
HOME="$H2" bash "$ROOT/install.sh" --local >/dev/null 2>&1 || true
[[ -f "$H2/.claude/skills/teach" && "$(cat "$H2/.claude/skills/teach")" == "keep" ]] \
  && ok "file collision preserved" || bad "file collision destroyed"

# 4. guide-me collision without --force → installer fails loudly
H3="$T/h3"; mkdir -p "$H3/.claude/skills/guide-me-x"; mv "$H3/.claude/skills/guide-me-x" "$H3/.claude/skills/guide-me"
touch "$H3/.claude/skills/guide-me/user-owned.txt"
if HOME="$H3" bash "$ROOT/install.sh" --local >/dev/null 2>&1; then
  bad "guide-me collision: installer claimed success"
else ok "guide-me collision: installer exits nonzero"; fi

# 5. --force backs up and replaces
HOME="$H3" bash "$ROOT/install.sh" --local --force >/dev/null 2>&1
[[ -f "$H3/.claude/skills/guide-me/SKILL.md" ]] && ok "--force replaced guide-me" || bad "--force did not replace"
ls "$H3/.claude/uni-claude-skills-backups/"*/guide-me/user-owned.txt >/dev/null 2>&1 \
  && ok "--force backup preserved old copy" || bad "--force backup missing"

# 6. --local marker guard: script copied outside the repo refuses
cp "$ROOT/install.sh" "$T/naked-install.sh"
if HOME="$T/h4" bash "$T/naked-install.sh" --local >/dev/null 2>&1; then
  bad "--local without marker: ran anyway"
else ok "--local without marker: refused"; fi

# 7. vault matrix
V="$T/v"
bash "$ROOT/install-vault.sh" "$V/absent" --local >/dev/null 2>&1 && [[ -f "$V/absent/Home.md" ]] \
  && ok "vault: absent target installs" || bad "vault: absent target"
mkdir -p "$V/empty"
bash "$ROOT/install-vault.sh" "$V/empty" --local >/dev/null 2>&1 && [[ -f "$V/empty/Home.md" ]] \
  && ok "vault: empty dir installs (no nesting)" || bad "vault: empty dir"
[[ -d "$V/empty/vault-starter" || -d "$V/empty/.vault-stage"* ]] && bad "vault: nested/stage debris" || ok "vault: no nesting or debris"
mkdir -p "$V/full"; echo "my note" > "$V/full/existing.md"; cp "$V/full/existing.md" "$T/existing.ref"
out=$(bash "$ROOT/install-vault.sh" "$V/full" --local 2>&1 || true)
echo "$out" | grep -qi "adopt" && ok "vault: nonempty → adoption message" || bad "vault: nonempty message"
cmp -s "$V/full/existing.md" "$T/existing.ref" && ok "vault: existing note byte-unchanged (cmp)" || bad "vault: existing note changed"
find "$V" -maxdepth 1 -name ".vault-stage-*" | grep -q . && bad "vault stage debris left" || ok "vault: no stage debris"
echo x > "$V/afile"
bash "$ROOT/install-vault.sh" "$V/afile" --local >/dev/null 2>&1 && bad "vault: file target accepted" || ok "vault: file target rejected"
ln -s "$V/absent" "$V/alink"
bash "$ROOT/install-vault.sh" "$V/alink" --local >/dev/null 2>&1 && bad "vault: symlink accepted" || ok "vault: symlink rejected"
bash "$ROOT/install-vault.sh" "$V/absent" --local >/dev/null 2>&1 && bad "vault: rerun overwrote" || ok "vault: rerun refused (adoption path)"

# 8. hygiene greps: no personal data, no absolute owner paths in skills
if grep -rIl "/Users/nikhilkumar\|Mangalayatan\|exceltech\|flaira\|Niksho" "$ROOT/skills" >/dev/null 2>&1; then
  bad "personal-data grep found matches"
else ok "personal-data grep clean"; fi

# 9. --release: exercise the ACTUAL published path (run after tagging/pushing)
if [[ "${1:-}" == "--release" ]]; then
  HR="$T/hr"; mkdir -p "$HR"
  tmp2="$T/dl"; mkdir -p "$tmp2"
  if curl -fsSLo "$tmp2/i.sh" "https://raw.githubusercontent.com/nikshostudios/uni-claude-skills/v1.0.0/install.sh" \
     && HOME="$HR" bash "$tmp2/i.sh" >/dev/null 2>&1; then
    rn=$(ls "$HR/.claude/skills" 2>/dev/null | grep -vc '^\.' || true)
    [[ "$rn" -eq "$expected" ]] && ok "release: published command installs exactly $rn" || bad "release: count=$rn want=$expected"
    [[ -f "$HR/.claude/skills/guide-me/.uni-claude-skills-owned" ]] && ok "release: guide-me kit-owned" || bad "release: guide-me marker missing"
  else
    bad "release: published install command failed"
  fi
  # broken-git variant: a git shim that always fails must fall through to curl/tar
  HB="$T/hb"; mkdir -p "$HB"; FAKEBIN="$T/fakebin"; mkdir -p "$FAKEBIN"
  printf '#!/bin/sh\nexit 1\n' > "$FAKEBIN/git"; chmod +x "$FAKEBIN/git"
  if HOME="$HB" PATH="$FAKEBIN:$PATH" bash "$tmp2/i.sh" >/dev/null 2>&1; then
    bn=$(ls "$HB/.claude/skills" 2>/dev/null | grep -vc '^\.' || true)
    [[ "$bn" -eq "$expected" ]] && ok "release: broken-git falls back to tar ($bn skills)" || bad "release: broken-git count=$bn"
  else
    bad "release: broken-git install failed (fallback missing)"
  fi
fi

echo
echo "== $pass passed, $fail failed =="
[[ $fail -eq 0 ]]
