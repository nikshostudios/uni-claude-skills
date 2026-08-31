---
name: graph
description: Turn a nuanced, high-stakes task into a small agent graph — jobs, arrows, a skeptic, a merge, and a human gate — instead of one long chat. Use when the work has multiple steps, multiple sources, real risk, or an expensive decision at the end: pitch decks, client proposals and solutioning, positioning and pricing calls, architecture and AI-engineering decisions, deep research, go-to-market plans, feedback synthesis, or recurring content. Triggers include /graph, "graph this", "design the workflow for", "help me think through X properly", "build a graph for this deck/client/decision". Skip for one-shot asks like naming, summarizing, or quick edits.
---

# /graph — agent-graph engineering

Prompt engineering = better question. Context engineering = better information.
**Graph engineering = better shape of the work around the model.**

A graph is **jobs** (steps) connected by **arrows** (real dependencies), carrying **state** (the artifacts each job leaves behind).

## Gate first — does this need a graph?

Run a graph only when **two or more** hold: multiple steps · multiple sources · parallelizable pieces · a wrong answer is expensive · output needs checking before it matters.

If not, say so in one line and just do the task. Do not build a graph for "10 name ideas".

## The loop

**1. One-sentence outcome.** Write the final deliverable as one sentence. "A one-page recommendation on whether to pitch Origine on X." Everything downstream serves this. Confirm it with the user before proceeding.

**2. List jobs a great human would do.** Not agents — jobs. Clarify the question, research the customer, research competitors, find distribution, hunt risks, check evidence, write the recommendation.

**3. Draw arrows only where a real dependency exists.** Anything independent runs in parallel. Delete fake waiting — sequence that exists only because chat is linear.

**4. Add a skeptic as its own job.** Never let the job that wrote the answer grade the answer. The skeptic asks: which claims are actually supported, which evidence is stale, which competitor got ignored, where did we confuse pain with willingness to pay, where did it sound confident without proving anything.

**5. Merge the survivors.** One job turns surviving evidence into the deliverable: the call, the wedge, the first test this week, and **what evidence would change our mind**.

**6. Human gate before the expensive step.** Gate strictness scales with reversibility — private memo → light; client email, public post, pricing sent to a buyer, code deploy, prod data → strict, explicit stop.

**7. Show the graph before running it.** Print the plan (jobs → arrows → gate) and get a go-ahead. Then run.

## Running it

Default is **file-based lanes** — each job writes its own file under `_graph/<slug>/`: `plan.md`, then one file per parallel lane, `review.md` (skeptic), `recommendation.md` (merge). The paper trail is the point: it's inspectable, diffable, and reusable next time.

Run parallel lanes as parallel subagents **only if the user asked for subagents or the lanes are genuinely heavy**; otherwise run the lanes yourself in sequence, one file at a time. The structure matters more than the concurrency.

## Rules that keep graphs good

- **Smallest graph that improves the quality.** Not the biggest. More agents ≠ better output — often more noise and five workers confidently repeating the same wrong idea.
- **Separate workers from checkers.** Always.
- **Stop when the answer is good enough.** No ritual extra passes.
- **Leave state behind.** Evidence, sources, drafts, the decision. Each run should make the next run smarter — that compounding memory is the real return, not the single output.
- **Manual before automated.** If the hand-run graph doesn't produce visibly better work, automating it just produces mediocre work faster.

## Shapes and worked examples

See [PATTERNS.md](PATTERNS.md) — diamond, chain-with-gates, and fan-out-branch, plus ready graphs for pitch decks, client solutioning, and AI-engineering decisions.
