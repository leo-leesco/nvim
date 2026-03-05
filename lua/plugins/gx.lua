return {
	"chrishrb/gx.nvim",
	keys = { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } },
	cmd = { "Browse" },
	init = function()
		vim.g.netrw_nogx = 1 -- disable netrw gx
	end,

	opts = {
		select_prompt = false, -- shows a prompt when multiple handlers match; disable to auto-select the top one

		handlers = {
			-- built-in handlers
			plugin = true,         -- open plugin links in lua (e.g. packer, lazy, ..)
			github = true,         -- open github issues
			package_json = true,   -- open dependencies from package.json

			rust = {               -- custom handler
				name = "rust",
				filename = "Cargo.toml", -- you can also set the required filetype for this handler via `filetype`
				handle = function(mode, line, _)
					local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")

					if crate then
						return "https://crates.io/crates/" .. crate
					end
				end,
			},

			brewfile = false,
			search = false, -- no online search
			go = false,
		},
	}
}
