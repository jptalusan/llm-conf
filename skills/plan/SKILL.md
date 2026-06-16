---
name: plan
description: Plan before coding. Use before any non-trivial implementation to state assumptions, surface tradeoffs and alternatives, and produce a verifiable step-by-step plan. Trigger when the task is ambiguous, touches multiple files, or has more than one reasonable approach.
---

# Plan

Produce an implementation plan before writing code.

1. **Restate the goal** in one sentence. If it's ambiguous, list the interpretations and ask — do not pick silently.
2. **State assumptions** explicitly. Flag anything uncertain.
3. **Surface alternatives.** If a simpler approach exists, recommend it. Note tradeoffs in one line each — don't survey exhaustively.
4. **List the steps**, each with a verify check:
   ```
   1. <step> → verify: <check>
   2. <step> → verify: <check>
   ```
5. **Identify the critical files** to touch and why.
6. Keep it surgical — the plan must not introduce work beyond the request.

Output the plan, then stop for confirmation unless the user already said to proceed.
