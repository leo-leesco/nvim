vim.lsp.config.typescript.capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.start(vim.lsp.config.typescript)
