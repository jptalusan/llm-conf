# llm-conf

A streamlined personal Claude Code config — kept deliberately small in the spirit of Karpathy-style `CLAUDE.md` files. A tiny always-on ruleset, a handful of skills, model-pinned subagents, and a verification fleet. Clone it once, symlink it into `~/.claude`, and it works across every project.

## What's in here

```
llm-conf/
├── CLAUDE.md                  # always-loaded operating rules (tiny)
├── Makefile                   # make install / make clean
├── install.sh                 # the actual symlink logic (Makefile calls this)
├── .claude-plugin/plugin.json # optional: install the skills as a Claude Code plugin instead
├── skills/                    # auto-discovered by Claude Code from each SKILL.md's frontmatter
│   ├── plan/SKILL.md          # /plan          — plan before coding
│   ├── review/SKILL.md        # /review        — single structured review pass
│   ├── verify-fleet/SKILL.md  # /verify-fleet  — 2 testers + 2 reviewers, independent, then synthesize
│   ├── model-routing/SKILL.md # /model-routing — conserve usage only when near a limit
│   └── report/SKILL.md        # /report        — succinct end-of-task summary + agent count
└── agents/                    # subagents with a model pinned per role
    ├── analyst.md             # Haiku  — text/language analysis, summarize, classify, scan
    ├── tester.md              # Sonnet — writes/runs tests, tries to break the change
    └── reviewer.md            # Opus   — deep correctness/security/design review
```

### How the pieces fit (the part that's easy to get wrong)
- **`CLAUDE.md`** is the *only* file Claude loads into context every session. Keep it terse.
- **Skills are auto-discovered** from `skills/<name>/SKILL.md`. You do **not** hand-wire links from a central file — Claude reads each skill's `name` + `description` and loads the body only when the skill is invoked (`/plan`, `/verify-fleet`, …). That progressive disclosure keeps context lean.
- **Subagents** in `agents/*.md` pin a `model:` per role — the real lever for controlling cost (a pinned model can't be overridden by a forgetful orchestrator).

## Install (clone + link)

```bash
git clone <your-fork-url> ~/Developer/personal/llm-conf   # or wherever you keep it
cd ~/Developer/personal/llm-conf
make install      # or: ./install.sh
```

This symlinks each skill folder into `~/.claude/skills/`, each subagent into `~/.claude/agents/`, and `CLAUDE.md` into `~/.claude/CLAUDE.md`. It works out of the box as long as `~/.claude` exists (it `mkdir -p`s the `skills/` and `agents/` subdirs itself) and never overwrites a real file already in place.

```bash
make status       # show which links are live
make clean        # (alias: make uninstall) remove only the symlinks this repo created
```

Then restart Claude Code (or run `/doctor`) so the new skills and agents register.

### Paths are absolute
The symlinks point at the **absolute** path of wherever you cloned this repo (e.g. `~/.claude/skills/plan -> /Users/you/Developer/personal/llm-conf/skills/plan`). Upside: they resolve no matter your working directory, and `git pull` here updates your live config instantly — no re-install. Tradeoff: if you **move** the clone, the links break — just re-run `make install` from the new location. (`plugin.json` uses *relative* paths because plugins are resolved relative to the plugin root; that's separate from the symlink install.)

> Custom `~/.claude` location? Set `CLAUDE_CONFIG_DIR` before running.

> Already have a `~/.claude/CLAUDE.md`? The script won't clobber it — it prints an `@`-import line to paste into your existing file so both rulesets apply.

### Alternative: install as a plugin
Instead of symlinking, install the skills via the bundled `.claude-plugin/plugin.json` through Claude Code's plugin/marketplace flow. Note: the plugin manifest ships the **skills** only — the subagents and `CLAUDE.md` are delivered by `make install`.

## Usage

You don't have to type the slash command — skills auto-trigger when your request matches their description. The command is just the explicit shortcut. Example phrasings that fire each one:

| Command | When | Or just say… |
|---|---|---|
| `/plan` | Before any non-trivial change — assumptions + a verifiable step plan first. | "Plan out how you'd add X before writing code." · "What's your approach here — show me the changes first." · "Don't code yet, draft a plan." |
| `/review` | Quick focused review pass on the current diff/PR. | "Review my changes." · "Look over this diff." · "Give the current changes a once-over." |
| `/verify-fleet` | After a coding/PR/issue fix you want high assurance on — spawns 2 independent testers + 2 reviewers, then synthesizes a ship / don't-ship verdict. | "Spin up some independent testers and reviewers for this fix." · "Verify this with a few independent agents." · "Get a couple testers and reviewers on this before we ship." |
| `/model-routing` | Only when near a usage limit — enter conserve mode to stretch remaining usage. | "I'm running low on usage — conserve." · "We're near the weekly limit, dial it back." · "Stretch what's left of my quota." |
| `/report` | Close out a task — dense summary of changes, tests, review verdict, follow-ups, and agent count. Auto-fires at the end of implement+test+review work. | "Wrap up with a summary." · "Give me a quick rundown of what changed and how many agents were involved." · "Close this out." |

You can also spawn the subagents directly by name (`analyst`, `tester`, `reviewer`); each runs on its pinned model — e.g. "have an analyst summarize these logs", "send a reviewer over this module".

### Model routing & cost
**By default there is no budgeting** — Claude uses its normal model and effort. The only standing rule is the per-role model pins on the subagents (Haiku/Sonnet/Opus), which are role defaults, not cost-cutting. Conserve mode (downshift every tier one notch + shrink the verify fleet) kicks in **only when you're near your 5-hour or weekly limit** — triggered by you or by `/usage` showing you're close. There's no reliable in-session read of remaining quota, so it isn't fully automatic. See `skills/model-routing/SKILL.md`.

## Customizing
- Edit `CLAUDE.md` to tune the always-on rules — keep it short.
- Add an ability: create `skills/<name>/SKILL.md` with `name` + `description` frontmatter, add it to `plugin.json`, re-run `make install`.
- Add a role: create `agents/<name>.md` with a pinned `model:`, re-run `make install`.

## Credit
Behavioral principles in `CLAUDE.md` are adapted from [Andrej Karpathy's LLM-coding guidelines](https://github.com/multica-ai/andrej-karpathy-skills) (MIT).
