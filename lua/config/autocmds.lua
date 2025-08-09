-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`

vim.api.nvim_create_augroup("_vimtex", { clear = true })

vim.api.nvim_create_autocmd("User", {
	pattern = "VimtexEventInitPost",
	group = "_vimtex",
	callback = function()
		vim.cmd("VimtexCompile")
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
				vim.notify("git add failed:\n" .. (add_result.stderr or add_result.stdout),
					vim.log.levels.WARN)
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

local session = vim.api.nvim_create_augroup("SessionManager", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = session,
	callback = function()
		if vim.fn.argc() == 0 and vim.fn.filereadable(".vimsession") == 1 then
			vim.cmd("source .vimsession")
		end
	end,
	nested = true,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = session,
	callback = function()
		if vim.fn.winnr("$") > 1 then
			vim.cmd("mksession! .vimsession")
		end
	end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
	group = session,
	callback = function(args)
		vim.api.nvim_create_autocmd("FileType", {
			buffer = args.buf,
			once = true,
			callback = function()
				local ft = vim.bo[args.buf].filetype
				local excluded = { xxd = true, gitrebase = true, [""] = true }
				if ft:match("commit") or excluded[ft] then
					return
				end

				local last_pos = vim.fn.line([['"]])
				if last_pos >= 1 and last_pos <= vim.fn.line("$") then
					vim.api.nvim_feedkeys('g`"', "n", false)
				end
			end,
		})
	end,
})
