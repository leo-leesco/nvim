local function git_commit_and_push()
	vim.fn.jobstart("git diff --quiet lazy-lock.json", {
		cwd = vim.fn.stdpath('config'),
		on_exit = function(_, return_val)
			if return_val == 1 then
				local cmds = {
					{ "git", "add",    "lazy-lock.json" },
					{ "git", "commit", "-m",            "chore(lazy): auto-update plugins" },
					{ "git", "push" }
				}

				local function async_git_calls()
					local co = coroutine.create(function()
						for cmd in vim.iter(cmds) do
							local current_thread = coroutine.running()

							vim.system(cmd, {
									cwd = vim.fn.stdpath('config'),
									text = true
								},
								function(obj)
									vim.schedule(function()
										coroutine.resume(current_thread, obj)
									end)
								end)

							local result = coroutine.yield() -- pauses here

							require("log")(result)
							if result.code ~= 0 then
								vim.notify("Git sequence aborted at: " .. cmd[2], vim.log.levels.ERROR)
								return
							end
						end
					end)

					-- fire the first corountine call
					coroutine.resume(co)
				end

				async_git_calls()
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
		require("lazy").sync({ wait = false, show = false })
	end,
})

vim.api.nvim_create_autocmd("User", {
	group = autoupdate,
	pattern = "LazySync",
	callback = git_commit_and_push,
})
