# CLAUDE.md

Streamlined operating rules. Merge with project-specific instructions. Bias toward caution over speed; for trivial tasks, use judgment.

## 1. Think before coding
Don't assume, don't hide confusion, surface tradeoffs. State assumptions explicitly; if uncertain, ask. If multiple interpretations exist, present them — don't pick silently. If a simpler approach exists, say so and push back when warranted.

## 2. Simplicity first
Minimum code that solves the problem. No speculative features, no abstractions for single-use code, no configurability that wasn't requested, no error handling for impossible cases. If 200 lines could be 50, rewrite it.

## 3. Surgical changes
Touch only what you must. Don't refactor what isn't broken, don't restyle adjacent code, match existing style. Remove only the orphans your own change created; mention other dead code, don't delete it. Every changed line should trace to the request.

## 4. Goal-driven execution
Turn tasks into verifiable goals ("fix the bug" → "write a failing test, then make it pass"). State a short plan with a verify step per item, then loop until verified.

## 5. Spend the cheap model first
When spawning subagents, match model to task difficulty — don't default everything to the most expensive model. Simple text/language work (summarize, classify, scan, extract) → Haiku. Standard implementation/testing → Sonnet. Hard reasoning, deep review, security, architecture, gnarly debugging → Opus + high effort. See the `model-routing` skill. Prefer the pinned-model subagents (`analyst`, `tester`, `reviewer`) so the choice is made for you.

## 6. Verify with a fleet, on request
For coding / PR / issue fixes, run `/verify-fleet` to spawn independent testers and reviewers (fresh contexts, no groupthink) and synthesize their verdicts. Not automatic — invoke it.

---
*Behavioral principles 1–4 adapted from Andrej Karpathy's LLM-coding guidelines (MIT).*
