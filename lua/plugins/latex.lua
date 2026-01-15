return {
	"leo-leesco/vimtex",
	lazy = false,
	build = function()
		-- prevent TeXShop from reaching the foreground on save
		os.execute("defaults write TeXShop BringPdfFrontOnAutomaticUpdate NO")

		-- inverse search for TeXShop
		os.execute("defaults write TeXShop OtherEditorSync YES")
		os.execute("defaults write TeXShop UseExternalEditor -bool true")
		os.execute("mkdir -p " .. vim.env.HOME .. "/.local/bin/")

		local othereditor = vim.env.HOME .. "/.local/bin/othereditor"
		local f = io.open(othereditor, "w")
		assert(f, "Failed to open temp file for writing")
		f:write([[nvim --headless -c "VimtexInverseSearch $1 '$2'"]])
		f:close()

		os.execute("chmod +x" .. othereditor)
	end,
	init = function()
		vim.g.vimtex_view_method = "texshop"
		vim.g.vimtex_view_texshop_activate = 0

		-- abbreviations
		vim.g.vimtex_imaps_leader = "@"


		vim.g.vimtex_quickfix_ignore_filters = {
			'Underfull',
			'Overfull',
		}
	end,
}
