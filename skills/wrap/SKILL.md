---
name: wrap
description: End-of-session ceremony for the vault. One command at the end of a real work session — writes a session digest, updates the touched Effort's Overview (decisions, next actions), appends to today's daily note, and refreshes Home.md's deadline radar if anything changed. Use when the user says "/wrap", "wrap", "wrap up", "wrap session", "end chat", or when a substantial session inside the vault is clearly winding down (offer it — don't force it).
---

# Skill: wrap

## What this is

The habit that makes the vault compound. Work sessions produce decisions, progress, and
next steps — /wrap files them so next session (or next month) starts warm instead of
cold. Without it the vault rots; with it, it becomes memory.

Runs inside the user's vault — **their** vault, whichever it is: the kit's starter
vault OR their own pre-existing Obsidian vault that adopted the starter structure
(the folder with `Home.md`-or-equivalent + `Efforts/`). If not obviously in a vault,
ask where it lives. If the vault is missing a piece this skill writes to (`Sessions/`,
`Templates/daily.md`), offer to create just that piece — never restructure anything
else.

## Steps

### 1. Draft the digest (from THIS conversation)
Reconstruct what actually happened this session:
- **Topic** — one line.
- **Done** — what got produced/decided (bullets, concrete).
- **Decisions** — anything chosen between alternatives, with the why.
- **Next actions** — what's now unblocked or promised, each with an owner ("me") and a
  date if one exists.
- **Open questions** — anything left genuinely unresolved.

### 2. One batched confirmation
Show the user the digest draft AND the list of files you intend to touch (see step 3) in
one message. Ask once: "File it?" Adjust if they correct anything. Never write before
this confirmation.

### 3. Write, in this order
0. **Path hygiene (shared rule with /vault-onboard):** slugs are lowercase
   letters/digits/dashes, empty falls back to `session`; paths stay inside the vault;
   if `Sessions/YYYY-MM-DD-<topic-slug>.md` already exists, append `-2`, `-3`, … —
   never overwrite an earlier digest.
1. `Sessions/YYYY-MM-DD-<topic-slug>.md` — the digest (create `Sessions/` if missing).
2. The touched Effort's `Overview.md` — append decisions to its Log with today's date;
   update its Next actions to match reality. If the session created a NEW commitment,
   create its Effort folder from `Templates/effort.md` and add it to
   `Efforts/Efforts.md`.
3. `Calendar/Daily/YYYY-MM-DD.md` — append a "Happened" line (create from
   `Templates/daily.md` if it doesn't exist).
4. `Home.md` — ONLY if something changed at dashboard level: a new effort, a finished
   one, a deadline moved. Keep the radar dated and sorted nearest-first.

### 4. Link
Digest links to the effort (`[[Efforts/<X>/Overview]]`); effort log line links back to
the digest. Two-way, always.

### 5. Report
One short block: files written (paths), one-line summary each. If the conversation is
very long and the user plans to continue the work, ALSO offer the `checkpoint` skill
("want a handoff prompt for a fresh session?").

## Guardrails

- Digest reflects the conversation, not aspiration — if something failed, log that it
  failed.
- Never duplicate an existing effort folder; extend it.
- Absolute dates only.
- Small sessions deserve small wraps: a 10-minute Q&A gets three lines, not a ceremony.
