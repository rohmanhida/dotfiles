return {
 "gbprod/nord.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require('nord').setup({
      borders = false,
    })
    vim.cmd.colorscheme 'nord'
  end
}
