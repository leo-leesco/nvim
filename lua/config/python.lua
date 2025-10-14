-- Autocommand group to ensure commands are cleared on reload
local python_env_group = vim.api.nvim_create_augroup('PythonEnv', { clear = true })

local current_dir = vim.fn.expand('%:p:h')
local project_root = nil
local venv_path = nil

local function setup_python_env()
	-- 1. Find the project root (.git) or file system root

	-- Traverse up to find .venv or a git root
	local path = current_dir
	while path ~= '/' and path ~= vim.fn.fnamemodify(path, ':h') do
		if vim.fn.isdirectory(path .. '/.git') then
			project_root = path
		end
		if vim.fn.isdirectory(path .. '/.venv') then
			venv_path = path .. '/.venv'
			break                -- Found it!
		end
		if project_root then break end -- Stop at git root if .venv not found yet
		path = vim.fn.fnamemodify(path, ':h')
	end

	-- If we reached the git root and still haven't found a venv, check one last time there
	if project_root and not venv_path and vim.fn.isdirectory(project_root .. '/.venv') then
		venv_path = project_root .. '/.venv'
	end

	-- 2. If no venv is found, ask to create one
	if not venv_path then
		local create_choice = vim.fn.confirm('No .venv found. Create one at ' .. current_dir .. '?', '&Yes\n&No', 2)
		if create_choice == 1 then
			local venv_create_dir = current_dir .. '/.venv'
			vim.notify('Creating virtual environment at ' .. venv_create_dir .. '...', vim.log.levels.INFO)
			-- Use a job to create it asynchronously
			vim.fn.jobstart('python3 -m venv ' .. venv_create_dir, {
				on_exit = function()
					vim.notify('✅ Virtual environment created!', vim.log.levels.INFO)
					-- After creation, run setup again to use it
					setup_python_env()
				end,
			})
			return -- Exit for now; the callback will re-run this function
		end
	end

	-- 3. Set the python executable path
	local python_executable
	local is_windows = vim.fn.has('win32') == 1
	if venv_path then
		if is_windows then
			python_executable = venv_path .. '/Scripts/python.exe'
		else
			python_executable = venv_path .. '/bin/python'
		end
		-- Store it in a buffer variable for the :Pip command to use
		vim.b.venv_python = true
		vim.notify('🐍 Using Python from: ' .. venv_path, vim.log.levels.INFO)
	else
		python_executable = 'python3' -- Fallback
		vim.b.venv_python = false
		vim.notify('🐍 Using system python3.', vim.log.levels.WARN)
	end

	-- Set makeprg to use the correct python
	vim.b.python_executable = python_executable
	vim.opt_local.makeprg = vim.b.python_executable .. ' %'
end

vim.api.nvim_create_autocmd('FileType', {
	group = python_env_group,
	pattern = 'python',
	callback = setup_python_env,
})

-- Use a new, unique group name to prevent it from being cleared elsewhere.
local python_lsp_attach_group = vim.api.nvim_create_augroup('PythonLspAttach', { clear = true })

local updated = false
vim.api.nvim_create_autocmd('LspAttach', {
	group = python_lsp_attach_group, -- Assign it to the new, isolated group
	callback = function(args)
		if not updated then
			-- Get the client that just attached
			local client = vim.lsp.get_client_by_id(args.data.client_id)

			-- ONLY act if the attached client is pyright
			if client and client.name == 'pyright' then
				-- Check if our FileType autocommand found a python path for this buffer
				if vim.b[args.buf].python_executable then
					local python_path = vim.b[args.buf].python_executable

					-- Dynamically update the config for this specific client instance
					vim.lsp.config('pyright', {
						settings = {
							python = {
								pythonPath = python_path,
							},
						},
					})

					-- Restart the client to apply the new settings
					vim.cmd "LspRestart"
					vim.notify("🐍 Pyright configured to use: " .. python_path, vim.log.levels.INFO,
						{ title = "Python Env" })
				end
			end
			updated = true
		end
	end,
})

vim.api.nvim_create_user_command('Pip',
	function(opts)
		local pip_executable
		local is_windows = vim.fn.has('win32') == 1
		if vim.b.venv_python then
			if is_windows then
				pip_executable = vim.fn.fnamemodify(vim.b.python_executable, ':h') .. '/pip.exe'
			else
				pip_executable = vim.fn.fnamemodify(vim.b.python_executable, ':h') .. '/pip'
			end
		else
			vim.notify('No active .venv detected. Using system pip3.', vim.log.levels.WARN)
			pip_executable = 'pip3'
		end
		-- Execute the command in a terminal for interactive output
		vim.cmd('terminal ' .. pip_executable .. ' ' .. opts.args)
	end, { nargs = '*', desc = 'Run pip command in the detected venv' })
