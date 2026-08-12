# dotfiles

Neovim · WezTerm · tmux · zsh — managed with [GNU Stow](https://www.gnu.org/software/stow/),
themed with [Catppuccin Mocha](https://catppuccin.com), driven entirely by `make`.

📋 **[Keymap cheatsheet →](docs/KEYMAPS.md)**

## Quick start

```sh
git clone https://github.com/aksdari/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

Then open a new terminal. `make install` is idempotent — re-run it any time. It
never deletes a real file: anything in its way moves to
`~/.dotfiles-backup-<timestamp>/`.

<details>
<summary>What <code>make install</code> does</summary>

1. Installs Homebrew if missing, then everything in the [`Brewfile`](Brewfile)
2. Removes symlinks left over from an older layout, backs up conflicting real files
3. Migrates `~/.zsh_history` to `~/.local/state/zsh/history`
4. Stows every package into `$HOME`
5. Installs tpm and all tmux plugins
6. Clones `fzf-tab` for zsh completions
7. Syncs Neovim plugins headlessly
8. Installs the pre-commit hook that blocks secrets
9. Tells you how to switch your login shell to Homebrew zsh

</details>

## Commands

```
make                 list every target
```

**Setup** — `install` (full setup) · `brew` (Brewfile only) · `hooks` (secret-blocking
git hooks) · `shell` (make Homebrew zsh the login shell)

**Symlinks** — `stow` · `unstow` · `check` (dry run)

**Maintenance** — `update` (brew + Neovim + tmux plugins) · `lint` (shellcheck +
stylua) · `doctor` (broken links, missing tools, shell startup time) ·
`clean` (drop the backup directories)

**Security** — `scan` (working tree + full history) · `scan-staged`

Every target takes a package list:

```sh
make install PACKAGES="nvim tmux"
make stow    PACKAGES="zsh"
```

## What's in here

| Package | Lands at | What it is |
| --- | --- | --- |
| `zsh` | `~/.zshenv`, `~/.config/zsh/` | No oh-my-zsh: native zsh, starship prompt, autosuggestions, fast-syntax-highlighting, fzf-tab, atuin, zoxide |
| `nvim` | `~/.config/nvim/` | LazyVim + curated plugins, Catppuccin, sidekick.nvim wired to Claude Code |
| `tmux` | `~/.config/tmux/` | `C-a` prefix, vi copy mode, sessionx, resurrect + continuum, Catppuccin status bar |
| `wezterm` | `~/.config/wezterm/` | Catppuccin Mocha, MesloLGS Nerd Font, blurred transparent window |
| `starship` | `~/.config/starship.toml` | Catppuccin powerline prompt: path, branch, dirty state, runtime versions; duration and clock on the right. Segments appear only when they apply |
| `git` | `~/.config/git/` | delta pager, rebase-by-default, sane fetch/push/rerere, aliases |
| `bat` | `~/.config/bat/` | Catppuccin Mocha + style defaults, reused by fzf previews and delta |
| `aerospace` | `~/.config/aerospace/` | Tiling window manager config |

## Secrets

**This repo is public, so nothing machine-specific or secret is tracked.**

- `make hooks` (run automatically by `make install`) points `core.hooksPath` at
  [`.githooks/`](.githooks). The pre-commit hook blocks a commit when
  [gitleaks](https://github.com/gitleaks/gitleaks) finds a credential in the
  staged diff, when a staged filename looks like key material (`*.pem`, `.env`,
  `id_ed25519`, `local.zsh`, …), or when an added line assigns a long opaque
  value to something named like a token.
- [`.gitignore`](.gitignore) refuses the same set of paths in the first place.
- `make scan` audits the working tree *and* the entire commit history on demand.

Anything private — SDK paths, work aliases, API tokens — belongs in
`~/.config/zsh/local.zsh`, which is gitignored and sourced last:

```sh
cp ~/.config/zsh/local.zsh.example ~/.config/zsh/local.zsh
```

Git identity (`user.name` / `user.email`) stays in `~/.gitconfig`, which git
reads *after* this repo's config, so it is never committed here.

If the hook ever fires on a false positive, `git commit --no-verify` bypasses
it — check what tripped it first.

## Adding a package

Mirror the path the file should have in `$HOME`:

```sh
mkdir -p ghostty/.config/ghostty
mv ~/.config/ghostty/config ghostty/.config/ghostty/config
make stow PACKAGES=ghostty
```

Then add the name to `PACKAGES` in the [`Makefile`](Makefile) and to
`ALL_PACKAGES` in [`bootstrap.sh`](bootstrap.sh).

## Requirements

macOS with Homebrew and the Xcode command line tools (for `make`). On Linux,
`make install` skips the Homebrew steps — install the [`Brewfile`](Brewfile)
equivalents with your package manager first, then re-run it.

### Optional: Aerospace

The `aerospace` package stows a config for the tiling window manager, but the app
itself isn't in the Brewfile — it ships from a third-party tap that Homebrew makes
you trust explicitly:

```sh
brew tap nikitabobko/tap
brew trust nikitabobko/tap
brew install --cask aerospace
```
