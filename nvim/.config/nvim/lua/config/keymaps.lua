-- Loaded on VeryLazy, on top of LazyVim's defaults:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- Save from any mode.
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Keep the cursor centred while jumping around.
map("n", "<C-d>", "<C-d>zz", { desc = "Half Page Down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half Page Up" })
map("n", "n", "nzzzv", { desc = "Next Search Result" })
map("n", "N", "Nzzzv", { desc = "Prev Search Result" })

-- Join lines without moving the cursor to the join point.
map("n", "J", "mzJ`z", { desc = "Join Lines" })

-- Paste over a selection without clobbering the unnamed register.
map("x", "<leader>p", [["_dP]], { desc = "Paste (keep register)" })

-- Yank to / delete into the system clipboard explicitly.
map({ "n", "x" }, "<leader>y", [["+y]], { desc = "Yank to Clipboard" })
map({ "n", "x" }, "<leader>d", [["_d]], { desc = "Delete (no register)" })

-- Keep the selection after indenting.
map("x", "<", "<gv", { desc = "Indent Left" })
map("x", ">", ">gv", { desc = "Indent Right" })
