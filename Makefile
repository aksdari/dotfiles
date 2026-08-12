# Every operation in this repo runs through here. `make help` lists them all.

PACKAGES ?= zsh nvim tmux wezterm starship git bat aerospace
STOW     := stow --target=$(HOME) --dir=$(CURDIR)
TPM      := $(HOME)/.config/tmux/plugins/tpm
BREW_ZSH := $(shell brew --prefix 2>/dev/null)/bin/zsh

.DEFAULT_GOAL := help

help: ## Show this help
	@awk 'BEGIN { \
		printf "\n\033[1mdotfiles\033[0m — make <target> [PACKAGES=\"nvim tmux\"]\n"; \
	} \
	/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5); next } \
	/^[a-zA-Z_-]+:.*?##/ { \
		split($$0, parts, ":.*?## "); \
		printf "  \033[36m%-14s\033[0m %s\n", parts[1], parts[2]; \
	} \
	END { printf "\n" }' $(MAKEFILE_LIST)

##@ Setup

install: ## Full setup on this machine (brew, cleanup, stow, plugins, hooks)
	@./bootstrap.sh $(PACKAGES)

brew: ## Install or update everything in the Brewfile
	@brew bundle --file=$(CURDIR)/Brewfile

hooks: ## Install the git hooks that block secrets from being committed
	@git config core.hooksPath .githooks
	@chmod +x .githooks/*
	@echo "hooks active: $$(ls .githooks | tr '\n' ' ')"

shell: ## Make Homebrew zsh the login shell (asks for sudo)
	@grep -qx '$(BREW_ZSH)' /etc/shells || echo '$(BREW_ZSH)' | sudo tee -a /etc/shells >/dev/null
	@chsh -s '$(BREW_ZSH)' && echo "login shell is now $(BREW_ZSH)"

##@ Symlinks

stow: ## Link packages into $HOME
	@$(STOW) --restow $(PACKAGES)
	@echo "stowed: $(PACKAGES)"

unstow: ## Remove the symlinks for packages
	@$(STOW) --delete $(PACKAGES)
	@echo "unstowed: $(PACKAGES)"

check: ## Dry run — show what stow would change
	@$(STOW) --no --verbose=2 --restow $(PACKAGES)

##@ Maintenance

update: ## Update brew packages, Neovim plugins and tmux plugins
	@brew update && brew upgrade && brew cleanup
	@nvim --headless "+Lazy! sync" +qa
	@TMUX_PLUGIN_MANAGER_PATH=$(HOME)/.config/tmux/plugins/ $(TPM)/bin/update_plugins all

lint: ## shellcheck the scripts and stylua-check the Lua
	@shellcheck -S warning bootstrap.sh .githooks/*
	@stylua --check nvim/.config/nvim/lua/
	@echo "lint clean"

doctor: ## Check for broken links, unstowed packages and missing tools
	@echo "── broken symlinks ──"
	@find $(HOME) -maxdepth 1 -type l ! -exec test -e {} \; -print 2>/dev/null || true
	@find $(HOME)/.config -maxdepth 2 -type l ! -exec test -e {} \; -print 2>/dev/null || true
	@echo "── packages needing a stow ──"
	@for p in $(PACKAGES); do \
		out=$$($(STOW) --no --verbose=1 $$p 2>&1 | grep -E "^(LINK|WARNING! )" || true); \
		[ -n "$$out" ] && echo "$$p: run 'make stow PACKAGES=$$p'" || true; \
	done
	@echo "── missing tools ──"
	@for t in stow nvim tmux wezterm zsh starship zoxide atuin eza bat fd rg fzf delta lazygit gitleaks; do \
		command -v $$t >/dev/null || echo "$$t is missing"; \
	done
	@echo "── shell startup ──"
	@/usr/bin/time -p zsh -i -c exit 2>&1 | awk '/real/ {printf "  zsh starts in %.0f ms\n", $$2 * 1000}'
	@echo "done"

clean: ## Delete the ~/.dotfiles-backup-* directories bootstrap created
	@ls -d $(HOME)/.dotfiles-backup-* 2>/dev/null || { echo "no backups to remove"; exit 0; }
	@printf "remove all of the above? [y/N] " && read ans && [ "$$ans" = "y" ] \
		&& rm -rf $(HOME)/.dotfiles-backup-* && echo "removed" || echo "kept"

##@ Security

scan: ## Scan the working tree and full git history for secrets
	@echo "── working tree ──"
	@gitleaks dir --no-banner --redact .
	@echo "── history ──"
	@gitleaks git --no-banner --redact .

scan-staged: ## Scan only what is staged (what the pre-commit hook runs)
	@gitleaks git --staged --no-banner --redact .

.PHONY: help install brew hooks shell stow unstow check update lint doctor clean scan scan-staged
