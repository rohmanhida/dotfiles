return {
  'nvim-treesitter/nvim-treesitter', build = ':TSUpdate',
  config = function()
    local config = require('nvim-treesitter.configs')
    config.setup({
      ensure_installed = { "lua", "go", "python", "javascript", "typescript", "tsx", "html", "css", "json" },
      sync_install = false,
      ignore_install = {},
      modules = {},
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true }
    })
  end
}
