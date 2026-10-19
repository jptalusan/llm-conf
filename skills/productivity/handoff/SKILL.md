---
name: handoff
description: Save the session to a handoff file outside the repo so a fresh context or another agent can continue the work.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

Write a handoff document so a fresh agent can continue the work without this conversation. A compaction keeps only a summary, so anything not in this file or already in the repo is at risk.

Save it to `$TMPDIR/llm-conf-handoff/<repo>.md` (`$TMPDIR`, else `/tmp`), where `<repo>` is the basename of the git root, or of the current directory outside git. Never write it inside the repo. Overwrite any previous handoff for the same repo: the newest state is the only one that matters. The `SessionStart` hook of this plugin prints that file back into context after a compaction or `claude --continue`.

The document holds these sections, in order:

- **Goal.** What the user is trying to achieve, in their words where possible.
- **Done.** Each item with its commit hash or file path.
- **Findings.** Every number or conclusion reached, with its source file. A finding that lives only in the conversation is lost.
- **Running jobs.** For each: machine, how to reach it, working directory, launch command, log path, the line that marks completion, and where results land.
- **Open decisions.** Questions waiting on the user, with the options discussed and any recommendation given.
- **Next steps.** In order, each concrete enough to start without rereading the conversation.
- **User preferences.** Corrections and style rules the user gave this session.
- **Suggested skills.** Which skills the next agent should call the Skill tool for.

Do not duplicate content already captured in other artifacts (plans, specs, ADRs, issues, commits, diffs). Reference them by path or URL instead.

Redact any sensitive information, such as API keys, passwords, or personally identifiable information.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.

Before finishing, reread the document once and ask: could a fresh session resume from this alone? If anything is only in the conversation, write it down. Then tell the user the file path and that it is safe to compact or start a new session.
