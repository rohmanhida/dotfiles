return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvimtools/none-ls-extras.nvim" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- lua (stylua)
        null_ls.builtins.formatting.stylua,

        -- markdown
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.diagnostics.markdownlint,

        -- javascript (prettier, eslint_d)
        null_ls.builtins.formatting.djhtml.with({
          extra_args = function(params)
            return {
              "--tabwidth",
              vim.o.shiftwidth
            }
          end,
        }),
        null_ls.builtins.formatting.prettier.with({
          filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "json", "css", "scss", "markdown" },
          extra_args = { "--single-quote", "true", "--tab-width", "2" }
        }),
        require('none-ls.diagnostics.eslint_d').with({
          command = "eslint_d",
          args = { "--stdin", "--stdin-filename", "$FILENAME", "--format", "json" },
          method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        }),

        -- golang (gofumpt, golangci-lint)
        null_ls.builtins.formatting.gofumpt.with({
          args
        }),
        null_ls.builtins.diagnostics.golangci_lint.with({
          command = "golangci-lint",
          args = { "run", "--out-format", "json", "--path-prefix", vim.fn.getcwd() }
        }),
      },
    })
    vim.keymap.set("n", "<leader>=", vim.lsp.buf.format, { desc = "Format" })
  end,
}
