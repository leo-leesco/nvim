local function git_commit_and_push()
	vim.fn.jobstart("git diff --quiet lazy-lock.json", {
		on_exit = function(_, return_val)
			if return_val == 1 then
				-- 2. Changes detected! Commit and Push.
				local cmds = {
					"git add lazy-lock.json",
					"git commit -m 'chore(lazy): auto-update plugins'",
					"git push"
				}

				vim.system(cmds, {
					on_exit = function(_, code)
						if code == 0 then
							vim.notify("Plugins updated and pushed to remote!", vim.log.levels.INFO)
						else
							vim.notify("Auto-push failed. Check git output.", vim.log.levels.ERROR)
						end
					end
				})
			else
			end
		end
	})
end

local autoupdate = vim.api.nvim_create_augroup("LazyAutoUpdate", { clear = true })
--
vim.api.nvim_create_autocmd("VimEnter", {
	group = autoupdate,
	callback = function()
		-- Run check() immediately on startup.
		-- wait = false: Don't block the UI
		-- show = false: Don't pop up the Lazy window unless there are errors
		require("lazy").check({ wait = false, show = false })
	end,
})

vim.api.nvim_create_autocmd("User", {
	group = autoupdate,
	pattern = "LazyCheck",
	callback = git_commit_and_push,
})
