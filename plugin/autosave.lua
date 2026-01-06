-- Create an augroup to prevent duplicate autocommands if the file is re-sourced
local format_sync_grp = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = format_sync_grp,
  pattern = "*",
  callback = function()
  if not vim.bo.modifiable or vim.bo.readonly then return end
  
  -- Try LSP formatting first
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  if #clients > 0 then
    vim.lsp.buf.format({ async = false })
  elseif vim.bo.formatprg ~= "" then
    vim.cmd("normal! gggqG")
  end
end
})

vim.opt_local.formatoptions = "jcqrn"
