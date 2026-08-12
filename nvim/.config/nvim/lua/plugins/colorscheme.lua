return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      background = { dark = "mocha" },
      transparent_background = false, -- wezterm already dims the window
      term_colors = true,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      integrations = {
        blink_cmp = true,
        fzf = true,
        gitsigns = true,
        grug_far = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        native_lsp = { enabled = true, underlines = { errors = { "undercurl" } } },
        neotree = true,
        noice = true,
        notify = true,
        snacks = true,
        treesitter = true,
        which_key = true,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
