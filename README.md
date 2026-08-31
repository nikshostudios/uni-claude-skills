# Martin's Odyssey

A full-stack Claude Code launch kit for university: **39 curated skills, an Obsidian
life-vault starter, and a seven-day flight plan**. Made for an info-systems student who
codes and studies with Claude Code, paced so a beginner never feels overwhelmed.

Start with **[the visual guide](https://nikshostudios.github.io/uni-claude-skills/)**.

## Step 0 — before anything

Install [Claude Code](https://claude.com/claude-code) and log in; check with
`claude --version`. The commands below are for the macOS/Linux terminal. On Windows,
run them inside WSL (`wsl --install` once from an admin PowerShell, reboot, then use
the WSL terminal — note Obsidian on Windows reads WSL files via `\\wsl$\...`, or keep
your vault on the Windows side under `/mnt/c/...`). Never paste passwords into any
chat.

## Install

**1. The skills (Day 1):**
```bash
t=$(mktemp -d) && curl -fsSLo $t/i.sh https://raw.githubusercontent.com/nikshostudios/uni-claude-skills/v1.0.1/install.sh && bash $t/i.sh && rm -rf $t
```
All 39 skills land in `~/.claude/skills/`, staged then activated per skill. Existing
same-name skills are never touched (`--force` replaces them, backing the old copies up
to `~/.claude/uni-claude-skills-backups/` first). A receipt of kit-owned skills is
written to `~/.claude/uni-claude-skills-receipt.txt` — review it before ever deleting
anything. Prefer to read code before running it? Clone this repo and run
`bash install.sh --local`.

**2. The vault (Day 3, no rush):**
```bash
t=$(mktemp -d) && curl -fsSLo $t/v.sh https://raw.githubusercontent.com/nikshostudios/uni-claude-skills/v1.0.1/install-vault.sh && bash $t/v.sh && rm -rf $t
```
Installs an Obsidian starter vault at `~/MyVault`. Want a different folder? Use this
complete form instead (the target goes inside the same command):
```bash
t=$(mktemp -d) && curl -fsSLo $t/v.sh https://raw.githubusercontent.com/nikshostudios/uni-claude-skills/v1.0.1/install-vault.sh && bash $t/v.sh ~/Uni && rm -rf $t
```
Open the vault in Obsidian, run `claude` inside it, and say
**"onboard me into my vault"** — three questions by default, a deeper interview only
if you opt in, and nothing is written without a preview and your yes.
**Already keep an Obsidian vault?** Skip this installer: open Claude Code inside your
vault and say "adopt the starter structure" — `/guide-me` previews what's missing,
copies only that, and never touches your notes.

**Then, in Claude Code, type:**
> /guide-me

## The seven-day flight plan

One small habit a day. Full detail on the [visual guide](https://nikshostudios.github.io/uni-claude-skills/).

| Day | Step | You say |
|---|---|---|
| 1 | Install + one real win on your nearest deadline | `/guide-me` |
| 2 | Get taught your most confusing topic (zero deps) | "Teach me X, here are my notes" |
| 3 | Install vault + get interviewed | "onboard me into my vault" |
| 4 | The two session habits | "wrap" · "checkpoint this" |
| 5 | First essay through the writing pipeline | "Grill my argument, then writing pipeline" |
| 6 | A project run like a professional | "to-spec this, tickets, implement" |
| 7 | Pick ONE power-up | "Which power-up fits my week?" |

## What's inside (39 skills, seven clusters)

- **Router:** `guide-me` (the front door: orientation, routing, pacing, dependency doctor)
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
No AI-detector evasion, no fabricated citations, no submitting work (prose OR code) you
can't explain. `assignment-creator` works from material you wrote and asks about your
course's AI policy; unknown policy defaults the kit to tutoring mode. Disclose AI use
where your university requires it.

## Credits

Workflow skills (`grill-me`, `to-spec`, `to-tickets`, `triage`, `implement`,
`wayfinder`, `writing-*`, `teach`, `ask-matt`…) originate from
[Matt Pocock's skills](https://github.com/mattpocock/skills). `watch` comes from the
[claude-video](https://github.com/bradautomates/claude-video) plugin. `humanizer` builds
on Wikipedia's "Signs of AI writing" guide. Curated and adapted from a working daily
setup.
