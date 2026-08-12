# ── PATH ─────────────────────────────────────────────────────────────────────
typeset -U path PATH                     # dedupe, keep first occurrence
path=(
  "$HOME/.local/bin"
  "$HOME/go/bin"
  "$XDG_DATA_HOME/npm/bin"
  $path
)
export PATH

# ── Editor / pager ───────────────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"
export PAGER="less"
export LESS="-R -F -i -M -w -z-4"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

# ── History ──────────────────────────────────────────────────────────────────
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"

setopt EXTENDED_HISTORY          # timestamp each entry
setopt SHARE_HISTORY             # sync across live shells
setopt INC_APPEND_HISTORY        # write as you go, not at exit
setopt HIST_IGNORE_ALL_DUPS      # keep only the most recent copy
setopt HIST_IGNORE_SPACE         # leading space = don't record
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY               # expand !! into the buffer, don't run it

# ── Shell behaviour ──────────────────────────────────────────────────────────
setopt AUTO_CD                   # `dotfiles` instead of `cd dotfiles`
setopt AUTO_PUSHD                # every cd pushes onto the dir stack
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt EXTENDED_GLOB
setopt GLOB_DOTS                 # globs match dotfiles
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt NO_FLOW_CONTROL           # free up C-s / C-q

# ── fzf ──────────────────────────────────────────────────────────────────────
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="
  --height 60% --layout=reverse --border=rounded --info=inline-right
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --color=selected-bg:#45475a
  --color=border:#6c7086,label:#cdd6f4"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :300 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}'"

# ── Tooling ──────────────────────────────────────────────────────────────────
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ANALYTICS=1
export BAT_THEME="Catppuccin Mocha"
export GOPATH="$HOME/go"
export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export DOTFILES="$HOME/github/dotfiles"
