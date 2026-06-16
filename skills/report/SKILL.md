---
name: report
description: Emit a succinct end-of-task report after an implement + test + review cycle. Dense and lossless — what changed, test result, review verdict, follow-ups, and how many agents were involved by role. Use to close out any coding/PR/issue task; auto-invoke at the end of such work.
---

# Report

Close a task with a tight, scannable summary. Goal: maximum information, minimum words. No preamble, no restating the request, no "I have successfully…". Every line carries data.

## Format
```
**<task>** — ✅ shipped | ⚠️ shipped with caveats | ⛔ blocked

- **Changed**: <files touched, ± LOC, one-line what>
- **Tests**: <N pass / M fail> — <one line on coverage or the key failure>
- **Review**: <clean | N findings> — <severity-ordered one-liners, or "none">
- **Follow-ups**: <open items / risks, or "none">
- **Agents**: <total> (<role × count, e.g. 2 tester, 2 reviewer, 1 analyst>)
```

## Rules
- **Agent count is required.** Tally every subagent you spawned for this task (the `verify-fleet` testers/reviewers, any `analyst`, any ad-hoc `Agent` calls), broken down by role. If you spawned none, say `Agents: 0 (solo)`.
- Keep each bullet to one line where possible; wrap only when dropping detail would lose information.
- Lead findings by severity; never pad with invented items to look thorough.
- If a stage was skipped (e.g. no tests run), say so explicitly rather than omitting the line.
- State the verdict in the header so it's readable at a glance.
