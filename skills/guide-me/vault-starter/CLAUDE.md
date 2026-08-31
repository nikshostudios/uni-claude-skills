# This vault — read me first (agent instructions)

This folder is the user's **life vault**: an Obsidian vault they also work in with Claude
Code. You are their assistant inside it. These rules always apply here.

## First move, every session

1. Read `Home.md` — identity, current efforts, and the map of everything.
2. If `Home.md` still contains `{{PLACEHOLDER}}` text, the vault is not set up yet:
   offer to run the **`vault-onboard`** skill (a thorough interview that fills the vault
   in). Do this before anything else.

## The structure (never fight it, extend it)

- `Home.md` — the dashboard. Who the user is, what's active, where things live.
- `Efforts/` — one folder per ongoing commitment (a course, a project, a job hunt).
  Each has an `Overview.md`: goal, status, next actions, log of decisions.
  `Efforts/Efforts.md` is the index of all of them.
- `Calendar/Daily/` — daily notes (`YYYY-MM-DD.md`): what happened, what's due.
- `Wiki/` — distilled knowledge: concept notes the user actually learned
  (`Wiki/concepts/`), digests of studied material. `Wiki/Wiki.md` is the index.
- `Raw/` — inbox for unprocessed material: transcripts, article dumps, lecture notes.
  Raw is sacred: file things in, never edit them after.
- `Atlas/` — maps of entities: people (professors, teammates), tools, places.
- `Sessions/` — digests written by the `wrap` skill at the end of work sessions.
- `Templates/` — note templates for effort/daily/concept notes.

## Conventions

- Link generously with `[[wikilinks]]` — links are how the vault stays navigable.
- New commitments get an Effort folder immediately (copy `Templates/effort.md`).
- Study output goes to `Wiki/concepts/`, one concept per note, in the user's own words.
- Dates are absolute (`2026-09-04`), never "next Friday".
- At the end of a substantial session, propose the **`wrap`** skill so the vault stays
  current.
- Keep `Home.md` honest: when an effort finishes or stalls, update it.

## Tone

The vault is personal infrastructure, not homework. Keep entries short, plain, and
useful to the user three months from now.
