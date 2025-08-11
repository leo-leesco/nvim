return {
	"leo-leesco/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	build = function()
		os.execute("defaults write TeXShop OtherEditorSync YES")
		os.execute("defaults write TeXShop UseExternalEditor -bool true")
		os.execute("defaults write TeXShop BringPdfFrontOnAutomaticUpdate NO")
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
		-- VimTeX configuration goes here, e.g.
		vim.g.vimtex_view_method = "texshop"
		vim.g.vimtex_view_texshop_activate = 0
	end
}
