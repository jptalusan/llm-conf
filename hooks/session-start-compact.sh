#!/usr/bin/env bash
# SessionStart hook (matchers "compact" and "resume"): after a compaction or a
# `claude --continue`, put the project's newest saved state back into context.
# Stdout is added to the new context. Uses session.md at the git root, else the
# newest-modified session.md among the repo's worktrees.
set -uo pipefail
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
root="$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null || echo "$dir")"
f="$root/session.md"
if [ ! -f "$f" ]; then
  found=()
  while IFS= read -r line; do
    wt="${line#worktree }"
    [ -f "$wt/session.md" ] && found+=("$wt/session.md")
  done < <(git -C "$dir" worktree list --porcelain 2>/dev/null | grep '^worktree ')
  [ ${#found[@]} -gt 0 ] && f="$(ls -t "${found[@]}" | head -1)"
fi
echo "Session resumed or compacted. Resume from the saved state below (the newest section of $f) and the project memory; follow its Next steps."
if [ -f "$f" ]; then
  # The newest state section: from the first "## State" heading to the next one.
  awk '/^## State/{n++} n==1' "$f" | head -c 12000
else
  echo "(no session.md found at $root or its worktrees; read the project memory and plan files before continuing)"
fi
exit 0
