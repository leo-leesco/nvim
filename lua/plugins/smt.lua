return {
	"bohlender/vim-smt2",
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "smt2",
			callback = function()
				vim.bo.lisp = true
				vim.bo.autoindent = true
			end,
		})
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.smt2",
			callback = function()
				local cursor_pos = vim.api.nvim_win_get_cursor(0)
				vim.cmd("normal! gg=G")
				vim.api.nvim_win_set_cursor(0, cursor_pos)
			end,
		})
	end
}
