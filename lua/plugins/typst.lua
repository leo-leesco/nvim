return {
	'chomosuke/typst-preview.nvim',
	ft = "typst",
	version = '1.*',
	build = { function()
		local executable = "typst"
		require("ensure_installed")(executable, { "brew install", executable })
	end },
	opts = {
		open_cmd = "open -g %s",
	}
}
