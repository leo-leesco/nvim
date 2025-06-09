local M = {}

local levels = vim.log.levels
M.levels = levels -- export vim.log.levels for convenience

-- Default threshold
M.level = levels.INFO

-- Log function
function M.log(msg, level)
	level = level or levels.INFO
	if level > M.level then
		return
	end

	local hl = ({
		[levels.ERROR] = "ErrorMsg",
		[levels.WARN] = "WarningMsg",
		[levels.INFO] = "None",
		[levels.DEBUG] = "Comment",
		[levels.TRACE] = "Comment",
	})[level] or "None"

	vim.api.nvim_echo({ { msg, hl } }, true, {})
end

return M
