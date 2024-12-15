return {
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf", build = "./install --all" }, -- This will install fzf as well
    config = function()
      -- Optional fzf configuration here
      -- For example, setting up fzf default options
      -- vim.g.fzf_layout = { down = '40%' }
    end,
  },
}
