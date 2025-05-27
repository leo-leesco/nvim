return {
	-- Built-in snippets with nvim-snippets
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
		config = function()
			require("vim.snippets").from_vscode("rafamadriz/friendly-snippets")
			require("vim.snippets").from_vscode(vim.fn.stdpath("config") .. "/snippets")
		end,
	},

	-- blink.cmp as the complete completion engine
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"folke/lazydev.nvim",
		},
		opts = {
			keymap = {
				preset = "super-tab",
				["<A-y>"] = require("minuet").make_blink_map(),
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = { auto_show = false },
				trigger = { prefetch_on_insert = false },
			},

			sources = {
				default = { "lazydev", "lsp", "path", "buffer", "snippets", "minuet" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					snippets = {
						name = "Snippets",
					},
					minuet = {
						name = "minuet",
						module = "minuet.blink",
						async = true,
						-- Should match minuet.config.request_timeout * 1000,
						-- since minuet.config.request_timeout is in seconds
						timeout_ms = 3000,
						score_offset = 50, -- Gives minuet higher priority among suggestions
					},
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		config = function(_, opts)
			require("lazydev").setup()
			require("blink.cmp").setup(opts)
		end,
	},
}
