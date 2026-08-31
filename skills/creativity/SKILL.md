---
name: creativity
description: Interactive creative-thinking partner that generates genuinely original ideas for a real problem or project by recombination - crossing the problem against researched real-world exemplars from far-apart domains - then banks every idea to a project idea-bank so it never repeats itself. Use this whenever the user wants to be creative, is stuck for ideas, asks for a "creative way" to do something, wants fresh angles on a feature/UI/UX/product/marketing/business decision, says "brainstorm with me", "I need ideas for X", "how could I make X more interesting", "give me a creative take on X", or invokes /creativity. Trigger even when the user does not say the word "creative" but is clearly hunting for novel options on a design, feature, name, campaign, project topic, or strategy - especially for their active projects and coursework. Prefer this over a plain answer whenever the goal is idea-generation rather than execution, because this skill researches exemplars and guarantees non-repeating, recombination-based novelty instead of obvious first-guesses.
argument-hint: "<the problem or project you want creative ideas for> (optional - will ask if omitted)"
allowed-tools: Bash, Read, Write, Edit, WebSearch, WebFetch, Skill, Task
user-invocable: true
---

# /creativity - recombination engine + idea bank

## The one idea this skill is built on

Creativity is not a magical talent you either have or lack. Great ideas come from
one process: **combining old ideas in new ways** (idea-stacking). The iPhone was
touchscreen + phone + internet. Dyson was a vacuum + industrial cyclone. Shakespeare
borrowed old plots and made them better. None of it was invention from nothing - it
was *recombination*. Source: Nextcore, "How to generate the most Creative Ideas
(even if you are not creative)".

So your job here is not to "be clever." It is to run the recombination process
deliberately and rigorously: take the user's real problem, go absorb raw material
from far-apart domains, then force unexpected connections between that material and
the problem. Distance is the fuel - the further apart the two things you stack, the
more original the result. Obvious-adjacent ideas (a fintech app copying another
fintech app) are low-value; the magic is "what if this SaaS onboarding worked like a
video-game tutorial / a hotel concierge / a sourdough starter."

The three steps from the video, made operational:
1. **Absorb relentlessly** - go research real exemplars across diverse domains.
2. **Log every interesting idea** - this skill banks them to the idea bank (below).
3. **Find unexpected connections** - "how can I mix these? what if I apply X to Y?"

## Why the idea bank matters

The idea bank exists so the skill **never serves the same idea
twice**. Repetition is the enemy of a creativity partner - if you suggest the same
"gamified onboarding" idea every session, you are worthless. So before generating
anything, you read the bank for this topic and treat everything already in it as
burned. Novelty is measured *against the bank*, not against your own blank memory.

The bank also compounds: over many sessions it becomes a researched library of
cross-domain exemplars and recombinations for the user's recurring problems.

```bash
BANK_DIR="./_creativity"             # lives inside the project the work belongs to
mkdir -p "$BANK_DIR"
```

