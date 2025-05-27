return {
	{
		"milanglacier/minuet-ai.nvim",
		dependencies = {
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp", -- Required for LSP completions
				"hrsh7th/cmp-path", -- Path completions
				"hrsh7th/cmp-buffer", -- Buffer completions
			},
		},

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

			provider = "codestral",
			provider_options = {
				codestral = {
					model = "codestral-latest",
					end_point = "https://codestral.mistral.ai/v1/fim/completions",
					api_key = "CODESTRAL_API_KEY",
					stream = true,
					optional = {
						max_tokens = 256,
						stop = { "\n\n" },
					},
				},

				openai = {
					model = "gpt-4.1-mini",
					stream = true,
					api_key = "OPENAI_API_KEY",
					optional = {
						-- pass any additional parameters you want to send to OpenAI request,
						-- e.g.
						-- stop = { 'end' },
						-- max_tokens = 256,
						-- top_p = 0.9,
					},
				},
			},
		},
	},
}
