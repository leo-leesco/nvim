-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`

local latex = vim.api.nvim_create_augroup("Latex", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
	group = latex,
	pattern = "*.tex",
	callback = function()
		vim.cmd("silent !pdflatex -shell-escape -interaction=nonstopmode -output-directory '%:p:h' '%'")

		-- check for bibtex files
		if vim.fn.glob(vim.fn.getcwd() .. "/*.bib") then
			vim.print(".bib found")
			vim.cmd("silent !bibtex '%:r' &")
			vim.cmd(
				"silent !pdflatex -shell-escape -interaction=nonstopmode -output-directory '%:p:h' '%' &")
			vim.cmd(
				"silent !pdflatex -shell-escape -interaction=nonstopmode -output-directory '%:p:h' '%' &")
		end

		-- toggle Preview to make sure the PDF is re-rendered
		vim.cmd("silent! !open '%:r.pdf'")
		-- vim.cmd("silent! !open -g '%:r.pdf'")
		-- vim.cmd [[ !osascript -e 'tell application "Preview" to open POSIX file "%:p:r.pdf"' -e 'tell application "Preview" to activate' -e 'tell application "System Events" to tell process "Preview" to keystroke "1" using {command down}' -e 'tell application "System Events" to tell process "Preview" to keystroke "9" using {command down}' -e 'tell application "System Events" to tell process "Preview" to key code 31 using {command down}' -e 'tell application "System Events" to tell process "Preview" to key code 124 using {command down}' ]]
		vim.cmd("silent! !open -a wezterm.app")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "txt" },
	callback = function()
		vim.opt_local.spell = false
	end,
})

-- Automatically commit lockfile after running Lazy Update (or Sync)
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyUpdate",
	callback = function()
		local repo_dir = "~/.config/nvim/"
		local lockfile = repo_dir .. "lazy-lock.json"

		local cmd = {
			"git",
			"-C",
			repo_dir,
			"commit",
			lockfile,
			"-m",
			"Update lazy-lock.json",
		}

		local success, process = pcall(function()
			return vim.system(cmd):wait()
		end)

		if process and process.code == 0 then
			vim.notify("Committed lazy-lock.json")
			vim.notify(process.stdout)
		else
			if not success then
				vim.notify("Failed to run command '" .. table.concat(cmd, " ") .. "':",
					vim.log.levels.WARN, {})
				vim.notify(tostring(process), vim.log.levels.WARN, {})
			else
				vim.notify("git ran but failed to commit:")
				vim.notify(process.stdout, vim.log.levels.WARN, {})
			end
		end
	end,
})

-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	group = vim.api.nvim_create_augroup("lsp", { clear = true }),
-- 	callback = function(args)
-- 		vim.api.nvim_create_autocmd("BufWritePre", {
-- 			buffer = args.buf,
-- 			callback = function(args)
-- 				local conform = require("conform")
-- 				if #conform.list_formatters(args.buf) > 0 then
-- 					conform.format({ bufnr = args.buf })
-- 				else
-- 					vim.lsp.buf.format({ async = false, id = args.data.client_id })
-- 				end
-- 			end,
-- 		})
-- 	end,
-- })
