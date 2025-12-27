return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {},
  config = function ()
    require('typescript-tools').setup({
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = 'change',
        expose_as_code_action = {},
      }
    })
  end
}
