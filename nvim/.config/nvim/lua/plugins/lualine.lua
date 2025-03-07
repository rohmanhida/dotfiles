return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- vim mode
		local mode = {
			"mode",
			fmt = function(str)
				-- return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
				return " " .. str
			end,
		}

		require("lualine").setup({
			options = {
				-- theme = require "catppuccin.utils.lualine" "latte",
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "neo-tree", "Avante" },
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { "location" },
				lualine_c = { "filename", "diagnostics" },
				lualine_x = {},
				lualine_y = { "filetype" },
				lualine_z = { { "branch", icon = "" } },
			},
		})
	end,
}
