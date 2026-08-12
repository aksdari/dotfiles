# Interactive shell entrypoint. Order matters:
#   exports   -> PATH, env, shell options (nothing depends on it yet)
#   plugins   -> completions, autosuggestions, highlighting, tool init
#   aliases   -> needs the tools that plugins.zsh confirmed exist
#   keybinds  -> may rebind widgets that plugins.zsh defined
#   functions -> uses aliases and tools
#   local     -> machine-specific, always wins

# Homebrew env for non-login interactive shells (tmux panes, nvim terminals).
if [[ -z "$HOMEBREW_PREFIX" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

for _module in exports plugins aliases keybinds functions; do
  [[ -r "$ZDOTDIR/$_module.zsh" ]] && source "$ZDOTDIR/$_module.zsh"
done
unset _module

# Not tracked in git: gcloud/pnpm/work paths, secrets, per-machine overrides.
[[ -r "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh"
