-- Loaded before lazy.nvim starts. LazyVim's defaults live at
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Only deviations from those defaults belong here.

local opt = vim.opt

opt.scrolloff = 8 -- keep context above/below the cursor
opt.sidescrolloff = 8
opt.cursorline = true
opt.wrap = false
opt.textwidth = 0
opt.colorcolumn = "100"
opt.timeoutlen = 300 -- which-key pops up faster
opt.updatetime = 200
opt.splitkeep = "screen"
opt.confirm = true -- prompt instead of failing on unsaved buffers
opt.undolevels = 10000
opt.ignorecase = true
opt.smartcase = true

-- Show whitespace that usually causes diffs.
opt.list = true
opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣", extends = "»", precedes = "«" }

-- Use ripgrep for :grep.
opt.grepprg = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m"
