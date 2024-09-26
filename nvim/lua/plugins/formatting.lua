return {
  "stevearc/conform.nvim",
  opts = {
    -- format_on_save = {
    --   -- These options will be passed to conform.format()
    --   timeout_ms = 500,
    --   lsp_format = "fallback",
    -- },
    formatters_by_ft = {
      lua = { "stylua" }, -- Lua formatter
      python = { "black", "isort" }, -- Python formatters
      javascript = { "prettier" }, -- JS formatter
      sh = { "shfmt" },
      -- Add more formatters by language here
    },
  },
}
