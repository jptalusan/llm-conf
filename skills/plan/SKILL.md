---
name: plan
description: Plan before coding. Use before any non-trivial implementation to state assumptions, surface tradeoffs and alternatives, and produce a verifiable step-by-step plan. Trigger when the task is ambiguous, touches multiple files, or has more than one reasonable approach.
---

# Plan

Produce an implementation plan before writing code.

1. **Restate the goal** in one sentence. If it's ambiguous, list the interpretations and ask — do not pick silently.
2. **State assumptions** explicitly. Flag anything uncertain.
3. **Surface alternatives.** If a simpler approach exists, recommend it. Note tradeoffs in one line each — don't survey exhaustively.
4. **Planned changes — be concrete, per file.** This is the part the user reviews before any code is written. For each file:
   ```
   <path>  (new | modify | delete)
     - <exact change: e.g. "add fn parse_window(rows) -> Window", "modify handle() to short-circuit on empty input", "delete dead helper foo()">
   ```
   Name the functions/sections/symbols you'll touch and what each edit does. Specific enough that the user can spot a wrong change before it happens — not "update the parser."
5. **List the steps**, each with a verify check:
   ```
   1. <step> → verify: <check>
   2. <step> → verify: <check>
   ```
6. Keep it surgical — the plan must not introduce work beyond the request.

Output the plan, then **stop for confirmation** unless the user already said to proceed. As you implement, if reality diverges from the planned changes, surface the delta before continuing — don't silently drift.
