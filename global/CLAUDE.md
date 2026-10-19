# CLAUDE.md

Operating rules for every project. Merge with project-specific instructions. The skills named here come from the llm-conf plugin. Call them by their full name, such as `llm-conf:code-review`, because some short names belong to Claude Code built-ins.

## 1. Ask before deciding
Decisions belong to the user. Before non-trivial work, meaning a new feature, a design change or an edit across several files, ask about every decision you would otherwise make silently, using the `grilling` skill's format: numbered rounds, each question with your recommended answer, worded so "yes" accepts it. Look up facts yourself and ask only about decisions. Typo fixes, one-line changes and plain questions go straight ahead. This rule overrides any default to pick the obvious option and proceed.

## 2. Simple code
Load the `simple-code` skill when writing or changing code. Write the least code that solves the problem, prefer the standard library unless the user names a package, and optimize only after a measurement shows a hot path.

## 3. Surgical changes
Touch only what you must. Match existing style and leave adjacent code alone. Remove only the orphans your own change created, and mention other dead code without deleting it. Every changed line traces to the request.

## 4. Goal-driven execution
Turn tasks into verifiable goals ("fix the bug" becomes "write a failing test, then make it pass"). State a short plan with a check per step, then loop until each check passes.

## 5. Correct by design
Load the `correct-by-design` skill when designing or writing non-trivial code. Checks live at trust boundaries, failures are loud and specific, and logs go to `./log/` at DEBUG by default. Tests go where the `tdd` skill says, at seams agreed with the user.

## 6. Typed-only skills
These skills run only when the user types them, so tell the user when one fits and wait for them to type it.
- `/llm-conf:plan` before non-trivial code. It grills, then writes a reviewed `*_PLAN.md`. Never plan through Claude Code's plan mode or the `Plan` agent. When planning comes up, ask the user to type `/llm-conf:plan`. If plan mode is on, ask the user to exit it (Shift+Tab) and type `/llm-conf:plan`, since plan mode cannot write the plan file.
- `/implement` once a plan or spec is approved. When the user says "go ahead" on a plan, answer "Type `/implement` to build it" and wait.
- `/handoff` when the user is stepping away, the session has run long, or work passes to another agent.
- `/grill-me` to stress-test an idea with no code, and `/grill-with-docs` to do the same while recording a glossary and ADRs.
- `/to-spec`, `/to-tickets` and `/implement-spec` for work too big for one plan, and `/triage` for an issue queue. Each needs `/setup-repo` run once per repo.

## 7. Write in plain English
Load the `flat-prose` skill before writing more than a sentence or two for a person: chat replies, docs, reports, commit messages and code comments. Skills and CLAUDE.md files follow the `writing-for-agents` skill.

## 8. Close with a report
After an implement and review cycle, end with the `report` skill's format, including the count of agents involved by role.

## 9. Conserve only near a usage limit
Use the session's normal model and effort. Only near a 5-hour or weekly limit, follow the `model-routing` skill. The `analyst` (Haiku) and `reviewer` (Opus) agents keep their pinned models as a role default.

## Compact Instructions
When compacting, keep the user's goal and preferences stated this session, every finding with its source file, each running job with its machine, log path and completion marker, open decisions awaiting the user, and the next steps in order. Point to the handoff file and the project memory as the record. Drop tool output and file contents that are already on disk.

---
*Principles 3 and 4 are adapted from Andrej Karpathy's LLM-coding guidelines (MIT).*
