return {
	"aspeddro/pandoc.nvim",
	config = function()
		require("pandoc").setup({
			commands = {
				name = "PandocBuild",
			},
			default = {
				output = "%s_output.pdf",
			},
			mappings = {
				-- normal mode
				n = {
					["<leader>pr"] = function()
						require("pandoc.render").init()
					end,
				},
			},
		})
	end,
}
