return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.ai').setup({})
    require('mini.surround').setup({})
    require('mini.files').setup({})
    vim.keymap.set('n', '<leader>fm', function() require('mini.files').open() end, { desc = '[F]ile [M]anager' })
  end
}
