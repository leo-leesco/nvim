vim.lsp.enable("haskell")
vim.lsp.start(vim.lsp.config.haskell)

vim.o.makeprg = "stack install"
vim.o.errorformat = ""
