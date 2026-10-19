#!/usr/bin/env bash
# Link this repo into ~/.claude:
#   ~/.claude/CLAUDE.md          -> global/CLAUDE.md   (always-on rules)
#   ~/.claude/skills/llm-conf    -> this repo          (loads in place as the llm-conf plugin)
# Also removes links left by the old per-skill install.
# Re-runnable. Run with --uninstall to remove the links it created.
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
  if [ -L "$dst" ] && [[ "$(readlink "$dst")" == "$REPO"* ]]; then
    rm "$dst"; echo "removed $dst"
  fi
}

# Links from the old layout: one per skill folder and one per agent.
for dst in "$CLAUDE_DIR"/skills/* "$CLAUDE_DIR"/agents/*; do
  [ "$(basename "$dst")" = "llm-conf" ] && continue
  unlink_if_ours "$dst"
done

if [ "${1:-}" = "--uninstall" ]; then
  unlink_if_ours "$CLAUDE_DIR/skills/llm-conf"
  unlink_if_ours "$CLAUDE_DIR/CLAUDE.md"
  echo "Uninstalled. Restart Claude Code."
  exit 0
fi

mkdir -p "$CLAUDE_DIR/skills"
link "$REPO" "$CLAUDE_DIR/skills/llm-conf"

# Global CLAUDE.md: link if none exists or it is already a link into this repo.
dst="$CLAUDE_DIR/CLAUDE.md"
if [ ! -e "$dst" ] && [ ! -L "$dst" ] || { [ -L "$dst" ] && [[ "$(readlink "$dst")" == "$REPO"* ]]; }; then
  link "$REPO/global/CLAUDE.md" "$dst"
else
  echo
  echo "NOTE: $dst exists and is not ours, not overwriting it."
  echo "      To include these rules, add this line to it:"
  echo "          @$REPO/global/CLAUDE.md"
fi

echo
echo "Done. Restart Claude Code to load the llm-conf plugin."
