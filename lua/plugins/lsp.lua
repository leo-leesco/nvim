return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- Library paths can be absolute
				"~/.config/nvim/",
				-- Or relative, which means they will be resolved from the plugin dir.
				"lazy.nvim",
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
			-- always enable unless `vim.g.lazydev_enabled = false`
			-- This is the default
			enabled = function(root_dir)
				return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
			end,
		},
	},
}
