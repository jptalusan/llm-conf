---
name: review
description: Single structured review pass over the current diff or a named PR. Use for a quick, focused correctness + quality review when you don't need the full independent fleet. For higher assurance, use verify-fleet instead.
---

# Review

Review the current diff (or named PR) in one focused pass. Scope: only changed lines and what they directly affect.

Check, in order:
1. **Correctness** — logic bugs, edge cases, error handling, off-by-one, null/empty.
2. **Security** — injection, authz, secrets, unsafe input.
3. **Reuse & simplicity** — duplicated logic, dead code, overcomplication.
4. **Consistency** — matches surrounding style and patterns.

For each finding: `file:line — severity — what — suggested fix`. Lead with the highest-severity items. Say so explicitly if you found nothing material — don't invent findings to fill space.

For deeper assurance (independent testers + reviewers in fresh contexts), use `/verify-fleet`.
