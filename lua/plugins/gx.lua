return {
	"chrishrb/gx.nvim",
	keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
	cmd = { "Browse" },
	init = function()
		vim.g.netrw_nogx = 1 -- disable netrw gx
	end,

	opts = {
		select_prompt = false, -- shows a prompt when multiple handlers match; disable to auto-select the top one

		handlers = {
			plugin = true,         -- open plugin links in lua (e.g. packer, lazy, ..)
			github = true,         -- open github issues
			package_json = true,   -- open dependencies from package.json

			rust = {               -- custom handler to open rust's cargo packages
				name = "rust",       -- set name of handler
				filetype = { "toml" }, -- you can also set the required filetype for this handler
				filename = "Cargo.toml", -- or the necessary filename
				handle = function(mode, line, _)
					local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")

					if crate then
						return "https://crates.io/crates/" .. crate
					end
				end,
			},

			brewfile = false, -- open Homebrew formulaes and casks
			search = false, -- search the web/selection on the web if nothing else is found
			go = false,    -- open pkg.go.dev from an import statement (uses treesitter)
		},
	}
}
