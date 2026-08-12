PACKAGES ?= zsh nvim tmux wezterm starship git bat aerospace
STOW     := stow --target=$(HOME) --dir=$(CURDIR)

.DEFAULT_GOAL := help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

install: ## Full setup: brew, cleanup, stow, plugins (./bootstrap.sh)
	@./bootstrap.sh

brew: ## Install/update everything in the Brewfile
	@brew bundle --file=$(CURDIR)/Brewfile

stow: ## Symlink all packages into $HOME
	@$(STOW) --restow $(PACKAGES)
	@echo "stowed: $(PACKAGES)"

unstow: ## Remove the symlinks for all packages
	@$(STOW) --delete $(PACKAGES)
	@echo "unstowed: $(PACKAGES)"

check: ## Dry run — show what stow would do
	@$(STOW) --no --verbose=2 --restow $(PACKAGES)

update: ## Update brew packages, nvim plugins and tmux plugins
	@brew update && brew upgrade && brew cleanup
	@nvim --headless "+Lazy! sync" +qa
	@TMUX_PLUGIN_MANAGER_PATH=$(HOME)/.config/tmux/plugins/ \
		$(HOME)/.config/tmux/plugins/tpm/bin/update_plugins all

doctor: ## Report broken symlinks pointing at this repo
	@find $(HOME) -maxdepth 1 -type l ! -exec test -e {} \; -print 2>/dev/null || true
	@find $(HOME)/.config -maxdepth 1 -type l ! -exec test -e {} \; -print 2>/dev/null || true
	@echo "no output above means every link resolves"

.PHONY: help install brew stow unstow check update doctor
