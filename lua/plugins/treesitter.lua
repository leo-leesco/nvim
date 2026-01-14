languages = {
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

		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

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
