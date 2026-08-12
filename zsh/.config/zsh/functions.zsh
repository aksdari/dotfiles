zmodload zsh/datetime   # $EPOCHREALTIME, used by zshtime below

# mkcd <dir> — create a directory and step into it.
mkcd() {
  mkdir -p -- "$1" && cd -- "$1"
}

# f — fuzzy-find a file and open it in nvim.
f() {
  local file
  file=$(fzf --preview 'bat --style=numbers --color=always --line-range :300 {}') || return
  nvim "$file"
}

# fh — fuzzy-search history and put the result on the command line.
fh() {
  local cmd
  cmd=$(fc -rl 1 | fzf --no-sort --query "$*" | sed 's/^ *[0-9]* *//') || return
  print -z -- "$cmd"
}

# tm [name] — tmux sessionizer. With no argument, fuzzy-pick a project under
# ~/github (and the dotfiles repo) and attach to a session named after it,
# creating the session if it does not exist yet.
tm() {
  local dir name
  if [[ -n "$1" ]]; then
    dir="$1"
  else
    dir=$(fd --type d --max-depth 2 --min-depth 1 . "$HOME/github" 2>/dev/null \
      | fzf --prompt='project> ' --preview 'eza --tree --level=2 --color=always {}') || return
  fi
  [[ -d "$dir" ]] || return 1
  name=$(basename "$dir" | tr '. ' '__')

  if ! tmux has-session -t="$name" 2>/dev/null; then
    tmux new-session -ds "$name" -c "$dir"
  fi

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$name"
  else
    tmux attach -t "$name"
  fi
}

# gclone <url> — clone into ~/github/<repo> and cd there.
gclone() {
  local url="$1" name
  name=$(basename "$url" .git)
  git clone "$url" "$HOME/github/$name" && cd "$HOME/github/$name"
}

# extract <archive> — one command for every archive format.
extract() {
  [[ -f "$1" ]] || { print -u2 "extract: '$1' is not a file"; return 1 }
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz)         tar xJf "$1" ;;
    *.tar)            tar xf "$1"  ;;
    *.zip)            unzip "$1"   ;;
    *.gz)             gunzip "$1"  ;;
    *.bz2)            bunzip2 "$1" ;;
    *.7z)             7z x "$1"    ;;
    *) print -u2 "extract: unknown format '$1'"; return 1 ;;
  esac
}

# zshtime — measure interactive startup, averaged over 10 runs.
zshtime() {
  local total=0 start end
  repeat 10 {
    start=$EPOCHREALTIME
    zsh -i -c exit
    end=$EPOCHREALTIME
    total=$(( total + (end - start) * 1000 ))
  }
  printf 'avg startup: %.0f ms\n' $(( total / 10 ))
}
