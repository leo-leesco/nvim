vim.api.nvim_create_user_command(
	'Pager',
	function(opts)
		local cmd = opts.args

		local ok, result = pcall(vim.api.nvim_exec2, cmd, { output = true })

		if not ok then
			vim.notify("Error: " .. result, vim.log.levels.ERROR)
			return
		end

		local content = result.output
		local lines = vim.split(content, "\n")
		local available_height = vim.api.nvim_win_get_height(0) - vim.o.cmdheight - 1

		if #lines < available_height then
			vim.cmd(cmd)
		else
			vim.cmd.tabnew()
			local buf = vim.api.nvim_get_current_buf()

			vim.bo[buf].buftype = "nofile"
			vim.bo[buf].bufhidden = "wipe"
			vim.bo[buf].swapfile = false

			vim.bo[buf].filetype = "help"
			vim.wo.conceallevel = 0
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.bo[buf].modifiable = false

			-- custom handler for paging the output of `highlight`
			if cmd:match("^hi") or cmd:match("^verbose%s+hi") then
				for _, line in ipairs(lines) do
					-- Only proceed if the line actually starts with a valid group name
					local group_name = line:match("^%s*(%a%w*)") -- Ensure it starts with a letter
					if group_name then
						-- Use pcall because 'syntax keyword' fails on some reserved words/weird names
						pcall(vim.cmd, "syntax keyword " .. group_name .. " " .. group_name)
					end
				end
			end


			vim.notify("Output too long (" .. #lines .. " lines) - Opened Pager", vim.log.levels.INFO)
		end
	end,
	{
		nargs = "+",
		complete = function(arg_lead, cmd_line, cursor_pos)
			-- 1. Strip the command name ("Page ") from the input
			-- This leaves us with just the command the user wants to run
			local remote_cmd = cmd_line:gsub("^%S+%s*", "", 1)

			-- 2. If the user hasn't typed anything after 'Page ', suggest commands
			if remote_cmd == "" then
				return vim.fn.getcompletion("", "command")
			end

			return vim.fn.getcompletion(remote_cmd, "cmdline")
		end
	})
