return {
	{
		-- detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},
	{
		-- hints keybinds
		"folke/which-key.nvim",
		opts = {
			 win = {
			   border = {
			     { '┌', 'FloatBorder' },
			     { '─', 'FloatBorder' },
			     { '┐', 'FloatBorder' },
			     { '│', 'FloatBorder' },
			     { '┘', 'FloatBorder' },
			     { '─', 'FloatBorder' },
			     { '└', 'FloatBorder' },
			     { '│', 'FloatBorder' },
			   },
			 },
		},
	},
	{
		-- autoclose parentheses, brackets, quotes, etc.
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {},
	},
	{
		-- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		-- high-performance color highlighter
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				DEFAULT_OPTIONS = {
					hsl_fn = true,
					RGB_fn = true,
					RRGGBBAA = true,
					RRGGBB = true,
					rgb_fn = true,
					css = true,
					css_fn = true,
				},
			})
		end,
	},
}
