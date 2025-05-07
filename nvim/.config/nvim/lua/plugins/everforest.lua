return {
  "sainnhe/everforest",
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.background = 'dark'
    vim.g.everforest_background = "soft"
    vim.g.everforest_better_performance = true
    vim.g.everforest_enable_italic = true
    vim.cmd.colorscheme("everforest")
  end,
}
