vim.api.nvim_create_user_command("Venv", function(opts)
	local input_path = opts.args ~= "" and vim.fn.fnamemodify(opts.args, ":p") or nil

	local function find_venv_dir(path)
		local venv_path = path .. "/.venv"
		local stat = vim.uv.fs_stat(venv_path)
		if stat and stat.type == "directory" then
			return venv_path
		end
		local parent = vim.fn.fnamemodify(path, ":h")
		if parent == path then
			return nil
		end
		return find_venv_dir(parent)
	end

	if input_path then
		-- Use given path as the venv location
		local venv = input_path
		if vim.fn.isdirectory(venv) == 0 then
			vim.fn.system({ "python3", "-m", "venv", venv })
			print("✅ Created virtual environment at: " .. venv)
		else
			print("📦 Using existing virtual environment at: " .. venv)
		end
		return
	end

	-- Start from current working directory
	local cwd = vim.fn.getcwd()
	local venv = find_venv_dir(cwd)

	if not venv then
		-- Create venv in current directory
		venv = cwd .. "/.venv"
		vim.fn.system({ "python3", "-m", "venv", venv })
		print("✅ Created new virtual environment at: " .. venv)
	else
		print("📦 Found virtual environment at: " .. venv)
	end

	-- Set environment variables to simulate "activation"
	vim.env.VIRTUAL_ENV = venv
	vim.env.PATH = venv .. "/bin:" .. vim.env.PATH

	print("✅ Virtual environment activated.")
end, {
	desc = "Create and activate a Python virtual environment",
	nargs = "?",
	complete = "file",
})

vim.api.nvim_create_user_command("Pip", function(opts)
	local cmd = { "pip" }
	for _, arg in ipairs(opts.fargs) do
		table.insert(cmd, arg)
	end

	vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data)
			if data then
				vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
			end
		end,
		on_stderr = function(_, data)
			if data then
				vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
			end
		end,
	})
end, {
	desc = "Run pip in the current (virtual) environment",
	nargs = "*",
	complete = "shellcmd",
})

vim.api.nvim_create_autocmd("FileType",
	{
		pattern = "python",
		callback = function()
			vim.opt_local.makeprg = "python3 %"
		end
	})
