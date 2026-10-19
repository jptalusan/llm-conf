.PHONY: install uninstall clean status validate

install:        ## Link global/CLAUDE.md and load this repo as the llm-conf plugin
	@./install.sh

uninstall clean: ## Remove the links this repo created
	@./install.sh --uninstall

status:         ## Show this repo's links in ~/.claude
	@CLAUDE_DIR=$${CLAUDE_CONFIG_DIR:-$$HOME/.claude}; \
	ls -l "$$CLAUDE_DIR/CLAUDE.md" "$$CLAUDE_DIR/skills/llm-conf" 2>/dev/null || echo "  (not installed)"

validate:       ## Check the plugin manifests and skills
	@claude plugin validate .
