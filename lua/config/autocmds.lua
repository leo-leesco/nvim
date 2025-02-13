-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local latex = vim.api.nvim_create_augroup("Latex", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = latex,
  pattern = "*.tex",
  callback = function()
    vim.cmd("silent !pdflatex -shell-escape -interaction=nonstopmode -output-directory '%:p:h' '%'")

    -- check for bibtex
    if vim.fn.glob(vim.fn.getcwd() .. "/*.bib") then
      vim.print(".bib found")
      vim.cmd("silent !bibtex '%:r'")
      vim.cmd("silent !pdflatex -shell-escape -interaction=nonstopmode -output-directory '%:p:h' '%'")
      vim.cmd("silent !pdflatex -shell-escape -interaction=nonstopmode -output-directory '%:p:h' '%'")
    end

    -- toggle Preview to make sure the PDF is re-rendered
    vim.cmd("silent! !open '%:r.pdf'")
    -- vim.cmd("silent! !open -g '%:r.pdf'")
    -- vim.cmd [[ !osascript -e 'tell application "Preview" to open POSIX file "%:p:r.pdf"' -e 'tell application "Preview" to activate' -e 'tell application "System Events" to tell process "Preview" to keystroke "1" using {command down}' -e 'tell application "System Events" to tell process "Preview" to keystroke "9" using {command down}' -e 'tell application "System Events" to tell process "Preview" to key code 31 using {command down}' -e 'tell application "System Events" to tell process "Preview" to key code 124 using {command down}' ]]
    vim.cmd("silent! !open -a wezterm.app")
  end,
})
