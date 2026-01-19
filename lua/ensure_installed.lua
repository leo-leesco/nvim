return function(executable, install_command)
	if not vim.fn.executable(executable) and vim.fn.confirm("Install " .. executable .. " ?", "&Yes\n&No") then
		vim.system(install_command, { text = true }, function(obj)
			require("log")(obj)
		end)
	end
end
