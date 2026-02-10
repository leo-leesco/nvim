vim.lsp.config.haskell.capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.start(vim.lsp.config.haskell)

vim.o.makeprg = "stack install"
vim.o.errorformat = ""
