-- import all files in directory `config`
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/config", [[v:val =~ '\.lua$']])) do
	require("config." .. file:gsub("%.lua$", ""))
end
