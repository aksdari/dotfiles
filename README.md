# dotfiles

Neovim · WezTerm · tmux · zsh — managed with [GNU Stow](https://www.gnu.org/software/stow/),
themed with [Catppuccin Mocha](https://catppuccin.com), bootstrapped in one command.

## Quick start

```sh
git clone https://github.com/aksdari/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

Then open a new terminal. That's it.

`bootstrap.sh` is idempotent — re-run it any time. It never deletes a real file:
anything in its way is moved to `~/.dotfiles-backup-<timestamp>/`.

<details>
<summary>What bootstrap.sh actually does</summary>

1. Installs Homebrew if missing, then everything in the [`Brewfile`](Brewfile)
2. Removes symlinks left over from an older layout, backs up conflicting real files
3. Migrates `~/.zsh_history` to `~/.local/state/zsh/history`
4. Stows every package into `$HOME`
5. Installs tpm and all tmux plugins
6. Clones `fzf-tab` for zsh completions
7. Syncs Neovim plugins headlessly
8. Tells you how to switch your login shell to Homebrew zsh

</details>

## What's in here

| Package | Lands at | What it is |
| --- | --- | --- |
| `zsh` | `~/.zshenv`, `~/.config/zsh/` | No oh-my-zsh: native zsh, starship prompt, autosuggestions, fast-syntax-highlighting, fzf-tab, atuin, zoxide |
| `nvim` | `~/.config/nvim/` | LazyVim + curated plugins, Catppuccin, sidekick.nvim wired to Claude Code |
| `tmux` | `~/.config/tmux/` | `C-a` prefix, vi copy mode, sessionx, resurrect + continuum, Catppuccin status bar |
| `wezterm` | `~/.config/wezterm/` | Catppuccin Mocha, MesloLGS Nerd Font, blurred transparent window |
| `starship` | `~/.config/starship.toml` | Two-line prompt: dir, git, runtime versions, command duration |
| `git` | `~/.config/git/` | delta pager, rebase-by-default, sane fetch/push/rerere, aliases |
| `bat` | `~/.config/bat/` | Catppuccin Mocha + style defaults, reused by fzf previews and delta |
| `aerospace` | `~/.config/aerospace/` | Tiling window manager config |

Identity (`user.name` / `user.email`) stays in `~/.gitconfig`, which git reads
*after* the repo's config — so nothing personal is committed here.

## Day-to-day

```sh
make            # list every target
make stow       # re-link all packages
make check      # dry run: show what stow would change
make update     # brew upgrade + Lazy sync + tpm update
make doctor     # list broken symlinks
make unstow     # remove all symlinks
```

Deploy a single package: `stow --target=$HOME nvim`
(or `./bootstrap.sh nvim tmux` to bootstrap just those).

### Adding a package

Mirror the path it should have in `$HOME`:

```sh
mkdir -p ghostty/.config/ghostty
mv ~/.config/ghostty/config ghostty/.config/ghostty/config
stow --target=$HOME ghostty
```

Then add the name to `ALL_PACKAGES` in `bootstrap.sh` and `PACKAGES` in the `Makefile`.

### Machine-specific settings

Anything that shouldn't be committed — work paths, SDKs, tokens — goes in
`~/.config/zsh/local.zsh`, which is gitignored and sourced last:

```sh
cp ~/.config/zsh/local.zsh.example ~/.config/zsh/local.zsh
```

## Keybindings

**tmux** — prefix is `C-a`

| Key | Action |
| --- | --- |
| `\|` / `-` | Split vertically / horizontally (in the current dir) |
| `h j k l` | Resize pane (repeatable) |
| `m` | Zoom pane |
| `o` | Session picker (sessionx) |
| `r` | Reload config |
| `C-h/j/k/l` | Move between panes *and* Neovim splits (no prefix) |
| `v` / `y` | Begin selection / yank to clipboard (copy mode) |

**Neovim** — leader is `Space`

| Key | Action |
| --- | --- |
| `<leader>ac` | Toggle Claude Code in a tmux-backed split |
| `<leader>gd` | Diffview of the working tree |
| `<leader>gh` | File history |
| `C-s` | Save from any mode |
| `C-n` | Add another cursor (visual-multi) |
| `<leader>p` | Paste over selection without losing the register |

**zsh**

| Command | Action |
| --- | --- |
| `tm` | Fuzzy-pick a project under `~/github` and attach a tmux session |
| `f` | Fuzzy-find a file and open it in Neovim |
| `C-r` | Atuin history search |
| `C-x C-e` | Edit the current command line in Neovim |
| `C-space` | Accept the autosuggestion |

## Requirements

macOS with Homebrew. On Linux, `bootstrap.sh` skips the Homebrew steps — install
the [`Brewfile`](Brewfile) equivalents with your package manager first, then re-run it.

### Optional: Aerospace

The `aerospace` package stows a config for the tiling window manager, but the app
itself isn't in the Brewfile — it ships from a third-party tap that Homebrew makes
you trust explicitly:

```sh
brew tap nikitabobko/tap
brew trust nikitabobko/tap
brew install --cask aerospace
```
