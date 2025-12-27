return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvimtools/none-ls-extras.nvim" },
  config = function()
    local null_ls = require("null-ls")
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    null_ls.setup({
      sources = {
        -- lua (stylua)
        null_ls.builtins.formatting.stylua,

        -- javascript (prettier, eslint_d)
        null_ls.builtins.formatting.htmlbeautifier,
        null_ls.builtins.formatting.prettier.with({
          filetypes = {
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "html",
            "vue",
            "json",
            "css",
            "scss",
            "markdown",
          },
          extra_args = { "--single-quote", "true", "--tab-width", "2" },
        }),
        require("none-ls.diagnostics.eslint_d").with({
          command = "eslint_d",
          args = { "--stdin", "--stdin-filename", "$FILENAME", "--format", "json" },
          method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        }),

        -- golang (gofumpt, golangci-lint)
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.diagnostics.golangci_lint.with({
          command = "golangci-lint",
          args = { "run", "--out-format", "json", "--path-prefix", vim.fn.getcwd() },
        }),
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end,
    })
    vim.keymap.set("n", "<leader>=", vim.lsp.buf.format, { desc = "Format" })
  end,
}
