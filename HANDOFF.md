# HANDOFF — read me first (you, the agent)

You are Claude Code, and your user just installed the **uni-claude-skills** pack. This
document briefs YOU on what happened and how to onboard them. Read it fully, then run the
tour protocol at the bottom.

## What just happened

The installer copied 35 skills into `~/.claude/skills/`. Each is a folder with a
`SKILL.md` (instructions you follow when the skill is invoked) and sometimes bundled
scripts/references. They were curated from a working power-user setup specifically for a
**university student in information systems** — someone who codes, studies, writes
reports, and does group projects. All personal paths and accounts from the original owner
were scrubbed; everything works standalone.

Your user can invoke any skill by typing `/skill-name`, by asking for it by name, or —
most importantly — **you should proactively invoke them** when their trigger conditions
match what the user is doing. That last part is the point of this document: the user
doesn't know what they have yet. You do.

## The mental model to give the user

Skills are saved expertise. Instead of the user writing a perfect prompt every time,
a skill is a tested, detailed playbook you execute. Tell them:

- Type `/` in Claude Code to see the skill list.
- They never need to memorize the list — they just describe what they're doing and you
  pick the right skill.
- Skills compose: `yt-search` → `yt-transcript` → `teach` is a study pipeline;
  `grill-me` → `to-spec` → `to-tickets` → `implement` is a project pipeline.

## The five clusters (and when YOU should reach for each)

### 1. Study & learning
- **`teach`** — user wants to *understand* something, not just get an answer. Reach for
  this when they say "explain", "I don't get", "teach me", or before an exam. It runs a
  real teaching loop with checks for understanding.
- **`yt-search`** — find the best video on a topic (needs `yt-dlp`).
- **`yt-transcript`** — they paste a YouTube link → fetch transcript into
  `./transcripts/`, then offer a study digest (summary + concepts + quiz). A bare pasted
  YouTube link IS the trigger.

### 2. Writing (essays, reports, discussion posts)
- **`unslop`** — quick pass to remove AI-sounding phrasing. Apply to anything you draft
  for them that a human will read.
- **`humanizer`** — the deep version; systematic sweep of AI-writing tells.
- **`writing-fragments` → `writing-beats` → `writing-shape`** — a three-stage pipeline
  for real writing FROM THE USER'S OWN THINKING: mine their rough notes for material,
  arrange it into an arc, then draft paragraph-by-paragraph with them steering. Use when
  they have an essay and a pile of thoughts. This produces *their* essay, not yours —
  which is both better and honest.

### 3. Thinking & deciding
- **`grill-me`** — they have a plan/idea (project proposal, thesis topic, app
  architecture) and you should stress-test it by interviewing them hard. Offer it
  whenever a plan sounds half-baked.
- **`grill-with-docs`** — same, but records decisions (ADRs, glossary) as you go. Use for
  group projects where decisions need a paper trail.
- **`creativity`** — structured brainstorming: researches real exemplars from far-apart
  domains, recombines, and banks every idea in `./_creativity/` so it never repeats
  itself across sessions. Use for project topics, app features, presentation angles.
- **`to-questionnaire`** — user is blocked on a decision that's actually someone else's
  (professor, teammate). Produce the questions to ask them.
- **`wait-what`** — user is confused by your last explanation. Re-pitch differently.
- **`zoom-out`** — user is lost in code details; give the bigger architectural picture.

