return {
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "",
							package_pending = "",
							package_uninstalled = "",
						},
					},
				},
			},
		},
		opts = {
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"gopls",
				"cssls",
				"html",
				"tailwindcss",
				"ruff",
				"eslint",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- keymaps
			local wk = require("which-key")
			wk.add({
				{ "<leader>l", group = "LSP", icon = " " },
			})
			vim.keymap.set("n", "<leader>lk", vim.lsp.buf.hover, { desc = "Show Documentation" })
			vim.keymap.set({ "n", "v" }, "<leader>lc", vim.lsp.buf.code_action, { desc = "Open [C]ode Action" })
			vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "[R]ename" })
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
	{ "folke/lazydev.nvim", opts = {} },
}
