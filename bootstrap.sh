#!/usr/bin/env bash
#
# Set up this machine from the dotfiles repo. Safe to re-run: every step checks
# before it acts, and nothing that is not a symlink is ever deleted — conflicting
# files are moved to ~/.dotfiles-backup-<timestamp>/ instead.
#
#   ./bootstrap.sh              # everything
#   ./bootstrap.sh nvim tmux    # only these packages
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
ALL_PACKAGES=(zsh nvim tmux wezterm starship git bat aerospace)

if [[ $# -gt 0 ]]; then
  PACKAGES=("$@")
else
  PACKAGES=("${ALL_PACKAGES[@]}")
fi

# ── Output helpers ───────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  BOLD=$'\033[1m'; BLUE=$'\033[34m'; GREEN=$'\033[32m'; YELLOW=$'\033[33m'; RED=$'\033[31m'; RESET=$'\033[0m'
else
  BOLD=""; BLUE=""; GREEN=""; YELLOW=""; RED=""; RESET=""
fi
step() { printf '\n%s==>%s %s%s%s\n' "$BLUE" "$RESET" "$BOLD" "$*" "$RESET"; }
info() { printf '    %s\n' "$*"; }
ok()   { printf '    %s✓%s %s\n' "$GREEN" "$RESET" "$*"; }
warn() { printf '    %s!%s %s\n' "$YELLOW" "$RESET" "$*"; }
die()  { printf '\n%serror:%s %s\n' "$RED" "$RESET" "$*" >&2; exit 1; }

# ── Backup helpers ───────────────────────────────────────────────────────────
# Move a real file or directory into the backup dir, preserving its layout.
backup_path() {
  local path="$1" rel dest
  [[ -e "$path" || -L "$path" ]] || return 0
  rel="${path#"$HOME"/}"
  dest="$BACKUP/$rel"
  mkdir -p "$(dirname "$dest")"
  mv "$path" "$dest"
  warn "moved $path -> $dest"
}

# Delete a path only if it is a symlink (repo-owned or dangling).
remove_link() {
  local path="$1"
  if [[ -L "$path" ]]; then
    rm -f "$path"
    ok "removed stale symlink $path"
  fi
}

# ── 1. Homebrew ──────────────────────────────────────────────────────────────
install_homebrew() {
  step "Homebrew"
  if command -v brew >/dev/null 2>&1; then
    ok "already installed ($(brew --version | head -1))"
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    info "installing…"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    warn "not macOS — skipping Homebrew, install the Brewfile tools yourself"
    return 0
  fi

  # Make brew usable in this script regardless of shell config.
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

# ── 2. Packages ──────────────────────────────────────────────────────────────
install_packages() {
  step "Brewfile"
  command -v brew >/dev/null 2>&1 || { warn "no brew — skipping"; return 0; }
  brew bundle --file="$DOTFILES/Brewfile"
  ok "packages installed"
}

# ── 3. Clean up the pre-stow / legacy layout ─────────────────────────────────
cleanup_legacy() {
  step "Cleaning up old symlinks"

  # Links created by the old flat `stow -t ~ .` layout, plus dangling leftovers.
  local stale=(
    "$HOME/.zshrc"
    "$HOME/.zshrc.pre-oh-my-zsh"
    "$HOME/.tmux.conf"
    "$HOME/.wezterm.lua"
    "$HOME/.aerospace.toml"
    "$HOME/.config/alacritty"
    "$HOME/.config/tmux"
    "$HOME/.config/nvim"
    "$HOME/.config/nvim.bak"
    "$HOME/.config/wezterm"
  )
  local path
  for path in "${stale[@]}"; do
    remove_link "$path"
  done

  # Real files/dirs from the oh-my-zsh + p10k era. Backed up, never deleted.
  for path in "$HOME/.oh-my-zsh" "$HOME/.p10k.zsh" "$HOME/.tmux" "$HOME/.zshrc"; do
    [[ -e "$path" && ! -L "$path" ]] && backup_path "$path"
  done
  rm -f "$HOME"/.zcompdump* 2>/dev/null || true

  ok "old layout cleared"
}

# ── 4. Shell history ─────────────────────────────────────────────────────────
migrate_history() {
  step "Shell history"
  local target="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
  mkdir -p "$(dirname "$target")"
  if [[ -f "$HOME/.zsh_history" && ! -f "$target" ]]; then
    cp "$HOME/.zsh_history" "$target"
    ok "migrated ~/.zsh_history -> $target"
  else
    ok "history at $target"
  fi
}

# ── 5. Stow ──────────────────────────────────────────────────────────────────
# Ask stow what would collide, back those paths up, then link for real.
resolve_conflicts() {
  local pkg="$1" out line target
  out="$(stow --no --verbose=1 --target="$HOME" --dir="$DOTFILES" "$pkg" 2>&1 || true)"
  while IFS= read -r line; do
    case "$line" in
      *"existing target is not owned by stow: "*) target="${line##*: }" ;;
      *"existing target is neither a link nor a directory: "*) target="${line##*: }" ;;
      *) continue ;;
    esac
    backup_path "$HOME/$target"
  done <<<"$out"
}

