return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "auto",
        dark_variant = "moon",
        dim_inactive_windows = true,
        extend_bacground_behind_borders = true,
        styles = {
          bold = true,
          italic = true,
          transparency = false,
        },
      })
    end,
  },
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "soft"
      vim.g.everforest_better_performance = true
      vim.g.everforest_enable_italic = true

      vim.o.background = "dark"
      vim.cmd.colorscheme("everforest")
    end,
  },
}
