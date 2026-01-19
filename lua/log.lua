return function log(obj)
	vim.fn.writefile(vim.inspect(obj), vim.env["NVIM_LOG_FILE"], "a")
end
