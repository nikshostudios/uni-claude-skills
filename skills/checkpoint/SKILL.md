---
name: checkpoint
description: Create a paste-ready handoff prompt for immediate continuation in a fresh Claude Code session. Use when context is hitting ~40-50% and output quality is degrading but work is mid-flow and needs to keep going right now without restarting. Output is optimized for hot continuation (operator pastes one block, new session resumes without re-deriving decisions). Distinct from a formal indefinite pause with comprehensive state capture. Trigger phrases include "checkpoint", "session handoff", "context handoff", "continue in new session", "context rot starting", "save state and continue", "hand off to new session", "spawn new session with this context", "near context limit".
---

# checkpoint

Create a hot session handoff: write a checkpoint file, output a paste-ready
prompt for a fresh Claude Code session. Optimized for active continuation, not
formal pause.

> Carried into this template as a working system-level skill. It is generic —
> no business content. Install it by copying this directory to
> `~/.claude/skills/checkpoint/`.

## When to use this skill (vs alternatives)

| Situation | Use this |
|-----------|----------|
| Context at 40-50%, quality degrading, mid-task, want to KEEP GOING right now | **checkpoint** |
| Stopping for hours or days, need full state for a cold resume | a formal pause-work skill |
| Want context summarized in-place (don't compact) | **checkpoint** (writes to file), not `/compact` |
| Lost track of where you are, need a memory snapshot | memory files / a session-memory plugin |

`checkpoint` is for active mid-flow continuation: lighter, faster, optimized for
"save before quality drops further, then keep going."

## Workflow

### Step 1: Read current state

Identify what is mid-flow:
- The master plan or spec that is the source of truth (look for `PLAN.md`,
  `SPEC.md`, recent `HANDOFF-*.md`)
- Files actively being edited or referenced in the last several exchanges
- Decisions made in the last 1-3 exchanges
- The next concrete action the user is about to take
- The current operating mode (planning / execution / debugging / verification)

### Step 2: Write the checkpoint file

Write to `{{PROJECT_ROOT}}/checkpoints/<YYYY-MM-DD>-<HHMM>-<topic-slug>.md`
(create the directory if missing). If the project has no such directory, write
to `<project-root>/.checkpoints/` instead.

Template:

```markdown
---
type: checkpoint
created: <YYYY-MM-DD HH:MM TZ>
purpose: hot continuation (not formal pause)
expected-pickup: within hours
operating-mode: <execution | planning | debugging | verification>
---

# What we were doing
<one paragraph in the operator's voice, what is mid-flow>

# Decisions just made (last 1-3 exchanges)
- bullet
- bullet

# Files to read first (in priority order)
- `<path>`: <one-line why>
- `<path>`: <one-line why>

# Next concrete action
<what the user is about to do, with enough detail that the new session knows
where to pick up>

# Hard constraints (operating mode)
<one or two lines: what is locked, what is open, what mode>

# Do not
- <hard guards: restart analysis, propose alternatives, shop frameworks, etc.>
```

### Step 3: Output the paste-block

Output one line with the checkpoint path, then the paste-ready prompt in a single
fenced block. No Steps list, no editor/terminal instructions (the operator starts
the fresh session their own way), no commentary after.

```
Wrote checkpoint to: <absolute path>

\`\`\`
I'm continuing work from a previous Claude Code session that's near context limits. State checkpoint at:

<absolute path to checkpoint>

Read it in full. Then read these references (paths relative to <project-root>):

- <ref1>: <why>
- <ref2>: <why>
- <ref3>: <why> (max 4 refs)

Your auto-memory should already include:
- <memory-file>: <why relevant>

After reading:
1. Confirm you have full state by summarizing <key thing> in your own words.
2. Confirm operating constraints: <one line>
3. Then ask me <next concrete action question>

Do not <hard guards>.
\`\`\`
```

## Hard rules

- Match the operator's output-style preferences (for example, some operators ban
  em-dashes — if so, none anywhere in any output).
- The paste-block IS the deliverable. No commentary, summaries, or trailing
  "let me know if you need anything else" after it.
- Reference at most 4 supporting files in the paste-block. More bloats the new
  session's opening context.
- The paste-block must be self-contained: a fresh session reading only the
  paste-block plus the referenced files must have enough state to continue.
- The checkpoint file is for the NEW session to read, not for archival. Keep it
  tight: 30-80 lines, not 200.
- Always include "Do not" guards. The biggest failure mode of a fresh session is
  restarting analysis instead of continuing. The paste-block must explicitly
  forbid that.

## Why this skill exists

Claude Code degrades after ~40-50% context. `/compact` makes it worse (context
poisoning + loss of detail). The clean alternative is to compact INTO a file,
then start fresh. This skill is the standardized tool for that move, optimized
for "active mid-flow, need continuity, no formal pause."
