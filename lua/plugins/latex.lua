return {
	"lervag/vimtex",
	lazy = false,
	build = function()
		-- prevent TeXShop from reaching the foreground on save
		os.execute("defaults write TeXShop BringPdfFrontOnAutomaticUpdate NO")

		-- inverse search for TeXShop
		os.execute("defaults write TeXShop OtherEditorSync YES")
		os.execute("defaults write TeXShop UseExternalEditor -bool true")
		os.execute("mkdir -p " .. vim.env.HOME .. "/.local/bin/")

		local othereditor = vim.env.HOME ..
				"/.local/bin/othereditor" -- NB: a symlink to this file should be created at /usr/local/bin/
		local f = io.open(othereditor, "w")
		assert(f, "Failed to open temp file for writing")
		f:write([[nvim --headless -c "VimtexInverseSearch $1 '$2'"]])
		f:close()

		os.execute("chmod +x " .. othereditor)
	end,
	init = function()
		vim.g.vimtex_view_method = "texshop"
		vim.g.vimtex_view_texshop_activate = 0

		vim.api.nvim_create_autocmd({ "BufDelete", "VimLeave" }, {
			pattern = "*.tex",
			callback = function()
				vim.fn.jobstart({ "osascript", "-e", 'quit app "TeXShop"' })
			end,
		})

		-- abbreviations
		vim.g.vimtex_imaps_leader = "@"


		vim.g.vimtex_quickfix_ignore_filters = {
			'Underfull',
			'Overfull',
		}

		vim.wo.conceallevel = 2
		vim.g.vimtex_syntax_conceal = {
			accents = 0,
			ligatures = 1,
			cites = 1,
			fancy = 1,
			texTabularChar = 1,
			spacing = 1,
			greek = 1,
			math_bounds = 0,
			math_delimiters = 0,
			math_fracs = 1,
			math_super_sub = 1,
			math_symbols = 0,
			sections = 1,
			styles = 1,
		}
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				vim.api.nvim_set_hl(0, "Conceal", { link = "Statement", force = true })
			end,
		})
		vim.g.vimtex_syntax_conceal_cites = {
			type = 'brackets',
			icon = '📖',
			verbose = true,
		}
	end,
}
