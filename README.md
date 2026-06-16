# llm-conf

A streamlined personal LLM/Claude Code config — kept deliberately small in the spirit of Karpathy-style `CLAUDE.md` files. A tiny always-on ruleset, a handful of skills, model-pinned subagents, and a verification fleet. Clone it once, symlink it into `~/.claude`, and it works across every project.

## What's in here

```
llm-conf/
├── CLAUDE.md                  # always-loaded operating rules (tiny)
├── AGENTS.md                  # human/cross-tool index of abilities
├── install.sh                 # symlinks the repo into ~/.claude  (./install.sh --uninstall to undo)
├── .claude-plugin/plugin.json # optional: install as a Claude Code plugin instead of symlinking
├── skills/                    # auto-discovered by Claude Code from each SKILL.md's frontmatter
│   ├── plan/SKILL.md          # /plan          — plan before coding
│   ├── review/SKILL.md        # /review        — single structured review pass
│   ├── verify-fleet/SKILL.md  # /verify-fleet  — 2 testers + 2 reviewers, independent, then synthesize
│   └── model-routing/SKILL.md # /model-routing — match model tier to task; conserve mode
└── agents/                    # subagents with a model pinned per role
    ├── analyst.md             # Haiku  — text/language analysis, summarize, classify, scan
    ├── tester.md              # Sonnet — writes/runs tests, tries to break the change
    └── reviewer.md            # Opus   — deep correctness/security/design review
```

### How the pieces fit (the part that's easy to get wrong)
- **`CLAUDE.md`** is the *only* file Claude loads into context every session. Keep it terse.
- **Skills are auto-discovered** from `skills/<name>/SKILL.md`. You do **not** hand-wire links from a central file for Claude to find them — it reads each skill's `name` + `description` and loads the body only when the skill is invoked (`/plan`, `/verify-fleet`, …). That progressive disclosure is what keeps context lean.
- **`AGENTS.md`** is the human-readable / cross-tool (Cursor, Codex) index. It documents the abilities; it is *not* the load-bearing wiring for Claude.
- **Subagents** in `agents/*.md` pin a `model:` per role — that's the real lever for controlling cost (a pinned model can't be overridden by a forgetful orchestrator).

## Install (clone + symlink)

```bash
git clone <your-fork-url> ~/Developer/personal/llm-conf   # or wherever you keep it
cd ~/Developer/personal/llm-conf
./install.sh
```

`install.sh` symlinks each skill folder into `~/.claude/skills/`, each subagent into `~/.claude/agents/`, and `CLAUDE.md` into `~/.claude/CLAUDE.md`. Because they're symlinks, `git pull` in this repo instantly updates your live config — no re-install. It never overwrites a real file already in place.

> Custom `~/.claude` location? Set `CLAUDE_CONFIG_DIR` before running.

> Already have a `~/.claude/CLAUDE.md`? The script won't clobber it — it prints an `@`-import line to paste into your existing file so both sets of rules apply.

Then restart Claude Code (or run `/doctor`) so the new skills and agents register.

### Uninstall
```bash
./install.sh --uninstall   # removes only the symlinks pointing back at this repo
```

### Alternative: install as a plugin
Instead of symlinking, you can install the skills via the bundled `.claude-plugin/plugin.json` through Claude Code's plugin/marketplace flow. (Note: the plugin manifest ships the **skills** only; the subagents and `CLAUDE.md` are delivered by `install.sh`.)

## Usage

| Command | When |
|---|---|
| `/plan` | Before any non-trivial change — get assumptions and a verifiable step plan first. |
| `/review` | Quick focused review pass on the current diff/PR. |
| `/verify-fleet` | After a coding/PR/issue fix you want high assurance on — spawns 2 independent testers + 2 reviewers, then synthesizes a ship / don't-ship verdict. |
| `/model-routing` | When deciding which model to spawn agents on, or to enter **conserve mode** to stretch remaining usage. |

You can also spawn the subagents directly by name (`analyst`, `tester`, `reviewer`) — each runs on its pinned model.

### Model routing & cost
Default routing by task difficulty: **Haiku** for text/language analysis, **Sonnet** for implementation/testing, **Opus + high effort** for hard reasoning and deep review. There is no reliable in-session read of your remaining weekly quota, so "auto-downgrade when low" isn't fully automatic — check `/usage` (account) or `/cost` (session) and trigger **conserve mode**, which drops every tier one notch and shrinks the verify fleet. See `skills/model-routing/SKILL.md`.

## Customizing
- Edit `CLAUDE.md` to tune the always-on rules — keep it short.
- Add an ability: create `skills/<name>/SKILL.md` with `name` + `description` frontmatter, add it to `AGENTS.md` and `plugin.json`, re-run `install.sh`.
- Add a role: create `agents/<name>.md` with a pinned `model:`, re-run `install.sh`.

## Credit
Behavioral principles in `CLAUDE.md` are adapted from [Andrej Karpathy's LLM-coding guidelines](https://github.com/multica-ai/andrej-karpathy-skills) (MIT).
