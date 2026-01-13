vim.lsp.enable("lua")
vim.lsp.start(vim.lsp.config.lua)

-- configure fallback formatter
-- The "-" tells stylua to read from stdin
vim.bo.formatprg = "stylua --search-parent-directories --stdin-filepath " .. vim.api.nvim_buf_get_name(0) .. " -"
