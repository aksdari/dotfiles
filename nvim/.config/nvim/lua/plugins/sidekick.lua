-- AI CLI integration only: no inline completion, no next-edit suggestions.
-- Sessions are created inside tmux so they survive closing Neovim, and
-- reattach to the same Claude Code conversation when you come back.
return {
  {
    "folke/sidekick.nvim",
    opts = {
      nes = { enabled = false },
      cli = {
        watch = true, -- reload buffers the CLI edits underneath us
        mux = {
          backend = "tmux",
          enabled = true,
          create = "terminal",
        },
        win = {
          layout = "right",
          split = { width = 90 },
        },
      },
    },
    keys = {
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        mode = { "n", "x" },
        desc = "Claude Code",
      },
    },
  },
}
