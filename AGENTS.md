# AGENTS.md — abilities index

Human- and cross-tool-readable map of this config. Claude Code auto-discovers the skills below from each `SKILL.md`'s frontmatter, so this file is documentation, not the wiring. Other tools (Cursor, Codex, etc.) read `AGENTS.md` directly.

The always-loaded operating rules live in [`CLAUDE.md`](./CLAUDE.md).

## Skills — invoke with `/<name>` or the Skill tool
| Ability | File | What it does |
|---|---|---|
| **plan** | [`skills/plan/SKILL.md`](./skills/plan/SKILL.md) | Think before coding: assumptions, tradeoffs, a verifiable step plan. |
| **review** | [`skills/review/SKILL.md`](./skills/review/SKILL.md) | Single structured review pass over a diff/PR. |
| **verify-fleet** | [`skills/verify-fleet/SKILL.md`](./skills/verify-fleet/SKILL.md) | Spawn 2 independent testers + 2 reviewers for a coding/PR/issue fix, then synthesize. |
| **model-routing** | [`skills/model-routing/SKILL.md`](./skills/model-routing/SKILL.md) | Match model tier to task difficulty; conserve mode when usage is low. |

## Subagents — model pinned per role
| Agent | File | Model | Role |
|---|---|---|---|
| **analyst** | [`agents/analyst.md`](./agents/analyst.md) | Haiku | Text/language analysis, summarization, classification, log scanning. |
| **tester** | [`agents/tester.md`](./agents/tester.md) | Sonnet | Writes/runs tests, reports pass/fail + repro. |
| **reviewer** | [`agents/reviewer.md`](./agents/reviewer.md) | Opus (high effort) | Deep correctness / security / design review. |
