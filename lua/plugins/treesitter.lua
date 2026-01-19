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

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",

	build = {
		function()
			require "ensure_installed" ("tree-sitter-cli", "bun install -g tree-sitter-cli")
		end,
		function()
			require 'nvim-treesitter'.install(languages)
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
}
