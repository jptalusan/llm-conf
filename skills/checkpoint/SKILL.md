---
name: checkpoint
description: Save everything a long session needs to survive compaction, then compact. Use before any /compact, when the context nears 80%, when the user says they are stepping away or their connection may drop, or when a long-running job is launched. Triggers on "checkpoint", "save state", "prepare to compact", "store everything before compaction".
---

# Checkpoint

A compaction keeps a summary and drops the rest. Anything not written to disk before it is at risk. This process writes the state where the next context will find it, in a fixed order, so nothing is missed. Run all of it; each step takes a minute.

## 1. State file

Update the project's state file, `session.md` at the repo root (create it if the project has none). Prepend a section titled `## State (<date>, <one-phrase reason>)` so the newest state is always first. It holds, in this order:

- **Goal.** What the user is trying to achieve this session, in their words where possible.
- **Done since the last checkpoint.** Each item with its commit hash or file path.
- **Findings.** Every number or conclusion reached, with its source file. A finding that lives only in the conversation is lost at compaction.
- **Running jobs.** For each: machine, how to reach it (ssh command), working directory, exact launch command, log path, the line that marks completion, where results land, and what to do with them when done.
- **Open decisions.** Questions waiting on the user, with the options already discussed and any recommendation given.
- **Next steps.** In order, each concrete enough to start without rereading the conversation.
- **User preferences learned this session.** Corrections, style rules, things the user asked not to do.

## 2. Plans and logs

If the project keeps a plan or findings log (for example `plan.md`, a dated results log, a registry), update it so it agrees with the state file. Mark finished items as done and superseded sections as superseded.

## 3. Memory

Update the auto-memory for this project: the project memory file and its one-line pointer in `MEMORY.md`. Record what a fresh session needs that the repo does not already say: where the records live, current machines and access, and preferences. Feedback the user gave goes in a feedback memory with its reason.

## 4. Artifacts and outputs

For every artifact, deck or document edited this session, note its link and the source of truth (for a deck the user edits on the page, snapshot the live files into the repo). Make sure every result file the findings depend on is in the repo; force-add files that `.gitignore` would drop.

## 5. Commit

Commit the state file, plans, snapshots and result files (no co-author lines unless the project allows them). Report the commit hash.

## 6. Verify, then compact

Reread the new state section once and ask: could a fresh session resume from this alone, without the conversation? If anything is only in the conversation, write it down. Then tell the user the checkpoint is done (commit hash, state file path, running jobs) and that it is safe to compact. Run `/compact` only if the user asked for it; auto-compaction handles the rest.

## After a compaction

The first thing to do after a compaction is read the newest section of `session.md` and the project memory, then continue from "Next steps". A `SessionStart` hook with the `compact` matcher (see `hooks/session-start-compact.sh` in llm-conf) prints the state file into context to make this automatic.
