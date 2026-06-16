.PHONY: install uninstall clean status

install:        ## Symlink skills, subagents, and CLAUDE.md into ~/.claude
	@./install.sh

uninstall clean: ## Remove the symlinks this repo created
	@./install.sh --uninstall

status:         ## Show which of this repo's links are live in ~/.claude
	@CLAUDE_DIR=$${CLAUDE_CONFIG_DIR:-$$HOME/.claude}; \
	echo "skills:"; ls -l "$$CLAUDE_DIR/skills" 2>/dev/null | grep -- '-> ' || echo "  (none)"; \
	echo "agents:"; ls -l "$$CLAUDE_DIR/agents" 2>/dev/null | grep -- '-> ' || echo "  (none)"; \
	echo "CLAUDE.md:"; ls -l "$$CLAUDE_DIR/CLAUDE.md" 2>/dev/null || echo "  (none)"
