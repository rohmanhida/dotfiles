return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- vim mode
		local mode = {
			"mode",
			fmt = function(str)
				-- return ' '
				return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
				-- return " " .. str
			end,
		}

		require("lualine").setup({
			options = {
				-- theme = require "catppuccin.utils.lualine" "latte",
				theme = "gruvbox",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "neo-tree" },
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { "filename" },
				lualine_c = { "filetype" },
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
	end,
}
