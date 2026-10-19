#!/usr/bin/env bash
# SessionStart hook (matchers "compact" and "resume"): after a compaction or a
# `claude --continue`, print the repo's handoff file back into context.
# The handoff skill writes it to $TMPDIR/llm-conf-handoff/<repo>.md, where
# <repo> is the basename of the git root (or of the directory outside git).
# Prints nothing when there is no handoff file.
set -uo pipefail
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
root="$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null || echo "$dir")"
f="${TMPDIR:-/tmp}"
f="${f%/}/llm-conf-handoff/$(basename "$root").md"
[ -f "$f" ] || exit 0
echo "Session resumed or compacted. Continue from the handoff below ($f), starting at its Next steps."
head -c 20000 "$f"
exit 0
