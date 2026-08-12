# Keymap cheatsheet

Everything worth memorising, in one place. `<leader>` is `Space` in Neovim;
the tmux prefix is `C-a`.

- [Crossing tools](#crossing-tools)
- [tmux](#tmux)
- [Neovim](#neovim)
- [zsh](#zsh)
- [WezTerm](#wezterm)

## Crossing tools

The bindings that work the same everywhere — this is the point of the setup.

| Key | Works in | Action |
| --- | --- | --- |
| `C-h` `C-j` `C-k` `C-l` | tmux + Neovim | Move between panes and splits as if they were one grid |
| `C-\` | tmux + Neovim | Jump back to the previous pane/split |
| `y` | tmux copy mode + Neovim | Yank to the macOS clipboard |
| `C-r` | zsh | Atuin history search (also inside any tmux pane) |

## tmux

Prefix is `C-a`. "`prefix` `x`" means press `C-a`, release, then `x`.

### Panes and windows

| Key | Action |
| --- | --- |
| `prefix` `\|` | Split vertically, in the current directory |
| `prefix` `-` | Split horizontally, in the current directory |
| `prefix` `c` | New window, in the current directory |
| `prefix` `h/j/k/l` | Resize the pane by 5 cells (repeatable — hold the key) |
| `prefix` `m` | Zoom the pane to full screen, and back |
| `prefix` `z` | Same as above (tmux default) |
| `prefix` `x` | Kill the pane |
| `prefix` `<` / `>` | Move the current window left / right |
| `prefix` `1`…`9` | Jump to window N (windows are 1-indexed) |
| `C-h/j/k/l` | Move between panes — no prefix, and it crosses into Neovim |

### Sessions

| Key | Action |
| --- | --- |
| `prefix` `o` | sessionx: fuzzy session switcher, with zoxide directories included |
| `prefix` `d` | Detach (the session keeps running) |
| `prefix` `s` | Built-in session list |
| `prefix` `$` | Rename the session |
| `tm` (shell) | Pick a project under `~/github` and attach a session named after it |

The status bar sits at the bottom: session name on the left, window list in the
middle, and on the right the current directory, CPU, RAM, battery and the date.

Sessions are saved every 15 minutes and restored automatically after a reboot
(resurrect + continuum). `prefix` `C-s` saves now, `prefix` `C-r` restores.

### Copy mode (vi keys)

| Key | Action |
| --- | --- |
| `prefix` `[` | Enter copy mode |
| `v` | Start selecting |
| `C-v` | Toggle block selection |
| `y` | Copy to the macOS clipboard and exit |
| `/` `?` | Search forward / backward |
| `q` | Leave copy mode |

Mouse drag also selects, and stays in copy mode when you release.

### Config

| Key | Action |
| --- | --- |
| `prefix` `r` | Reload `~/.config/tmux/tmux.conf` |
| `prefix` `I` | Install any tmux plugins added to the config |
| `prefix` `U` | Update installed tmux plugins |

## Neovim

Leader is `Space`. This lists the additions in this repo plus the LazyVim
defaults worth knowing; `<leader>` on its own opens which-key, which shows the
rest.

### From this config

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>ac` | n, v | Toggle Claude Code in a tmux-backed split (sidekick) |
| `<leader>gd` | n | Diffview of the working tree |
| `<leader>gh` | n | File history of the current file |
| `<leader>gH` | n | History of the whole branch |
| `<leader>gq` | n | Close Diffview |
| `C-s` | any | Save |
| `C-n` | n, v | Add another cursor at the next match (visual-multi) |
| `<leader>p` | v | Paste over the selection without clobbering the register |
| `<leader>y` | n, v | Yank to the system clipboard |
| `<leader>d` | n, v | Delete without touching the register |
| `C-d` / `C-u` | n | Half page down/up, cursor recentred |
| `n` / `N` | n | Next/previous match, recentred |
| `J` | n | Join lines, cursor stays put |
| `<` / `>` | v | Indent and keep the selection |

### LazyVim essentials

| Key | Action |
| --- | --- |
| `<leader><space>` | Find file in the project |
| `<leader>/` | Live grep the project |
| `<leader>,` | Switch buffer |
| `<leader>e` | File explorer (neo-tree) |
| `<leader>ff` / `<leader>fr` | Find files / recent files |
| `<leader>gg` | lazygit |
| `<leader>sr` | Search & replace across the project (grug-far) |
| `<leader>cr` | Rename symbol (inc-rename, live preview) |
| `<leader>ca` | Code action |
| `<leader>cf` | Format buffer |
| `<leader>xx` | Diagnostics list (trouble) |
| `<leader>qs` | Restore the session for this directory |
| `gd` `gr` `gI` `gy` | Go to definition / references / implementation / type |
| `K` | Hover documentation |
| `]d` `[d` | Next / previous diagnostic |
| `]h` `[h` | Next / previous git hunk |
| `s` | Flash jump — type two characters, then the label |
| `S` | Flash treesitter select |
| `gcc` / `gc` | Comment line / selection |
| `<leader>bd` | Close buffer |
| `<leader>l` | Lazy plugin manager |
| `<leader>cm` | Mason (LSP/tool installer) |

Git blame for the current line is shown inline; toggle it with
`:Gitsigns toggle_current_line_blame`.

## zsh

### Reading the prompt

Each block appears only when it applies, so a plain directory shows nothing but
the path.

| Block | Colour | Means |
| --- | --- | --- |
| Path | Blue | Current directory, truncated to the repo root |
| Branch | Mauve | Current git branch |
| Dirty state | Peach | Working tree has changes — markers below |
| Rebase/merge | Red | Mid-operation, with `step/total` progress |
| Runtime | Grey | Language version, only inside a project that uses it |
| User / host | Lavender / maroon | Over SSH only |

Markers inside the peach block:

| Marker | Means |
| --- | --- |
| `!n` | n modified |
| `+n` | n staged |
| `?n` | n untracked |
| `✘n` | n deleted |
| `»n` | n renamed |
| `⇡n` / `⇣n` | n commits ahead / behind upstream |
| `⇕⇡n⇣n` | Diverged from upstream |

On the right: how long the last command took (shown past 2s) and the clock.
On the prompt line, `❯` turns red and prints the exit code when a command
fails.

### Functions

| Command | Action |
| --- | --- |
| `tm [dir]` | Fuzzy-pick a project under `~/github`, attach or create its tmux session |
| `f` | Fuzzy-find a file (with a bat preview) and open it in Neovim |
| `fh` | Fuzzy-search history and put the result on the command line |
| `mkcd <dir>` | Create a directory and cd into it |
| `gclone <url>` | Clone into `~/github/<repo>` and cd there |
| `extract <file>` | Unpack any archive format |
| `zshtime` | Average shell startup over 10 runs |

### Keys

| Key | Action |
| --- | --- |
| `C-r` | Atuin: fuzzy search all history, across sessions and machines |
| `C-t` | fzf: insert a file path (bat preview) |
| `M-c` | fzf: cd into a subdirectory (tree preview) |
| `C-space` | Accept the greyed-out autosuggestion |
| `↑` / `↓`, `C-p` / `C-n` | History search using what you have typed as a prefix |
| `Tab` | fzf-tab completion menu, with previews for files, dirs and git |
| `S-Tab` | Cycle completions backwards |
| `C-x C-e` | Open the current command line in Neovim |
| `C-a` / `C-e` | Start / end of line |
| `C-←` / `C-→` | Move by word |
| `C-u` | Delete to the start of the line |

### Aliases worth remembering

| Alias | Runs |
| --- | --- |
| `ls` `l` `ll` `lt` | eza, increasingly detailed; `lt` is a 2-level tree |
| `cat` | bat |
| `v` | nvim |
| `lg` | lazygit |
| `gs` `gd` `gl` `gp` | git status / diff / log graph / push |
| `dot` | cd to the dotfiles repo |
| `ghd` | cd to `~/github` |
| `ta` `tls` `tn` `tk` | tmux attach / list / new / kill session |
| `reload` | Restart the shell |
| `brewup` | update + upgrade + cleanup |

## WezTerm

Deliberately sparse — tmux owns panes, tabs and sessions.

| Key | Action |
| --- | --- |
| `Cmd-Enter` | Toggle full screen |
| `Cmd-k` | Clear scrollback and viewport |
| `Cmd-f` | Search the scrollback |
| `Cmd-+` / `Cmd--` | Font size |
| `Cmd-0` | Reset font size |

### macOS line editing

The terminal has no concept of `Cmd`, so WezTerm translates these into the
control codes zsh already understands.

| Key | Sends | Effect at the prompt |
| --- | --- | --- |
| `Cmd-Backspace` | `C-u` | Delete the whole line |
| `Opt-Backspace` | `C-w` | Delete the previous word |
| `Cmd-←` / `Cmd-→` | `C-a` / `C-e` | Start / end of line |
| `Opt-←` / `Opt-→` | `M-b` / `M-f` | Move one word |

These reach any program in the terminal, so `Cmd-Backspace` in Neovim's insert
mode also deletes to the start of the line (in normal mode `C-u` is still half a
page up).
