return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true, -- toggle with :Gitsigns toggle_current_line_blame
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 300,
      },
      current_line_blame_formatter = "  <author>, <author_time:%R> · <summary>",
      max_file_length = 40000,
    },
  },

  -- Full-window diffs and file history, for the reviews lazygit is awkward at.
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview (working tree)" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    },
    opts = { enhanced_diff_hl = true },
  },
}
