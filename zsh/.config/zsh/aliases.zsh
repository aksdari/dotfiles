# ── Files ────────────────────────────────────────────────────────────────────
alias ls='eza --group-directories-first --icons'
alias l='eza -l --group-directories-first --icons --git'
alias ll='eza -la --group-directories-first --icons --git'
alias lt='eza --tree --level=2 --icons --git-ignore'
alias cat='bat --paging=never'
alias catp='bat --plain --paging=never'
alias du='du -h'
alias df='df -h'
alias mkdir='mkdir -p'

# ── Navigation ───────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias dot='cd "$DOTFILES"'
alias ghd='cd "$HOME/github"'

# ── Git ──────────────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status --short --branch'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit --message'
alias gca='git commit --amend'
alias gco='git checkout'
alias gsw='git switch'
alias gb='git branch'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all -30'
alias gp='git push'
alias gpl='git pull --rebase'
alias gst='git stash'
alias lg='lazygit'

# ── Editor ───────────────────────────────────────────────────────────────────
alias v='nvim'
alias vim='nvim'
alias vi='nvim'
alias nv='nvim'

# ── tmux ─────────────────────────────────────────────────────────────────────
alias ta='tmux attach -t'
alias tls='tmux list-sessions'
alias tn='tmux new-session -s'
alias tk='tmux kill-session -t'
alias tks='tmux kill-server'

# ── Misc ─────────────────────────────────────────────────────────────────────
alias reload='exec zsh'
alias zshconfig='nvim "$ZDOTDIR/.zshrc"'
alias path='echo -e ${PATH//:/\\n}'
alias ip='ipconfig getifaddr en0'
alias myip='curl -s https://ifconfig.me && echo'
alias ports='lsof -i -P -n | grep LISTEN'
alias brewup='brew update && brew upgrade && brew cleanup'
