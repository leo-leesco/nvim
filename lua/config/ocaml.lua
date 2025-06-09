vim.opt.rtp:prepend("~/.opam/default/share/ocp-indent/vim")

local dune_job_id = nil

local function dune_start_watch()
	if dune_job_id == nil then
		dune_job_id = vim.fn.jobstart({ "dune", "build", "-w" }, {
			detach = true, -- let it run independently
		})
		if dune_job_id > 0 then
			vim.notify("Started dune build -w (job ID " .. dune_job_id .. ")", vim.log.levels.INFO)
		else
			vim.notify("Failed to start dune build -w", vim.log.levels.ERROR)
		end
	end
end

local function dune_stop()
	if dune_job_id and dune_job_id > 0 then
		vim.fn.jobstop(dune_job_id)
		vim.notify("Stopped dune", vim.log.levels.INFO)
		dune_job_id = nil
	end
end

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*.ml", "*.mli" },
	callback = dune_start_watch,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = dune_stop,
})

-- replicates "dune …" via ":Dune …"
vim.api.nvim_create_user_command("Dune", function(opts)
	dune_stop()

	-- opts.args is a string; split on whitespace
	local args = {}
	for tok in opts.args:gmatch("%S+") do
		table.insert(args, tok)
	end
	-- default to "runtest" if nothing is passed
	if #args == 0 then
		table.insert(args, "runtest")
	end
	-- prepend "dune"
	table.insert(args, 1, "dune")

	-- run it
	local cmd_job = vim.fn.jobstart(args, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data)
			if data then
				vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
			end
		end,

		on_stderr = function(_, data)
			if data and data[1] ~= "" then
				vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
			end
		end,

		on_exit = function(_, code)
			if code == 0 then
				vim.notify("`" .. table.concat(args, " ") .. "` succeeded", vim.log.levels.INFO)
			else
				vim.notify("`" .. table.concat(args, " ") .. "` failed (code " .. code .. ")", vim.log.levels.WARN)
			end

			dune_start_watch()
		end,
	})

	if cmd_job <= 0 then
		vim.notify("Failed to launch dune command", vim.log.levels.ERROR)
	end
end, {
	nargs = "*",
	desc = "Proxy for dune commands",
})
