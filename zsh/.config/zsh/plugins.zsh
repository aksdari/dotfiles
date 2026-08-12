# ── Completions ──────────────────────────────────────────────────────────────
# Brew's completion functions have to be on fpath before compinit runs.
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi

autoload -Uz compinit
_zcompdump="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
[[ -d "${_zcompdump:h}" ]] || mkdir -p "${_zcompdump:h}"
# Only rebuild the dump once a day; -C skips the (slow) security check.
if [[ -n "$_zcompdump"(#qN.mh+24) ]]; then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu no                      # fzf-tab replaces the menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# ── Plugins ──────────────────────────────────────────────────────────────────
_plug() { [[ -r "$1" ]] && source "$1" }

_plug "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'

# fzf-tab must load after compinit and before syntax highlighting.
_plug "$XDG_DATA_HOME/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
zstyle ':fzf-tab:*' fzf-flags --height=60% --layout=reverse --border=rounded
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=2 --color=always $realpath'
zstyle ':fzf-tab:complete:(nvim|bat|cat):*' fzf-preview \
  '[[ -f $realpath ]] && bat --style=numbers --color=always --line-range :300 $realpath'
zstyle ':fzf-tab:complete:git-(add|diff|restore|checkout):*' fzf-preview \
  'git diff --color=always -- $realpath'

# Syntax highlighting wraps the ZLE widgets, so it goes last.
_plug "$HOMEBREW_PREFIX/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

unfunction _plug

# ── Tool integrations ────────────────────────────────────────────────────────
command -v fzf      >/dev/null && source <(fzf --zsh)
command -v zoxide   >/dev/null && eval "$(zoxide init zsh)"
command -v atuin    >/dev/null && eval "$(atuin init zsh --disable-up-arrow)"
command -v starship >/dev/null && eval "$(starship init zsh)"
