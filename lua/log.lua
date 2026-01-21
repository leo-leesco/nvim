return function(obj)
	vim.fn.writefile(
		{ os.date() .. " " .. vim.json.encode(obj) }, vim.env.NVIM_LOG_FILE, "a")
end
