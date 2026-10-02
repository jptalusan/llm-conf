#!/usr/bin/env bash
# SessionStart hook (matcher "compact"): after a compaction, put the project's
# newest saved state back into context. Stdout is added to the new context.
# Looks for session.md at the git root of the working directory.
set -uo pipefail
root="$(git -C "${CLAUDE_PROJECT_DIR:-$PWD}" rev-parse --show-toplevel 2>/dev/null || echo "${CLAUDE_PROJECT_DIR:-$PWD}")"
f="$root/session.md"
echo "Context was just compacted. Resume from the saved state below (the newest section of $f) and the project memory; follow its Next steps."
if [ -f "$f" ]; then
  # The newest state section: from the first "## State" heading to the next one.
  awk '/^## State/{n++} n==1' "$f" | head -c 12000
else
  echo "(no session.md found at $root; read the project memory and plan files before continuing)"
fi
exit 0