### 4. Project workflow (capstones, group coding projects)
The core pipeline, in order:
1. **`grill-me`** the idea →
2. **`to-spec`** turn the conversation into a written spec →
3. **`to-tickets`** break it into small ordered tickets →
4. **`implement`** execute them methodically.
Plus: **`triage`** (work an issue/PR backlog), **`wayfinder`** (work too big for one
session), **`graph`** (structure a genuinely high-stakes task as a multi-step agent
workflow), **`ask-matt`** (router — when the user isn't sure which flow fits, invoke this).

Session management — teach the user these two early, they save real pain:
- **`checkpoint`** — when a long session starts degrading, produce a paste-ready handoff
  so a fresh session continues seamlessly.
- **`claude-handoff` / `mp-handoff`** — hand the conversation to a fresh agent.

### 5. Coding & design
- **`frontend-design`** — aesthetic direction so their web projects don't look like
  bootstrap defaults. Read it before building any UI for them.
- **`impeccable`** — the heavyweight: design, audit, and polish any frontend.
- **`ui-styling`**, **`ui-ux-pro-max`**, **`design-system`** — component building,
  a searchable style/palette/font database, and design tokens respectively.
- **`improve-codebase-architecture`** — architecture review with a visual HTML report;
  great before submitting a coding project.
- **`setup-ts-deep-modules`** — dependency-cruiser config for clean TypeScript modules.
- **`playwright-cli`** — browser automation and web testing; useful for IS coursework
  involving web apps.

### 6. Documents
- **`assignment-creator`** — turn an assignment brief into a polished PDF/DOCX with
  cover page, dot-leader table of contents, Mermaid diagrams (Gantt, WBS, risk
  quadrants), and shaded tables. It maps every rubric line to a section so nothing is
  missed. **Integrity rule is built in:** it refuses AI-detector evasion and expects the
  user to follow their university's AI policy. Frame it as a *production and formatting*
  tool for work the user owns and understands.

## Power-ups (NOT installed by the pack — teach these when the user is ready)

These are separate tools/plugins that upgrade Claude Code itself. Don't dump them on the
user day one; introduce each when a real need appears:

- **codex (second opinion).** When you're stuck on a bug, or a decision is high-stakes,
  a second frontier model cross-checking you is genuinely valuable. Setup: user installs
  the Codex CLI (`npm i -g @openai/codex`, `codex login` — needs a ChatGPT account),
  then adds a codex companion plugin via `/plugin`. After that, when the user says "get
  a second opinion" or you hit a wall, delegate the investigation to codex and compare
  answers. Two models agreeing = high confidence; disagreeing = the interesting case,
  dig in.
- **ego lite (real browser automation).** A desktop app giving you isolated "task
  spaces" in a real browser that inherits the user's logins. Once installed, its
  `ego-browser` skill teaches you the API. Use it for: testing the user's web-app
  coursework end-to-end, pulling readings from course portals, any logged-in web chore.
  The user should ask the friend who gave them this pack for the app. Until then, plain
  WebFetch/WebSearch covers read-only research.
- **claude-mem (persistent memory).** Marketplace plugin that compresses each session
  into searchable observations — you remember decisions across a whole semester project.
  Install via `/plugin`. Suggest it the first time the user asks "what did we do last
  time?"
- **mattpocock-skills (full plugin).** This pack vendors several of Matt Pocock's skills;
  the full plugin adds `tdd`, `diagnosing-bugs`, `code-review`, `domain-modeling`,
  `codebase-design`, `prototype`, `research` and more — the engineering-discipline set.
  Install via `/plugin` from github.com/mattpocock/skills. Suggest `tdd` the first time
  they build something non-trivial, `diagnosing-bugs` on the first nasty crash.
- **Built-in reviews.** Claude Code ships `/code-review` and `/security-review` — run
  them before the user submits any coding assignment.

## Dependencies (install on demand, not upfront)

- `yt-dlp` → yt-search, yt-transcript (`brew install yt-dlp`)
- Playwright + Chromium → assignment-creator PDF rendering, playwright-cli
- `pymupdf`, `python-docx`, `pillow` → assignment-creator DOCX
Everything else: zero deps. When a skill fails on a missing tool, install it then and
there and continue.

## Academic integrity — your standing instruction

This pack helps the user learn, think, plan, and produce. Do not help them misrepresent
authorship: no AI-detector evasion, no fabricated citations, no work they can't explain.
When they use `assignment-creator` or the writing pipeline, the ideas and understanding
must be theirs — your job is structure, rigor, and polish. If their university requires
AI-use disclosure, remind them once per assignment.

## THE TOUR PROTOCOL — run this now

Don't lecture the whole list. Run a short interactive onboarding:

1. **Ask three questions:** What are you studying this semester? What's the next
   deadline you're worried about? Are you coding anything right now?
2. **Match 3–4 skills** to their answers and demo the single most relevant one
   immediately on their real work (e.g. deadline = essay → `writing-fragments`;
   deadline = report → `assignment-creator`; studying from videos → `yt-transcript`;
   group project → `grill-me`).
3. **Show the pipelines** relevant to them (study pipeline / writing pipeline / project
   pipeline) as one-liners, not documentation dumps.
4. **Teach the two session skills** (`checkpoint`, `claude-handoff`) in one sentence each.
5. **Tell them about the visual guide** — the repo's `index.html` (or the GitHub Pages
   link in README) is a map of everything, organized by school scenario.
6. From then on: **invoke skills proactively** when triggers match. That's how this pack
   pays off — the user shouldn't have to remember any of this.
