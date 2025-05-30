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
			vim.cmd("silent !pdflatex -shell-escape -interaction=nonstopmode -output-directory '%:p:h' '%' &")
			vim.cmd("silent !pdflatex -shell-escape -interaction=nonstopmode -output-directory '%:p:h' '%' &")
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

-- autocommit and push to remote on LazyUpdate
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyUpdate",
	callback = function()
		-- wait for lazy-lock.json to be written to
		vim.defer_fn(function()
			local repo_dir = vim.fn.expand("~/.config/nvim")
			local lockfile = "lazy-lock.json"

			-- Check for changes
			local diff_result = vim.system({
				"git",
				"-C",
				repo_dir,
				"diff",
				"--quiet",
				"--",
				lockfile,
			}):wait()

			if diff_result.code == 0 then
				vim.notify("No changes to lazy-lock.json, skipping commit")
				return
			end

			-- Stage the lockfile
			local add_result = vim.system({
				"git",
				"-C",
				repo_dir,
				"add",
				lockfile,
			}):wait()
			if add_result.code ~= 0 then
				vim.notify("git add failed:\n" .. (add_result.stderr or add_result.stdout), vim.log.levels.WARN)
				return
			end

			-- Commit the file
			local commit_result = vim.system({
				"git",
				"-C",
				repo_dir,
				"commit",
				"-m",
				"Update lazy-lock.json",
				"--",
				lockfile,
			}, { text = true }):wait()

			if commit_result.code == 0 then
				vim.notify("Committed lazy-lock.json")
			else
				vim.notify("git commit failed (exit " .. commit_result.code .. "):", vim.log.levels.WARN)
				vim.notify("stdout:\n" .. (commit_result.stdout or "nil"), vim.log.levels.WARN)
				vim.notify("stderr:\n" .. (commit_result.stderr or "nil"), vim.log.levels.WARN)
				return
			end

			-- Push the commit
			local push_result = vim.system({
				"git",
				"-C",
				repo_dir,
				"push",
			}, { text = true }):wait()

			if push_result.code == 0 then
				vim.notify("Pushed lazy-lock.json update to remote")
			else
				vim.notify("git push failed (exit " .. push_result.code .. "):", vim.log.levels.WARN)
				vim.notify("stdout:\n" .. (push_result.stdout or "nil"), vim.log.levels.WARN)
				vim.notify("stderr:\n" .. (push_result.stderr or "nil"), vim.log.levels.WARN)
			end
		end, 100) -- wait 100ms to make sure lazy-lock.json is written to
	end,
})

local grp = vim.api.nvim_create_augroup("SessionManager", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = grp,
	callback = function()
		if vim.fn.argc() == 0 and vim.fn.filereadable(".vimsession") == 1 then
			vim.cmd("source .vimsession")
		end
	end,
	nested = true,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = grp,
	callback = function()
		if vim.fn.winnr("$") > 1 then
			vim.cmd("mksession! .vimsession")
		end
	end,
})