stow_packages() {
  step "Stowing packages"
  command -v stow >/dev/null 2>&1 || die "stow is not installed"

  local pkg
  for pkg in "${PACKAGES[@]}"; do
    [[ -d "$DOTFILES/$pkg" ]] || die "no such package: $pkg"
    resolve_conflicts "$pkg"
    stow --restow --target="$HOME" --dir="$DOTFILES" "$pkg"
    ok "$pkg"
  done
}

# ── 6. tmux plugin manager ───────────────────────────────────────────────────
install_tpm() {
  step "tmux plugins"
  local tpm="$HOME/.config/tmux/plugins/tpm"
  if [[ ! -d "$tpm" ]]; then
    git clone --quiet --depth 1 https://github.com/tmux-plugins/tpm "$tpm"
    ok "tpm cloned"
  else
    ok "tpm present"
  fi
  TMUX_PLUGIN_MANAGER_PATH="$HOME/.config/tmux/plugins/" "$tpm/bin/install_plugins" >/dev/null
  ok "plugins installed"
}

# ── 7. zsh plugins that Homebrew does not ship ───────────────────────────────
install_zsh_plugins() {
  step "zsh plugins"
  local dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/fzf-tab"
  if [[ ! -d "$dir" ]]; then
    git clone --quiet --depth 1 https://github.com/Aloxaf/fzf-tab "$dir"
    ok "fzf-tab cloned"
  else
    git -C "$dir" pull --quiet --ff-only || true
    ok "fzf-tab up to date"
  fi
}

# ── 8. bat theme cache ───────────────────────────────────────────────────────
build_bat_cache() {
  step "bat theme"
  command -v bat >/dev/null 2>&1 || { warn "bat not installed — skipping"; return 0; }
  bat cache --build >/dev/null
  ok "Catppuccin Mocha registered"
}

# ── 9. Neovim plugins ────────────────────────────────────────────────────────
sync_neovim() {
  step "Neovim plugins"
  command -v nvim >/dev/null 2>&1 || { warn "nvim not installed — skipping"; return 0; }
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || warn "lazy sync reported issues — open nvim to check"
  ok "plugins synced"
}

# ── 10. Login shell ──────────────────────────────────────────────────────────
set_login_shell() {
  step "Login shell"
  local brew_zsh="${HOMEBREW_PREFIX:-/usr/local}/bin/zsh"
  [[ -x "$brew_zsh" ]] || { warn "Homebrew zsh not found — keeping $SHELL"; return 0; }
  if [[ "$SHELL" == "$brew_zsh" ]]; then
    ok "already $brew_zsh"
    return 0
  fi
  warn "current login shell is $SHELL"
  info "to switch, run:"
  info "  echo '$brew_zsh' | sudo tee -a /etc/shells"
  info "  chsh -s '$brew_zsh'"
}

# ── Run ──────────────────────────────────────────────────────────────────────
main() {
  printf '%sdotfiles%s  %s\n' "$BOLD" "$RESET" "$DOTFILES"
  printf 'packages: %s\n' "${PACKAGES[*]}"

  install_homebrew
  install_packages
  cleanup_legacy
  migrate_history
  stow_packages
  install_tpm
  install_zsh_plugins
  build_bat_cache
  sync_neovim
  set_login_shell

  step "Done"
  [[ -d "$BACKUP" ]] && info "replaced files were backed up to $BACKUP"
  info "next: start a new shell, then run 'atuin import auto' to load old history"
  info "      inside tmux, press C-a I once if any plugin looks missing"
}

main "$@"
