# llm-conf

A personal Claude Code setup packaged as a plugin. The agent asks about every decision before it works, plans are written and reviewed before code, code stays simple and checked at its boundaries, and every change goes through review until only nits remain. Most engineering skills come from [Matt Pocock's skills](https://github.com/mattpocock/skills).

## Install

The plugin carries the skills, agents and hook. The global rules in `global/CLAUDE.md` cannot ship inside a plugin, so each machine also needs the clone and `make install`.

On a machine where you edit this repo, clone it and run `make install`.

```bash
git clone git@github.com:jptalusan/llm-conf.git ~/Developer/personal/llm-conf
cd ~/Developer/personal/llm-conf
make install
```

That links `global/CLAUDE.md` to `~/.claude/CLAUDE.md` and links the repo to `~/.claude/skills/llm-conf`, where Claude Code loads it in place as the `llm-conf@skills-dir` plugin. Edits apply in the next session, or after `/reload-plugins` in a running one. `make status` shows the links, `make clean` removes them, and `make validate` checks the manifests.

On any other machine, install the plugin from GitHub and link the rules from a clone.

```bash
claude plugin marketplace add jptalusan/llm-conf
claude plugin install llm-conf@llm-conf
```

Run `/plugin`, open Marketplaces, and enable auto-update for `llm-conf` to receive changes automatically. Use one method per machine, because both together load every skill twice.

## Skills

Typed skills run only when you type them, and the agent suggests them when they fit. Every skill also answers to its full name, such as `/llm-conf:code-review`, which matters where Claude Code has a built-in with the same short name (`plan`, `code-review`). Automatic skills also load on their own when a request matches their description.

| Skill | Mode | Use |
|---|---|---|
| `plan` | typed | Grill, then write a reviewed `*_PLAN.md` at the repo root, gitignored by default. Type `/llm-conf:plan`, since `/plan` is a Claude Code built-in |
| `implement` | typed | Build a plan step by step with `tdd`, run every check, loop `code-review` until only nits, report, commit |
| `implement-spec` | typed | Build a ticketed spec with parallel agents on one integration branch |
| `to-spec` | typed | Turn the conversation into a spec on the issue tracker |
| `to-tickets` | typed | Split a plan or spec into tickets with blocking links |
| `triage` | typed | Move issues through triage states and write agent briefs |
| `setup-repo` | typed | Configure the issue tracker, triage labels and glossary layout for a repo, once |
| `simple-code` | automatic | Least code that works, standard library first, optimize only after measuring |
| `correct-by-design` | automatic | Checks at trust boundaries, loud specific failures, DEBUG logs to `./log/` |
| `codebase-design` | automatic | Deep modules behind small interfaces, and where seams go |
| `tdd` | automatic | Red, then green, one slice at a time, at seams agreed with you |
| `code-review` | automatic | Two parallel reviewers, one for repo standards and code smells and one for the spec |
| `diagnosing-bugs` | automatic | Build a failing loop first, then minimise, hypothesise, instrument, fix |
| `research` | automatic | Background agent reads primary sources and writes a cited note |
| `prototype` | automatic | Throwaway code to answer a design question about logic or UI |
| `domain-modeling` | automatic | Keep `GLOSSARY.md` and ADRs current while terms and decisions settle |
| `pr` | automatic | Pull request body with a summary visual, evidence and merge risk |
| `wizard` | automatic | Bash script that walks a person through steps only they can do |
| `grill-me` | typed | Interview about an idea until nothing is assumed |
| `grill-with-docs` | typed | Same interview, recording a glossary and ADRs |
| `handoff` | typed | Save the session to `$TMPDIR/llm-conf-handoff/<repo>.md` for a fresh context |
| `grilling` | automatic | The interview itself, in rounds with a recommended answer per question |
| `writing-for-agents` | automatic | How to write skills and CLAUDE.md files |
| `flat-prose` | automatic | Plain, direct prose for anything a person reads |
| `report` | automatic | End-of-task summary with files, checks, review rounds and agent count |
| `model-routing` | automatic | Cheaper models only when near a usage limit |
| `markitdown` | automatic | Read PDF, Office, image, audio and video files with local tools |
| `git-guardrails` | automatic | Add permission rules that ask you before `git push`, `reset --hard` and other destructive commands |

The `analyst` agent runs on Haiku for cheap scans and summaries. The `reviewer` agent runs on Opus and does the reviews in `plan` and `code-review`.

After a compaction or `claude --continue`, the plugin's `SessionStart` hook prints the repo's handoff file back into context. Auto-compaction keeps Claude Code's default threshold.

## Credit

Skills under `skills/` that are not ours come from [mattpocock/skills](https://github.com/mattpocock/skills) at commit `5beb35b040e3de97e54fa9e386d7e42d15c295c2`, under the MIT license in `LICENSES/mattpocock-skills.txt`. Ours are `simple-code`, `correct-by-design`, `plan`, `flat-prose`, `report`, `model-routing` and `markitdown`, and `implement`, `code-review`, `handoff` and `setup-repo` are edited from his. Principles 3 and 4 in `global/CLAUDE.md` are adapted from [Andrej Karpathy's LLM-coding guidelines](https://github.com/multica-ai/andrej-karpathy-skills) (MIT). The plan and review rules borrow from [drogers0/llm-config](https://github.com/drogers0/llm-config).
