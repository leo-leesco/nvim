vim.g.pandoc_compiler_args = '--latex_macros'
vim.cmd.compiler("pandoc") -- WARNING : the standard behaviour of `compiler-pandoc` has been edited : the output format is `pdf` ; passing options to `:make` does not make any difference
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	pattern = "make",
	callback = function()
		if vim.v.shell_error ~= 0 then return end

		local output_file = vim.fn.expand("%:r") .. ".pdf"
		vim.ui.open(output_file)
	end,
})
