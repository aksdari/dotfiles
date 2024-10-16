-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }

-- Use <C-k> to show LSP Signature help
vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, opts)
