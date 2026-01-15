vim.lsp.enable("latex")
vim.lsp.start(vim.lsp.config.latex)

vim.cmd("VimtexCompile")
