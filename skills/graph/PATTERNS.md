# Graph shapes and worked examples

## The three shapes

**Diamond** — default for decisions and research.
`question → planner → [lane A ‖ lane B ‖ lane C] → skeptic → merge → human gate`
Use when one question splits into independent angles that must come back as one answer.

**Chain with gates** — default for production work with risk at the end.
`classify → gather context → draft → checker → human gate → ship`
Use when steps genuinely depend on each other and the risk lives at the output.

**Fan-out branch** — default for one artifact spawning many derivatives.
`research → thesis → draft → checker → [titles ‖ visuals ‖ captions ‖ variants]`
Use when the hard thinking is upstream and the downstream pieces are cheap and parallel.

---

## Pitch deck

Outcome sentence: *"A deck that gets <buyer> to agree to <specific next step>."*

```
planner (what must be true for them to say yes)
  ├─ audience lane   → who decides, what they already believe, what they fear
  ├─ evidence lane   → proof we actually have: results, numbers, references
  ├─ competitor lane → what else they're considering, incl. doing nothing
  └─ narrative lane  → the one argument the deck makes, in one sentence
        ↓
skeptic → which claims can't be defended live? where is a number unsourced?
          what's the obvious objection we never answer? does the ask match trust level?
        ↓
merge → slide-by-slide outline: slide, job of that slide, one line of proof
        ↓
HUMAN GATE (strict — this goes to a client) → then build the deck
```
Skip the skeptic here and you present a claim you can't defend in the room.
If the deck ships with a presenter script, treat script and deck as one artifact — change one, update the other.

## Client solution / proposal

Outcome sentence: *"A one-page recommendation on how we solve <client problem>, with scope and price."*

```
planner (restate the problem in the client's words, not ours)
  ├─ problem lane     → what actually hurts, who feels it, what it costs them today
  ├─ constraint lane  → budget, timeline, systems, politics, compliance, who says no
  ├─ option lane      → 2-3 real approaches, incl. the cheap one and the do-nothing one
  └─ delivery lane    → what we can actually staff and ship, honestly
        ↓
skeptic → are we solving the stated problem or the fun problem? what breaks at month 3?
          where are we pricing effort instead of value? what did the client not say?
        ↓
merge → recommendation, scope boundary, price, first milestone, what would change our mind
        ↓
HUMAN GATE (strict) → then write the proposal
```

## AI-engineering / architecture decision

Outcome sentence: *"A decision on <X> with the tradeoff that made it, written down."*

```
planner (what does this decision actually have to survive?)
  ├─ requirements lane → real load, latency, cost ceiling, failure tolerance
  ├─ options lane      → 2-3 approaches with named tradeoffs, no strawmen
  ├─ prior-art lane    → what our own repo/vault already does; why it was done that way
  └─ failure lane      → how each option fails, and how loudly
        ↓
skeptic → which claim is benchmark-free? which option is chosen because it's familiar?
          what's the reversal cost if we're wrong in 6 months?
        ↓
merge → decision + the tradeoff accepted + the trigger that would reverse it
        ↓
HUMAN GATE (light for a memo, strict before anything touches prod)
```

---

## Anti-patterns

| Smell | Fix |
|---|---|
| Ten lanes on a two-lane problem | Cut to the smallest graph that changes the answer |
| Lanes that all read the same source | Merge them — they'll agree and it means nothing |
| Skeptic run by the same pass that wrote the draft | Separate job, separate file, adversarial framing |
| Human gate at the end of everything | Gate the expensive step, not every step |
| Sequential lanes with no real dependency | Fake waiting — parallelize |
| Graph rebuilt from scratch each time | Reuse `_graph/` structure; the state is the asset |

## Knowledge graph vs agent graph

This skill builds **agent graphs** — how work moves. A **knowledge graph** is how information connects (this client → this product → this issue → this owner); that's `/graphify` territory. Best systems use both: the knowledge graph feeds context into the agent graph's lanes.
