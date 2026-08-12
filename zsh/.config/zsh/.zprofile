# Login shells only. Homebrew's environment has to be set before .zshrc so that
# $HOMEBREW_PREFIX is available when plugins are sourced.

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
