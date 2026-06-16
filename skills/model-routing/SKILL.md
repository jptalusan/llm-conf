---
name: model-routing
description: Conserve usage only when near a 5-hour or weekly limit by downshifting model tiers and shrinking agent fleets. By default does nothing — Claude uses its normal model and effort. Use when the user asks to conserve or /usage shows you are close to a limit.
---

# Model routing

**Default: no budgeting.** Use the session's normal model and effort (your `settings.json` defaults). Do not proactively downgrade — quality first. The one standing exception is the pinned-model subagents (`analyst`→Haiku, `tester`→Sonnet, `reviewer`→Opus); that's a role default, not budgeting, and it applies in every mode.

Conserve mode is the only behavior this skill changes, and it activates **only near a usage limit**.

## When to enter conserve mode
Trigger ONLY when the 5-hour or weekly usage limit is genuinely close:
- the user asks to conserve, or
- `/usage` shows you're near a limit.

There is **no reliable in-session read of remaining quota** — don't guess a number. Check `/usage` (account) or `/cost` (session), or ask the user to report it. Do **not** enter conserve mode for ordinary cost-consciousness — only when a limit is actually near.

## What conserve mode does
- **Downshift every tier one notch:** Opus→Sonnet, Sonnet→Haiku. Keep Opus only for genuinely critical reasoning.
- **Route by task difficulty:**
  | Task | Conserve model |
  |---|---|
  | Summarize, classify, extract, scan, language/text analysis, mechanical edits | Haiku |
  | Standard implementation, writing/running tests, routine refactors | Haiku (Sonnet only if it stalls) |
  | Hard reasoning, deep review, security, architecture | Sonnet (Opus only if critical) |
- **Shrink fleets:** `verify-fleet` 2+2 → 1+1.
- **Announce** when you enter or leave conserve mode so the user knows the quality/cost tradeoff in effect.
