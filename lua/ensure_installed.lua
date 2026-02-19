--- it is created once per `nvim` session, and is safely accessed only by this script
local ensure_installed = {}

--- @param executable string
--- @param install_command string[]
return function(executable, install_command)
	if ensure_installed[executable] then
		return
	end
	ensure_installed[executable] = true

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
