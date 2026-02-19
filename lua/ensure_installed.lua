if not vim.g.ensure_installed then
	vim.g.ensure_installed = {}
end

--- this function produces a global `vim.g.ensure_installed` table ; it is used to make sure that in a given session, this function is never called more than once (for instance the user has refused the prompt)
--- @param executable string
--- @param install_command string[]
return function(executable, install_command)
	if vim.g.ensure_installed[executable] then
		return
	else
		vim.g.ensure_installed[executable] = true
	end

	if
			vim.fn.executable(executable) ~= 1
			and vim.fn.confirm("Install " .. executable .. " ?", "&Yes\n&No") == 1
	then
		vim.system(

			{ "sh", "-c", table.concat(install_command, " ") },

			{ text = true }, function(obj)
				vim.schedule(function()
					vim.notify((obj.code == 0 and "Successfully installed " or "Failed to install ") .. executable)
					require "log" (obj)
				end)
			end)
	end
end
