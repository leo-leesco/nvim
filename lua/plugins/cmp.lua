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

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				trigger = { prefetch_on_insert = false },
			},

			sources = {
				default = { "lazydev", "lsp", "path", "buffer", "snippets" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					snippets = {
						name = "Snippets",
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
