return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" }, -- Lua formatter
      python = { "black", "isort" }, -- Python formatters
      javascript = { "prettier" }, -- JS formatter
      sh = { "shfmt" },
      -- Add more formatters by language here
    },
  },
}
