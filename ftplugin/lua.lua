-- The "-" tells stylua to read from stdin
vim.bo.formatprg = "stylua --search-parent-directories --stdin-filepath " .. vim.api.nvim_buf_get_name(0) .. " -"
