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

## 5. Conserve only when near a usage limit
By default, do **not** budget — use the session's normal model and effort; quality first. Only when you're near your 5-hour or weekly usage limit, enter conserve mode: downshift model tiers and shrink agent fleets. See the `model-routing` skill. (The pinned-model subagents — `analyst`/`tester`/`reviewer` — keep their role-appropriate models regardless; that's a role default, not budgeting.)

## 6. Verify with a fleet, on request
For coding / PR / issue fixes, run `/verify-fleet` to spawn independent testers and reviewers (fresh contexts, no groupthink) and synthesize their verdicts. Not automatic — invoke it.

## 7. Close with a report
After an implement + test + review cycle, end with the succinct `report` format: what changed, test result, review verdict, follow-ups, and a count of agents involved (by role). Dense, not chatty — no information dropped.

---
*Behavioral principles 1–4 adapted from Andrej Karpathy's LLM-coding guidelines (MIT).*
