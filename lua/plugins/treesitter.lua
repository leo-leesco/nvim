languages = {
	-- logic
	"agda",

	-- general purpose
	"python",
	"ocaml",
	"ocamllex",

	-- `nvim` config
	"lua",
	"luadoc",
	"vim",
	"vimdoc",

	-- web dev
	"astro",
	"html",
	"css",
	"javascript",
	"typescript",

	-- markup
	"markdown",
	"latex",
	"typst",

	-- config
	"yaml",
	"json",

	-- shell
	"fish",
}

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",

	build = {
		function()
			vim.system({ "bun", "install", "-g", "tree-sitter-cli" }, { text = true }, function(obj)
				vim.schedule(function()
					if obj.code == 0 then
						vim.notify("Output: " .. obj.stdout, vim.log.levels.INFO)
					else
						vim.notify("Error: " .. obj.stderr, vim.log.levels.ERROR)
					end
				end)
			end)
		end,
		":TSUpdate",
	},

	-- main = "nvim-treesitter.configs", -- Sets main module to use for opts
	opts = {
		ensure_installed = languages,
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
	},
}
