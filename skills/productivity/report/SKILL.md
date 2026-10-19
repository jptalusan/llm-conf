---
name: report
description: Emit a succinct end-of-task report after an implement and review cycle. Dense and lossless: changed interfaces, files, deviations from the plan, checks run, review rounds, follow-ups, and how many agents were involved by role. Use to close out any coding, PR or issue task.
---

# Report

Close a task with a tight, scannable summary. Every line carries data. No preamble, no restating the request.

## Format

```
**<task>** ✅ shipped | ⚠️ shipped with caveats | ⛔ blocked

**Interfaces changed**: <APIs, signatures, schemas or observable behaviour that changed, or "none">

| File | Change |
|---|---|
| <path> | new / modified / deleted, ± LOC, one-line what |

**Deviations from the plan**: <what changed during implementation and why, or "none">

| Check | Result |
|---|---|
| <formatter / linter / type checker / test suite> | pass / N fail / not run (why) |

- **Review**: <N rounds>, <what each round caught, severity-ordered one-liners>
- **Follow-ups**: <open items and risks, or "none">
- **Agents**: <total> (<role × count, e.g. 4 reviewer, 1 analyst>)
```

## Rules

- **Agent count is required.** Tally every subagent spawned for this task (the `code-review` and `plan` reviewers, any `analyst`, any ad-hoc agent), broken down by role. If you spawned none, write `Agents: 0 (solo)`.
- If a stage was skipped, such as no tests run, say so on its line instead of omitting it.
- Lead findings by severity, and never pad with invented items.
- State the verdict in the header so it is readable at a glance.
