vim.lsp.enable("latex")
vim.lsp.start(vim.lsp.config.latex)

local bufname = vim.api.nvim_buf_get_name(0)
if bufname:match("%.tex$") then
	vim.cmd("VimtexCompile")
end

vim.opt.formatprg = "latexindent"
