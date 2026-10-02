#!/usr/bin/env python3
"""Opt-in: merge the compaction settings into ~/.claude/settings.json.

Adds env CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80 (auto-compact at 80% of the
context window; Claude Code only honours values below its default) and a
SessionStart hook with matcher "compact" that runs session-start-compact.sh.
Keeps every other setting, writes a .bak copy first, and is safe to rerun.
Run with --uninstall to remove exactly what it added.
"""

import json
import os
import shutil
import sys
from pathlib import Path

CLAUDE_DIR = Path(os.environ.get("CLAUDE_CONFIG_DIR", Path.home() / ".claude"))
SETTINGS = CLAUDE_DIR / "settings.json"
HOOK = str(Path(__file__).resolve().parent / "session-start-compact.sh")
PCT = "80"


def main() -> None:
    data = json.loads(SETTINGS.read_text()) if SETTINGS.exists() else {}
    if SETTINGS.exists():
        shutil.copy2(SETTINGS, SETTINGS.with_suffix(".json.bak"))
    env = data.setdefault("env", {})
    hooks = data.setdefault("hooks", {}).setdefault("SessionStart", [])
    ours = lambda g: any(h.get("command") == HOOK for h in g.get("hooks", []))  # noqa: E731
    if "--uninstall" in sys.argv:
        if env.get("CLAUDE_AUTOCOMPACT_PCT_OVERRIDE") == PCT:
            env.pop("CLAUDE_AUTOCOMPACT_PCT_OVERRIDE")
        data["hooks"]["SessionStart"] = [g for g in hooks if not ours(g)]
        print("removed compaction settings")
    else:
        env["CLAUDE_AUTOCOMPACT_PCT_OVERRIDE"] = PCT
        if not any(ours(g) for g in hooks):
            hooks.append({"matcher": "compact", "hooks": [{"type": "command", "command": HOOK}]})
        print(f"auto-compact at {PCT}%, post-compaction hook {HOOK}")
    SETTINGS.write_text(json.dumps(data, indent=2) + "\n")
    print(f"wrote {SETTINGS} (backup {SETTINGS.with_suffix('.json.bak')}); restart Claude Code")


if __name__ == "__main__":
    main()
