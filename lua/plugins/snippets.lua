return {
	{
		"garymjr/nvim-snippets",
		keys = {
			{
				"<Tab>",
				function()
					if vim.snippet.active({ direction = 1 }) then
						vim.schedule(function()
							vim.snippet.jump(1)
						end)
						return
					end
					return "<Tab>"
				end,
				expr = true,
				silent = true,
				mode = "i",
			},
			{
				"<Tab>",
				function()
					vim.schedule(function()
						vim.snippet.jump(1)
					end)
				end,
				expr = true,
				silent = true,
				mode = "s",
			},
			{
				"<S-Tab>",
				function()
					if vim.snippet.active({ direction = -1 }) then
						vim.schedule(function()
							vim.snippet.jump(-1)
						end)
						return
					end
					return "<S-Tab>"
				end,
				expr = true,
				silent = true,
				mode = { "i", "s" },
			},
		},
	},

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
					require("luasnip.loaders.from_vscode").lazy_load({
						paths = { vim.fn.stdpath("config") .. "/snippets" },
					})
				end,
			},
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},

	-- add mini.snippets
	{ "echasnovski/mini.snippets", version = false, lazy = true, dependencies = { "echasnovski/mini.completion" } },

	-- nvim-cmp integration
	{
		"hrsh7th/nvim-cmp",
		optional = true,
		dependencies = { "saadparwaiz1/cmp_luasnip", "abeldekat/cmp-mini-snippets" },
		opts = function(_, opts)
			opts.snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
					local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
					insert({ body = args.body }) -- Insert at cursor
					cmp.resubscribe({ "TextChangedI", "TextChangedP" })
					require("cmp.config").set_onetime({ sources = {} })
				end,
			}
			table.insert(opts.sources, { name = "luasnip" })
			table.insert(opts.sources, { name = "nvim_lsp" })
			table.insert(opts.sources, { name = "nvim_lua" })
			table.insert(opts.sources, { name = "buffer" })
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
		build = "cargo +nightly build --release",
		optional = true,
		opts = {
			snippets = {
				preset = "luasnip",
			},
		},
	},
}
