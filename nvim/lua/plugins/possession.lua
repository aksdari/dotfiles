return {
  "gennaro-tedesco/nvim-possession",
  dependencies = {
    "ibhagwan/fzf-lua",
  },
  config = true,
  init = function()
    local possession = require("nvim-possession")
    vim.keymap.set("n", "<C-S-p>l", function()
      possession.list()
    end)
    vim.keymap.set("n", "<C-S-p>n", function()
      possession.new()
    end)
    vim.keymap.set("n", "<C-S-p>u", function()
      possession.update()
    end)
    vim.keymap.set("n", "<C-S-p>d", function()
      possession.delete()
    end)
  end,
}
