return {
	"leo-leesco/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	build = function()
		-- prevent TeXShop from reaching the foreground on save
		os.execute("defaults write TeXShop BringPdfFrontOnAutomaticUpdate NO")

		-- inverse search for TeXShop
		os.execute("defaults write TeXShop OtherEditorSync YES")
		os.execute("defaults write TeXShop UseExternalEditor -bool true")
		os.execute("sudo mkdir -p /usr/local/bin/")

		local tmp_path = "/tmp/othereditor"
		local f = io.open(tmp_path, "w")
		assert(f, "Failed to open temp file for writing")
		f:write([[nvim --headless -c "VimtexInverseSearch $1 '$2'"]])
		f:close()

		local othereditor = " /usr/local/bin/othereditor"
		os.execute("sudo mv " .. tmp_path .. othereditor)
		os.execute("sudo chmod +x" .. othereditor)
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
