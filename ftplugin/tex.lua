-- wait for VimTex to be fully loaded before trying to compile
if vim.api.nvim_buf_get_name(0):match("%.tex$") then
	vim.api.nvim_create_autocmd("User", {
		pattern = "VimtexEventInitPost",
		callback = function(ev)
			if ev.buf ~= vim.api.nvim_get_current_buf() then return end
			vim.cmd("VimtexCompile")
			return true -- delete the autocmd once it has run for our buffer
		end,
	})
end

vim.opt.formatprg = "latexindent"
