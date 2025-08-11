return {
	"lervag/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	build = function()
		-- inverse search for TeXShop
		os.execute("defaults write TeXShop OtherEditorSync YES")
		os.execute("defaults write TeXShop UseExternalEditor -bool true")
		os.execute("sudo mkdir -p /usr/local/bin/")

		local f = io.open("/usr/local/bin/othereditor", "w")
		f:write([[nvim --headless -c "VimtexInverseSearch $1 '$2'"]])
		f:close()
		os.execute("sudo chmod +x /usr/local/bin/othereditor")
	end,
	init = function()
		-- VimTeX configuration goes here, e.g.
		vim.g.vimtex_view_method = "texshop"
		vim.g.vimtex_view_texshop_activate = 0
	end
}
