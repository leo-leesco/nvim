return {
	"folke/trouble.nvim",
	event = "LspAttach",
	opts = {
		modes = {
			diagnostics = {
				auto_close = true,
				auto_open = true,
			}
		}
	},
}
