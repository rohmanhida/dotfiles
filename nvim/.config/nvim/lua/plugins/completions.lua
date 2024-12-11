return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()
			local kind_icons = {
				Text = '󰉿',
				Method = 'm',
				Function = '󰊕',
				Constructor = '',
				Field = '',
				Variable = '󰆧',
				Class = '󰌗',
				Interface = '',
				Module = '',
				Property = '',
				Unit = '',
				Value = '󰎠',
				Enum = '',
				Keyword = '󰌋',
				Snippet = '',
				Color = '󰏘',
				File = '󰈙',
				Reference = '',
				Folder = '󰉋',
				EnumMember = '',
				Constant = '󰇽',
				Struct = '',
				Event = '',
				Operator = '󰆕',
				TypeParameter = '󰊄',
			}

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
				formatting = {
					fields = { 'kind', 'abbr', 'menu' },
					format = function(entry, vim_item)
						-- Kind icons
						vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
						-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
						vim_item.menu = ({
							nvim_lsp = '[LSP]',
							luasnip = '[Snippet]',
							buffer = '[Buffer]',
							path = '[Path]',
						})[entry.source.name]
						return vim_item
					end,
				}
			})
		end,
	},
}
