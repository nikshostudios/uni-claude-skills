# uni-claude-skills

A curated pack of **35 Claude Code skills** for university students — study faster, write
better, plan smarter, and ship cleaner code. Hand-picked and scrubbed from a working
power-user setup, for an info-systems student who codes and studies with Claude Code.

## Install (one command)

```bash
curl -fsSL https://raw.githubusercontent.com/nikshostudios/uni-claude-skills/main/install.sh | bash
```

That's it. Every skill lands in `~/.claude/skills/`. Existing skills with the same name are
never overwritten (re-run with `bash install.sh --force` from a clone to overwrite).

Then open Claude Code and paste this to get a guided tour:

> Read https://raw.githubusercontent.com/nikshostudios/uni-claude-skills/main/HANDOFF.md and walk me through my new skills.

Or open **[the visual guide](https://nikshostudios.github.io/uni-claude-skills/)** (`index.html`).

## What's inside

### 📚 Study & learning
| Skill | One-liner |
|---|---|
| `teach` | Have Claude actually *teach* you a concept, not just answer |
| `yt-search` | Search YouTube for the best tutorial without opening a browser |
| `yt-transcript` | Paste a YouTube link → transcript + study digest with quiz |

### ✍️ Writing
| Skill | One-liner |
|---|---|
| `unslop` | Strips AI-sounding phrasing from any writing |
| `humanizer` | Deep de-AI-ify pass based on Wikipedia's signs-of-AI-writing guide |
| `writing-fragments` | Mine your rough notes for the good raw material |
| `writing-beats` | Arrange that material into a narrative arc |
| `writing-shape` | Draft the piece paragraph by paragraph, with you in the loop |

### 🧠 Thinking & ideas
| Skill | One-liner |
|---|---|
| `grill-me` | Claude relentlessly interrogates your plan until it's solid |
| `grill-with-docs` | Same grilling, but records decisions as docs as you go |
| `creativity` | Research-backed brainstorming that never repeats an idea |
| `to-questionnaire` | Turn "I can't decide" into questions for the person who can |
| `wait-what` | "That explanation didn't land — try again differently" |
| `zoom-out` | Ask for the bigger picture around a piece of code |
| `loop-me` | Interview you about a workflow you want automated |

### 📋 Project workflow (group projects, capstones)
| Skill | One-liner |
|---|---|
| `to-spec` | Turn a conversation into a written spec |
| `to-tickets` | Break a plan into small, ordered, doable tickets |
| `implement` | Execute a spec/tickets methodically |
| `triage` | Work through issues/PRs in a disciplined loop |
| `wayfinder` | Map work too big for one session as decision tickets |
| `graph` | Structure a high-stakes task as a multi-agent workflow |
| `checkpoint` | Save session state before context runs out |
| `claude-handoff` / `mp-handoff` | Hand work to a fresh session cleanly |
| `ask-matt` | Router: "which of these skills fits my situation?" |
| `write-a-skill` | Build your own skills |

### 💻 Coding & design
| Skill | One-liner |
|---|---|
| `frontend-design` | Distinctive UI direction instead of bootstrap-y defaults |
| `impeccable` | Full front-end design/audit/polish toolkit |
| `ui-styling` | shadcn/Tailwind component building + visual canvas |
| `ui-ux-pro-max` | Searchable local database of styles, palettes, fonts |
| `design-system` | Design tokens + component specs + slide generation |
| `improve-codebase-architecture` | Architecture review with a visual report |
| `setup-ts-deep-modules` | Wire dependency-cruiser for clean TS module boundaries |
| `playwright-cli` | Browser automation / web testing from the CLI |

### 📄 Documents
| Skill | One-liner |
|---|---|
| `assignment-creator` | Brief → polished PDF/DOCX with TOC, diagrams, tables |

## Power-ups (separate installs, worth it)

Not part of the pack — plugins and tools that upgrade Claude Code itself:

- **codex second opinion** — `npm i -g @openai/codex` + `codex login`, then add a codex
  companion plugin via `/plugin`. Cross-check hard bugs and big decisions with GPT.
- **ego lite** — desktop app that gives Claude a real logged-in browser (task spaces).
  Ask the person who gave you this pack.
- **claude-mem** — persistent memory across sessions, via `/plugin`.
- **mattpocock-skills plugin** — adds `tdd`, `diagnosing-bugs`, `code-review`,
  `domain-modeling` and more: [mattpocock/skills](https://github.com/mattpocock/skills).
- **Built-ins** — run `/code-review` and `/security-review` before submitting code.

## Optional dependencies

Most skills need nothing. A few want tools you may already have:

```bash
brew install yt-dlp        # yt-search, yt-transcript
npm i -D playwright && npx playwright install chromium   # assignment-creator PDF render, playwright-cli
pip install --user pymupdf python-docx pillow            # assignment-creator DOCX
```

Skills tell you what's missing when you run them — install on demand.

## Academic integrity

These skills help you **learn, plan, write, and produce** — they are not a
do-my-degree button. `assignment-creator` explicitly refuses AI-detector evasion and
tells you to follow your university's AI-disclosure policy. Use Claude to understand
your work, not to avoid it.

## Credits

Several workflow skills (`grill-me`, `to-spec`, `to-tickets`, `triage`, `implement`,
`wayfinder`, `writing-*`, `teach`, `ask-matt`, and friends) originate from
[Matt Pocock's skills](https://github.com/mattpocock/skills). `humanizer` builds on
Wikipedia's "Signs of AI writing" guide. Curated and adapted by Nikhil.
