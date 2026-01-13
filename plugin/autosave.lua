local format_sync_grp = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = format_sync_grp,
  pattern = "*",
  callback = function(args)
    if not vim.bo[args.buf].modifiable or vim.bo[args.buf].readonly then
      return
    end

    -- 1. Try to find an LSP client that supports formatting
    local clients = vim.lsp.get_clients({ bufnr = args.buf })
    local lsp_formatted = false

    for _, client in ipairs(clients) do
      -- Logic from your snippet: check capability and avoid "willSave" overlap
      if client:supports_method("textDocument/formatting") 
         and not client:supports_method("textDocument/willSaveWaitUntil") then
        
        vim.lsp.buf.format({ 
          bufnr = args.buf, 
          id = client.id, 
          async = false, -- Must be sync for BufWritePre
          timeout_ms = 1000 
        })
        lsp_formatted = true
        break -- Exit after first successful format to avoid conflicts
      end
    end

    -- 2. Fallback to ftplugin/formatprg if no LSP handled it
    if not lsp_formatted and vim.bo[args.buf].formatprg ~= "" then
      -- Save cursor position
      local view = vim.fn.winsaveview()
      -- Run the formatprg (gggqG)
      vim.cmd("normal! gggqG")
      -- Restore cursor position
      vim.fn.winrestview(view)
    end
  end,
})

-- Default format options
vim.opt.formatoptions = "jcqrn"
