vim.lsp.config.latex.capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.start(vim.lsp.config.latex)

local bufname = vim.api.nvim_buf_get_name(0)
if bufname:match("%.tex$") then
	vim.cmd("VimtexCompile")
end

vim.opt.formatprg = "latexindent"
