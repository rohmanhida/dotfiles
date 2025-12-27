return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		version = "1.*",
		opts = {
			keymap = {
				preset = "default",
				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<C-e>"] = false,
			},
			completion = {
				documentation = {
					auto_show = true,
					window = {
						border = "rounded",
					},
				},
				menu = { border = "rounded" },
			},
			sources = {
				default = { "lsp", "snippets", "path", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	},
}
