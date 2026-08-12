bindkey -e                                  # emacs keys; vi lives in nvim/tmux

# Prefix-aware history on C-p / C-n. Atuin owns C-r and (optionally) the arrows.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search   # up arrow
bindkey '^[[B' down-line-or-beginning-search # down arrow

# C-x C-e opens the current command line in $EDITOR.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Word-wise movement and deletion.
bindkey '^[[1;5C' forward-word               # ctrl-right
bindkey '^[[1;5D' backward-word              # ctrl-left
bindkey '^[[3;5~' kill-word                  # ctrl-delete
bindkey '^H' backward-kill-word              # ctrl-backspace
bindkey '^[[3~' delete-char
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^U' backward-kill-line

# Accept the autosuggestion without leaving home row (widget only exists if the
# plugin loaded, and bindkey would error out otherwise).
zle -la autosuggest-accept && bindkey '^ ' autosuggest-accept   # ctrl-space
bindkey '^[[Z' reverse-menu-complete         # shift-tab
