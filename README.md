# Martin's Odyssey

A full-stack Claude Code launch kit for university: **38 curated skills, an Obsidian
life-vault starter, and a seven-day flight plan**. Made for an info-systems student who
codes and studies with Claude Code, paced so a beginner never feels overwhelmed.

Start with **[the visual guide](https://nikshostudios.github.io/uni-claude-skills/)**.

## Install

**1. The skills (Day 1):**
```bash
curl -fsSL https://raw.githubusercontent.com/nikshostudios/uni-claude-skills/main/install.sh | bash
```
All 38 skills land in `~/.claude/skills/`. Never overwrites existing skills
(`--force` from a clone if you want that).

**2. The vault (Day 3, no rush):**
```bash
curl -fsSL https://raw.githubusercontent.com/nikshostudios/uni-claude-skills/main/install-vault.sh | bash
```
Installs an Obsidian starter vault at `~/MyVault` (pass another path as an argument).
Open it in Obsidian, run `claude` inside it, and say **"onboard me into my vault"**.
A ten-minute interview builds the vault around your actual life and ends with
personalized skill recommendations.

**Then, in Claude Code:**
> Read the HANDOFF.md from the uni-claude-skills repo and be my guide.

## The seven-day flight plan

One small habit a day. Full detail on the [visual guide](https://nikshostudios.github.io/uni-claude-skills/).

| Day | Step | You say |
|---|---|---|
| 1 | Install + one real win on your nearest deadline | "…be my guide. Here's my semester…" |
| 2 | Study pipeline on your most confusing topic | "Find the best video on X, transcript, teach me" |
| 3 | Install vault + get interviewed | "onboard me into my vault" |
| 4 | The two session habits | "wrap" · "checkpoint this" |
| 5 | First essay through the writing pipeline | "Grill my argument, then writing pipeline" |
| 6 | A project run like a professional | "to-spec this, tickets, implement" |
| 7 | Pick ONE power-up | "Which power-up fits my week?" |

## What's inside (38 skills, six clusters)

- **Study:** `teach` · `yt-search` · `yt-transcript` · `watch` · `wait-what` · `zoom-out`
- **Vault:** `vault-onboard` · `wrap` (+ the `vault-starter/` shell with its own CLAUDE.md)
- **Writing:** `unslop` · `humanizer` · `writing-fragments` · `writing-beats` · `writing-shape`
- **Thinking:** `grill-me` · `grill-with-docs` · `creativity` · `to-questionnaire` · `loop-me`
- **Projects:** `to-spec` · `to-tickets` · `implement` · `triage` · `wayfinder` · `graph` · `checkpoint` · `claude-handoff` · `mp-handoff` · `ask-matt` · `write-a-skill`
- **Coding & design:** `frontend-design` · `impeccable` · `ui-styling` · `ui-ux-pro-max` · `design-system` · `improve-codebase-architecture` · `setup-ts-deep-modules` · `playwright-cli`
- **Documents:** `assignment-creator`

## Power-ups (week 2+, separate installs)

- **codex second opinion** — `npm i -g @openai/codex` + `codex login` + a codex plugin
  via `/plugin`. Cross-check hard bugs with a second frontier model.
- **ego lite** — desktop app giving Claude a real logged-in browser via task spaces.
- **claude-mem** — persistent memory across sessions, via `/plugin`.
- **mattpocock-skills plugin** — `tdd`, `diagnosing-bugs`, `code-review`, more:
  [mattpocock/skills](https://github.com/mattpocock/skills).
- **Built-ins** — `/code-review` and `/security-review` before submitting code.

## The hangar (advanced — star now, explore later)

[claudex-loop](https://github.com/chaseai-yt/claudex-loop) ·
[archify](https://github.com/tt-a1i/archify) ·
[herdr](https://github.com/herdrdev/herdr) ·
[anydoc](https://github.com/firecrawl/anydoc) ·
[deepseek-harness](https://github.com/deepseek-ai/deepseek-harness)

## Optional dependencies

```bash
brew install yt-dlp ffmpeg   # yt-search, yt-transcript, watch
npm i -D playwright && npx playwright install chromium   # assignment-creator PDF, playwright-cli
pip install --user pymupdf python-docx pillow            # assignment-creator DOCX
```
Skills tell you what's missing when you run them — install on demand.

## Academic integrity

These tools help you **learn, think, plan, and produce** — not misrepresent authorship.
No AI-detector evasion, no fabricated citations, no submitting work you can't explain;
`assignment-creator` refuses that by design. Disclose AI use where your university
requires it.

## Credits

Workflow skills (`grill-me`, `to-spec`, `to-tickets`, `triage`, `implement`,
`wayfinder`, `writing-*`, `teach`, `ask-matt`…) originate from
[Matt Pocock's skills](https://github.com/mattpocock/skills). `watch` comes from the
[claude-video](https://github.com/bradautomates/claude-video) plugin. `humanizer` builds
on Wikipedia's "Signs of AI writing" guide. Curated and adapted from a working daily
setup.
