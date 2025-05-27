return {
	-- Install nvim-cmp as a dependency
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- Required for LSP completions
			"hrsh7th/cmp-path", -- Path completions
			"hrsh7th/cmp-buffer", -- Buffer completions
		},
	},

	-- Minuet-AI (now works since nvim-cmp is available)
	{
		"milanglacier/minuet-ai.nvim",
		opts = {
			virtualtext = {
				auto_trigger_ft = {},
				keymap = {
					accept = "<A-A>",
					accept_line = "<A-a>",
					accept_n_lines = "<A-z>",
					prev = "<A-[>",
					next = "<A-]>",
					dismiss = "<A-e>",
				},
			},
			provider_options = {
				codestral = {
					model = "codestral-latest",
					end_point = "https://codestral.mistral.ai/v1/fim/completions",
					api_key = "CODESTRAL_API_KEY",
					stream = true,
					template = {
						prompt = "See [Prompt Section for default value]",
						suffix = "See [Prompt Section for default value]",
					},
					optional = {
						max_tokens = 256,
						stop = { "\n\n" },
					},
				},
			},
		},
	},
}
