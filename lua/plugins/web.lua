return {
	{
		"olrtg/nvim-emmet",
		ft = { "html", "css", "javascript", "typescript", "astro" },
		config = function()
			vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
		end,
	},
	{
		"brianhuster/live-preview.nvim",
		ft = { "html", "css", "javascript", "typescript", "astro" },
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
}
