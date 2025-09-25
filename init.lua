local env_path = vim.fn.stdpath("config") .. "/.env" -- ~/.config/nvim/.env
if vim.fn.filereadable(env_path) == 1 then
	for line in io.lines(env_path) do
		if line:match("^%w") then -- Skip comments/empty lines
			local key, value = line:match("([^=]+)=([^=]+)")
			if key and value then
				vim.env[key] = value:gsub('^"(.*)"$', "%1") -- Remove quotes if present
			end
		end
	end
end

require("config.config")
require("config.lazy")

-- import all files in directory `config`
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/config", [[v:val =~ '\.lua$']])) do
	local filename = file:gsub("%.lua$", "")
	if filename ~= "config" then
		require("config." .. filename)
	end
end
