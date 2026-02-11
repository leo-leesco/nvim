local function git_commit_and_push()
	-- 1. check if lazy-lock.json actually changed
	--    'git diff --quiet' returns 1 if there are changes
	local check_changes = "git diff --quiet lazy-lock.json"

	vim.fn.jobstart(check_changes, {
		on_exit = function(_, return_val)
			if return_val == 1 then
				-- 2. Changes detected! Commit and Push.
				local cmds = {
					"git add lazy-lock.json",
					"git commit -m 'chore(lazy): auto-update plugins [skip ci]'",
					"git push"
				}

				-- Run them sequentially
				-- (Using a simple loop for brevity; for production, chain them via callbacks)
				local chain = table.concat(cmds, " && ")

				vim.fn.jobstart(chain, {
					on_exit = function(_, code)
						if code == 0 then
							vim.notify("Plugins updated and pushed to remote!", vim.log.levels.INFO)
						else
							vim.notify("Auto-push failed. Check git output.", vim.log.levels.ERROR)
						end
					end
				})
			else
				-- No changes to lockfile, do nothing.
			end
		end
	})
end

-- === 1. Auto-Update on Startup ===
vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("LazyAutoUpdate", { clear = true }),
	callback = function()
		-- Run check() immediately on startup.
		-- wait = false: Don't block the UI
		-- show = false: Don't pop up the Lazy window unless there are errors
		require("lazy").check({ wait = false, show = false })
	end,
})

-- === 2. Listen for 'LazyCheck' to Push ===
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyCheck",
	callback = git_commit_and_push,
})
