return {
	"olrtg/nvim-emmet",
	build = function()
		vim.cmd("LspInstall emmet_language_server")
	end,
	config = function()
		vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
	end,
}
