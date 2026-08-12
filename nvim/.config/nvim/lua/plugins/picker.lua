-- This repo (and most config work) lives under dotted directories like
-- .config/, which fd and rg skip by default. Show hidden files everywhere,
-- while still honouring .gitignore and never walking into .git itself.
local hidden = {
  hidden = true,
  ignored = false,
  exclude = { ".git", "node_modules", ".DS_Store" },
}

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = hidden,
          smart = hidden,
          grep = hidden,
          grep_word = hidden,
          grep_buffers = hidden,
          explorer = hidden,
        },
      },
    },
  },
}
