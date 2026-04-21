vim.lsp.config.python.capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.start(vim.lsp.config.python)
