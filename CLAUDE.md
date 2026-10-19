# llm-conf maintainer rules

This repo is a Claude Code plugin (`.claude-plugin/plugin.json`) and its own marketplace (`.claude-plugin/marketplace.json`). `global/CLAUDE.md` holds the user's global rules and is linked to `~/.claude/CLAUDE.md` by `make install`. This file only loads for agents working inside this repo.

Skills live in bucket folders under `skills/`: `engineering/` for code work, `productivity/` for workflow and writing, `misc/` for setup helpers. Each skill is a folder with a `SKILL.md`.

When you add, remove or rename a skill, update all three places in the same change: the `skills` array in `.claude-plugin/plugin.json`, the skill table in `README.md`, and the typed-only list in `global/CLAUDE.md` section 6 when the skill sets `disable-model-invocation: true`. Then run `claude plugin validate .`. The only expected warning is the one about this root `CLAUDE.md`.

Every skill is either typed-only (`disable-model-invocation: true`, reachable only when the user types it) or automatic (no such line, so the agent loads it when a request matches its description). Follow the `writing-for-agents` skill when writing skills or either CLAUDE.md. Text written for people (README, commit messages) follows `flat-prose`.

Skills copied from Matt Pocock's repo keep his wording so his later changes merge cleanly. The README records the upstream commit they came from and `LICENSES/mattpocock-skills.txt` holds his MIT license. When syncing, diff his repo at the new commit against that one and carry over changes by hand, keeping our renames (`setup-repo`) and our edits to `implement`, `code-review` and `handoff`.

No em dashes in this repo's prose.
