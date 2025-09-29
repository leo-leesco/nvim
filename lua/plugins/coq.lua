return {
	'whonore/Coqtail',
	config = function()
		vim.g.coqtail_coq_path = "/opt/homebrew/bin/"
		vim.cmd [[ "follow the colorscheme used"
			hi def link CoqtailChecked DiffAdd
			hi def link CoqtailSent    DiffChange
		]]
	end
}
