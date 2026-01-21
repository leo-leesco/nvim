--- @param executable string
--- @param install_command string[]
return function(executable, install_command)
	if
			vim.fn.executable(executable) ~= 1
			and vim.fn.confirm("Install " .. executable .. " ?", "&Yes\n&No") == 1
	then
		vim.system(

			{ "sh", "-c", table.concat(install_command, " ") },

			{ text = true }, function(obj)
				vim.schedule(function()
					require("log")(obj)
				end)
			end)
	end
end
