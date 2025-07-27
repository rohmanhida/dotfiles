return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"gopls",
					"marksman",
					"cssls",
					"svelte",
					"pyright"
				},
				automatic_installation = false,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- css
			lspconfig.cssls.setup({
				capabilities = capabilities,
				filetypes = { "css, scss, less" },
			})

			-- markdown
			lspconfig.marksman.setup({
				capabilities = capabilities,
				filetypes = { "markdown" },
			})

			-- lua
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = {
								"${3rd}/luv/library",
								unpack(vim.api.nvim_get_runtime_file("", true)),
							},
						},
					},
				},
				capabilities = capabilities,
			})

			-- typescript
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.volar.setup({
				capabilities = capabilities,
			})

			-- golang
			lspconfig.gopls.setup({
				capabilities = capabilities,
				settings = {
					gopls = {
						gofumpt = true,
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

			-- svelte
			lspconfig.svelte.setup({
				capabilities = capabilities,
			})

			-- python
			lspconfig.pyright.setup({
				capabilities = capabilities,
			})

			-- xml
			lspconfig.lemminx.setup({
				capabilities = capabilities,
			})

			lspconfig.qmlls.setup({
				capabilities = capabilities,
			})


			-- keymaps
			local wk = require('which-key')
			wk.add({
				{ '<leader>l', group = "LSP", icon = ' '}
			})
			vim.keymap.set("n", "<leader>lk", vim.lsp.buf.hover, { desc = "Show Documentation" })
			vim.keymap.set({ "n", "v" }, "<leader>lc", vim.lsp.buf.code_action, { desc = "Open [C]ode Action" })
			vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "[R]ename" })
		end,
	},
}
