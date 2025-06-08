return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- vim mode
		local mode = {
			"mode",
			fmt = function(str)
				-- return ' '
				return " " .. str:sub(1, 1) -- displays only the first character of the mode
				-- return " " .. str
			end,
		}

		require("lualine").setup({
			options = {
				-- theme = require "catppuccin.utils.lualine" "latte",
				theme = "auto",
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "neo-tree" },
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { "filename" },
				lualine_c = {
					"filetype",
					{
						require("noice").api.status.command.get,
						cond = require("noice").api.status.command.has,
						color = { fg = "#fe8019" },
					},
					{
						require("noice").api.status.mode.get,
						cond = require("noice").api.status.mode.has,
						color = { fg = "#fe8019" },
					},
				},
				lualine_x = { "diagnostics" },
				lualine_y = {
					{
						function()
							local clients = vim.lsp.get_clients({ bufnr = 0 })
							if not clients or vim.tbl_isempty(clients) then
								return "  No LSP"
							end
							local names = {}
							for _, client in ipairs(clients) do
								table.insert(names, client.name)
							end
							return "  " .. table.concat(names, ", ")
						end,
					},
				},
				lualine_z = { { "branch", icon = "" } },
			},
		})
		-- require('transparent').clear_prefix('lualine')
	end,
}
