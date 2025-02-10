-- Define an autocommand group for LaTeX
local latex_group = vim.api.nvim_create_augroup("LatexAutoCompile", { clear = true })

-- Execute pdflatex on save for .tex files
-- Opens a PDF viewer that refreshes on modification
-- TODO : use the bibtex compilation chain only when .bib is detected
vim.api.nvim_create_autocmd("BufWritePost", {
	group = latex_group,
	pattern = "*.tex",
	callback = function()
		vim.cmd("silent !pdflatex -shell-escape -interaction=nonstopmode -output-directory '%:p:h' '%'")
		vim.cmd("silent !bibtex '%:r'")
		vim.cmd("silent !pdflatex -shell-escape -interaction=nonstopmode -output-directory '%:p:h' '%'")
		vim.cmd("silent !pdflatex -shell-escape -interaction=nonstopmode -output-directory '%:p:h' '%'")
		vim.cmd("silent! !open '%:r.pdf'")
		-- vim.cmd("silent! !open -g '%:r.pdf'")
		-- vim.cmd [[ !osascript -e 'tell application "Preview" to open POSIX file "%:p:r.pdf"' -e 'tell application "Preview" to activate' -e 'tell application "System Events" to tell process "Preview" to keystroke "1" using {command down}' -e 'tell application "System Events" to tell process "Preview" to keystroke "9" using {command down}' -e 'tell application "System Events" to tell process "Preview" to key code 31 using {command down}' -e 'tell application "System Events" to tell process "Preview" to key code 124 using {command down}' ]]
		vim.cmd("silent! !open -a wezterm.app")
	end,
})
