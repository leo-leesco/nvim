return {
	"kdheepak/lazygit.nvim",
	lazy = false,
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = {
		"nvim-telescope/telescope.nvim",

		-- optional for floating window border decoration
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
	},
	config = function()
		require("telescope").load_extension("lazygit")
	end,
}
