return {
  -- Multiple cursors: C-n to select the word, n/N to add, q to skip.
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
      }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, {
        "bash",
        "diff",
        "dockerfile",
        "gitcommit",
        "gitignore",
        "go",
        "hcl",
        "make",
        "regex",
        "sql",
        "ssh_config",
        "terraform",
        "tmux",
      })
    end,
  },
}
