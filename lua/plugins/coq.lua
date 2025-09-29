return {
	'whonore/Coqtail',
	filetype = { "coq", "*.v" },
	config = function()
		vim.g.coqtail_coq_path = "/opt/homebrew/bin/"
		vim.cmd [[ "follow the colorscheme used"
			hi def link CoqtailChecked DiffAdd
			hi def link CoqtailSent    DiffChange
		]]

		vim.api.nvim_create_autocmd(
			"FileType",
			{
				pattern = { "coq", "*.v" },
				callback = function(_)
					vim.fn.execute("RocqStart")
				end,
			}
		)
	end
}
