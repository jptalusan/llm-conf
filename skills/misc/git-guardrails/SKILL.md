---
name: git-guardrails
description: Set up Claude Code permission rules that make dangerous git commands (push, reset --hard, clean, branch -D, checkout ., restore .) ask the user before they run. Use when the user wants to guard against destructive git operations or add git safety rules.
---

# Setup Git Guardrails

Adds `ask` permission rules so Claude Code prompts the user before any dangerous git command runs. The user's approval at the prompt is the override: "go ahead and push" works because the user then approves the prompt. Ask rules prompt in every permission mode, including auto mode and bypassPermissions, and they match each part of a compound command, so `cd x && git push` still prompts.

## Rules

```json
"Bash(git push)",
"Bash(git push *)",
"Bash(git reset --hard*)",
"Bash(git reset * --hard*)",
"Bash(git clean *)",
"Bash(git branch -D *)",
"Bash(git checkout .)",
"Bash(git restore .)"
```

Rules match command text, so `git -C . push` or a quoted `git 'push'` slips past them. These are a guardrail against mistakes, not a security boundary.

## Steps

### 1. Ask scope

Ask the user: install for **this project only** (`.claude/settings.json`) or **all projects** (`~/.claude/settings.json`)?

### 2. Add the rules

Merge the rules above into `permissions.ask` in the chosen settings file. Back up the file first. Keep every existing key and rule, skip rules already present, and create `permissions.ask` if it is missing.

### 3. Ask about customization

Ask if the user wants to add or remove any rules, and edit the list accordingly.

### 4. Verify

Read the settings file back and confirm it parses as JSON and that `permissions.ask` holds every rule. Tell the user the rules apply from the next session, or after `/permissions` reloads them.
