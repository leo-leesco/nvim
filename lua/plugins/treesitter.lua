local languages = {
	-- logic

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
			local executable = "tree-sitter-cli"
			require "ensure_installed" (executable, { "bun install -g", executable })
		end,
		function()
			require 'nvim-treesitter'.install(languages, { summary = true }):wait(5000)
		end,
		":TSUpdate",
	},

	opts = {
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
	},

	config = function(opts)
		require("nvim-treesitter").setup(opts)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = languages,
			callback = function(args)
				vim.treesitter.start()

				vim.wo.foldmethod = 'expr'
				vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
				vim.cmd('normal! zR')
				vim.wo.foldlevel = math.max(99, vim.wo.foldlevel)

				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end
}
