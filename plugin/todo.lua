local keywords = { "TODO", "FIXME", "HACK", "NOTE", "WARN" }
local pattern = "\\c\\v(" .. table.concat(keywords, "|") .. "):"

local function todo_refresh()
	vim.cmd("silent! lvimgrep /" .. pattern .. "/j %")
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
	callback = todo_refresh,
})

vim.api.nvim_create_user_command("Todo", function()
	todo_refresh()
	vim.cmd("lopen")
end, {})
