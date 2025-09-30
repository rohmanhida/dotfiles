return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvimtools/none-ls-extras.nvim" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      debug = true,
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
          extra_args = { "--single-quote", "true", "--tab-width", "2" }
        }),
        require("none-ls.diagnostics.eslint_d"),

        -- golang (gofumpt, golangci-lint)
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.diagnostics.golangci_lint.with({
          command = "golangci-lint",
          args = { "run", "--out-format", "json", "--path-prefix", vim.fn.getcwd() }
        }),

        -- python
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
      },
    })

    vim.keymap.set("n", "<leader>=", vim.lsp.buf.format, { desc = "Format" })
  end,
}
