#!/usr/bin/env bash
# Symlink this repo's skills, subagents, and CLAUDE.md into ~/.claude.
# Re-runnable. Run with --uninstall to remove the symlinks it created.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

link() {  # src dst
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "SKIP (real file in the way, not touching): $dst"
    return
  fi
  ln -sfn "$src" "$dst"
  echo "linked  $dst -> $src"
}

unlink_if_ours() {  # dst
  local dst="$1"
  if [ -L "$dst" ] && [[ "$(readlink "$dst")" == "$REPO"/* ]]; then
    rm "$dst"; echo "removed $dst"
  fi
}

if [ "${1:-}" = "--uninstall" ]; then
  for dir in "$REPO"/skills/*/;  do unlink_if_ours "$CLAUDE_DIR/skills/$(basename "$dir")"; done
  for f   in "$REPO"/agents/*.md; do unlink_if_ours "$CLAUDE_DIR/agents/$(basename "$f")"; done
  unlink_if_ours "$CLAUDE_DIR/CLAUDE.md"
  echo "Uninstalled. Restart Claude Code."
  exit 0
fi

mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/agents"

# Skills (one symlink per skill folder)
for dir in "$REPO"/skills/*/; do
  link "${dir%/}" "$CLAUDE_DIR/skills/$(basename "$dir")"
done

# Subagents
for f in "$REPO"/agents/*.md; do
  link "$f" "$CLAUDE_DIR/agents/$(basename "$f")"
done

# Global CLAUDE.md: symlink if none exists, otherwise tell the user to import.
if [ ! -e "$CLAUDE_DIR/CLAUDE.md" ]; then
  link "$REPO/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
else
  echo
  echo "NOTE: $CLAUDE_DIR/CLAUDE.md already exists — not overwriting."
  echo "      To include these rules, add this line to it:"
  echo "          @$REPO/CLAUDE.md"
fi

echo
echo "Done. Restart Claude Code (or run /doctor) to pick up new skills/agents."
