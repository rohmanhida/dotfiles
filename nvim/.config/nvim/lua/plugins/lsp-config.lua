return {
  {
  'williamboman/mason.nvim',
  config = function()
    require('mason').setup()
  end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'ts_ls',
          'gopls',
          'golangci_lint_ls',
        },
        automatic_installation = false,
      })
    end
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require('lspconfig')

      -- lua
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
            },
          },
        },
        capabilities = capabilities
      })

      -- typescript
      lspconfig.ts_ls.setup({
        capabilities = capabilities
      })

      -- golang
      lspconfig.gopls.setup({
        capabilities = capabilities,
        settings = {
          gopls = {
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            analyses = {
              unusedparams = true,
              shadow = true,
              nilness = true,
              fieldalignment = true,
            },
          },
        },
      })
      lspconfig.golangci_lint_ls.setup({
        capabilities = capabilities
      })

      -- keymaps
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show Documentation' })
      vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Open [C]ode [A]ction' })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })

    end
  }
}