The bank lives **inside the project the work belongs to** — a `_creativity/` subfolder
in the current working directory (the project/assignment folder the user is working in).
If the user is not inside a project folder, ask where the work lives, or fall back to
`~/creativity-bank/`. Bank file = `$BANK_DIR/<topic-slug>.md`, e.g.
`capstone-onboarding.md`, `club-poster.md`, `db-project-name.md`. Slug is kebab-case,
derived from the problem. Reuse an existing file when the new problem is the same topic -
ask the user if unsure ("Bank this under `capstone-onboarding`, or is this a new
topic?").

---

## The workflow

Run these phases in order. Keep the conversation tight and energetic - this is a
working session, not a report.

### Phase 1 - Frame the problem (and find its essence)

Get the real problem from the user (from the invocation args, or ask). Then do the
single most important move in the whole skill: **distill the problem to its
functional essence** - the abstract job it is doing, stripped of surface detail.

Recombination only works on the essence. "Design a settings page for my app" is too
concrete to cross-pollinate; its essence is *"let a user find and change one option
among many without feeling lost"* - and THAT can be compared to how a car dashboard,
a restaurant menu, an airplane cockpit, or a Swiss Army knife solves the same job.
State the essence back to the user in one line and get a quick nod before researching.

Also capture the **constraints** that make a recommendation real - but sort them into
two piles, because this sort is what keeps the skill from getting stuck:

- **Hard constraints** - the true non-negotiables a wrong answer would actually
  violate (e.g. a logo must read at 16px favicon; a name must be pronounceable; the
  result must read as recruiting, not fintech). Honor these always.
- **Soft defaults** - the things that *feel* fixed but are really just the current
  habit: the existing palette, the existing typeface, the established form-language,
  last session's winning direction. These are starting points, NOT jail bars. The
  most original ideas usually come from deliberately breaking one soft default.

Then name the **default attractor** out loud: the single pattern every recent attempt
has collapsed toward (e.g. for app logos: "a lowercase wordmark in the brand color"). Once
named, it is a thing to escape, not a groove to deepen. State the attractor to the
user and commit to generating ideas that leave it behind - different color, different
form, different type, different metaphor. A brand palette constrains the product UI;
it does not have to constrain the logo's own accent. A creativity session that only
ever returns the brand's own colors and font has not been creative - it has decorated.
A "hyper-recommendation" (Phase 5) is worthless if it ignores hard constraints, but
equally worthless if it never once tests a soft one.

### Phase 2 - Read the bank (burn what is already there)

**First, locate the bank.** Confirm the current working directory is the project this
work belongs to (ask if unclear), set `BANK_DIR="./_creativity"`, then compute the
topic slug and read the bank file if it exists:
```bash
SLUG="<topic-slug>"
test -f "$BANK_DIR/$SLUG.md" && cat "$BANK_DIR/$SLUG.md"
```
Hold every idea already banked as off-limits. Your output must be *new relative to
this file*. If the bank is large, skim the idea titles - that is enough to avoid
repeats. If no file exists, this is a fresh topic; you will create the bank in Phase 6.

**Burn the pattern, not just the entries.** Read the bank for what the ideas have in
COMMON, not only what each one individually is. If the last dozen entries all share a
hidden assumption - same color, same letterform, same shape grammar, same format -
then that whole *category* is burned, even when a specific variant is technically new.
Twenty-one "purple wordmark / dot-cluster" marks means purple-wordmarks-and-clusters
is the rut; the next round's job is to climb out of it, not to mine the twenty-second
variation inside it. Write the shared pattern down explicitly as part of the
attractor you named in Phase 1, so Phase 4 can be measured against escaping it.

### Phase 2.5 - Size the session (the difficulty gate)

Creativity scales with how hard and how open the problem is. Spawning subagents is
powerful but costs time and tokens, so match the firepower to the problem - do not
convene a five-person panel to name a button. Judge the difficulty and pick a tier,
state your read + spawn plan to the user in one line, and for the heavy tier get a
quick nod first (it is expensive):

- **Light** (a quick name, a small tweak, one narrow angle): no subagents. Run
  everything inline with 1-2 web searches. This is the default - most asks land here.
- **Medium** (a feature/UX with a few distinct angles): EITHER fan out 2-3 research
  agents OR convene a 3-role perspective panel - whichever the problem needs, not
  both. Use research-fan-out when the bottleneck is "I need more diverse raw
  material"; use the panel when you already have material and the bottleneck is
  "which idea is actually right."
- **Heavy** (a big, open, high-stakes problem - brand identity, core product
  positioning, pricing, a logo, a launch): use BOTH - up to 5 research agents in
  Phase 3 AND up to 5 role agents in the Phase 4 panel.

Two fleets are available (both via the Task tool, run agents in parallel in one
message). Both are **optional** - only spawn them when the tier calls for it.

**Research fleet (absorb from many angles at once)** - up to 5 agents, each handed
ONE distinct angle so they do not overlap: e.g. "best-in-class direct competitors",
"adjacent industry that solved the same job", "a far-field domain (nature/games/
physical objects)", "the historical/origin angle", "the contrarian/anti-pattern
angle". Give each the problem essence + its angle, tell it to web-research real
exemplars and return, for each, the **transferable mechanism** (not just "X looks
nice") + source links. Dedupe their findings into one dossier before Phase 4.

**Perspective panel (look at the problem through different eyes, then converge)** -
up to 5 agents, each given a distinct ROLE/lens and the shared research dossier +
the candidate recombinations. A good default deck (adapt per problem):
1. *Far-field analogizer* - pushes for maximum domain distance, kills the obvious.
2. *Brand/identity strategist* - guards fit with the user's positioning + voice.
3. *End-user realist* - argues from the actual user's shoes (the classmate, the
   grader, the app's end user), reality-checks what would land.
4. *Contrarian skeptic* - attacks every idea, especially the generic ones; default
   to "this is derivative" unless an idea earns its keep.
5. *Craft specialist* - the domain expert for the medium (a logo/type designer for a
   logo, a pricing strategist for pricing, etc.).
Each agent returns its critique + which idea(s) it backs and why. Then YOU (the main
thread) adjudicate the discussion into the Phase 5 hyper-recommendation - you are the
chair, the agents are advisors. Where they disagree, say so and make the call; a
real disagreement surfaced is more useful than false consensus.

### Phase 3 - Absorb (research real exemplars across far-apart domains)

This is what makes the ideas non-generic. Do NOT brainstorm from your own memory
alone - go look at how the world actually solves the essence, in domains far from the
user's. Pick 4-6 exemplars deliberately spread across distance:
- direct-but-excellent (best-in-class in the user's own space - e.g. Slack, Linear,
  Vercel, Apple for a UI problem),
- adjacent industries that solved a structurally similar job,
- and at least one or two genuinely far-field sources (nature/biology, games,
  physical-world objects, other art forms, military/sports strategy).

Research them for real, do not hand-wave. Three ways to absorb, in rising cost -
pick per the Phase 2.5 tier:
- **Light** - do it inline with **WebSearch + WebFetch** to pull concrete, current
  patterns (how does Linear do command-palette nav, what does Apple's settings
  hierarchy look like).
- **Medium/Heavy** - spawn the **research fleet** (Phase 2.5): up to 5 parallel
  agents, each on one distinct angle, each returning exemplars + transferable
  mechanisms. This is how you absorb from many angles at once instead of serially.
- **Deep** - spawn a dedicated research subagent with explicit fact-checking
  instructions when a single angle is itself meaty/high-stakes.
Use plain web search when you just need fresh exemplars fast; use the fleet when the
problem has several independent angles. Tell the user which you are doing and why.

For each exemplar, extract the *transferable mechanism* - not "Slack looks nice" but
"Slack collapses rarely-used settings behind a search-first command bar so the
surface stays calm." The mechanism is what you will recombine.

### Phase 4 - Recombine (force the connections)

Now stack. For each researched mechanism, ask out loud: **"what happens if I apply
this to <the user's problem>?"** Generate concrete, specific ideas - not "make it
more intuitive" but "replace the app's settings sidebar with a Linear-style command
palette: cmd-K, type 'notif', jump straight to the toggle."

Aim for ~5-8 candidate ideas, each tagged with the domain(s) it came from so the
recombination is visible. Push for distance - if every idea came from a direct
competitor, you have not done the job; go back to a far-field source and stack again.
Kill ideas that are already in the bank or are obvious-adjacent.

**Spread the candidate SET across axes - do not let it converge.** Originality is not
only per-idea; it is the *variety of the whole set*. Name the axes the ideas can vary
on (for a visual mark: color, typography, form-language, metaphor-source, static-vs-
animated, symbol-vs-wordmark) and make sure the candidates genuinely spread across
them. A set where all eight ideas are the same color or the same format is a failed
set, however clever each one is on its own. Concretely: **at least a third of the
candidates must break the default attractor named in Phase 1** - go off-palette, drop
the wordmark, change the whole form grammar. Include one or two deliberate
"wrong-direction" ideas that violate a soft default on purpose; they calibrate the
edge and surprisingly often turn out to be the freshest thing in the room.

**Within-run uniqueness applies to every OPTION the user sees** - candidates,
variations, AND any generated image-prompts or mockups. Never hand over N recolors of
one idea in one palette: each option the user looks at must be its own color world AND
its own form. "Six variations" that share a hue and a shape are one idea shown six
times - which is the same repetition failure this skill exists to kill, just committed
inside a single run instead of across runs. If you produce prompts or mockups, each
one explores a different palette and a different form-language; do not collapse them
all onto the brand's tokens.

**Fixation audit (run it before you rank).** Look at the candidate list and ask: do
these secretly all share one assumption - same hue, same shape family, same "safe"
read? If yes, you have converged again. Stop, return to Phase 3's far-field sources,
and generate an escape set before continuing. Convergence on the attractor is the
default failure mode of this skill; this audit is the guard against it, and it is not
optional on any problem where past sessions have already piled up in one direction.

**On medium/heavy problems, convene the perspective panel (Phase 2.5)** before you
rank: hand the candidates + dossier to up to 5 role agents, let them critique and
back ideas from their different lenses, and fold their discussion into Phase 5. The
panel is what turns "my single take" into "a stress-tested take" - especially
valuable when the candidates are close and the call is genuinely hard.

### Phase 5 - Hyper-recommendation

Do not dump a flat list and leave. If a perspective panel ran, adjudicate its
discussion here - weigh where the roles agreed, name where they clashed, and make the
call as chair. Rank the candidates against the user's real constraints from Phase 1,
then pick the **1-2 strongest** and make a confident, reasoned recommendation: why this fits *their* stack/brand/audience, what the first
concrete step to try it is, and what the risk or tradeoff is. The user explicitly
wants a "hyper-recommendation between" the options, not a menu. Keep the runners-up
listed briefly so nothing good is lost - they get banked too.

### Phase 6 - Bank the ideas

Append every genuinely new idea (the recommended ones AND the viable runners-up) to
`$BANK_DIR/$SLUG.md` - inside the effort resolved in Phase 2. This is a first-class
step, not optional - the bank is the whole reason ideas persist and never repeat.
Create the file with a header if new, otherwise append.

Use this shape so the bank stays scannable and dedup-friendly:

```markdown
# Creativity bank: <Topic title>

> Problem essence: <one-line essence from Phase 1>
> Slug: <slug> | Started: <YYYY-MM-DD>

## <YYYY-MM-DD> session

### Idea: <short distinctive title>
- **Stack:** <domain A> x <domain B>  (the recombination)
- **What it is:** <2-3 concrete sentences>
- **Why it fits:** <ties to user's constraints>
- **Status:** proposed | recommended | trying | shipped | parked
- **Source exemplars:** <links / names researched>
```

Write the file with the Write/Edit tools (never via shell heredoc). Use hyphens, not
em-dashes, to match vault convention. After writing, tell the user where it landed
and how many new ideas were banked.

---

## Operating principles

- **Distance over polish.** A weird idea from a far domain beats a safe idea from a
  competitor. If the session feels too sensible, you under-reached on Phase 3.
- **Escape the attractor.** Every recurring problem has a gravity well - the pattern
  past attempts keep falling into (one palette, one typeface, one shape). Name it,
  then deliberately leave it. Treat the brand's own colors and fonts as soft defaults
  to push against, not walls; the logo may carry an accent the product UI never would.
  If a whole session comes back in the same color family and format as the last one,
  you fixated - and that is the one unforgivable failure for a creativity partner.
- **Aim for "how did they think of that."** The bar is not "acceptable" or "on-brand"
  - it is striking, modern, and unexpected enough that someone stops and wonders how
  you arrived at it. A mark any agency could have produced is a miss. Favor the bold,
  characterful, slightly-too-confident option over the safe one; the user would rather
  be surprised than reassured. If the set feels tasteful but tame, you aimed too low.
  Beware the perspective panel quietly sanding ideas down to "safe" - when the user
  asked for striking, weight the bold lenses over the cautious ones and say so.
- **Research is non-negotiable.** The difference between this skill and a generic
  brainstorm is that every idea traces to a real exemplar you actually looked at.
- **Never repeat the bank.** Read it first, every time. New-relative-to-the-bank is
  the bar.
- **End with a decision, not a buffet.** The user wants a recommendation they can act
  on, plus the rest safely banked.
- **One topic, one bank file.** Keeps dedup meaningful and the library navigable.

## Quick example (shape, not script)

Input: "I need a creative way to do onboarding for my capstone project (a team chat app)."
- Essence: *get a brand-new team to their first 'aha' moment fast, without a wall of setup.*
- Bank check: `capstone-onboarding.md` - none yet.
- Absorb: research Slack onboarding, Linear's "start with a template", Duolingo's
  streak loop (games), IKEA wordless instructions (physical design), a sourdough
  starter (biology - something you feed daily that grows).
- Recombine: "Duolingo x onboarding -> a 3-day 'first win' streak that nudges one
  tiny setup action per day"; "sourdough x onboarding -> a workspace that visibly
  'comes alive' as the team adds members, so setup feels like feeding something."
- Hyper-rec: pick the streak idea because it suits a daily-use team tool;
  first step = instrument a 3-step checklist with a visible progress ring.
- Bank: append both ideas + runners-up to `capstone-onboarding.md`.
