# Dotfiles Restructure — Design

Date: 2026-08-12
Repo: `~/github/dotfiles` (remote `github.com/aksdari/dotfiles`)

## Goal

A clean-slate, stow-managed dotfiles repo for the daily drivers — Neovim, WezTerm,
tmux, zsh — that a fresh machine can adopt in three commands, with no leftover
symlink junk from the previous flat layout.

## Problems with the current state

- Flat layout stowed with `stow -t ~ .`: all-or-nothing, needs `.stow-local-ignore`.
- `~/.config/tmux` is a broken symlink (target never existed in the repo).
- `~/.config/alacritty` dangles (configs deleted, link left behind).
- `~/.config/nvim.bak` and `~/.zshrc.pre-oh-my-zsh` are stray duplicate links.
- `.zshrc` is oh-my-zsh with `robbyrussell` and `plugins=(git)` — the README
  promises powerlevel10k that is never sourced. Machine-specific absolute paths
  are committed.
- No Brewfile, no bootstrap; tpm and oh-my-zsh installs are manual README steps.
- Neovim custom plugin files were deleted in the working tree but never committed.

## Decisions

| Area | Decision |
|---|---|
| Layout | Per-tool stow packages, XDG paths throughout |
| Shell | No oh-my-zsh. Native zsh + brew plugins + starship prompt |
| Theme | Catppuccin Mocha across wezterm, tmux, nvim, bat, fzf, starship, eza |
| Neovim | Clean-slate LazyVim, curated `lua/plugins/`, no Copilot |
| Neovim AI | `sidekick.nvim` CLI integration only (`nes.enabled = false`), tmux mux backend, Claude Code sessions |
| Bootstrap | `Brewfile` + idempotent `bootstrap.sh` + small `Makefile` |
| Repo path | Stays at `~/github/dotfiles`; README clones to `~/.dotfiles` on new machines |

## Structure

```
dotfiles/
├── README.md
├── Brewfile
├── Makefile
├── bootstrap.sh
├── zsh/       .zshenv, .config/zsh/{.zshrc,exports,aliases,plugins,keybinds,functions}.zsh
├── nvim/      .config/nvim/…
├── tmux/      .config/tmux/tmux.conf
├── wezterm/   .config/wezterm/wezterm.lua
├── starship/  .config/starship.toml
├── git/       .config/git/{config,ignore}
├── bat/       .config/bat/config
└── aerospace/ .config/aerospace/aerospace.toml
```

Each directory is a stow package: `stow nvim tmux zsh wezterm starship git bat`.

## Components

### bootstrap.sh

Idempotent, safe to re-run. Order:

1. Resolve its own directory; refuse to run outside a checkout.
2. Install Homebrew if missing; `brew bundle --file Brewfile`.
3. **Cleanup pass** — unstow the legacy flat layout, delete symlinks that point
   into the repo or dangle (`~/.tmux.conf`, `~/.wezterm.lua`, `~/.aerospace.toml`,
   `~/.zshrc`, `~/.zshrc.pre-oh-my-zsh`, `~/.config/{alacritty,tmux,nvim,nvim.bak}`),
   and move real files/dirs that would conflict (`~/.oh-my-zsh`, `~/.p10k.zsh`,
   `~/.tmux`, `~/.config/git/ignore`) into `~/.dotfiles-backup-<timestamp>/`.
   Never deletes a real file.
4. Migrate `~/.zsh_history` into `~/.local/state/zsh/history` if not already there.
5. `stow` the package list (all packages by default, or the ones named as args).
6. Install tpm into `~/.config/tmux/plugins/tpm` and run `install_plugins`.
7. Clone `fzf-tab` into `~/.local/share/zsh/plugins/fzf-tab`.
8. Add Homebrew zsh to `/etc/shells` and `chsh` to it if not current.
9. Print next steps (`nvim` first launch, `atuin import auto`).

### zsh

`~/.zshenv` is the only file in `$HOME`. It sets XDG variables and
`ZDOTDIR="$XDG_CONFIG_HOME/zsh"`; everything else lives under `~/.config/zsh/`:

- `.zshrc` — orchestrator, sources the modules in order
- `exports.zsh` — PATH, EDITOR, history, fzf, less, XDG-ification of tool state
- `plugins.zsh` — autosuggestions, fast-syntax-highlighting, fzf-tab, completion styles
- `aliases.zsh` — eza/bat/git/tmux/nvim aliases
- `keybinds.zsh` — emacs keys, word nav, `edit-command-line`, history search
- `functions.zsh` — `mkcd`, fuzzy file open, fuzzy tmux session switcher
- `local.zsh` — gitignored, machine-specific (gcloud, pnpm); `local.zsh.example` is tracked

Prompt is starship. History is atuin-backed with a plain-zsh fallback file.

### tmux

Rewritten, same muscle memory: prefix `C-a`, `|`/`-` splits, `r` reload, vi copy,
`hjkl` resize, `m` zoom, mouse on, 1-indexed windows. Plugins via tpm at the XDG
path: vim-tmux-navigator, resurrect, continuum, sessionx (`prefix o`), yank, and
catppuccin v2 for the status line (replacing dracula/themepack).

### wezterm

Moves to `~/.config/wezterm/wezterm.lua`. Catppuccin Mocha, MesloLGS Nerd Font,
existing opacity/blur preferences retained, tab bar hidden when a single tab
(tmux owns multiplexing), larger scrollback, sensible macOS key handling.

### neovim

Commit the deletions as an intentional clean slate, drop the starter
`example.lua`, then add focused plugin files: `colorscheme.lua`, `ui.lua`,
`editor.lua`, `git.lua`, `sidekick.lua`, `tmux.lua`. Language support comes from
LazyVim extras declared in `lazyvim.json`.

### README

Three-command quickstart, package table, what bootstrap does, day-2 commands for
adding/restowing packages, keybinding cheatsheet, machine-local override notes.

## Non-goals

- Linux support beyond "brew section is skipped gracefully".
- Secret management; nothing sensitive is committed.
- Migrating alacritty or aerospace configs beyond relocating aerospace to XDG.

## Verification

- `stow -n -v` dry run reports no conflicts for every package.
- Every stowed path resolves: no dangling links under `$HOME` or `~/.config`.
- `zsh -ic exit` succeeds and startup time is measured and reported.
- `tmux -f tmux/.config/tmux/tmux.conf new-session -d` starts without errors.
- `nvim --headless "+Lazy! sync" +qa` completes without errors.
- `wezterm --config-file … ls-fonts` parses the config.
