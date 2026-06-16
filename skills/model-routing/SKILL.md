---
name: model-routing
description: Match model tier to task difficulty when spawning subagents, and conserve usage when budget is low. Use whenever deciding which model an agent or subtask should run on, or when the user wants to stretch remaining usage.
---

# Model routing

Goal: don't burn the most expensive model on cheap work, and downshift when usage is running low.

## Default tiers (by task difficulty)
| Task | Model | Effort |
|---|---|---|
| Summarize, classify, extract, scan logs/output, language/text analysis, mechanical edits | **Haiku** | low/med |
| Standard implementation, writing/running tests, routine refactors | **Sonnet** | med |
| Hard reasoning, deep review, security, architecture, gnarly debugging, synthesis | **Opus 4.8** | high |

Prefer the pinned-model subagents — `analyst` (Haiku), `tester` (Sonnet), `reviewer` (Opus) — so the choice is automatic. For ad-hoc `Agent`/workflow spawns, pass `model`/`effort` explicitly per this table.

## Checking usage
There is **no reliable programmatic read of remaining weekly/account quota** from inside a session — don't pretend a number you can't see. What you *can* observe:
- **Session cost & context %** — run `/cost`, or read the statusline (it surfaces `cost.total_cost_usd` and context-window %).
- **Account/plan usage** — run `/usage` (interactive); ask the user to report it if you need the number.
- **Workflows only** — the `budget` global exposes `spent()` / `remaining()` against a per-turn target.

## Conserve mode
Trigger when: the user asks to conserve, `/usage` shows you're near a limit, or session `/cost` is high relative to value delivered. Then:
- Drop every tier by one: Opus→Sonnet, Sonnet→Haiku. Keep Opus only for genuinely critical reasoning.
- Shrink fleets (`verify-fleet` 2+2 → 1+1).
- Default ad-hoc subagents to Haiku unless the task clearly needs more.

Announce when you enter or leave conserve mode so the user knows the quality/cost tradeoff in effect.
