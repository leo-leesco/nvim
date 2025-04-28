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
		-- optional: provides snippets for the snippet source
		dependencies = { "rafamadriz/friendly-snippets" },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "default" },

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = false } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
