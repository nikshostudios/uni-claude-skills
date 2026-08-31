---
name: vault-onboard
description: Interview a new vault owner thoroughly about their life, studies, week, and goals — then populate their Obsidian starter vault (Home, Efforts, Atlas, Calendar) from the answers and give personalized skill recommendations. Use when the user says "onboard me", "onboard me into my vault", "/vault-onboard", "set up my vault", "interview me", or when a vault's Home.md still contains {{PLACEHOLDER}} text. This is the vault's day-one experience — be warm, be thorough, never rush it.
---

# Skill: vault-onboard

## What this is

The user just installed a starter vault (Home / Efforts / Wiki / Raw / Atlas / Calendar /
Sessions). It's an empty shell. Your job: **interview them properly, then build their
vault around their real life** — and end with personalized recommendations for which
skills fit their actual week.

Tone: curious friend helping them set up, not a form. One theme at a time. React to
answers, ask the obvious follow-up. Prefer AskUserQuestion for choice-shaped questions
and plain chat for open ones. NEVER dump all questions at once.

## Two modes

- **Starter-vault mode** (default): the vault came from the kit's installer —
  `Home.md` contains `{{PLACEHOLDER}}` text. Run the interview and fill it.
- **Existing-vault mode**: the user adopted the starter structure into a vault they
  already had. Identified by the `.uni-vault-adopted` marker at the vault root
  (written by guide-me's adoption recipe; it records their real dashboard path — use
  that instead of assuming `Home.md`). Everything below applies with one change:
  be strictly ADDITIVE — read what their vault already answers (identity notes, course
  folders, deadline lists), ask ONLY for genuinely missing fields, and write ONLY new
  files. Never rewrite, rename, append to, or reorganize anything that existed before;
  if something belongs in one of their existing notes, write it as a new note and tell
  them, so any merge is theirs to do.

## Before starting

1. Identify the vault and mode: `.uni-vault-adopted` marker present → existing-vault
   mode (dashboard path is inside the marker). No marker but `Home.md` contains
   placeholder text → starter mode. Neither → ask where the vault lives and which
   note is their dashboard.
2. **Privacy preamble, always:** "Your answers get saved as plain files in this vault on
   your machine; what you type here is processed by Claude under your account's data
   settings. Skip any question you like. Never give me passwords, ID numbers, or
   anything you wouldn't write in a notebook."
3. **Import intake if it exists:** read `~/.claude/uni-intake.md` (written by /guide-me
   with consent). Anything answered there is NOT asked again. Offer to delete the file
   once imported.
4. **Offer two depths:**
   - **Fast path (default, ~3 min):** three questions — name + university/program, ONE
     active effort with its next real deadline (as an absolute `YYYY-MM-DD` date plus
     timezone if it's an online submission; "unknown" is a valid answer and is
     recorded as unknown, never estimated), the most annoying recurring task. Build
     the vault from just that; everything else stays honestly thin.
   - **Full interview (~10-15 min):** the five rounds below. Offer as "want to go
     deeper now or later?" — later is a fine answer; they can rerun this skill anytime
     to enrich.

## The interview — five rounds

### Round 1 — Identity
- Name (as they want it in their own vault), university, program/major, current
  semester/year.
- One line on where they're headed (dream job / field / "no idea yet" is a fine answer).

### Round 2 — The week (this powers everything else)
- What does a normal week actually look like? Class days/times roughly, part-time work,
  gym/sport, clubs, commute, when they study best (morning/night).
- Where does time leak? (be gentle, but ask)
- How do they currently keep track of deadlines and notes? (phone notes / head / nothing
  — no judgment, this is the baseline)

### Round 3 — Commitments (becomes Efforts/)
- Every current course this semester: name, rough deadline pressure (heavy project?
  weekly labs? one big exam?).
- Any projects outside coursework: side project, job applications, a club role, a
  business idea.
- For each: what would "this went well" look like at end of semester?
- **Dates for real:** ask for the actual known due dates (absolute, e.g. 2026-09-12)
  and their timezone if deadlines are online. Unknown dates are recorded as
  "unknown" — never estimated, never invented.

### Round 4 — Goals & pain
- Top 1-3 goals for this semester, concretely.
- The single most stressful/annoying recurring task in their student life right now.
  (This directly drives your skill recommendations.)
- Anything big on the horizon: exchange, internship hunt, thesis.

### Round 5 — Tools & style
- Devices and stack: which languages/frameworks their program uses, editor, OS.
- Obsidian experience: new or already using it?
- How much do they want Claude proactively managing things vs. only when asked?

## Then build the vault (with Write/Edit — AFTER the write gate)

**Write gate:** before writing anything, show a preview — the list of files you'll
create/update with a one-line gist each — and ask "File it?". Only write on yes;
adjust on corrections.

**Path hygiene (shared rule with /wrap):** every folder/file name derived from answers
is slugified — lowercase, letters/digits/dashes only, empty result falls back to
`note`; resolved paths must stay inside the vault; on collision append `-2`, `-3`, …

1. **Home.md** — replace every placeholder: identity line, the week (as a compact
   schedule), active efforts (linked), deadline radar (dated, nearest first).
2. **Efforts/** — one folder per course + per project from Round 3, each with an
   `Overview.md` from `Templates/effort.md`: goal, deadline, 1-3 next actions from what
   they said. Update `Efforts/Efforts.md` index.
3. **Atlas/People/** — a stub note per person who came up (professors, project
   teammates): name + context.
4. **Atlas/Tools/stack.md** — their stack from Round 5.
5. **Calendar/Daily/<today>.md** — first daily note from `Templates/daily.md`, with
   today's actual top priority.
6. **Sessions/<today>-onboarding.md** — short digest: what was set up, key facts learned.

## Close with the personalized map (the payoff)

Based on their answers, give a short "your setup, your skills" briefing:
- Their most stressful task (Round 4) → the exact skill/pipeline that attacks it, with
  the sentence to say.
- Their study style → study pipeline suggestion (/yt-search → /yt-transcript → /teach).
- Their heaviest course → suggest a standing weekly ritual (e.g. "after each lecture,
  paste the recording link; Sunday night, /wrap the week").
- Their coding coursework → the coding-cluster skills that apply.
- Remind them of the one habit that makes the vault compound: **end real work sessions
  with `/wrap`**.

Keep the close under ~20 lines. They should finish feeling oriented, not assigned
homework.

## Guardrails

- Never invent facts they didn't say; leave sections honestly thin instead.
- Absolute dates everywhere (2026-09-12, not "in two weeks").
- If they stall mid-interview, save what you have — the vault must never end up worse
  than you found it. Offer to resume later; note where you stopped in the Sessions
  digest.
