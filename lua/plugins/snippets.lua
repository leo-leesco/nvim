return {
	-- disable builtin snippet support
	{ "garymjr/nvim-snippets", enabled = false },

	-- add luasnip
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		build = "make install_jsregexp",
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
				end,
			},
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},

	-- nvim-cmp integration
	{
		"hrsh7th/nvim-cmp",
		optional = true,
		dependencies = { "saadparwaiz1/cmp_luasnip" },
		opts = function(_, opts)
			opts.snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			}
			table.insert(opts.sources, { name = "luasnip" })
		end,
		-- stylua: ignore
		keys = {
			{ "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
			{ "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
		},
	},

	-- blink.cmp integration
	{
		"saghen/blink.cmp",
		optional = true,
		opts = {
			snippets = {
				preset = "luasnip",
			},
		},
	},
}
